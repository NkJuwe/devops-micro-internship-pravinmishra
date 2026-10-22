#!/usr/bin/env bash
set -uo pipefail

# Synthetic regression tests for pipeline-triage.sh.
# Each scenario copies the script into a temp directory and runs it against a fake `az`
# that serves fixture JSON. No Azure DevOps call is made and the real reports/ folder is not touched.

TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT="$(cd "$TESTS_DIR/.." && pwd)/pipeline-triage.sh"

ROOT="$(mktemp -d)"
trap 'rm -rf "$ROOT"' EXIT

PASS=0
FAIL=0

pass() { PASS=$((PASS + 1)); echo "  PASS: $1"; }
fail() { FAIL=$((FAIL + 1)); echo "  FAIL: $1"; }

# Fake az: answers only the calls the script makes, from $FAKE_AZ_FIXTURES.
# A missing fixture file makes the call fail, which simulates an Azure DevOps read error.
write_fake_az() {
    cat > "$1" <<'FAKE_AZ'
#!/usr/bin/env bash
fixtures="$FAKE_AZ_FIXTURES"

# Marker files simulate a sign-in or project-access failure.
if [[ "$1 $2" == "account show" ]]; then
    [[ -f "$fixtures/noauth" ]] && exit 1
    exit 0
fi

if [[ "$1 $2" == "devops project" ]]; then
    [[ -f "$fixtures/noproject" ]] && exit 1
    exit 0
fi

if [[ "$1 $2" == "pipelines runs" ]]; then
    pid=""
    while [[ $# -gt 0 ]]; do
        [[ "$1" == "--pipeline-ids" ]] && pid="$2"
        shift
    done
    cat "$fixtures/runs-$pid.json"
    exit $?
fi

if [[ "$1 $2" == "devops invoke" ]]; then
    resource="" build="" logid=""
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --resource) resource="$2"; shift 2; continue ;;
            buildId=*) build="${1#buildId=}" ;;
            logId=*) logid="${1#logId=}" ;;
        esac
        shift
    done
    case "$resource" in
        timeline) cat "$fixtures/timeline-$build.json" ;;
        logs)
            if [[ -n "$logid" ]]; then
                cat "$fixtures/log-$build-$logid.json"
            else
                cat "$fixtures/logs-$build.json"
            fi ;;
        *) exit 1 ;;
    esac
    exit $?
fi

exit 1
FAKE_AZ
    chmod +x "$1"
}

# Writes a log fixture: each argument becomes one log line.
write_log() {
    local file="$1"
    shift
    printf '%s\n' "$@" | jq -R -s 'split("\n") | map(select(length > 0)) | {value: .}' > "$file"
}

# Creates a scenario directory with a fake az, a copy of the script, and a healthy App run 39-equivalent for pipeline 7.
make_scenario() {
    local dir="$ROOT/$1"
    mkdir -p "$dir/bin" "$dir/fixtures" "$dir/work"
    cp "$SCRIPT" "$dir/work/pipeline-triage.sh"
    write_fake_az "$dir/bin/az"
    echo '[{"id":39,"status":"completed","result":"succeeded","sourceBranch":"refs/heads/main"}]' > "$dir/fixtures/runs-7.json"
    echo "$dir"
}

# Sets the latest run for a pipeline ID (default 8, the App pipeline).
set_run() {
    local dir="$1" pipeline_id="$2" run_id="$3" status="$4" result="$5"
    echo "[{\"id\":$run_id,\"status\":\"$status\",\"result\":\"$result\",\"sourceBranch\":\"refs/heads/main\"}]" > "$dir/fixtures/runs-$pipeline_id.json"
}

set_app_run() {
    set_run "$1" 8 "$2" "$3" "$4"
}

set_infra_run() {
    set_run "$1" 7 "$2" "$3" "$4"
}

# Prints the Nth pipeline block (1 = App, 2 = Infra) of the latest report in a scenario.
block_n() {
    local dir="$1" n="$2"
    local report
    report="$(ls -t "$dir/work/reports"/triage-*.txt 2>/dev/null | head -n 1)"
    awk -v n="$n" '/=== Pipeline Triage Report ===/{k++; if (k > n) exit} k == n' "$report"
}

