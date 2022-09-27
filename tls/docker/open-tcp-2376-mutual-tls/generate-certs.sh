#!/bin/bash
#
# You need to create a passphrase.txt file in this directory

test -d ./certs && rm -rf ./certs

mkdir certs

# generate the CA private key
openssl genpkey -out ./certs/ca-key.pem -pass file:./passphrase.txt -algorithm RSA -pkeyopt rsa_keygen_bits:4096 -aes-128-cbc

# Optionally, generate CSR
openssl req -new -key ./certs/ca-key.pem -passin file:./passphrase.txt -out ./certs/ca.csr \
  -subj "/C=ES/ST=OU/L=Ourense/O=My house/OU=Work Office/CN=my.house.com/emailAddress=estonoesmiputocorreo@gmail.com" 

# Generate the certificate from the private key and the CSR
openssl x509 -req -sha256 -days 365 -in ./certs/ca.csr -passin file:./passphrase.txt -signkey ./certs/ca-key.pem -out ./certs/ca.crt

# generate the Server private key
openssl genpkey -out ./certs/server-key.pem -pass file:./passphrase.txt -algorithm RSA -pkeyopt rsa_keygen_bits:4096 -aes-128-cbc

# Optionally, generate CSR
openssl req -new -key ./certs/server-key.pem -passin file:./passphrase.txt -out ./certs/server.csr \
  -subj "/C=ES/ST=OU/L=Ourense/O=My house/OU=Work Office/CN=secure.docker.com/emailAddress=estonoesmiputocorreo@gmail.com"

cat <<EOF > ./certs/extfile.conf
subjectAltName = DNS:secure.docker.com,IP:192.168.56.30,IP:127.0.0.1
extendedKeyUsage = serverAuth
EOF

# Create the certificate and sign with the CA private key, CA certificate
openssl x509 -req -days 365 -sha256 -in ./certs/server.csr -passin file:./passphrase.txt -CA ./certs/ca.crt -CAkey ./certs/ca-key.pem \
  -CAcreateserial -out ./certs/server.crt -extfile ./certs/extfile.conf

# Generate the private key for the client
openssl genpkey -out ./certs/client-key.pem -pass file:./passphrase.txt -algorithm RSA -pkeyopt rsa_keygen_bits:4096 -aes-128-cbc

# Optionally, generate CSR
openssl req -new -key ./certs/client-key.pem -passin file:./passphrase.txt -out ./certs/client.csr -subj '/CN=client'

echo "extendedKeyUsage = clientAuth" > ./certs/extfile_client.conf

# Create certificate, sign with the CA that the server is using
openssl x509 -req -days 365 -sha256 -in ./certs/client.csr -passin file:./passphrase.txt -CA ./certs/ca.crt -CAkey ./certs/ca-key.pem \
  -CAcreateserial -out ./certs/client.crt -extfile ./certs/extfile_client.conf

mkdir ./certs/.docker

# Needed for the server and client
cp ./certs/ca.crt           ./certs/.docker/ca.pem

# Needed only for the server
cp ./certs/server.crt       ./certs/.docker/cert.pem
openssl pkey -in ./certs/server-key.pem -out ./certs/.docker/key.pem -outform pem -passin file:./passphrase.txt

# Needed only for the client
cp ./certs/client.crt       ./certs/.docker/client_cert.pem
openssl pkey -in ./certs/client-key.pem -out ./certs/.docker/client_key.pem -outform pem -passin file:./passphrase.txt

