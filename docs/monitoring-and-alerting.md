# Layered monitoring and alerting

Updated: **6 November 2026** — public, sanitized overview.

## Design

Zabbix 7.0 LTS is the central monitoring system. Collection techniques are chosen by layer rather than imposing a single agent on every device.

| Layer | Method | Current evidence |
|---|---|---|
| Host/network reachability | ICMP latency, reachability and packet loss | 18 actual targets UP at the latest consolidated check; 18 new application ICMP items supported |
| Application endpoints | Six existing Zabbix web scenarios, HTTP 200 and application-specific response checks | All six scenario definitions enabled; individual historical tests documented; do not duplicate them |
| Proxmox virtualization | Proxmox API and discovery | Integrated; one known API availability anomaly requires separate review |
| Ceph storage | Cluster API HTTP master plus ten dependent items | 11/11 supported; MON/OSD/PG counters verified, nine alert triggers configured |
| NAS and ZFS infrastructure | SNMPv3 templates | Three NAS nodes of one type and another NAS node configured; early checks observed no unsupported items on the three-node subset |
| Proxmox Backup Server | HTTP API template and monitored jobs | API integration and datastore status accessible; selected alerts and freshness checks require follow-through |
| Certificates and DNS | Prepared Agent 2 items / split-horizon probes | Designed and privately staged; **not imported** into production yet |
| Alert delivery | Existing job notifications plus Zabbix email and push webhook | Real Zabbix email alerts received during storage maintenance: host-down, host-up/recovery and degraded-pool notifications. Push webhook test succeeded, but filtered action/recipient linkage remains pending |

## Service health versus host reachability

An ICMP UP result does **not** prove the application works. Web scenarios verify endpoints and, where appropriate, content such as an API version string, maintenance-state indicator or health marker.

Web scenarios also do **not** prove an end-to-end user transaction. Future checks can authenticate and perform a read-only transaction, with credentials kept in protected host configuration.

Interface 'Unknown' in Zabbix is not automatically an outage: the Agent indicator is separate from simple ICMP checks. Dedicated service availability must be reported via actual collected metrics.

## Alerting policy

- Use human-readable, self-contained notifications: affected component, event, severity, detection timestamp, observed evidence, likely impact, suggested investigation, recovery state.
- Correlate downstream alarms with upstream network, DNS, hypervisor and storage failures before escalating.
- Avoid alerting on every non-fatal warning; review warning-level Ceph health alongside actual quorum, OSD, placement group and object degradation metrics.
- Separate **collection success** from **alert route delivered** and **full incident recovery tested**.
- Keep notification endpoints, tokens and routing rules outside the public repository.

## Current validation snapshot

The Ceph API collector and all ten dependent metrics reported supported data: three monitors in quorum, two OSDs up/in, 32 placement groups, and zero inactive/degraded placement groups or degraded objects. Cluster health itself reported a warning, so no claim of completely clean Ceph health is made. These numbers are a **point-in-time observation**, not a guarantee of current state.

All six application hosts had their three ICMP checks supported and returned UP. Previously configured checks on twelve other hosts also returned UP. Web scenario configurations are enabled; a complete new regression of all web-trigger deliveries has not been performed.

## Next steps

Real-event email problem and recovery delivery has been confirmed for host availability and storage-degradation events. Keep the existing email action intact; complete recipient/filtered-action configuration for critical push alerts, then validate the push path without causing production outages. Separately, import and validate DNS/TLS monitoring templates. A NAS alternative DNS resolver is being configured, but its independent local-zone answers and compatibility with domain-based VPN policy routing require testing before it becomes a client DNS option. See [DNS resilience design](local-dns-resilience.md). Finally add service levels and dashboards using measured application health.
