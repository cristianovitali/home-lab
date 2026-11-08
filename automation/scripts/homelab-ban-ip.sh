#!/usr/bin/env bash
# Home Lab: add one public IPv4 or a newline-separated list to the manual nftables ban set.
# Usage: sudo homelab-ban-ip.sh <IPv4|file>
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Uso: $0 <IPv4|file_con_un_IP_per_riga>" >&2
  exit 2
fi

python3 - "$1" <<'PY'
import fcntl
import ipaddress
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile

CONFIG = Path('/etc/nftables.d/homelab-manual-bans.nft')
TABLE = 'homelab_manual_bans'
SET = 'blocked_ipv4'
LOCK = Path('/run/lock/homelab-manual-bans.lock')


def die(message):
    print(f'ERRORE: {message}', file=sys.stderr)
    raise SystemExit(1)


def public_ipv4(value):
    try:
        addr = ipaddress.IPv4Address(value)
    except ipaddress.AddressValueError:
        die(f'IPv4 non valido: {value!r} (CIDR e IPv6 non supportati)')
    if not addr.is_global:
        die(f'Indirizzo non pubblico: {value!r}; rifiutato per evitare blocchi LAN/VPN')
    return str(addr)


if os.geteuid() != 0:
    die('eseguire come root (sudo)')
if not CONFIG.is_file() or CONFIG.is_symlink():
    die(f'file persistente non trovato o non regolare: {CONFIG}')
nft = shutil.which('nft')
if not nft:
    die('nft non trovato')

source = sys.argv[1]
source_path = Path(source)
if source_path.is_file():
    raw_lines = source_path.read_text(encoding='utf-8-sig').splitlines()
elif source_path.exists():
    die(f'il percorso non e un file regolare: {source}')
else:
    raw_lines = [source]

requested = []
for number, line in enumerate(raw_lines, 1):
    value = line.split('#', 1)[0].strip()
    if not value:
        continue
    try:
        requested.append(public_ipv4(value))
    except SystemExit:
        print(f'  (riga {number} dell\'input)', file=sys.stderr)
        raise
requested = list(dict.fromkeys(requested))
if not requested:
    die('nessun indirizzo valido nell\'input')

LOCK.parent.mkdir(parents=True, exist_ok=True)
with LOCK.open('a+') as lock:
    fcntl.flock(lock, fcntl.LOCK_EX)
    original = CONFIG.read_text(encoding='utf-8')
    match = re.search(
        r'(\bset\s+blocked_ipv4\s*\{.*?\belements\s*=\s*\{\s*)([^}]*?)(\s*\})',
        original,
        flags=re.S,
    )
    if not match:
        die(f'impossibile trovare "elements" nel set {SET} di {CONFIG}')

    existing = []
    for token in match.group(2).split(','):
        token = token.strip()
        if token:
            existing.append(public_ipv4(token))
    desired = list(dict.fromkeys(existing + requested))

    # Confirm that the correct set is already loaded; do not reload the entire ruleset.
    result = subprocess.run(
        [nft, '-j', 'list', 'set', 'inet', TABLE, SET],
        capture_output=True, text=True,
    )
    if result.returncode:
        die(f'set nftables non attivo: {TABLE}/{SET}: {result.stderr.strip()}')
    try:
        objects = json.loads(result.stdout)['nftables']
        live_set = next(obj['set'] for obj in objects if 'set' in obj and obj['set'].get('name') == SET)
    except (ValueError, KeyError, StopIteration, TypeError) as exc:
        die(f'impossibile interpretare nft list set: {exc}')

    # This runbook uses individual IPv4 elements; existing interval/range expressions
    # are not silently expanded or rewritten by the script.
    live = set()
    for entry in live_set.get('elem', []):
        if isinstance(entry, str):
            live.add(entry)
        elif isinstance(entry, dict) and isinstance(entry.get('elem'), str):
            live.add(entry['elem'])
    missing_live = [ip for ip in desired if ip not in live]

    if missing_live:
        command = f'add element inet {TABLE} {SET} {{ {", ".join(missing_live)} }}\n'
        added = subprocess.run([nft, '-f', '-'], input=command, capture_output=True, text=True)
        if added.returncode:
            die(f'aggiunta live non riuscita; file invariato: {added.stderr.strip()}')

    new_value = ', '.join(desired)
    updated = original[:match.start(2)] + new_value + original[match.end(2):]
    if updated != original:
        stat = CONFIG.stat()
        fd, name = tempfile.mkstemp(prefix='.homelab-manual-bans.', dir=CONFIG.parent)
        try:
            os.fchmod(fd, stat.st_mode & 0o777)
            os.fchown(fd, stat.st_uid, stat.st_gid)
            with os.fdopen(fd, 'w', encoding='utf-8') as output:
                output.write(updated)
                output.flush()
                os.fsync(output.fileno())
            os.replace(name, CONFIG)
        finally:
            if os.path.exists(name):
                os.unlink(name)

    newly_stored = [ip for ip in requested if ip not in existing]
    print(f'Blacklist: {len(newly_stored)} nuovi IP persistenti; '
          f'{len(missing_live)} aggiunti alla regola attiva; '
          f'{len(desired)} IP nel file.')
    for ip in newly_stored:
        print(f'  + {ip}')
    if not newly_stored and not missing_live:
        print('Nessuna modifica: indirizzi gia presenti.')
    print(f'File: {CONFIG}')
PY
