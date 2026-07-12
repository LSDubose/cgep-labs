#!/usr/bin/env bash
set -euo pipefail

RUN_ID="${1:?usage: verify-evidence.sh <run_id>}"
VAULT="${EVIDENCE_VAULT:-cgep-evidence-vault-72009a51}"

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
cd "$WORK"

PREFIX="runs/${RUN_ID}"
aws s3 cp "s3://${VAULT}/${PREFIX}/" . --recursive

BUNDLE=$(ls evidence-*.tar.gz | head -1)

echo "=== 1. Integrity (SHA-256) ==="
EXPECTED=$(cat "${BUNDLE}.sha256")
ACTUAL=$(sha256sum "${BUNDLE}" | awk '{print $1}')
[[ "$EXPECTED" == "$ACTUAL" ]] || { echo "FAIL: SHA mismatch"; exit 1; }
echo "  OK (${ACTUAL})"

echo "=== 2. Authenticity (Cosign + Sigstore Rekor) ==="
cosign verify-blob \
  --bundle "${BUNDLE}.sig.bundle" \
  --certificate-identity-regexp '.*' \
  --certificate-oidc-issuer 'https://token.actions.githubusercontent.com' \
  "${BUNDLE}"
echo "  OK"

echo ""
echo "CHAIN INTACT for run ${RUN_ID}"