health_of() {
    cat "$1/work/reports/pipeline-health-report.txt" 2>/dev/null || echo "NO-HEALTH-REPORT"
}

expect_exit() {
    local label="$1" dir="$2" code="$3"
    if [[ "$(cat "$dir/exit_code.txt" 2>/dev/null)" == "$code" ]]; then
        pass "$label: exit code $code"
    else
        fail "$label: expected exit code $code, got '$(cat "$dir/exit_code.txt" 2>/dev/null)'"
    fi
}

expect_file() {
    local label="$1" dir="$2" name="$3"
    if [[ -s "$dir/work/reports/$name" ]]; then
        pass "$label: wrote $name"
    else
        fail "$label: missing or empty $name"
    fi
}

# Runs the script for a scenario and prints the App pipeline block (the first block in the report).
run_scenario() {
    local dir="$1"
    local report

    (
        cd "$dir/work" || exit 1
        PATH="$dir/bin:$PATH" FAKE_AZ_FIXTURES="$dir/fixtures" bash pipeline-triage.sh
    ) > "$dir/stdout.txt" 2>&1
    echo "$?" > "$dir/exit_code.txt"

    report="$(ls -t "$dir/work/reports"/triage-*.txt 2>/dev/null | head -n 1)"
    if [[ -z "$report" ]]; then
        echo "NO-REPORT"
        return
    fi
    awk '/=== Pipeline Triage Report ===/{n++} n==1' "$report"
}

expect_in() {
    local label="$1" block="$2" needle="$3"
    if grep -Fq -- "$needle" <<< "$block"; then
        pass "$label: contains '$needle'"
    else
        fail "$label: missing '$needle'"
    fi
}

expect_not_in() {
    local label="$1" block="$2" needle="$3"
    if grep -Fq -- "$needle" <<< "$block"; then
        fail "$label: unexpectedly contains '$needle'"
    else
        pass "$label: does not contain '$needle'"
    fi
}

echo "Syntax checks"
if bash -n "$SCRIPT" && bash -n "$TESTS_DIR/run-synthetic-tests.sh"; then
    pass "bash -n on script and test runner"
else
    fail "bash -n reported a syntax error"
fi

echo "Scenario: healthy App run"
dir="$(make_scenario healthy)"
set_app_run "$dir" 43 completed succeeded
block="$(run_scenario "$dir")"
expect_in "healthy" "$block" "Failure category: NONE"
expect_in "healthy" "$block" "Result: succeeded"
expect_not_in "healthy" "$block" "Failure category: TEST"

echo "Scenario: Run 44 ESLint failure (regression case)"
dir="$(make_scenario run44-eslint)"
set_app_run "$dir" 44 completed failed
cat > "$dir/fixtures/timeline-44.json" <<'EOF'
{"records":[
 {"name":"Job","type":"Job","result":"failed","log":{"id":15}},
 {"name":"Run application tests","type":"Task","result":"failed","log":{"id":9}},
 {"name":"__default","type":"Stage","result":"failed"}
]}
EOF
write_log "$dir/fixtures/log-44-15.json" \
    "2026-10-22T20:20:23.1305502Z ##[error]Bash exited with code '1'."
write_log "$dir/fixtures/log-44-9.json" \
    "2026-10-22T20:20:21.6915757Z ##[section]Starting: Run application tests" \
    "2026-10-22T20:20:21.8447855Z npm test" \
    "2026-10-22T20:20:22.1043737Z > mvc_project2@1.0.0 test" \
    "2026-10-22T20:20:22.1068860Z > npm run lint" \
    "2026-10-22T20:20:22.3360007Z > ./node_modules/.bin/eslint \"**/*.js \"" \
    "2026-10-22T20:20:23.0889039Z /home/ubuntu/azagent/_work/1/s/server.js" \
    "2026-10-22T20:20:23.0889787Z   36:7  error  'deliberateFailureDemo' is assigned a value but never used  no-unused-vars" \
    "2026-10-22T20:20:23.1060659Z ✖ 1 problem (1 error, 0 warnings)" \
    "2026-10-22T20:20:23.1305469Z ##[error]Bash exited with code '1'." \
    "2026-10-22T20:20:23.1334082Z ##[section]Finishing: Run application tests"
