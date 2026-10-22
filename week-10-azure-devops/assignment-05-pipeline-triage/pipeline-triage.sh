#!/usr/bin/env bash
set -uo pipefail

# Read-only Azure DevOps pipeline failure triage.
# This script only lists runs, reads timelines and task logs, and writes reports.
# It never queues, triggers, retries, cancels, approves, or modifies a run or pipeline.
#
# Exit codes (overall verdict, worst pipeline wins):
#   0 PASS  - latest run of every pipeline completed and succeeded.
#   1 WARN  - nothing failed, but a run is unfinished, canceled, partially succeeded, or a pipeline has no runs.
#   2 FAIL  - the latest completed run of a pipeline failed; category and evidence are in the report.
#   3 ERROR - az or jq missing, not signed in, project not reachable, or a latest run could not be read.

ORG="https://dev.azure.com/nikkyjuwe"
PROJECT="EpicBook-Deployment"
API_VERSION="7.1"

APP_PIPELINE_ID=8
INFRA_PIPELINE_ID=7

REPORT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/reports"
mkdir -p "$REPORT_DIR"

TIMESTAMP="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
# Timestamped reports are never overwritten: a same-second collision gets a numeric suffix.
REPORT_STAMP="$(date -u '+%Y%m%dT%H%M%SZ')"
REPORT_FILE="$REPORT_DIR/triage-$REPORT_STAMP.txt"
report_suffix=1
while [[ -e "$REPORT_FILE" ]]; do
    REPORT_FILE="$REPORT_DIR/triage-$REPORT_STAMP-$report_suffix.txt"
    report_suffix=$((report_suffix + 1))
done

# Overwritten on every run: overall verdict, and the latest-run evidence for each pipeline.
HEALTH_REPORT="$REPORT_DIR/pipeline-health-report.txt"
APP_LAST_LOG="$REPORT_DIR/app-last-run.log"
INFRA_LAST_LOG="$REPORT_DIR/infra-last-run.log"

TEMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TEMP_DIR"' EXIT

# Overall verdict rank: 0 PASS, 1 WARN, 2 FAIL, 3 ERROR.
OVERALL_RANK=0
VERDICT_LINES=""
# Pipeline IDs whose block was written this run, e.g. " 8 7 ".
PUBLISHED_IDS=" "
ERROR_REASON=""

# Shared by classify_failure and extract_evidence so the two cannot drift apart.
# Includes SSH key/host rejections (e.g. "Permission denied (publickey).", "Host key verification failed.").
AUTH_PATTERN='authentication failed|unauthorized|forbidden|access denied|permission denied|invalid credentials|host key verification failed|too many authentication failures|load key .*invalid format|(http|status( code)?|response|error)[^0-9]{0,15}40[13]\b'
# Agent offline, or a job/agent that timed out waiting for an agent.
AGENT_PATTERN='no space left on device|agent.*(offline|disconnected|unavailable)|stopped hearing from agent|no agent.*available|no agent found|waiting for an available agent|no hosted parallelism|runner.*unavailable|lost communication with agent|job.*could not be started|(agent|job|pool|runner).*timed out|timed out.*(agent|job|pool|runner)'
TEST_PATTERN='test failed|tests? failed|assertion failed|failed tests|npm test.*fail|pytest.*failed|junit.*failure'
# ESLint diagnostics: "36:7  error  'x' is ... no-unused-vars", "✖ 1 problem (1 error, 0 warnings)", "lint ... failed".
LINT_PATTERN='[0-9]+:[0-9]+[[:space:]]+error[[:space:]]|[0-9]+ problems? \(|no-unused-vars|eslint.*(error|failed)|lint.*failed'
# Source file header lines printed by linters, e.g. "/home/agent/_work/1/s/server.js".
FILE_PATTERN='^[^[:space:]].*\.(js|jsx|ts|tsx)$'
# Task names that identify a test or lint step. Used only together with a specific diagnostic.
TEST_TASK_PATTERN='test|lint|spec|jest|mocha|pytest'
DEPENDENCY_PATTERN='could not resolve|unable to resolve dependency|dependency resolution failed|package.*not found|module not found|npm ERR!.*(resolve|depend|install)|pip.*no matching distribution'
BUILD_PATTERN='build failed|compilation failed|compile error|syntax error|webpack.*error|next build.*failed|error TS[0-9]+'
# Terraform CLI errors and Azure resource failures during infrastructure runs.
TERRAFORM_PATTERN='terraform.*(error|failed|failure)|error acquiring the state lock|error: (creating|updating|deleting|reading|invalid|missing|unsupported)|azurerm_[a-z_]+.*(error|failed)'
# Ansible play failures, Nginx config/startup errors, and deployment step failures.
ANSIBLE_PATTERN='ansible.*(error|failed|fatal)|fatal: \[[^]]+\]: failed|failed=[1-9][0-9]*|unreachable=[1-9][0-9]*|nginx: \[emerg\]|nginx.*(failed|error)|deployment.*failed'

