# Local DNS and DHCP resilience — implementation status

**Updated:** 6 November 2026. **Evidence:** operator-supplied configuration and direct DNS query results. **Client rollout:** not performed.

## Objective and boundaries

A virtualized OpenWrt gateway provides normal LAN DNS, DHCP, Internet routing and domain-aware VPN policy routing. The resilience design uses an existing NAS as an **independent authoritative source for internal names**, rather than relying on forwarding internal queries back to an unavailable gateway.

- The NAS is **not** a substitute for routing: Internet access still depends on the gateway.
- Public recursive resolution must continue through the primary gateway only, with **Forward only** policy and no direct public fallback; this preserves the selected domain-based routing path, subject to testing of resolver caching.
- A second DHCP service is planned to operate simultaneously with the gateway using **non-overlapping IPv4 address pools**. This is not synchronized DHCP failover, nor a guaranteed 50/50 distribution of clients.

## Progress verified on 6 November

1. Native DNS Server package installed on the NAS; gateway-only forwarding configured.
2. An **authoritative primary forward-lookup zone for the internal domain was created**.
3. An initial resource record appeared in the management UI but direct DNS queries returned `NXDOMAIN` even though the server answered authoritatively.
4. Exported zone data had a newer SOA serial than the currently served zone. A misconfigured NS record (attached to an individual name rather than the zone apex) was corrected.
5. **Direct query validation succeeded:** the served SOA advanced to serial 5 and the initial NAS hostname resolved to the expected internal address from the alternate DNS server.

This verifies **one record in one local zone**, not the full internal record set, automated replication, client resolver behavior or survivability during an outage.

## Record synchronization — prepared, not installed

The next phase uses a separate operations host to:

- Read explicit static DNS A mappings from the gateway over SSH.
- Compare the desired entries with authoritative responses from the NAS.
- Use authenticated RFC 2136/TSIG dynamic DNS updates, rather than editing the NAS's internal zone files.
- Preserve SOA/NS records and manually managed records; apply guarded additions, changes, and removals only for previously script-managed names.
- Run a dry-run first, then enable a daily systemd timer after live tests.

A first implementation package has been prepared **privately**. It has **not** been installed on the operations host, authenticated against the NAS, or exercised in a live update. A second authoritative zone for selected public-looking internal service names still needs creation and its behavior needs careful review: making an entire public domain authoritative locally may hide unrelated public records. Only static A records are within the initial sync scope; DHCP lease-derived hostnames and other record types need separate treatment.

## DHCP and cutover are still pending

- Inspect current DHCP pools, reservations and active leases before selecting the NAS range.
- Test consistency of router, DNS, search-domain and lease options, including IPv6 RA/RDNSS if applicable.
- Check VPN policy routing with responses forwarded via the gateway and served from the NAS cache; caching can affect domain-derived routing sets.
- Validate both DNS servers individually before advertising the alternate DNS to clients.
- Validate failure and recovery separately, without treating DNS lookup success as proof that Internet routing is available.

## Evidence levels

| Capability | Status |
|---|---|
| NAS DNS application and internal primary zone | **Configured** |
| One internal A record resolving via direct query | **Verified** |
| Complete internal/static split-DNS records | **Not yet synchronized** |
| Periodic authenticated update script | **Prepared, not deployed** |
| Additional authoritative service-name zone | **Not yet created** |
| Alternate DNS distributed via DHCP | **Not deployed** |
| Second active DHCP with non-overlapping pool | **Design agreed, not enabled** |
| Gateway-down DNS continuity and VPN policy behavior | **Not tested** |

This public document intentionally excludes names, addresses, device identifiers, source configurations and key material.
