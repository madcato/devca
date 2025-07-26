#!/bin/bash

# Check if server.key or server.pem already exists
if [ -f server.key ] || [ -f server.pem ]; then
  echo "Warning: server.key or server.pem already exists. Do you want to overwrite them? (y/n)"
  read -r confirm
  if [ "$confirm" != "y" ]; then
    echo "Aborting."
    exit 1
  fi
fi

# Define variables for certificate details (customize these)
CN="example.com"
SAN="DNS:example.com,DNS:www.example.com"  # Add more SANs as needed
DAYS=825
CA_CERT="$HOME/.devca/ca.crt"
CA_KEY="$HOME/.devca/ca.key"

# Create a temporary OpenSSL configuration file for extensions
CONFIG=$(mktemp)
cat > "$CONFIG" <<EOL
[req]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[dn]
C = US
ST = State
L = City
O = Organization
OU = Unit
CN = $CN

[req_ext]
subjectAltName = $SAN
keyUsage = critical,digitalSignature,keyEncipherment
extendedKeyUsage = serverAuth
basicConstraints = CA:FALSE

[v3_ca]
subjectAltName = $SAN
keyUsage = critical,digitalSignature,keyEncipherment
extendedKeyUsage = serverAuth
basicConstraints = CA:FALSE
EOL

# Generate private key and certificate signing request (CSR)
openssl req -newkey rsa:2048 -nodes -keyout server.key -out server.csr \
  -config "$CONFIG"

# Generate certificate signed by CA with extensions
openssl x509 -req -in server.csr -CA "$CA_CERT" -CAkey "$CA_KEY" \
  -CAcreateserial -out server.pem -days "$DAYS" -sha256 \
  -extfile "$CONFIG" -extensions v3_ca

# Remove temporary files
rm server.csr "$CONFIG"

echo "Generated server.key and server.pem with SANs ($SAN) for Nginx."
