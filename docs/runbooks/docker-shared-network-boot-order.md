# Runbook: a reverse proxy sharing a VPN container's network namespace fails after reboot

**Scope:** Docker Engine with a reverse proxy configured as `network_mode: "service:vpn"` in Docker Compose. This is a **sanitized engineering pattern**; names and examples below are generic. Last updated 8 November 2026.

## Failure mode

A reverse proxy may fail to start after a host reboot even though both the Docker daemon and the VPN container eventually become active. The proxy shares the VPN container's network namespace, so its startup can fail when that namespace is not yet available.

A typical error is:

```text
cannot join network namespace of a non running container
```

A Compose `depends_on` entry controls Compose operations, but **does not guarantee ordering of the Docker daemon's autonomous restart-policy recovery** after a host reboot. A container marked `restart: always` can therefore remain in an exited state even after its dependency is running.

## Diagnose without restarting the VPN

```bash
docker ps -a
docker inspect reverse-proxy --format 'Status={{.State.Status}} Error={{.State.Error}} ExitCode={{.State.ExitCode}} NetworkMode={{.HostConfig.NetworkMode}}'
docker ps --filter name=vpn-container --format 'table {{.Names}}\t{{.Status}}'
```

Confirm the VPN container is running and the proxy is the only failed service. Avoid broad Docker or host restarts until the failure is understood.

## Immediate recovery

When the VPN container is already up:

```bash
docker start reverse-proxy
docker ps --filter name=reverse-proxy --format 'table {{.Names}}\t{{.Status}}'
```

Validate the actual HTTPS application endpoint separately. `Up` indicates container runtime state, **not** proof of application health.

## Minimal boot-retry mitigation

An optional one-shot systemd unit can retry starting the existing proxy container after Docker starts. Replace the illustrative container name with the actual one:

```ini
[Unit]
Description=Retry reverse proxy startup after Docker
Requires=docker.service
After=docker.service
StartLimitIntervalSec=0

[Service]
Type=oneshot
ExecStart=/usr/bin/docker start reverse-proxy
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
```

Enable with `systemctl daemon-reload` and `systemctl enable --now <unit-name>.service`. A completed `Type=oneshot` unit normally becomes `inactive (dead)`; inspect its last exit status rather than interpreting that state as an error.

**Limitations:** this is a small mitigation, not a general-purpose dependency orchestrator or proof of successful startup on the next cold boot. It retries command failure; it does not continuously check application health or automatically repair every namespace/container replacement scenario. Validate during the next actual reboot and consider stronger lifecycle ordering if needed.

## If the VPN container was recreated

A proxy that references an old container ID may require **recreation**, not just `docker start`. With a Compose project that separates the base VPN service and the proxy into two files, target only the proxy:

```bash
docker compose -f compose.yaml -f compose.proxy.yaml up -d --no-deps reverse-proxy-service
```

Confirm the Compose service name and configuration first. Do not recreate the VPN service as an accidental side effect of repairing the proxy.

## What to validate

- Docker engine is active; VPN container is `Up`; proxy is `Up`.
- HTTPS endpoint is reachable and using the expected certificate.
- Reverse proxy configuration is valid; mounted configuration and certificate storage survived recreation.
- After a real reboot, the retry unit ran and the proxy returned automatically.
- Firewall enforcement and monitoring resumed; compare against prior evidence.

## Validation note (field observation, 8 November 2026)

Observed: proxy failed during the host reboot with the namespace-unavailable error, started successfully by hand after its network-sharing VPN container was running, then stayed up. A one-shot systemd retry unit was enabled and invoked successfully while the proxy was already running. **Automatic recovery on a subsequent reboot remains untested.** This distinction is intentional: implementation is not equivalent to demonstrated resilience.
