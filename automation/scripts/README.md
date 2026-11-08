# Sanitized operational scripting patterns

This directory provides **reviewable reference implementations**, **not full exports of running production scripts**. Production alerting uses private local paths, OS services and messaging backends that are deliberately omitted here.

- `systemd_failure_report.py` demonstrates a systemd OnFailure summary using a restricted service-name argument and selected `systemctl show` properties. **Printing is the default**, with explicit opt-in to local Proxmox mail forwarding.
- `reboot_required_report.py` reads `/run/reboot-required` and the optional package list and emits JSON. It **does not reboot or send a notification**.
- [`homelab-ban-ip.sh`](homelab-ban-ip.sh) safely adds one **public IPv4** or a newline-separated list of IPv4 addresses to an *already deployed* independent nftables manual-denylist. It updates the running set immediately and the persistent config file, skips duplicates, rejects non-public/invalid addresses and does not restart Docker, CrowdSec or the VPN. Requires root, Python 3 and nftables; tested locally with a mocked nft backend, **not yet deployed/validated on a live VPS**.

  ```bash
  sudo install -m 0750 homelab-ban-ip.sh /usr/local/sbin/homelab-ban-ip.sh
  sudo /usr/local/sbin/homelab-ban-ip.sh 1.1.1.1
  sudo /usr/local/sbin/homelab-ban-ip.sh /root/manual-bans.txt
  ```

  Input files support one address per line, blank lines, and `#` comments. Examples use well-known public resolver IPs for **syntax only**; do not block them as a real policy. The script does **not** create the nft table, set, or boot-time unit; deploy those first according to [the nftables runbook](../../docs/runbooks/manual-nftables-bans.md). Manual bans should not be automatically promoted from CrowdSec without explicit, reviewed criteria.

Run `python3 -m py_compile automation/scripts/*.py` before adapting. Keep production credentials in protected configuration files or a secrets manager, never in code or command-line arguments. Do not publish runtime outputs without anonymization.

These are anonymized examples of a pattern, **not verified production deployments**. Software license: [MIT](../LICENSE).
