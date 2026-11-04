# ADR-0001: Layered monitoring with a single Zabbix control plane

**Status:** Accepted, implemented in stages. **Date:** November 2026.

## Context

An independently operated Home Lab uses different platforms: virtualization hosts, an API-capable storage cluster, dedicated NAS appliances, application VMs and external gateways. Requiring a full agent on every appliance is not feasible or useful.

## Decision

Use Zabbix for event collection and alerting. Match checks to capabilities: API for virtualization/storage and PBS, SNMPv3 for supported NAS devices, ICMP for reachability, and web scenarios for service endpoints. Collect cluster-wide metrics **once** per cluster rather than linking duplicate discovery templates to every node. Maintain shared monitoring definitions as importable, versioned templates when safe.

## Consequences

**Advantages:** fewer agents to maintain; distinct evidence for reachability versus service health; predictable data ownership; easier auditing of custom API preprocessing.

**Costs:** network, DNS and credentials are dependencies of monitoring itself; an API change can make several dependent items unsupported; an Agent interface icon can remain Unknown even when ICMP is UP; notification routing and alarm dependencies require additional configuration beyond template import.

## Validation and limits

The cluster template was imported successfully and the master plus ten dependents were supported. Six web scenarios already existed and were deliberately preserved. Delivering alerts and injecting failures are separate validation steps; no claim is made that all recovery actions are tested.