# Set by collect_failure_logs: how many task logs were actually retrieved.
FETCHED_LOG_COUNT=0

# True when the log has an ##[error] line other than the generic Bash exit message.
has_specific_diagnostic() {
    local log_file="$1"
    local diagnostics

    diagnostics="$(grep -Ei '##\[error\]' "$log_file" | grep -Eiv 'Bash exited with code' || true)"
    [[ -n "$diagnostics" ]]
}

# True when a failed timeline record has a test or lint task name.
has_failed_test_task() {
    local names_file="$1"

    grep -Eiq "$TEST_TASK_PATTERN" "$names_file"
}

classify_failure() {
    local log_file="$1"
    local names_file="$2"

    if grep -Eiq "$AUTH_PATTERN" "$log_file"; then
        echo "AUTHENTICATION"
    elif grep -Eiq "$AGENT_PATTERN" "$log_file"; then
        echo "AGENT/RUNNER AVAILABILITY"
    elif grep -Eiq "$TEST_PATTERN|$LINT_PATTERN" "$log_file"; then
        # Direct test or lint evidence in the logs.
        echo "TEST"
    elif has_failed_test_task "$names_file" && has_specific_diagnostic "$log_file"; then
        # A test or lint task failed with a diagnostic other than the generic Bash exit code.
        echo "TEST"
    elif grep -Eiq "$DEPENDENCY_PATTERN" "$log_file"; then
        echo "DEPENDENCY"
    elif grep -Eiq "$BUILD_PATTERN" "$log_file"; then
        echo "BUILD"
    elif grep -Eiq "$TERRAFORM_PATTERN" "$log_file"; then
        echo "TERRAFORM/INFRASTRUCTURE"
    elif grep -Eiq "$ANSIBLE_PATTERN" "$log_file"; then
        echo "ANSIBLE/NGINX/DEPLOYMENT"
    else
        echo "UNCLASSIFIED"
    fi
}

extract_evidence() {
    local log_file="$1"

    # Diagnostics first, then generic ##[error] lines for context.
    # Keep the first matching lines, drop duplicates, cap their length, and mask obvious secret assignments.
    {
        grep -Ein "$AUTH_PATTERN|$AGENT_PATTERN|$TEST_PATTERN|$LINT_PATTERN|$FILE_PATTERN|$DEPENDENCY_PATTERN|$BUILD_PATTERN|$TERRAFORM_PATTERN|$ANSIBLE_PATTERN" \
            "$log_file" | head -n 10 || true
        grep -Ein '##\[error\]' "$log_file" | head -n 2 || true
    } \
        | awk '!seen[$0]++' \
        | cut -c1-300 \
        | sed -E 's/((password|pwd|token|secret|api[_-]?key|key)[[:space:]]*[:=][[:space:]]*)[^[:space:]]+/\1[REDACTED]/Ig' \
        || true
}

