#!/usr/bin/bash

# Merge the policies with the host ones.
policy_root=/etc/opt/edge/policies

for policy_type in managed recommended enrollment; do
  policy_dir="$policy_root/$policy_type"
  mkdir -p "$policy_dir"

  if [[ "$policy_type" == 'managed' ]]; then
    ln -sf /app/share/flatpak-edge/flatpak_policy.json "$policy_dir"
  fi

  if [[ -d "/run/host/$policy_root/$policy_type" ]]; then
    find "/run/host/$policy_root/$policy_type" -type f -name '*' \
      -maxdepth 1 -name '*.json' -type f \
      -exec ln -sf '{}' "$policy_root/$policy_type" \;
  fi
done

# Add opensc lib to nss pkcs11.txt file
pkcs11_txt="${HOME}/.pki/nssdb/pkcs11.txt"

if [[ -e "${pkcs11_txt}" ]] && ! grep -qF opensc-pkcs11.so "${pkcs11_txt}"; then
  [[ $(tail -n 1 "${pkcs11_txt}") == '' ]] || echo >> "${pkcs11_txt}"
  cat >> "${pkcs11_txt}" << _EOF
library=/app/lib/onepin-opensc-pkcs11.so
name=opensc
_EOF
fi

exec cobalt "$@"
