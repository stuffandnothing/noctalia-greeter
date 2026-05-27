#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  echo "error: run as root (use sudo)." >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GREETER_USER="${GREETER_USER:-greeter}"
SESSION_BIN="${NOCTALIA_GREETER_SESSION_BIN:-/usr/local/bin/noctalia-greeter-session}"

echo "info: applying greetd PAM runtime module patch..."
"${SCRIPT_DIR}/setup_greetd_pam.sh"

echo "info: preparing greeter log paths..."
mkdir -p /var/lib/noctalia-greeter
touch /var/log/noctalia-greeter.log /var/lib/noctalia-greeter/greeter.log /tmp/noctalia-greeter.log

if id -u "${GREETER_USER}" >/dev/null 2>&1; then
  chown -R "${GREETER_USER}:${GREETER_USER}" /var/lib/noctalia-greeter
  chown "${GREETER_USER}:${GREETER_USER}" /var/log/noctalia-greeter.log /tmp/noctalia-greeter.log
else
  echo "warn: user '${GREETER_USER}' does not exist yet; skipping chown."
fi

chmod 0664 /var/log/noctalia-greeter.log /var/lib/noctalia-greeter/greeter.log /tmp/noctalia-greeter.log

if [[ ! -x "${SESSION_BIN}" ]]; then
  echo "warn: session launcher '${SESSION_BIN}' not found or not executable."
  echo "warn: install first via: sudo meson install -C build"
fi

echo
echo "System setup complete."
echo
echo "Next steps:"
echo "  1. Add to /etc/greetd/config.toml:"
echo
echo "     [default_session]"
echo "     command = \"${SESSION_BIN}\""
echo "     user = \"${GREETER_USER}\""
echo
echo "  2. Restart greetd (pick what your distro uses):"
if command -v systemctl >/dev/null 2>&1; then
  echo "     sudo systemctl restart greetd"
fi
if command -v sv >/dev/null 2>&1; then
  echo "     sudo sv restart greetd"
fi
if ! command -v systemctl >/dev/null 2>&1 && ! command -v sv >/dev/null 2>&1; then
  echo "     restart greetd using your init system"
fi