recommend_action() {
    case "$1" in
        AUTHENTICATION)
            echo "Human to check the service connection, SSH key, or permission named in the evidence (no credential values are shown here), fix or re-authorize it in Azure DevOps, then queue a new run manually and triage again." ;;
        "AGENT/RUNNER AVAILABILITY")
            echo "Human to check the self-hosted agent under Project settings > Agent pools (online, enough free disk space, not saturated), fix it, then queue a new run manually and triage again." ;;
        "TERRAFORM/INFRASTRUCTURE")
            echo "Human to check the Terraform configuration, state lock, or Azure resource named in the evidence, correct it in the infrastructure repository, commit the change, queue a new infra run manually, and triage again." ;;
        "ANSIBLE/NGINX/DEPLOYMENT")
            echo "Human to check the playbook task, target host, or Nginx configuration named in the evidence, correct it in the deployment repository, commit the change, queue a new run manually, and triage again." ;;
        TEST)
            echo "Human to fix the failing test, lint error, or code under test named in the evidence, commit the change, queue a new run, and triage again." ;;
        DEPENDENCY)
            echo "Human to correct the package or module name or version named in the evidence in the dependency manifest, commit the change, queue a new run, and triage again." ;;
        BUILD)
            echo "Human to fix the compile or build error at the file and line in the evidence, commit the change, queue a new run, and triage again." ;;
        *)
            echo "No category could be assigned from the evidence. Human to review the full task log in Azure DevOps before acting." ;;
    esac
}

# Writes the combined logs of failed timeline records into $2 and sets FETCHED_LOG_COUNT.
# Writes "<log id><TAB><task name>" for each failed timeline record into "$2.names".
# Returns non-zero when the timeline or log index cannot be read.
collect_failure_logs() {
    local run_id="$1"
    local out_file="$2"
    local names_file="$out_file.names"
    local timeline_json="$TEMP_DIR/timeline-${run_id}.json"
    local index_json="$TEMP_DIR/log-index-${run_id}.json"
    local body_json="$TEMP_DIR/log-body-${run_id}.json"
    local log_ids log_id

    FETCHED_LOG_COUNT=0
    : > "$out_file"
    : > "$names_file"

    if ! az devops invoke \
        --organization "$ORG" \
        --area build \
        --resource timeline \
        --route-parameters project="$PROJECT" buildId="$run_id" \
        --api-version "$API_VERSION" \
        --output json > "$timeline_json" 2>/dev/null; then
        return 1
    fi

    # Prefer logs of failed or canceled timeline records (stages, jobs, tasks).
    jq -r '.records[]
        | select((.result == "failed" or .result == "canceled" or .result == "abandoned") and .log != null)
        | "\(.log.id)\t\(.name)"' "$timeline_json" > "$names_file"
    log_ids="$(cut -f1 "$names_file" | sort -un)"

    # Fallback when no failed record has a log: use every log of the run.
    if [[ -z "$log_ids" ]]; then
        if ! az devops invoke \
            --organization "$ORG" \
            --area build \
            --resource logs \
            --route-parameters project="$PROJECT" buildId="$run_id" \
            --api-version "$API_VERSION" \
            --output json > "$index_json" 2>/dev/null; then
            return 1
        fi
        log_ids="$(jq -r '.value[].id' "$index_json" | sort -un)"
    fi

    for log_id in $log_ids; do
        if az devops invoke \
            --organization "$ORG" \
            --area build \
            --resource logs \
            --route-parameters project="$PROJECT" buildId="$run_id" logId="$log_id" \
            --api-version "$API_VERSION" \
            --output json > "$body_json" 2>/dev/null; then
            {
                echo "----- log $log_id -----"
                jq -r '.value[]?' "$body_json"
            } >> "$out_file"
            FETCHED_LOG_COUNT=$((FETCHED_LOG_COUNT + 1))
        fi
    done

    [[ "$FETCHED_LOG_COUNT" -gt 0 ]]
}

