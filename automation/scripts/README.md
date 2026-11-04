# Sanitized operational scripting patterns

This directory provides **reviewable reference implementations**, **not full exports of running production scripts**. Production alerting uses private local paths, OS services and messaging backends that are deliberately omitted here.

- `systemd_failure_report.py` demonstrates a systemd OnFailure summary using a restricted service-name argument and selected `systemctl show` properties. **Printing is the default**, with explicit opt-in to local Proxmox mail forwarding.
- `reboot_required_report.py` reads `/run/reboot-required` and the optional package list and emits JSON. It **does not reboot or send a notification**.

Run `python3 -m py_compile automation/scripts/*.py` before adapting. Keep production credentials in protected configuration files or a secrets manager, never in code or command-line arguments. Do not publish runtime outputs without anonymization.

These are anonymized examples of a pattern, **not verified production deployments**. Software license: [MIT](../LICENSE).