block="$(run_scenario "$dir")"
expect_in "run44" "$block" "Run ID: 44"
expect_in "run44" "$block" "Failure category: TEST"
expect_in "run44" "$block" "Failed task(s): Job;Run application tests"
expect_in "run44" "$block" "no-unused-vars"
expect_in "run44" "$block" "36:7  error  'deliberateFailureDemo' is assigned a value but never used  no-unused-vars"
expect_in "run44" "$block" "server.js"
expect_in "run44" "$block" "1 problem (1 error, 0 warnings)"
expect_in "run44" "$block" "Bash exited with code"
expect_not_in "run44" "$block" "Failure category: UNCLASSIFIED"

echo "Scenario: generic Bash exit only in a test task (must not be TEST)"
dir="$(make_scenario generic-bash-exit)"
set_app_run "$dir" 50 completed failed
cat > "$dir/fixtures/timeline-50.json" <<'EOF'
{"records":[{"name":"Run application tests","type":"Task","result":"failed","log":{"id":9}}]}
EOF
write_log "$dir/fixtures/log-50-9.json" \
    "2026-10-22T20:20:21.8447855Z npm test" \
    "2026-10-22T20:20:23.1305469Z ##[error]Bash exited with code '1'."
block="$(run_scenario "$dir")"
expect_in "generic-bash" "$block" "Failure category: UNCLASSIFIED"
expect_not_in "generic-bash" "$block" "Failure category: TEST"
expect_in "generic-bash" "$block" "Bash exited with code"

echo "Scenario: unit test task with a specific ##[error] diagnostic (TEST via task name)"
dir="$(make_scenario unit-test-task)"
set_app_run "$dir" 51 completed failed
cat > "$dir/fixtures/timeline-51.json" <<'EOF'
{"records":[{"name":"Run unit tests","type":"Task","result":"failed","log":{"id":9}}]}
EOF
write_log "$dir/fixtures/log-51-9.json" \
    "2026-10-22T20:20:22.1043737Z FAIL src/app.test.js" \
    "2026-10-22T20:20:23.1000000Z ##[error]Expected 2 but received 3" \
    "2026-10-22T20:20:23.1305469Z ##[error]Bash exited with code '1'."
block="$(run_scenario "$dir")"
expect_in "unit-test-task" "$block" "Failure category: TEST"
expect_in "unit-test-task" "$block" "Expected 2 but received 3"

echo "Scenario: Authentication failure"
dir="$(make_scenario auth)"
set_app_run "$dir" 52 completed failed
cat > "$dir/fixtures/timeline-52.json" <<'EOF'
{"records":[{"name":"Checkout code","type":"Task","result":"failed","log":{"id":9}}]}
EOF
write_log "$dir/fixtures/log-52-9.json" \
    "2026-10-22T20:20:22.1043737Z fatal: unable to access the repository: The requested URL returned error: 403" \
    "2026-10-22T20:20:23.1305469Z ##[error]Bash exited with code '1'."
block="$(run_scenario "$dir")"
expect_in "auth" "$block" "Failure category: AUTHENTICATION"

echo "Scenario: Agent unavailable"
dir="$(make_scenario agent)"
set_app_run "$dir" 53 completed failed
cat > "$dir/fixtures/timeline-53.json" <<'EOF'
{"records":[{"name":"Initialize job","type":"Job","result":"failed","log":{"id":9}}]}
EOF
write_log "$dir/fixtures/log-53-9.json" \
    "2026-10-22T20:20:22.1043737Z ##[error]We stopped hearing from agent Azure Pipelines 1."
block="$(run_scenario "$dir")"
expect_in "agent" "$block" "Failure category: AGENT/RUNNER AVAILABILITY"

