# Public validation log

Updated: **7 November 2026**. Public evidence is summarized rather than posting original command output, private topology or credentials.

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
| Alternate local DNS resolver | Two authoritative zones, 33 static A mappings; 32 live updates and zero-change repeat dry-run; timer enabled; local, override and external lookups successful | **Sync and queries verified**; first unattended timer run and outage validation pending |
| Parallel DHCP option | Gateway and NAS DHCPv4 enabled with disjoint pools; gateway option 6 advertises both resolvers, confirmed on a Windows client; operator later reported DHCP and static-IP checks complete | **Gateway client config measured; NAS DHCP verification operator-reported**, no second-server lease transcript retained |
| Local backup host rescue flash | Separate onboard eMMC formatted, mounted and root-only backup directory created; automated local copies not yet scheduled | **Storage prepared**, backup/restore untested |
| NAS-backed VM delayed-boot retry | Separate nonblocking systemd retry enabled; three production VMs have standard onboot disabled, remained running; manual service start terminated successfully with all VMs already up | **Configuration and no-op test verified**; delayed storage, host reboot and true recovery not exercised |
| Disaster recovery | Runbooks and backup copies available | **Recovery exercise outstanding** |

## Evidence conventions

- **Configured:** a file, job, template or trigger exists.
- **Collected:** a real metric or result has been observed.
- **Alert delivered:** a notification reached the intended recipient.
- **Restore tested:** recovery was exercised and verified.
- **Full failover tested:** an actual controlled failover was performed and timings measured.

These are independent stages. Do not collapse them into a single 'done' label.
