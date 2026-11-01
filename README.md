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

The core infrastructure and primary self-hosted services are operational. Proxmox API monitoring, system/ICMP checks, and HTTP health checks are being rolled out through Zabbix. Backup workflows are in use; **full end-to-end restore evidence, some replication validation, and deeper hardware/storage alerting remain ongoing work**.

This is a living operational environment. The architecture document distinguishes deployed capabilities from validations that are still pending.

## Documentation roadmap

- [x] Sanitized architecture overview and design trade-offs
- [ ] Public runbooks with secrets and private environment details removed
- [ ] Backup/restore test reports with results and recovery times
- [ ] Monitoring dashboards and alert design
- [ ] Architecture decision records and selected reusable automation

## Responsible publication

This portfolio intentionally excludes live endpoints, public IPs, internal addresses, user identities, API tokens, VPN configuration, secrets, backup paths, device serial numbers, and configuration exports. Diagrams are logical, not literal network maps.

The work uses AI-assisted research, drafting, and troubleshooting as engineering support. Requirements, design decisions, execution, and verification remain under the project maintainer's control.
## License

Original documentation and architecture diagrams in this repository are provided under the [Creative Commons Attribution 4.0 International (CC BY 4.0)](LICENSE) license. Reuse and adaptation are welcome with appropriate attribution and indication of changes. Third-party names, trademarks and any independently licensed assets remain subject to their respective rights. Any source code published later will carry its own explicit software license.
