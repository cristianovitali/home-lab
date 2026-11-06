# Local DNS and DHCP resilience — implementation and validation

**Updated:** 6 November 2026. **Evidence:** operator terminal output, NAS configuration screenshots, and a Windows DHCP client. This public engineering note intentionally excludes production addresses, DNS names, device identities and credentials.

## Design

An existing NAS provides authoritative internal DNS independently of the virtualized gateway. An operations host copies explicit static A mappings from gateway configuration to two NAS authoritative zones using RFC 2136 updates authenticated with a protected TSIG key. The NAS forwards other DNS queries exclusively to the gateway, with a single upstream and Forward only policy; Internet access remains dependent on the gateway.

Two IPv4 DHCP servers are simultaneously enabled on one LAN, using **non-overlapping pools**. They do not exchange leases, coordinate failover, or guarantee proportional client assignment.

## Verified on 6 November 2026

1. **Two authoritative zones:** primary internal and local service-name override zones were created. Correcting an incorrectly placed zone-apex NS resolved initial authoritative NXDOMAIN responses. Direct SOA and A queries subsequently succeeded.
2. **Live DNS synchronization:** 33 explicit static A mappings were read from the gateway over SSH: 26 in the internal zone and seven in the service-override zone. The first dry-run proposed 32 additions and preserved one existing record. A TSIG-authenticated apply reported **25 + 7 verified updates**. A repeat dry-run returned **zero changes**.
3. **Automation deployed:** the sync script, protected key and state configuration are installed on the operations host. Its systemd service and timer are enabled with a daily 03:30 schedule, five-minute random delay, boot offset, and persistent catch-up behavior. **No unattended timed execution has yet been observed.**
4. **Resolver tests:** direct NAS queries succeeded for an internal name, a locally overridden service name, and an unrelated external domain. Settings confirmed gateway-only forwarding and Forward only policy.
5. **DHCP deployment:** the gateway retained its original 50-address pool and the NAS enabled a separate 20-address pool. The gateway's generated DHCP configuration includes both DNS servers in option 6; an actual Windows gateway-leased client displays both resolvers and the correct gateway.
6. **PBR smoke test:** after a DNS query sent to the NAS for a domain with a dedicated gateway policy-routing rule, the gateway nftset contained the IP returned by the NAS. This is observed matching state, not proof that cache hits always refresh policy sets.

## Known limitations and outstanding validation

- **No NAS DHCP lease observed:** activation and disjoint pool configuration are confirmed, but a client lease issued by the second server has not yet been captured.
- **Possible static-IP collision:** probing the proposed NAS range found no ARP/ICMP respondents, but a powered-off device may have an address in that range. Verify or move it before powering it on.
- **Cache vs. policy routing:** the NAS DNS cache may answer without querying gateway dnsmasq; after a PBR restart, some destination nftsets could be stale. Test this separately.
- **Authoritative override trade-off:** the local override zone masks public MX/TXT/apex and other names not represented locally. This limitation is accepted for the current service use case, not a generally complete public DNS mirror.
- **Record scope:** only explicitly configured static A records are synchronized, not lease-derived names, AAAA, CNAME, MX, TXT, PTR or full zone transfers.
- **IPv6:** DHCPv6/router advertisements remain on the gateway; end-to-end IPv6 DNS/RA checks have not been completed.
- **Outage:** direct authoritative lookup has been tested while the gateway was available; controlled gateway-down resilience, recovery timings and actual redundant-DHCP behavior have **not** been tested.

## Evidence matrix

| Capability | Evidence |
|---|---|
| Two NAS authoritative zones | Direct SOA/A queries verified |
| Authenticated static A sync | 32 live updates verified; one existing record preserved |
| Idempotence | Repeat dry-run: zero modifications |
| Scheduled sync | Timer installed/enabled; unattended run pending |
| Gateway-only external forwarder | Configuration screenshot; external resolution succeeded |
| Dual DNS advertisement | Generated dnsmasq config and Windows client verified |
| Simultaneous disjoint DHCPv4 | Both services enabled; NAS-issued lease pending |
| Domain-aware PBR test | NAS-served IP observed in matching gateway nftset |
| Cache recovery and outage testing | Outstanding |

**Publication boundary:** no production endpoints, hostnames, domain names, secrets, private keys, or precise routing definitions are included.
