# Public validation log

Updated: **8 November 2026**. Public evidence is summarized rather than posting original command output, private topology or credentials.

| Area | Current claim | Verification level |
|---|---|---|
| Ceph monitoring template | One master and ten dependents supported; MON/OSD/PG counters plausible | **Measured collection** |
| Ceph alert rules | Nine configured triggers | **Configured**, outage/recovery notifications not deliberately tested |
| ICMP reachability | Eighteen hosts up, including six with complete triple ICMP checks | **Measured collection** |
| Application HTTP health | Six enabled web scenario definitions at 1-minute interval | **Configuration verified**, selected historical endpoint tests; not a complete new end-to-end audit |
| NAS via SNMPv3 | Several NAS targets integrated; no unsupported items in initial three-node check | **Partial measured collection** |
| Backup Server API | Authenticated data retrieval and monitoring template integration | **Functional API path**, per-job alert and restore evidence separate |
| Backups and replication | Automated jobs and monitoring mechanisms in place | **Configured/selected success logs**, not universal restore validation |
| DNS/TLS additional templates | Twelve monitored DNS-resolution and TLS-certificate items linked to the monitoring host, all 12 reported Supported and no errors in a read-only sampling | **Measured item collection**; individual trigger delivery not exercised |
| Zabbix email transport and action | Operator received real host-down, host-up/recovery and degraded-pool alert emails during physical disk maintenance on 6 November | **Real-event problem/recovery notification delivery confirmed** for observed event types; not all triggers tested |
| Zabbix push webhook and action | Media type tested successfully, user recipient associated, separate action saved with unsuppressed High/Disaster filters and recovery operation; 7–21 November is the observation window | **Configured and direct webhook transport tested**; automatic incident-to-recipient delivery not yet observed |
| Alternate local DNS resolver | Two authoritative zones, 33 static A mappings; 32 live updates and zero-change repeat dry-run; timer enabled; local, override and external lookups successful | **Sync and queries verified**; first unattended timer run and outage validation pending |
| Parallel DHCP option | Gateway and NAS DHCPv4 enabled with disjoint pools; gateway option 6 advertises both resolvers, confirmed on a Windows client; operator later reported DHCP and static-IP checks complete | **Gateway client config measured; NAS DHCP verification operator-reported**, no second-server lease transcript retained |
| Local backup host rescue flash | Separate onboard eMMC formatted, mounted and root-only backup directory created; automated local copies not yet scheduled | **Storage prepared**, backup/restore untested |
| NAS-backed VM delayed-boot retry | Separate nonblocking systemd retry enabled; three production VMs have standard onboot disabled, remained running; manual service start terminated successfully with all VMs already up | **Configuration and no-op test verified**; delayed storage, host reboot and true recovery not exercised |
| Backup datastore usage threshold | Existing percentage-used alerts retained, warning threshold changed to 80% on backup-server host rather than new alerts | **Operator-confirmed host macro override**; crossing threshold and delivery untested |
| Monthly application availability | Six application Services matched to existing HTTP-failure triggers; one 24/7 monthly SLA, informational target | **Configured for six services**; report association checked for first service; SLI reaction to a real outage observed |
| Actual application outage detection | A previously monitored service became unresponsive and was restarted twice; observed SLI percentage change | **Real-event responsiveness observed**; downtime duration and root cause not formally analyzed |
| Infrastructure map/dashboard | Nineteen monitored elements shown on a linked logical infrastructure map, charting compute, memory and NAS disk temperatures with 24-hour aligned times | **Operator screenshot / visual verification**; sanitized production evidence not published |
| Power-loss graceful shutdown | UPS and coordinated system shutdown identified as future investment and runbook topic | **Planned, not deployed** |
| Disaster recovery | Runbooks and backup copies available | **Recovery exercise outstanding** |
| VPS container patching and proxy recovery (8 Nov) | Ubuntu, reverse-proxy and notifications images, and container runtime upgraded. Proxy initially failed on host reboot due to a network-namespace startup race, recovered manually; one-shot systemd retry enabled. Operator subsequently switched to the upgraded VPS VPN and confirmed working traffic | **Host reboot, manual proxy recovery, and real post-upgrade VPN connectivity operator-confirmed**; automatic recovery on the next reboot, endpoint-by-endpoint checks and rescanned CVEs outstanding |

## Evidence conventions

- **Configured:** a file, job, template or trigger exists.
- **Collected:** a real metric or result has been observed.
- **Alert delivered:** a notification reached the intended recipient.
- **Restore tested:** recovery was exercised and verified.
- **Full failover tested:** an actual controlled failover was performed and timings measured.

These are independent stages. Do not collapse them into a single 'done' label.