echo "Scenario: Dependency resolution failure"
dir="$(make_scenario dependency)"
set_app_run "$dir" 54 completed failed
cat > "$dir/fixtures/timeline-54.json" <<'EOF'
{"records":[{"name":"Install dependencies","type":"Task","result":"failed","log":{"id":9}}]}
EOF
write_log "$dir/fixtures/log-54-9.json" \
    "2026-10-22T20:20:22.1043737Z npm ERR! Could not resolve dependency: mvc-foo@9.9.9" \
    "2026-10-22T20:20:23.1305469Z ##[error]Bash exited with code '1'."
block="$(run_scenario "$dir")"
expect_in "dependency" "$block" "Failure category: DEPENDENCY"

echo "Scenario: Build failure"
dir="$(make_scenario build)"
set_app_run "$dir" 55 completed failed
cat > "$dir/fixtures/timeline-55.json" <<'EOF'
{"records":[{"name":"Build client","type":"Task","result":"failed","log":{"id":9}}]}
EOF
write_log "$dir/fixtures/log-55-9.json" \
    "2026-10-22T20:20:22.1043737Z src/index.ts(3,7): error TS2304: Cannot find name 'foo'." \
    "2026-10-22T20:20:23.1305469Z ##[error]Bash exited with code '1'."
block="$(run_scenario "$dir")"
expect_in "build" "$block" "Failure category: BUILD"
expect_not_in "build" "$block" "Failure category: TEST"

echo "Scenario: timeline unavailable"
dir="$(make_scenario timeline-missing)"
set_app_run "$dir" 56 completed failed
block="$(run_scenario "$dir")"
expect_in "timeline-missing" "$block" "Failure category: UNCLASSIFIED"
expect_in "timeline-missing" "$block" "Timeline or log retrieval failed"

echo "Scenario: secret masking in test evidence"
dir="$(make_scenario redaction)"
set_app_run "$dir" 57 completed failed
cat > "$dir/fixtures/timeline-57.json" <<'EOF'
{"records":[{"name":"Run application tests","type":"Task","result":"failed","log":{"id":9}}]}
EOF
write_log "$dir/fixtures/log-57-9.json" \
    "2026-10-22T20:20:22.1043737Z Test failed with password=hunter2" \
    "2026-10-22T20:20:23.1305469Z ##[error]Bash exited with code '1'."
block="$(run_scenario "$dir")"
expect_in "redaction" "$block" "Failure category: TEST"
expect_in "redaction" "$block" "password=[REDACTED]"
expect_not_in "redaction" "$block" "hunter2"

echo "Scenario: healthy run writes exit code 0, PASS health report and last-run logs"
dir="$(make_scenario health-pass)"
set_app_run "$dir" 70 completed succeeded
set_infra_run "$dir" 71 completed succeeded
run_scenario "$dir" > /dev/null
expect_exit "health-pass" "$dir" 0
expect_in "health-pass" "$(health_of "$dir")" "Overall status: PASS"
expect_file "health-pass" "$dir" "pipeline-health-report.txt"
expect_file "health-pass" "$dir" "app-last-run.log"
expect_file "health-pass" "$dir" "infra-last-run.log"
expect_in "health-pass" "$(cat "$dir/work/reports/infra-last-run.log")" "Run ID: 71"
expect_in "health-pass" "$(cat "$dir/work/reports/app-last-run.log")" "Verdict: PASS"

echo "Scenario: timestamped reports are kept across runs"
dir="$(make_scenario retention)"
set_app_run "$dir" 72 completed succeeded
run_scenario "$dir" > /dev/null
run_scenario "$dir" > /dev/null
count="$(ls "$dir/work/reports"/triage-*.txt 2>/dev/null | wc -l | tr -d ' ')"
if [[ "$count" == "2" ]]; then
    pass "retention: two timestamped reports kept after two same-second runs"
else
    fail "retention: expected 2 timestamped reports, found $count"
fi

