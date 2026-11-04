#!/usr/bin/env python3
"""Sanitized reference: systemd OnFailure report, with optional PBS mail forwarding.

Default behavior is dry-run: print a short report to stdout. Forwarding is
explicitly opt-in and requires a compatible Proxmox mail-forward program.
No real host addresses, service identifiers, or secrets are embedded.
"""
import argparse
import re
import socket
import subprocess
from datetime import datetime, timezone
from email.message import EmailMessage


def build_report(unit: str) -> tuple[str, str]:
    if not re.fullmatch(r"[A-Za-z0-9][A-Za-z0-9_.@-]*\.service", unit):
        raise ValueError("Invalid systemd service unit name")
    completed = subprocess.run(
        ["/usr/bin/systemctl", "show", unit, "--no-pager",
         "--property=Description,Result,ExecMainCode,ExecMainStatus,"
         "ExecMainStartTimestamp,ExecMainExitTimestamp"],
        text=True, capture_output=True, check=True, timeout=10,
    )
    fields = dict(line.split("=", 1) for line in completed.stdout.splitlines()
                  if "=" in line)
    result = fields.get("Result", "unknown")
    status = fields.get("ExecMainStatus", "unknown")
    title = "Infrastructure automation failed: " + unit
    report = "\n".join([
        "Event: systemd service failure",
        "Host: " + socket.gethostname(),
        "Unit: " + unit,
        "Description: " + fields.get("Description", unit),
        "Observed: " + datetime.now(timezone.utc).isoformat(),
        "Result: " + result,
        "Exit status: " + status,
        "Root cause: unconfirmed; inspect journal before assigning blame",
        "Impact: this scheduled operation may not have completed",
        "Action: review journalctl for this unit and its most recent backup",
        "Journal command: journalctl -u " + unit + " -n 100 --no-pager",
    ])
    return title, report


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("unit", help="A fully qualified .service unit")
    parser.add_argument("--forward-pbs", action="store_true",
                        help="Opt in to local Proxmox mail forwarding")
    args = parser.parse_args()
    title, report = build_report(args.unit)
    if not args.forward_pbs:
        print(title + "\n\n" + report)
        return
    msg = EmailMessage()
    msg["From"] = "root@localhost"
    msg["To"] = "root"
    msg["Subject"] = title
    msg.set_content(report)
    subprocess.run(["/usr/libexec/proxmox-mail-forward"],
                   input=msg.as_bytes(), check=True, timeout=50)


if __name__ == "__main__":
    main()
