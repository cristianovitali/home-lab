#!/usr/bin/env python3
"""Read-only OS reboot-required check. Prints local diagnostic JSON only.

Derived from the reboot-context idea used by the private Home Lab.
Does not send notifications and never reboots the host.
"""
import json
from datetime import datetime, timezone
from pathlib import Path


def main() -> None:
    marker = Path("/run/reboot-required")
    packages = Path("/run/reboot-required.pkgs")
    related = packages.read_text(errors="replace").splitlines() if packages.exists() else []
    print(json.dumps({
        "event": "reboot_required" if marker.exists() else "no_reboot_request",
        "observed_utc": datetime.now(timezone.utc).isoformat(),
        "reboot_required": marker.exists(),
        "related_packages": related if marker.exists() else [],
        "root_cause": "not determined by marker alone",
        "recommended_action": "plan a controlled reboot after dependency review"
                              if marker.exists() else "none",
        "automatic_reboot": False,
    }, indent=2))


if __name__ == "__main__":
    main()
