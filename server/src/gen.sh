#!/bin/sh

set -eu

: "${HOST:?HOST is required}"
: "${IP:?IP is required}"

echo "host: $HOST"
echo "ip: $IP"

umask 077

envsubst < subjectnames-template.txt > subjectnames.txt

# サーバ用の秘密鍵を CA とは別に作る
openssl genrsa 2048 > /out/server.key

# サーバ証明書の CSR を作る
openssl req -new \
  -sha256 \
  -key /out/server.key \
  -subj "/C=JP/ST=Tokyo/O=Self Sign Cert Server/CN=${HOST}" \
  > /out/server.csr

# issuer + serial が重複しないよう、serial は毎回ランダムにする
SERIAL="$(openssl rand -hex 16)"

# CA でサーバ証明書に署名する
openssl x509 \
  -req \
  -sha256 \
  -days 365 \
  -in /out/server.csr \
  -CA /ca/ca.crt \
  -CAkey /ca/ca.key \
  -set_serial "0x${SERIAL}" \
  -extfile subjectnames.txt \
  -out /out/server.crt

# .crt はすでに PEM 形式なのでコピーで十分
cp -p /out/server.crt /out/server.pem

chmod 644 /out/server.crt /out/server.pem /out/server.csr
chmod 600 /out/server.key


# 確認
openssl verify -CAfile /ca/ca.crt /out/server.crt

echo "server serial: 0x${SERIAL}"

