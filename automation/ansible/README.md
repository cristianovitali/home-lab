# Public Ansible reference playbooks

These playbooks are **sanitized technical examples**, adapted from a private Home Lab review folder. They are **not copies verified against all currently deployed production files** and should **not** be run unchanged against real hosts. No inventory of real machines, SSH keys, API tokens, DNS names, addresses, or secret files is included.

## Contents

| Playbook | Purpose | Side effects |
|---|---|---|
| preflight.yml | Linux host facts and reboot-required context | Read-only |
| monitoring-health.yml | Check Zabbix server, database and reverse-proxy services | Read-only |
| nextcloud-health.yml | Check data mount marker, services and Nextcloud occ status | Read-only; review example data directory and commands |
| pbs-health.yml | Check PBS service, task and datastore CLI access | Read-only; commands are version-dependent |
| vps-preflight.yml | Check presence of a private backup wrapper and Docker state | Read-only; path is illustrative |
| run-existing-vps-backup.yml | Explicitly invoke a separately installed, private backup wrapper | **Mutating; opt-in only**, disabled by default |
| ../tasks/reboot-notification-context.yml | Report why the OS might need a controlled reboot | Read-only; does not notify/restart |

## Safe usage

1. Copy inventory.example.yml **outside** this public repository and replace placeholders with your own targets.
2. Inspect the playbooks, paths, OS/service names, installed tools and required sudo permissions before execution.
3. Install Ansible and run its syntax checks (no hosts are contacted), e.g.:

~~~bash
ansible-playbook --syntax-check -i /path/to/private-inventory.yml playbooks/preflight.yml
~~~

4. Start with explicitly targeted preflight checks and review output before broader use.
5. The example manual backup launcher requires **both** a deliberately installed private wrapper and `backup_execute=true`; it does not store credentials or schedule backups.
6. The reboot task is diagnostic only. Do not publish its runtime output without redaction.

Published source code in this directory is under the [MIT License](../LICENSE).