echo "Scenario: Terraform state lock on the infra pipeline (FAIL, exit 2)"
dir="$(make_scenario terraform)"
set_app_run "$dir" 60 completed succeeded
set_infra_run "$dir" 61 completed failed
cat > "$dir/fixtures/timeline-61.json" <<'EOF'
{"records":[{"name":"Terraform apply","type":"Task","result":"failed","log":{"id":9}}]}
EOF
write_log "$dir/fixtures/log-61-9.json" \
    "2026-10-22T20:20:22.1043737Z terraform apply -auto-approve" \
    "2026-10-22T20:20:22.5000000Z Error: Error acquiring the state lock" \
    "2026-10-22T20:20:23.1305469Z ##[error]Bash exited with code '1'."
run_scenario "$dir" > /dev/null
expect_exit "terraform" "$dir" 2
expect_in "terraform" "$(block_n "$dir" 2)" "Failure category: TERRAFORM/INFRASTRUCTURE"
expect_in "terraform" "$(block_n "$dir" 2)" "Verdict: FAIL"
expect_in "terraform" "$(cat "$dir/work/reports/infra-last-run.log")" "Error acquiring the state lock"
expect_in "terraform" "$(cat "$dir/work/reports/app-last-run.log")" "Failure category: NONE"
expect_in "terraform" "$(health_of "$dir")" "Overall status: FAIL"

echo "Scenario: Ansible and Nginx deployment failure (FAIL, exit 2)"
dir="$(make_scenario ansible-nginx)"
set_app_run "$dir" 62 completed failed
cat > "$dir/fixtures/timeline-62.json" <<'EOF'
{"records":[{"name":"Deploy with Ansible","type":"Task","result":"failed","log":{"id":9}}]}
EOF
write_log "$dir/fixtures/log-62-9.json" \
    "2026-10-22T20:20:22.1043737Z fatal: [10.0.1.5]: FAILED! => {\"msg\": \"Unable to start service nginx\"}" \
    "2026-10-22T20:20:22.5000000Z nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)" \
    "2026-10-22T20:20:23.1305469Z ##[error]Bash exited with code '2'."
run_scenario "$dir" > /dev/null
expect_exit "ansible-nginx" "$dir" 2
expect_in "ansible-nginx" "$(block_n "$dir" 1)" "Failure category: ANSIBLE/NGINX/DEPLOYMENT"
expect_in "ansible-nginx" "$(block_n "$dir" 1)" "nginx: [emerg]"

echo "Scenario: SSH key rejected during checkout (AUTHENTICATION, exit 2)"
dir="$(make_scenario ssh-auth)"
set_app_run "$dir" 63 completed failed
cat > "$dir/fixtures/timeline-63.json" <<'EOF'
{"records":[{"name":"Checkout code","type":"Task","result":"failed","log":{"id":9}}]}
EOF
write_log "$dir/fixtures/log-63-9.json" \
    "2026-10-22T20:20:22.1043737Z git@ssh.dev.azure.com: Permission denied (publickey)." \
    "2026-10-22T20:20:22.1043738Z fatal: Could not read from remote repository." \
    "2026-10-22T20:20:23.1305469Z ##[error]Bash exited with code '128'."
run_scenario "$dir" > /dev/null
expect_exit "ssh-auth" "$dir" 2
expect_in "ssh-auth" "$(block_n "$dir" 1)" "Failure category: AUTHENTICATION"

echo "Scenario: agent timeout while waiting for a job (AGENT/RUNNER AVAILABILITY, exit 2)"
dir="$(make_scenario agent-timeout)"
set_app_run "$dir" 64 completed failed
cat > "$dir/fixtures/timeline-64.json" <<'EOF'
{"records":[{"name":"Initialize job","type":"Job","result":"failed","log":{"id":9}}]}
EOF
write_log "$dir/fixtures/log-64-9.json" \
    "2026-10-22T20:20:22.1043737Z ##[error]The job has timed out waiting for an agent from pool Default."
run_scenario "$dir" > /dev/null
expect_exit "agent-timeout" "$dir" 2
expect_in "agent-timeout" "$(block_n "$dir" 1)" "Failure category: AGENT/RUNNER AVAILABILITY"