verdict_name() {
    case "$1" in
        0) echo "PASS" ;;
        1) echo "WARN" ;;
        2) echo "FAIL" ;;
        *) echo "ERROR" ;;
    esac
}

# Adds one pipeline's verdict to the health summary and raises the overall verdict if it is worse.
add_verdict() {
    local rank="$1"
    local label="$2"

    VERDICT_LINES+="$label: $(verdict_name "$rank")"$'\n'
    if (( rank > OVERALL_RANK )); then
        OVERALL_RANK="$rank"
    fi
}

# Appends a finished pipeline block to the timestamped report, overwrites its last-run log,
# and records the verdict. The block is read from $TEMP_DIR/block-<pipeline ID>.txt.
# Arguments: pipeline ID, pipeline name, verdict rank (0-3), last-run log path.
publish_block() {
    local pipeline_id="$1"
    local pipeline_name="$2"
    local rank="$3"
    local last_log="$4"
    local block_file="$TEMP_DIR/block-${pipeline_id}.txt"
    local detail

    cat "$block_file" >> "$REPORT_FILE"
    cp "$block_file" "$last_log"
    PUBLISHED_IDS+="$pipeline_id "

    detail="$(sed -n -e 's/^Run ID: /run /p' -e 's/^Failure category: /category /p' "$block_file" | paste -sd ',' -)"
    if [[ -n "$detail" ]]; then
        add_verdict "$rank" "$pipeline_name (ID $pipeline_id) - $detail"
    else
        add_verdict "$rank" "$pipeline_name (ID $pipeline_id)"
    fi
}

# Reports a pipeline whose baseline (latest run) could not be read. The verdict is ERROR.
fail_pipeline() {
    local pipeline_id="$1"
    local pipeline_name="$2"
    local reason="$3"
    local last_log="$4"

    echo "ERROR: $reason"
    {
        echo "=== Pipeline Triage Report ==="
        echo "Inspection timestamp (UTC): $TIMESTAMP"
        echo "Organization: $ORG"
        echo "Project: $PROJECT"
        echo "Pipeline: $pipeline_name"
        echo "Pipeline ID: $pipeline_id"
        echo "Inspection status: ERROR"
        echo "Verdict: ERROR"
        echo "Reason: $reason"
        echo
    } > "$TEMP_DIR/block-${pipeline_id}.txt"
    publish_block "$pipeline_id" "$pipeline_name" 3 "$last_log"
}

