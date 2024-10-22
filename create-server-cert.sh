
if [ -f server.key ]; then
  echo "Warning: server.key exists. Do you want to overwrite it? (y/n)"
  read -r confirm
  if [ "$confirm" != "y" ]; then
    echo "Aborting."
    exit 1
  fi
fi

openssl req -newkey rsa:2048 -nodes -keyout server.key -out server.csr
DOMAIN=$1
openssl x509 -req -in server.csr -CA ~/.devca/ca.crt -CAkey ~/.devca/ca.key -CAcreateserial -out server.crt -days 825 -sha256 -extfile config.cnf -extensions req_ext

rm server.csr