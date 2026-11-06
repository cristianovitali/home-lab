# Home Lab

**Hybrid infrastructure · Virtualization · Storage · Data protection · Monitoring**

A practical self-hosted infrastructure project combining Proxmox VE, Ceph, TrueNAS/ZFS, Proxmox Backup Server, Linux services, private networking, and centralized observability.

The objective is not to reproduce an enterprise datacenter at home. It is to apply sound infrastructure and data-protection principles **within realistic constraints**: reused hardware, limited budget, power consumption, operational simplicity, and maintainability.

> **Public portfolio edition.** Host labels and network boundaries are intentionally generic. Real hostnames, domains, IP addresses, credentials, keys, identifiers, exact routing rules, and sensitive configuration are not published. This repository describes design patterns and operational lessons rather than serving as a deployable copy of the private environment.

## At a glance

| Layer | Technologies | Main purpose |
|---|---|---|
| Compute | Proxmox VE, virtual machines, Linux containers | Workload isolation and lifecycle management |
| Cluster storage | Ceph | Shared storage for selected clustered workloads |
| Network storage | TrueNAS, ZFS, NFS; Synology, iSCSI | Data services, snapshots and selected shared storage |
| Backup | Proxmox Backup Server, ZFS snapshots/replication, scripted acquisition | Recovery points and protection of critical workloads |
| Network & remote access | OpenWrt, private VPN links, Caddy | Segmented access and controlled publication of services |
| Applications | Nextcloud, ONLYOFFICE, Plex, Home Assistant, Frigate | Collaboration, media and smart-home services |
| Security & operations | CrowdSec, centralized notifications, Zabbix | Defense-in-depth, health checks and operational visibility |

## Architecture

The environment uses a **two-node Proxmox cluster with an external quorum witness**, plus a separate utility virtualization host, dedicated NAS systems, a backup server, and external Linux VPS instances for controlled remote access. Selected VM workloads use Ceph; application data and backup storage use purpose-specific ZFS/NAS arrangements.

A high-level, sanitized system diagram, architectural trade-offs, data-protection approach, monitoring coverage, and known limitations are documented here:

**[Read the architecture overview](docs/architecture-overview.md)**

## Engineering principles

1. **Recovery before redundancy claims:** a backup is not proven until its restore path is tested.
2. **Separate compute, data, and protection:** use the storage and availability model appropriate to each workload.
3. **Least privilege and private management:** keep administrative interfaces off the public internet wherever practicable.
4. **Prefer deliberate simplicity:** adding resilience must not create disproportionate operational risk.
5. **Document trade-offs:** constraints and failure modes matter as much as feature lists.
6. **Observe the service, not just the host:** pair device checks with application endpoints and backup outcomes.

## Current state

The core infrastructure and primary self-hosted services are operational. Zabbix monitoring now covers **18 verified ICMP targets**, **six already configured application web scenarios**, and a **Ceph API template with 11 of 11 items collecting successfully** at the last validation. API/SNMP monitoring is in place for backup and storage systems. Backup workflows are in use. **A direct email test and a direct push-webhook test succeeded**, and a Zabbix email trigger action has been saved; **alert delivery from a real trigger has not yet been verified**, and the push route still needs recipient/action configuration. Secondary local DNS configuration has begun on an existing NAS; DNS zone population, synchronization, policy-routing tests, DHCP changes and outage validation remain pending. Full end-to-end restores, some replication validation and deeper hardware/storage alerting are also ongoing.

This is a living operational environment. The architecture document distinguishes deployed capabilities from validations that are still pending.

## Public documentation and reusable automation

- [Project roadmap and priorities](docs/roadmap.md)
- [Monitoring coverage and alerting approach](docs/monitoring-and-alerting.md)
- [Hardware inventory and disk-replacement recovery case](docs/hardware-inventory.md) — anonymized inventory methodology and observed, unfinished resilver
- [Local DNS resilience and DHCP trade-offs](docs/local-dns-resilience.md) — configuration started; client cutover and failover are not claimed
- [Validation status and evidence levels](docs/validation-status.md)
- [ADR: Layered monitoring](docs/adr/0001-layered-monitoring.md)
- [ADR: Recovery-first protection](docs/adr/0002-backup-and-restore.md)
- [Runbook: Backup failure triage](docs/runbooks/backup-failure-triage.md)
- [Runbook: Power-event recovery](docs/runbooks/power-event-recovery.md)
- [Ansible reference playbooks](automation/ansible/README.md) — six reviewed examples, sample inventory and reboot diagnostic task
- [Sanitized Python operational scripts](automation/scripts/README.md) — systemd failure and reboot-required reports

## Documentation roadmap

- [x] Sanitized architecture overview and design trade-offs
- [x] Public runbooks for selected safe operational workflows
- [x] Architecture decision records and initial reusable automation
- [x] Monitoring status and alert design (deployment of advanced alerts in progress)
- [ ] Backup/restore test reports with measured results and recovery times
- [ ] Sanitized monitoring dashboards and visual infrastructure diagrams

## Responsible publication

This portfolio intentionally excludes live endpoints, public IPs, internal addresses, user identities, API tokens, VPN configuration, secrets, backup paths, device serial numbers, and configuration exports. Diagrams are logical, not literal network maps.

The work uses AI-assisted research, drafting, and troubleshooting as engineering support. Requirements, design decisions, execution, and verification remain under the project maintainer's control.
## License

Original documentation and architecture diagrams in this repository are provided under the [Creative Commons Attribution 4.0 International (CC BY 4.0)](LICENSE) license. Reuse and adaptation are welcome with appropriate attribution and indication of changes. Third-party names, trademarks and any independently licensed assets remain subject to their respective rights. Public automation and code examples are distributed under the [MIT License](automation/LICENSE), separately from the CC BY 4.0 documentation license.