inspect_pipeline() {
    local pipeline_id="$1"
    local pipeline_name="$2"
    local last_log="$3"
    local run_json="$TEMP_DIR/run-${pipeline_id}.json"
    local block_file="$TEMP_DIR/block-${pipeline_id}.txt"
    local run_id status result branch
    local failed_log="$TEMP_DIR/failed-${pipeline_id}.txt"
    local names_file="$failed_log.names"
    local failed_tasks="none recorded"
    local category="NONE"
    local evidence="No failure evidence: run succeeded."
    local recommendation="No action required. Pipeline is healthy."
    local limitation="None."
    local verdict=0

    echo
    echo "Inspecting: $pipeline_name (ID $pipeline_id)"

    if ! az pipelines runs list \
        --organization "$ORG" \
        --project "$PROJECT" \
        --pipeline-ids "$pipeline_id" \
        --top 1 \
        --output json > "$run_json"; then
        fail_pipeline "$pipeline_id" "$pipeline_name" "Unable to list runs; Azure DevOps run listing failed." "$last_log"
        return 1
    fi

    if ! jq -e 'type == "array"' "$run_json" >/dev/null 2>&1; then
        fail_pipeline "$pipeline_id" "$pipeline_name" "Run listing did not return readable JSON." "$last_log"
        return 1
    fi

    if ! jq -e 'length > 0' "$run_json" >/dev/null 2>&1; then
        echo "No runs found for $pipeline_name."
        {
            echo "=== Pipeline Triage Report ==="
            echo "Inspection timestamp (UTC): $TIMESTAMP"
            echo "Organization: $ORG"
            echo "Project: $PROJECT"
            echo "Pipeline: $pipeline_name"
            echo "Pipeline ID: $pipeline_id"
            echo "Inspection status: NOT ASSESSABLE"
            echo "Verdict: WARN"
            echo "Reason: No pipeline runs were returned."
            echo
        } > "$block_file"
        publish_block "$pipeline_id" "$pipeline_name" 1 "$last_log"
        return 0
    fi

    run_id="$(jq -r '.[0].id // empty' "$run_json")"
    status="$(jq -r '.[0].status // "unknown"' "$run_json")"
    result="$(jq -r '.[0].result // "unknown"' "$run_json")"
    branch="$(jq -r '.[0].sourceBranch // "unknown"' "$run_json")"

    if [[ -z "$run_id" ]]; then
        fail_pipeline "$pipeline_id" "$pipeline_name" "Latest run ID could not be determined." "$last_log"
        return 1
    fi

    if [[ "$status" == "completed" && "$result" == "succeeded" ]]; then
        # Healthy run: no logs are needed and no category is triggered.
        category="NONE"
        verdict=0
    elif [[ "$status" != "completed" ]]; then
        category="NOT ASSESSABLE"
        verdict=1
        evidence="Run has not completed (status: $status)."
        recommendation="Wait for the run to finish, then run triage again."
        limitation="Failure analysis is skipped for runs that have not completed."
    else
        # A failed run is FAIL. Other completed results (canceled, partiallySucceeded, ...) are WARN.
        if [[ "$result" == "failed" ]]; then
            verdict=2
        else
            verdict=1
        fi
        if collect_failure_logs "$run_id" "$failed_log"; then
            category="$(classify_failure "$failed_log" "$names_file")"
            evidence="$(extract_evidence "$failed_log")"
            if [[ -z "$evidence" ]]; then
                evidence="No matching error lines found in the retrieved logs."
            fi
            failed_tasks="$(cut -f2 "$names_file" | awk 'NF && !seen[$0]++' | paste -sd ';' -)"
            if [[ -z "$failed_tasks" ]]; then
                failed_tasks="none recorded"
            fi
            limitation="Analyzed $FETCHED_LOG_COUNT task log(s) from the run timeline (read-only)."
        else
            category="UNCLASSIFIED"
            evidence="Task logs could not be retrieved; no evidence is available."
            limitation="Timeline or log retrieval failed. No category was inferred."
        fi
        recommendation="$(recommend_action "$category")"
    fi

    {
        echo "=== Pipeline Triage Report ==="
        echo "Inspection timestamp (UTC): $TIMESTAMP"
        echo "Organization: $ORG"
        echo "Project: $PROJECT"
        echo "Pipeline: $pipeline_name"
        echo "Pipeline ID: $pipeline_id"
        echo "Run ID: $run_id"
        echo "Source branch: $branch"
        echo "Status: $status"
        echo "Result: $result"
        echo "Failed task(s): $failed_tasks"
        echo "Failure category: $category"
        echo "Verdict: $(verdict_name "$verdict")"
        echo "Evidence:"
        echo "$evidence" | sed 's/^/  /'
        echo "Recommended human action: $recommendation"
        echo "Limitations: $limitation"
        echo
    } > "$block_file"
    publish_block "$pipeline_id" "$pipeline_name" "$verdict" "$last_log"

    echo "Run ID: $run_id"
    echo "Status: $status"
    echo "Result: $result"
    echo "Failure category: $category"
    echo "Verdict: $(verdict_name "$verdict")"
}

