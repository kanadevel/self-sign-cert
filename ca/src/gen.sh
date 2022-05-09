#!/bin/sh

echo "ca name: $CANAME"

# Generate private key for CA and Server.
openssl genrsa 2048 > /out/ca.key

# Generate certificate sigining requests from same key.
openssl req -new -key /out/ca.key -subj "/C=AU/ST=Some-State/O=Self Sign Cert CA/CN=${CANAME}" > /out/ca.csr

# Generate CA certificate.
openssl ca -batch -extensions v3_ca -out /out/ca.crt -in /out/ca.csr -selfsign -keyfile /out/ca.key
