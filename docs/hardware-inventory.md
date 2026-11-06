# Hardware inventory — approach and initial coverage

**Updated:** 6 November 2026. **Public portfolio overview; deliberately anonymized.**

A maintainable Home Lab benefits from a per-host inventory rather than a diagram that merely shows service names. The private working inventory now includes separate hardware sheets for virtualization nodes, the backup system, three NAS systems, an existing commercial NAS, network appliances, and externally hosted VPS instances.

## Recorded hardware classes

| Class | High-level known configuration | What remains to validate |
|---|---|---|
| Virtualization nodes | Two 12-thread midrange Intel CPU nodes with approximately 16 GB RAM each, plus a lower-power four-port utility mini-PC with approximately 8 GB RAM | Motherboards, exact slot-level disk inventory, link dependencies, power |
| ZFS NAS | Three reused desktop-class CPU platforms, each with approximately 16 GB RAM; RAIDZ, mirror and replication roles | Current per-drive inventory, resilver/SMART completion evidence, HBA and physical locations |
| Commercial NAS | Existing two-bay appliance with shared block storage and planned alternative DNS | Physical disk health, dependency sequencing, DNS validation |
| Backup server | Dedicated Proxmox Backup Server role | Actual machine classification and CPU/RAM inventory need reconciliation |
| VPS | Two externally hosted instances providing selected network/application services | Virtual resource quotas, independent recovery capability |
| Access/network | Commodity switches, separate cluster-storage links and mesh wireless | Cable/port map, power failure domains |

The private inventory distinguishes **confirmed model**, **historically observed**, **not yet known** and **planned**. Logical disks and cloud-provided virtual resources are not misrepresented as physical devices.

## Field note: disk replacements during ZFS recovery

An observed maintenance event involved replacing **two storage devices** on one ZFS NAS system. Resilvering was **in progress** at the last operator report. CPU utilization did not exceed **10% during the interval observed by the operator**; this does **not** establish completion, storage throughput or recovery health. Physical drive-label and firmware-reported identifiers had previously shown a discrepancy on one device, raising a possible remarketing/refurbishment question; the cause is **not established**.

The case motivates three practices:

1. Inventory firmware serials, physical labels and actual chassis slots separately, especially before disk removal.
2. Record replacement and resilver completion as **different milestones**; log status, errors and follow-up SMART explicitly.
3. Avoid assuming low CPU usage indicates storage operations are finished, safe or throughput-optimized.

The public version intentionally excludes live hostnames, addresses, disk serials, internal pool identifiers, identifiers tied to external service contracts and detailed recovery paths.
