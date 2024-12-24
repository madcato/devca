openssl genrsa -out server.key 4096

openssl req -new -key server.key -out server.csr -config <(cat <<EOF
[req]
default_bits = 4096
prompt = no
default_md = sha256
distinguished_name = dn
req_extensions = v3_req

[dn]
CN = gitlab.local
emailAddress = daniel@veladan.org
O = veladan
L = zaragoza
ST = zaragoza
C = ES

[v3_req]
subjectAltName = @alt_names

[alt_names]
DNS.1 = gitlab.local
EOF
)

openssl x509 -req -in server.csr -CA ~/.devca/ca.crt -CAkey ~/.devca/ca.key -CAcreateserial -out server.crt -days 1800 -sha256 -extfile v3.ext 