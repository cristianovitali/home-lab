# Runbook: recovery after a power event

**Purpose:** a general order-of-operations checklist, not an exact blueprint of any private network.

## Priority and dependencies

1. **Power, hardware and network:** inspect actual server, switch and storage state. Avoid repeated power cycling if a device is rebuilding or repairing.
2. **Gateway and DNS:** confirm address resolution, default route and access to service management systems. Missing DNS/gateway can cascade into apparently unrelated storage, hypervisor and backup failures.
3. **Storage:** verify the NAS is online, pool health is acceptable, required iSCSI/NFS exports are reachable and relevant data mounts are present. Never mount a potentially damaged dataset read-write until its status is understood.
4. **Compute and cluster:** confirm quorum and cluster coordination. Distinguish VMs waiting on storage from VMs that have actually failed.
5. **Application data:** confirm the correct data volumes and database availability before starting applications that depend on them.
6. **Backup infrastructure:** confirm datastores are mounted at their intended paths before running backup, verification or garbage-collection jobs.
7. **Monitoring and alerting:** verify normal telemetry resumes, then inspect unresolved alarms and any backup tasks missed during the outage.

## Evidence to collect

- System service states, without copying credentials or entire environment files.
- Storage mount and pool states; iSCSI/NFS connectivity; PBS datastore presence.
- Cluster quorum and pending HA jobs.
- Application endpoint checks beyond ICMP.
- Backlog of failed or skipped backup/replication jobs.

## Explicitly avoid

- Automatically deleting backup locks, failed snapshots or interrupted tasks.
- Assuming NFS storage is healthy just because the NAS responds to ICMP.
- Starting a data-dependent VM before its data storage is available.
- Publishing real topology, hostnames, addresses or access paths in incident reports.

## Validation

Power-event recovery paths should be exercised under maintenance and measured. The checklist is a reusable reference, not evidence of successful failover.
