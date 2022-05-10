#!/bin/sh

echo "host: $HOST"
echo "ip: $IP"

envsubst < subjectnames-template.txt > subjectnames.txt

# Generate certificate sigining requests from same key.
openssl req -new -key /ca/ca.key -subj "/C=AU/ST=Some-State/O=Self Sign Cert Server/CN=${HOST}" > /out/server.csr

# Generate server certificate with CA certificate.
openssl x509 -days 365 -req -extfile subjectnames.txt -CA /ca/ca.crt -CAkey /ca/ca.key -set_serial 1 < /out/server.csr > /out/server.crt


openssl x509 -in /out/server.crt -out /out/tmp.der -outform DER
openssl x509 -in /out/tmp.der -inform DER -out /out/server.pem -outform pem
rm /out/tmp.der

cp -p /ca/ca.key /out/server.key
