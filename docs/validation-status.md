# Public validation log

Updated: **6 November 2026**. Public evidence is summarized rather than posting original command output, private topology or credentials.

| Area | Current claim | Verification level |
|---|---|---|
| Ceph monitoring template | One master and ten dependents supported; MON/OSD/PG counters plausible | **Measured collection** |
| Ceph alert rules | Nine configured triggers | **Configured**, outage/recovery notifications not deliberately tested |
| ICMP reachability | Eighteen hosts up, including six with complete triple ICMP checks | **Measured collection** |
| Application HTTP health | Six enabled web scenario definitions at 1-minute interval | **Configuration verified**, selected historical endpoint tests; not a complete new end-to-end audit |
| NAS via SNMPv3 | Several NAS targets integrated; no unsupported items in initial three-node check | **Partial measured collection** |
| Backup Server API | Authenticated data retrieval and monitoring template integration | **Functional API path**, per-job alert and restore evidence separate |
| Backups and replication | Automated jobs and monitoring mechanisms in place | **Configured/selected success logs**, not universal restore validation |
| DNS/TLS additional templates | Prepared privately for later deployment | **Not deployed** |
| Zabbix email transport and action | Operator received real host-down, host-up/recovery and degraded-pool alert emails during physical disk maintenance on 6 November | **Real-event problem/recovery notification delivery confirmed** for observed event types; not all triggers tested |
| Zabbix push webhook and action | Media enabled and direct webhook test reached recipient; secret reference configured; critical-only action and recipient linkage pending | **Transport tested**, automatic alerting not deployed |
| Alternate local DNS resolver | Authoritative internal zone loaded; initial A record verified with direct query after NS correction; full synchronization and outage test pending | **Single-record DNS lookup measured**, resilience not tested |
| Parallel DHCP option | Two simultaneously active DHCP servers with disjoint pools agreed; no second DHCP enabled and no client DHCP changes | **Design agreed, not deployed** |
| Local backup host rescue flash | Separate onboard eMMC formatted, mounted and root-only backup directory created; automated local copies not yet scheduled | **Storage prepared**, backup/restore untested |
| Disaster recovery | Runbooks and backup copies available | **Recovery exercise outstanding** |

## Evidence conventions

- **Configured:** a file, job, template or trigger exists.
- **Collected:** a real metric or result has been observed.
- **Alert delivered:** a notification reached the intended recipient.
- **Restore tested:** recovery was exercised and verified.
- **Full failover tested:** an actual controlled failover was performed and timings measured.

These are independent stages. Do not collapse them into a single 'done' label.
