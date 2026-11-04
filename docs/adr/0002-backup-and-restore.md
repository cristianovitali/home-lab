# ADR-0002: Recovery-first data protection

**Status:** Accepted, with restore validation outstanding. **Date:** November 2026.

## Context

Redundant disks, clustered hosts and replication improve some failure modes, but they cannot replace independent recoverable backups. Consumer-grade hardware and power events make a controlled recovery procedure as important as service uptime.

## Decision

Use purpose-specific layers: ZFS snapshots/replication for versioned storage, Proxmox Backup Server for backup deduplication and VM/container recovery points, and scheduled configuration backups for network, storage and virtualization systems. Centralize relevant job-failure notifications through a local systemd OnFailure pattern where feasible. Avoid new storage purchases without a clear recovery benefit.

## Trade-offs

- Replication copies data-state changes and possibly mistakes; it is not equivalent to an independent historical backup.
- A job reported successful does not prove the application can be restored.
- Configured replication frequency does not by itself establish measured recovery point objectives.
- A two-node cluster with an external witness solves quorum concerns, but can still fail because of upstream storage or networking.

## Validation backlog

Exercise restore of selected workloads, restore of a replicated backup copy, application-consistent database recovery, boot dependencies after a full power event, and measured recovery time. Record test evidence and residual risks before upgrading status from configured to tested.