# Writes the overall verdict and per-pipeline verdicts. Overwritten on every run.
write_health_report() {
    {
        echo "=== Pipeline Health Report ==="
        echo "Inspection timestamp (UTC): $TIMESTAMP"
        echo "Organization: $ORG"
        echo "Project: $PROJECT"
        echo "Overall status: $(verdict_name "$OVERALL_RANK")"
        echo "Exit code: $OVERALL_RANK"
        echo "Pipeline verdicts:"
        printf '%s' "$VERDICT_LINES" | sed 's/^/  /'
        if [[ -n "$ERROR_REASON" ]]; then
            echo "Reason: $ERROR_REASON"
        fi
        if [[ -f "$REPORT_FILE" ]]; then
            echo "Triage report: $(basename "$REPORT_FILE")"
        else
            echo "Triage report: not written (triage stopped before inspection)"
        fi
        echo "Last-run logs: $(basename "$APP_LAST_LOG"), $(basename "$INFRA_LAST_LOG")"
        echo "Exit codes: 0=PASS 1=WARN 2=FAIL 3=ERROR"
    } > "$HEALTH_REPORT"
}

# Writes an ERROR last-run log for a pipeline that was never inspected because triage stopped early.
write_not_inspected_log() {
    local pipeline_id="$1"
    local pipeline_name="$2"
    local last_log="$3"

    add_verdict 3 "$pipeline_name (ID $pipeline_id)"
    {
        echo "=== Pipeline Triage Report ==="
        echo "Inspection timestamp (UTC): $TIMESTAMP"
        echo "Organization: $ORG"
        echo "Project: $PROJECT"
        echo "Pipeline: $pipeline_name"
        echo "Pipeline ID: $pipeline_id"
        echo "Inspection status: ERROR"
        echo "Verdict: ERROR"
        echo "Reason: Triage stopped before this pipeline was inspected: $ERROR_REASON"
        echo
    } > "$last_log"
}

# Ends the run: fills in last-run logs for any pipeline not inspected, writes the health report,
# and exits with the overall verdict code (0 PASS, 1 WARN, 2 FAIL, 3 ERROR).
finish() {
    if [[ "$PUBLISHED_IDS" != *" $APP_PIPELINE_ID "* ]]; then
        write_not_inspected_log "$APP_PIPELINE_ID" "Epicbook-App-Pipeline" "$APP_LAST_LOG"
    fi
    if [[ "$PUBLISHED_IDS" != *" $INFRA_PIPELINE_ID "* ]]; then
        write_not_inspected_log "$INFRA_PIPELINE_ID" "Epicbook-infra-pipeline" "$INFRA_LAST_LOG"
    fi

    write_health_report
    echo
    echo "Overall status: $(verdict_name "$OVERALL_RANK") (exit $OVERALL_RANK)"
    echo "Health report saved to: $HEALTH_REPORT"
    exit "$OVERALL_RANK"
}

# Stops before any pipeline is inspected. Without a readable baseline the result is ERROR, never PASS.
fail_early() {
    ERROR_REASON="$1"
    OVERALL_RANK=3
    echo "ERROR: $1"
    finish
}

if ! command -v az >/dev/null 2>&1; then
    fail_early "Azure CLI (az) is required."
fi

if ! command -v jq >/dev/null 2>&1; then
    fail_early "jq is required. Install it before running this script."
fi

if ! az account show --output none >/dev/null 2>&1; then
    fail_early "Azure CLI is not signed in. Run az login manually."
fi

if ! az devops project show \
    --organization "$ORG" \
    --project "$PROJECT" \
    --output none >/dev/null 2>&1; then
    fail_early "Cannot access the configured Azure DevOps project."
fi

: > "$REPORT_FILE"

echo "Azure DevOps read-only pipeline triage"
echo "Project: $PROJECT"
echo "Report: $REPORT_FILE"

inspect_pipeline "$APP_PIPELINE_ID" "Epicbook-App-Pipeline" "$APP_LAST_LOG"
inspect_pipeline "$INFRA_PIPELINE_ID" "Epicbook-infra-pipeline" "$INFRA_LAST_LOG"

echo
echo "Triage report saved to: $REPORT_FILE"
finish
