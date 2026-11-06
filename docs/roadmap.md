# Public engineering roadmap

Updated: **6 November 2026**. This is a **sanitized engineering roadmap** for a running Home Lab; it intentionally omits the topology, identities and access details of the live environment.

## Completed and evidenced

- **Virtualization and core services:** Proxmox-based utility host and an independent two-node cluster with quorum witness; application workloads separated into VMs/containers.
- **Layered storage:** Ceph for selected shared virtual disks, NAS/ZFS for data and snapshots, and a dedicated Proxmox Backup Server for backups.
- **Recovery automation:** recurring backup and replication jobs, service-level failure handlers, and scheduled configuration backup workflows. Specific restore paths still require full exercises.
- **Service monitoring:** a Zabbix deployment with 19 configured targets, 18 active ICMP targets with reachability verified, and six application web scenarios.
- **Ceph observations:** one cluster-wide API collector and ten dependent items; 11 of 11 items supported in the last check, with nine configured alert triggers. Monitoring has been verified to collect data, but deliberate failure injection has not been performed.
- **Storage monitoring:** SNMPv3 integrations for three TrueNAS servers and one Synology NAS; API-based Proxmox and PBS monitoring. Some individual storage metrics remain to be validated.
- **Documentation-as-code:** a separate private operational repository plus this sanitized public engineering portfolio; initial read-only Ansible playbooks and reusable notification patterns published.
- **Per-host hardware inventory started:** CPU/RAM/storage/network fields recorded with evidence levels; the dedicated backup server's hardware and separate local rescue eMMC are now confirmed. Two-drive NAS replacement resilver completion is still pending. [Hardware methodology and field note](hardware-inventory.md).

## In progress / next

1. **Alert quality and delivery:** real Zabbix email alerts for host DOWN/UP and degraded storage pool were received during actual disk replacement on 6 November (**problem/recovery email delivery validated for those events**). Finish the separate critical-only ntfy route, trigger dependencies and broader coverage; do not disturb the working email action or deliberately fail backups.
2. **DNS resilience and TLS checks:** a native DNS service on an existing NAS is installed and routes non-local lookups through the primary gateway only. An authoritative internal zone and one record have been **directly verified** after correcting zone NS configuration. Full static record synchronization, an additional service-name zone, split-horizon validation and safe client distribution are **not yet complete**. A guarded scheduled synchronization implementation exists privately but **is not installed**. DNS/TLS monitoring templates remain privately staged, not deployed. See the [DNS resilience design note](local-dns-resilience.md).
3. **Backup freshness and storage diagnostics:** verify PBS job results and datastore health, ZFS pool alerts, SMART temperatures, and stale replication detection. On the low-power PBS host, prepare periodic configuration rescue archives on the newly initialized secondary flash device; the storage is mounted but no new archive job is active. Keep existing job notifications intact.
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

- The agreed second active DHCP service with a non-overlapping address pool; not yet enabled. Validate lease allocations, advertised DNS/router options and domain-based VPN routing before activation.
- Additional security telemetry such as host intrusion monitoring.
- Improved Home Assistant controls, IoT integrations and emergency VPS management.
- Codec modernization and media-library quality reporting.

## Evidence policy

**Designed** is not **deployed**. **Deployed** is not **working**. **Working** is not **recovery-tested**.

This public portfolio intentionally includes only high-level status and synthetic examples. Real endpoints, access credentials, internal IP addresses, certificates, service accounts, serial numbers and unredacted logs remain private.
