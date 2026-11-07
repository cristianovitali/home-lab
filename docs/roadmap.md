# Public engineering roadmap

Updated: **7 November 2026**. This is a **sanitized engineering roadmap** for a running Home Lab; it intentionally omits the topology, identities and access details of the live environment.

## Completed and evidenced

- **Virtualization and core services:** Proxmox-based utility host and an independent two-node cluster with quorum witness; application workloads separated into VMs/containers.
- **Layered storage:** Ceph for selected shared virtual disks, NAS/ZFS for data and snapshots, and a dedicated Proxmox Backup Server for backups.
- **Recovery automation:** recurring backup and replication jobs, service-level failure handlers, and scheduled configuration backup workflows. Specific restore paths still require full exercises.
- **Service monitoring:** a Zabbix deployment with 19 configured targets, 18 active ICMP targets with reachability verified, and six application web scenarios.
- **Ceph observations:** one cluster-wide API collector and ten dependent items; 11 of 11 items supported in the last check, with nine configured alert triggers. Monitoring has been verified to collect data, but deliberate failure injection has not been performed.
- **Storage monitoring:** SNMPv3 integrations for three TrueNAS servers and one Synology NAS; API-based Proxmox and PBS monitoring. Some individual storage metrics remain to be validated.
- **Documentation-as-code:** a separate private operational repository plus this sanitized public engineering portfolio; initial read-only Ansible playbooks and reusable notification patterns published.
- **Per-host hardware inventory started:** CPU/RAM/storage/network fields recorded with evidence levels; the dedicated backup server's hardware and separate local rescue eMMC are now confirmed. Two-drive NAS replacement resilver completion is still pending. [Hardware methodology and field note](hardware-inventory.md).
- **Nonblocking VM start recovery configured (7 November):** a separate systemd service was enabled on the utility virtualization host to retry startup of three NAS-backed production guests when their shared storage is detected as active. Default guest autostart was disabled for those guests, leaving them running during configuration. The host's normal startup and iSCSI configuration were not altered. The service completed one no-op test successfully while all guests were already running; **delayed NAS readiness and real restart recovery remain untested**. Future cluster HA will require redesign/removal of the local retry service.

## Newly configured and observed — 7 November 2026

- **Emergency notification route:** a separate HTTPS push action was configured with Problem and Recovery operations. Its current policy is unsuppressed High/Disaster triggers, without per-trigger opt-in tags, during a two-week observation trial. Delivery through the webhook's standalone test has been confirmed; **automatic end-to-end delivery through a real trigger is not yet verified**. Existing email alerting is preserved.
- **Backup capacity alert:** the existing backup-server datastore usage warning threshold was changed from 90% to **80%** through a host-level override. The action remains at a non-emergency severity, to avoid duplicating high-priority push notifications. Native failure alerts remain in charge of backup and replication job failures. Detailed per-workload freshness monitoring was deliberately deferred.
- **Application reliability measurement:** six application services are now represented as Zabbix Services linked to existing HTTP health-check triggers. One monthly 24/7 SLA measures their service-level indicators; its 99% SLO is a **reporting reference rather than a contractual availability objective**. During an actual service-unresponsive incident, the operator observed the measured availability indicator change. This validates responsiveness to one real outage, not a comprehensive uptime audit.
- **Operational dashboard:** a map of monitored infrastructure with dynamic problem highlighting has been incorporated into an existing operational dashboard alongside CPU, memory, and NAS disk-temperature charts. Graph time ranges were normalized to the **last 24 hours**. Elevated NAS memory occupancy is mostly attributable to ZFS ARC cache in the observed setup, rather than proving RAM pressure. **No unsanitized production map or dashboard is published.**

## Observation / validation focus

1. **Two-week alert observation (7–21 November):** examine event relevance, duplicates and missed notifications before introducing new trigger tags, exclusions or dependency rules. Do not claim the push action is end-to-end verified before a real event is seen.
2. **Measure observed application availability over time:** retain monthly 24/7 reports, describe internal-probe blind spots during site-wide outages, and decide later whether to publish aggregated sanitized results.
3. **Test delayed storage availability on a real restart:** verify that an independent VM startup retry correctly recovers storage-backed guests without delaying host startup; a successful no-op test while guests run is not proof of delayed-start recovery.
4. **Check existing resilience tasks opportunistically:** restored-backup exercises, standby workloads, storage replacements and periodic configuration backups continue in their own workstreams. No unnecessary new backup monitoring scripts.
5. **Power-loss resilience:** a future UPS and graceful coordinated shutdown/restart plan remains a priority, **not yet deployed**. No artificial blackout test is requested.

## Planned validation / resilience work

- Controlled restore of a workload and critical application data, including encrypted/offsite or replicated backups where available.
- Failure and delayed-start tests for storage-dependent virtual machines and infrastructure startup ordering.
- Verification of backup copy recovery from a second storage node.
- Controlled failover tests for clustered services; report actual RTO/RPO rather than assuming configured intervals imply guaranteed recovery.
- Security reviews: externally reachable entrypoints, authentication, least privilege, vulnerability scanning and alert normalization.

## Research backlog (not deployed)

- Record a documented end-to-end DHCP lease and DNS/PBR behavior under gateway outage if needed; operator reports DHCP/IP checks already performed, but no detailed lease transcript is included in the public evidence.
- Additional security telemetry such as host intrusion monitoring.
- Improved Home Assistant controls, IoT integrations and emergency VPS management.
- Codec modernization and media-library quality reporting.

## Evidence policy

**Designed** is not **deployed**. **Deployed** is not **working**. **Working** is not **recovery-tested**.

This public portfolio intentionally includes only high-level status and synthetic examples. Real endpoints, access credentials, internal IP addresses, certificates, service accounts, serial numbers and unredacted logs remain private.
