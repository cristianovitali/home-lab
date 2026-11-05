# Local DNS and DHCP resilience — design note

**Updated:** 5 November 2026. **Status:** partial configuration; not deployed to client devices.

## Why this matters

A virtualized gateway can become unavailable after a power event or while its dependent storage initializes. When the same gateway provides routing, DHCP and the only DNS resolver, one startup failure affects multiple services. The recovery sequence therefore matters as much as an individual service's uptime.

## Proposed roles

- **Primary resolver and gateway:** OpenWrt remains responsible for normal DNS forwarding, LAN routing and domain-sensitive VPN policies.
- **Alternative resolver:** a DNS service on an existing Synology NAS provides a locally held copy of essential internal names. This is not a new VM or an additional public DNS service.
- **Optional additional DHCP server:** a separate, future phase with non-overlapping pools, consistent DHCP options and a controlled migration/validation plan.

### Why a local zone copy is necessary

The gateway's lightweight DNS service does not automatically offer conventional authoritative zone transfer to the NAS. A forwarding-only domain pointing back to the gateway would fail with it. The alternative resolver therefore needs local authoritative records, plus a maintained synchronization mechanism. This is **not** proof of working DNS slave-zone replication.

A single upstream forwarder and **Forward only** policy were selected to retain the gateway as the required path for external lookups. The local names may continue to work if the primary DNS disappears, but external lookup and Internet connectivity may still fail.

## Important boundaries

1. **DNS is not a gateway replacement.** With the only router unavailable, an alternative DNS server cannot restore Internet routing.
2. **DNS caching can affect domain-based VPN policy routing.** A cached answer on the alternative resolver may not update the gateway's DNS-derived policy sets. This behavior requires actual testing before serving clients.
3. **Two DHCP servers do not constitute a synchronized HA pair.** Their pools must not overlap, and leases/options need explicit verification.
4. **Local resolution and split-horizon responses must agree.** An out-of-date copy can create misleading success signals and break internal application routing.
5. **Startup dependencies remain:** the NAS itself supplies storage to selected infrastructure workloads.

## Evidence snapshot

| Capability | State at last operator confirmation |
|---|---|
| NAS DNS service installed | Confirmed |
| External forwarding directed only to the gateway | Configured and saved |
| Local authoritative zone populated | Not yet confirmed |
| Automated record synchronization | Not implemented |
| DNS advertised to client devices | Not changed |
| Second DHCP server | Proposed, not configured |
| Failure-mode and VPN-policy validation | Pending |

The next milestone is to build and validate the NAS's local DNS zone **without** changing client DHCP or relying on public fallback resolvers. This design note deliberately omits private names, addresses, routes, credentials and exports.
