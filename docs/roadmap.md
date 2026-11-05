# Public engineering roadmap

Updated: **5 November 2026**. This is a **sanitized engineering roadmap** for a running Home Lab; it intentionally omits the topology, identities and access details of the live environment.

## Completed and evidenced

- **Virtualization and core services:** Proxmox-based utility host and an independent two-node cluster with quorum witness; application workloads separated into VMs/containers.
- **Layered storage:** Ceph for selected shared virtual disks, NAS/ZFS for data and snapshots, and a dedicated Proxmox Backup Server for backups.
- **Recovery automation:** recurring backup and replication jobs, service-level failure handlers, and scheduled configuration backup workflows. Specific restore paths still require full exercises.
- **Service monitoring:** a Zabbix deployment with 19 configured targets, 18 active ICMP targets with reachability verified, and six application web scenarios.
- **Ceph observations:** one cluster-wide API collector and ten dependent items; 11 of 11 items supported in the last check, with nine configured alert triggers. Monitoring has been verified to collect data, but deliberate failure injection has not been performed.
- **Storage monitoring:** SNMPv3 integrations for three TrueNAS servers and one Synology NAS; API-based Proxmox and PBS monitoring. Some individual storage metrics remain to be validated.
- **Documentation-as-code:** a separate private operational repository plus this sanitized public engineering portfolio; initial read-only Ansible playbooks and reusable notification patterns published.

## In progress / next

1. **Alert quality and delivery:** finish Zabbix action routing, an ntfy integration, trigger dependencies, and notification recovery behavior. Validate delivery without disturbing production or deliberately failing backups.
2. **DNS resilience and TLS checks:** a native DNS service on an existing NAS is installed and forwards exclusively through the primary gateway; the local authoritative zone, record synchronization, split-horizon validation and safe client distribution are **not yet complete**. Additional DNS/TLS monitoring templates are privately staged but **not yet deployed**. See the [DNS resilience design note](local-dns-resilience.md).
3. **Backup freshness and storage diagnostics:** verify PBS job results and datastore health, ZFS pool alerts, SMART temperatures, and stale replication detection. Keep existing job notifications intact.
4. **Failure dependency model:** suppress derivative application incidents when an upstream network, DNS, storage or virtualization dependency is unavailable.
5. **Monitoring service levels:** define application-level availability objectives and measure rolling historical periods; distinguish reachable host, correct HTTP response and verified application transaction.
6. **Operational dashboards:** aggregate meaningful network, backup, cluster, and application states while avoiding noisy or misleading green statuses.

## Planned validation / resilience work

- Controlled restore of a workload and critical application data, including encrypted/offsite or replicated backups where available.
- Failure and delayed-start tests for storage-dependent virtual machines and infrastructure startup ordering.
- Verification of backup copy recovery from a second storage node.
- Controlled failover tests for clustered services; report actual RTO/RPO rather than assuming configured intervals imply guaranteed recovery.
- Security reviews: externally reachable entrypoints, authentication, least privilege, vulnerability scanning and alert normalization.

## Research backlog (not deployed)

- A possible second DHCP service with separate address pools, after DNS and domain-based VPN routing validation.
- Additional security telemetry such as host intrusion monitoring.
- Improved Home Assistant controls, IoT integrations and emergency VPS management.
- Codec modernization and media-library quality reporting.

## Evidence policy

**Designed** is not **deployed**. **Deployed** is not **working**. **Working** is not **recovery-tested**.

This public portfolio intentionally includes only high-level status and synthetic examples. Real endpoints, access credentials, internal IP addresses, certificates, service accounts, serial numbers and unredacted logs remain private.
