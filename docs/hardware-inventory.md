# Hardware inventory — approach and initial coverage

**Updated:** 6 November 2026. **Public portfolio overview; deliberately anonymized.**

A maintainable Home Lab benefits from a per-host inventory with evidence levels. The private inventory covers compute, backup, network appliances, three ZFS NAS systems, a commercial NAS and externally hosted VPS instances.

## Recorded hardware classes

| Class | High-level confirmed configuration | What remains to validate |
|---|---|---|
| Virtualization nodes | Two midrange Intel desktop CPU nodes, each with 16 GB RAM, plus a low-power four-port mini-PC with about 8 GB RAM | Motherboards, disk mapping, link dependencies, power |
| ZFS NAS | Three reused desktop-class platforms, approximately 16 GB RAM each; different RAIDZ/mirror/replication roles | Current drive inventory, resilver and SMART completion, slot mapping |
| Commercial NAS | Existing two-bay appliance used for shared storage and alternate DNS | Storage health and dependency sequencing |
| **Backup server** | **Reused compact thin-client platform; 4-core low-power Intel CPU, 8 GB RAM; SATA flash system disk and separate onboard eMMC; Gigabit Ethernet and integrated Wi-Fi controller** | Physical module details, network negotiated speed, flash wear |
| VPS | Two externally hosted virtual instances | Virtual quotas and independent recovery controls |
| Access/network | LAN switches, selected independent cluster-storage links, wireless mesh | Cable/port and power-failure map |

## Dedicated backup host: flash-storage reuse

The backup host's operating system is on its SATA flash device. A separate onboard eMMC, previously without a recognized filesystem, was partitioned and formatted ext4, mounted locally with **noatime** and an automatic mount configured with **nofail**. A root-only destination for **future local configuration rescue copies** has been created. **No new scheduled rescue backup has been activated and no restore of the eMMC copy has been tested.** Normal backup datastore capacity remains on external storage; the eMMC is not a production backup datastore.

This is a low-cost reuse of existing hardware, but an onboard recovery copy is **not an off-host backup** and will not survive loss of the appliance.

## Field note: disk replacements during ZFS recovery

Two storage devices were replaced on one NAS system. Resilvering was **still in progress** at the last operator report. CPU usage did not exceed **10% during the interval observed**; that does not demonstrate resilver completion or storage health. A difference between a physical drive label and a firmware-reported identifier was observed; its cause remains undetermined.

Operational practices:

1. Record physical labels, firmware identifiers and actual slots independently before replacing disks.
2. Treat replacement, resilver completion, error review and post-operation SMART checks as separate milestones.
3. Distinguish observed system load from proof of successful recovery.

All concrete addresses, internal names, serial numbers and recovery paths remain in the private inventory.
