# Runbook: scheduled backup failure triage

**Purpose:** generic, read-only first response. No live identifiers or credentials are included.

## Observe before changing state

1. Identify the systemd unit named in the alert and the last scheduled execution time.
2. Read the result, exit status and timestamp:

~~~bash
systemctl show --no-pager example-backup.service \
  -p Result -p ExecMainCode -p ExecMainStatus \
  -p ExecMainStartTimestamp -p ExecMainExitTimestamp
~~~

3. Read the latest journal entries for the corresponding unit:

~~~bash
journalctl -u example-backup.service -n 100 --no-pager
~~~

4. Determine whether the issue is access, filesystem mount, NAS connectivity, authentication, low capacity, an overlapping job, or an application error. **Do not assume a cause** from an exit code alone.
5. Check that a recent valid recovery point exists. A failed scheduled job can be tolerated differently depending on the age of the last verified backup.
6. Only after reviewing concurrency, disk space, snapshot/backup locks and retention should an operator rerun the job. Never blindly remove locks or prune datasets.
7. If a backup succeeds after intervention, confirm the data is restorable before closing a data-protection incident.

## Notification design

Use systemd OnFailure to dispatch through a local reporter. The reporter should include the unit, host role, observed result, timestamp and suggested logs. Send through the environment's authorized mail or notification transport without putting secrets in the unit or GitHub.

A sanitized implementation of the reporting pattern is available in [automation/scripts/systemd_failure_report.py](../../automation/scripts/systemd_failure_report.py). It defaults to reporting to stdout, not contacting a live notification service.

**Test status:** the reference runbook has not been executed against all private production jobs as published. Real backup/restore tests remain separately tracked.
