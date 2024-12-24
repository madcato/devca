openssl genrsa -out server.key 4096

openssl req -new -newkey rsa:4096 -nodes -keyout server.key -out server.csr -config <(
cat << EOF
[req]
distinguished_name = req_distinguished_name
x509_extensions = v3_req
prompt = no
[req_distinguished_name]
C = ES
ST = Zaragoza
L = Zaragoza
O = veladan
OU = IT
CN = gitlab.local
[v3_req]
basicConstraints = CA:FALSE
keyUsage = digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
[alt_names]
DNS.1 = gitlab.local
EOF
)


openssl x509 -req -in server.csr -CA ~/.devca/ca.crt -CAkey ~/.devca/ca.key -CAcreateserial -out server.crt -days 1800 -sha256 -extfile v3.ext 



# To check
openssl x509 -in server.crt -text -noout | grep -A1 'Subject Alternative Name'