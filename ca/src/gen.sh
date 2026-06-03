#!/bin/sh

set -eu

: "${CANAME:?CANAME is required}"

echo "ca name: $CANAME"

umask 077

SERIAL="$(openssl rand -hex 16)"

cat > ca.conf <<EOF
[req]
prompt = no
distinguished_name = dn
x509_extensions = v3_ca

[dn]
C = JP
ST = Tokyo
O = ${CANAME}
CN = ${CANAME}

[v3_ca]
basicConstraints = critical,CA:TRUE,pathlen:0
keyUsage = critical,keyCertSign,cRLSign
subjectKeyIdentifier = hash
EOF

openssl req \
  -x509 \
  -newkey rsa:2048 \
  -nodes \
  -sha256 \
  -days 3650 \
  -set_serial "0x${SERIAL}" \
  -keyout /out/ca.key \
  -out /out/ca.crt \
  -config ca.conf

cp -p /out/ca.crt /out/ca.pem

chmod 644 /out/ca.crt /out/ca.pem
chmod 600 /out/ca.key


echo "ca serial: 0x${SERIAL}"

