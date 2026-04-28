#!/bin/bash
set -euo pipefail

EXP_FILE="/opt/course/14/expiration"
RENEW_FILE="/opt/course/14/kubeadm-renew-certs.sh"
CERT_FILE="/etc/kubernetes/pki/apiserver.crt"

fail() {
  echo " $1"
  exit 1
}

pass() {
  echo " $1"
}

[ -f "$CERT_FILE" ] || fail "Certificate file $CERT_FILE does not exist"
[ -f "$EXP_FILE" ] || fail "Missing $EXP_FILE"
[ -f "$RENEW_FILE" ] || fail "Missing $RENEW_FILE"

# Expected OpenSSL expiration, normalized.
expected_expiration="$(openssl x509 -enddate -noout -in "$CERT_FILE" | sed 's/^notAfter=//' | xargs)"
user_expiration="$(tr -d '\r' < "$EXP_FILE" | sed '/^[[:space:]]*$/d' | head -n1 | xargs)"

[ -n "$user_expiration" ] || fail "$EXP_FILE is empty"

if [ "$user_expiration" != "$expected_expiration" ]; then
  fail "Wrong expiration date. Expected: '$expected_expiration' but found: '$user_expiration'"
fi

pass "Expiration date matches the kube-apiserver certificate"

# Verify the written date is consistent with kubeadm output.
# kubeadm formats as: 'Apr 28, 2027 10:15 UTC', while OpenSSL uses: 'Apr 28 10:15:42 2027 GMT'.
expected_epoch="$(date -u -d "$expected_expiration" +%s)"

kubeadm_line="$(kubeadm certs check-expiration 2>/dev/null | awk '$1 == "apiserver" {print; exit}')"
[ -n "$kubeadm_line" ] || fail "Could not find apiserver in kubeadm certs check-expiration output"

# Extract fields from kubeadm output: CERTIFICATE EXPIRES RESIDUAL... => apiserver Apr 28, 2027 10:15 UTC ...
kubeadm_date="$(awk '$1 == "apiserver" {print $2, $3, $4, $5}' <<< "$kubeadm_line")"
kubeadm_epoch="$(date -u -d "$kubeadm_date" +%s 2>/dev/null || true)"
[ -n "$kubeadm_epoch" ] || fail "Could not parse kubeadm expiration date from: $kubeadm_line"

# kubeadm usually displays minute precision, openssl displays seconds.
# Accept up to 60 seconds difference.
diff=$(( expected_epoch - kubeadm_epoch ))
if [ "${diff#-}" -gt 60 ]; then
  fail "OpenSSL and kubeadm expiration dates do not match closely. OpenSSL: '$expected_expiration'; kubeadm: '$kubeadm_date'"
fi

pass "kubeadm expiration output matches the certificate expiration"

# Validate renewal command file.
renew_content="$(tr -d '\r' < "$RENEW_FILE" | sed 's/[[:space:]]\+$//' | sed '/^[[:space:]]*$/d')"
[ -n "$renew_content" ] || fail "$RENEW_FILE is empty"

# Require a single non-empty command line.
line_count="$(printf '%s\n' "$renew_content" | wc -l | xargs)"
[ "$line_count" = "1" ] || fail "$RENEW_FILE must contain exactly one non-empty command"

# Normalize optional sudo and extra spaces.
normalized="$(printf '%s' "$renew_content" | xargs)"
normalized="${normalized#sudo }"

case "$normalized" in
  "kubeadm certs renew apiserver"|"kubeadm alpha certs renew apiserver")
    pass "Renewal command is correct"
    ;;
  *)
    fail "Wrong renewal command. Expected: 'kubeadm certs renew apiserver'"
    ;;
esac

echo "Scenario completed successfully"