echo "Scenario: failed run with no matching evidence (UNCLASSIFIED, FAIL, exit 2)"
dir="$(make_scenario unclassified)"
set_app_run "$dir" 65 completed failed
cat > "$dir/fixtures/timeline-65.json" <<'EOF'
{"records":[{"name":"Mystery step","type":"Task","result":"failed","log":{"id":9}}]}
EOF
write_log "$dir/fixtures/log-65-9.json" \
    "2026-10-22T20:20:22.1043737Z something unexpected happened"
run_scenario "$dir" > /dev/null
expect_exit "unclassified" "$dir" 2
expect_in "unclassified" "$(block_n "$dir" 1)" "Failure category: UNCLASSIFIED"
expect_in "unclassified" "$(block_n "$dir" 1)" "Verdict: FAIL"

echo "Scenario: canceled run is WARN, not FAIL (exit 1)"
dir="$(make_scenario canceled)"
set_app_run "$dir" 66 completed canceled
run_scenario "$dir" > /dev/null
expect_exit "canceled" "$dir" 1
expect_in "canceled" "$(health_of "$dir")" "Overall status: WARN"

echo "Scenario: run still in progress is WARN, not PASS (exit 1)"
dir="$(make_scenario in-progress)"
echo '[{"id":67,"status":"inProgress","sourceBranch":"refs/heads/main"}]' > "$dir/fixtures/runs-8.json"
run_scenario "$dir" > /dev/null
expect_exit "in-progress" "$dir" 1
expect_in "in-progress" "$(block_n "$dir" 1)" "Verdict: WARN"
expect_in "in-progress" "$(block_n "$dir" 1)" "Failure category: NOT ASSESSABLE"

echo "Scenario: pipeline with no runs is WARN (exit 1)"
dir="$(make_scenario no-runs)"
echo '[]' > "$dir/fixtures/runs-8.json"
run_scenario "$dir" > /dev/null
expect_exit "no-runs" "$dir" 1
expect_in "no-runs" "$(block_n "$dir" 1)" "Reason: No pipeline runs were returned."

echo "Scenario: sign-in failure is ERROR, never PASS (exit 3)"
dir="$(make_scenario no-auth)"
set_app_run "$dir" 68 completed succeeded
touch "$dir/fixtures/noauth"
run_scenario "$dir" > /dev/null
expect_exit "no-auth" "$dir" 3
expect_in "no-auth" "$(health_of "$dir")" "Overall status: ERROR"
expect_in "no-auth" "$(cat "$dir/work/reports/app-last-run.log")" "Verdict: ERROR"
expect_in "no-auth" "$(cat "$dir/work/reports/infra-last-run.log")" "Verdict: ERROR"
expect_not_in "no-auth" "$(health_of "$dir")" "Overall status: PASS"

echo "Scenario: project not reachable is ERROR (exit 3)"
dir="$(make_scenario no-project)"
set_app_run "$dir" 69 completed succeeded
touch "$dir/fixtures/noproject"
run_scenario "$dir" > /dev/null
expect_exit "no-project" "$dir" 3
expect_in "no-project" "$(health_of "$dir")" "Overall status: ERROR"

echo "Scenario: one pipeline's latest run cannot be read is ERROR (exit 3)"
dir="$(make_scenario app-unreadable)"
rm -f "$dir/fixtures/runs-8.json"
set_infra_run "$dir" 73 completed succeeded
run_scenario "$dir" > /dev/null
expect_exit "app-unreadable" "$dir" 3
expect_in "app-unreadable" "$(health_of "$dir")" "Epicbook-infra-pipeline (ID 7) - run 73,category NONE: PASS"
expect_in "app-unreadable" "$(health_of "$dir")" "Epicbook-App-Pipeline (ID 8): ERROR"
expect_in "app-unreadable" "$(cat "$dir/work/reports/app-last-run.log")" "Inspection status: ERROR"

echo
echo "Results: $PASS passed, $FAIL failed"
[[ "$FAIL" -eq 0 ]]
