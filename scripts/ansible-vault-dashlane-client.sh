#!/usr/bin/env sh
set -eu

VAULT_ID=""

usage() {
  echo "Usage: $0 --vault-id <id>" >&2
  exit 1
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --vault-id)
      VAULT_ID="$2"
      shift 2
      ;;
    *)
      usage
      ;;
  esac
done

[ -z "$VAULT_ID" ] && usage

NOTE_NAME="ansible-vault-${VAULT_ID}"

PASSWORD="$(dcli note "$NOTE_NAME" 2>/dev/null || true)"

if [ -z "$PASSWORD" ]; then
  echo "Could not find Secure Note $NOTE_NAME; is Secure Note created in Dashlane and has content?" >&2
  exit 1
fi

echo "$PASSWORD"
