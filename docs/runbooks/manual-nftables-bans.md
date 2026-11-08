# Runbook: persistent manual IP bans with nftables alongside Docker and CrowdSec

**Purpose:** maintain a small operator-reviewed denylist without placing permanent addresses into CrowdSec-managed sets. **Sanitized example only**; replace the documentation-only IPv4 address with an address verified by the operator.

## Rationale

CrowdSec's automatic decisions can expire or change as the security engine and bouncer synchronize. A **manual** denylist should be separate, explicit and reviewable. Using an nftables `prerouting` chain allows a rule to apply before common Docker DNAT/filter paths, as well as host services.

Do not indiscriminately block entire hosting providers or automatically promote every alert to a lifetime ban: false positives happen. A manual ban does not prove an attempted VPN handshake or a compromise.

## Prerequisites

- Linux using nftables, or iptables backed by `nf_tables`.
- An administrator has verified the current nftables chains and understands how other firewall managers interact with them.
- A recovery/console access plan exists before changing rules on a remote VPS.

## Independent nftables set and chain

File `/etc/nftables.d/manual-bans.nft`:

```nft
table inet manual_bans {
    set blocked_ipv4 {
        type ipv4_addr
        flags interval
        elements = { 203.0.113.50 }
    }

    chain prerouting_drop {
        type filter hook prerouting priority -310; policy accept;
        ip saddr @blocked_ipv4 counter drop
    }
}
```

`203.0.113.50` belongs to the documentation-only TEST-NET-3 block and must be replaced with the IP the operator intends to deny.

Load once:

```bash
nft -c -f /etc/nftables.d/manual-bans.nft
nft -f /etc/nftables.d/manual-bans.nft
nft list table inet manual_bans
```

The negative prerouting priority is intentionally earlier than typical connection-tracking, NAT and Docker filter processing. Avoid altering CrowdSec-managed sets or calling `nft flush ruleset`.

## Boot-time loading

Example `/etc/systemd/system/manual-bans.service`:

```ini
[Unit]
Description=Load persistent operator-managed nftables bans
After=local-fs.target
Before=network-pre.target docker.service
Wants=network-pre.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/sbin/nft -f /etc/nftables.d/manual-bans.nft

[Install]
WantedBy=multi-user.target
```

```bash
systemctl daemon-reload
systemctl enable manual-bans.service
systemctl is-enabled manual-bans.service
```

If the table was already loaded manually, do not automatically rerun the whole file just to verify enablement. `enabled` means the unit is installed for boot, **not** that a future reboot has been tested.

## Add or remove one address

Edit the file first so the desired state survives reboot. Then update only the in-memory set, substituting the exact target address:

```bash
nft add element inet manual_bans blocked_ipv4 '{ 203.0.113.51 }'
nft list set inet manual_bans blocked_ipv4
```

To remove an address, remove it from the file and run:

```bash
nft delete element inet manual_bans blocked_ipv4 '{ 203.0.113.51 }'
nft list set inet manual_bans blocked_ipv4
```

Repeat on each VPS for symmetrical policies; independently verify both files and live sets. If a set or chain is missing, diagnose before running create commands, as other firewall services may have changed the ruleset.

## Validate

- Confirm the file and in-memory set contain exactly the intended addresses.
- Check `systemctl is-enabled manual-bans.service`.
- During the next natural reboot, check `systemctl status manual-bans.service` and `nft list table inet manual_bans`.
- Confirm SSH, Docker port publishing, VPN traffic and the existing CrowdSec/other firewall chains remain functional.
- Record confirmed and **not-yet-tested** aspects separately.

**Field note (8 Nov 2026):** an equivalent private implementation was enabled on two Linux VPS hosts. Live rule loading was observed on one; both boot units were enabled. A later real reboot has **not yet** validated persistence of this configuration.
