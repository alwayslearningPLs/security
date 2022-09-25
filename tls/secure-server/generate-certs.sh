#!/bin/bash

# It is used to generate the public and the private key
openssl req -x509 -newkey rsa:4096 -keyout ./key.pem -out ./cert.pem -sha256 -days 365 -nodes -subj "/C=ES/ST=Galicia/L=Ourense/O=MyHouse/OU=Org/CN=localhost"

# To request the public key to the server
echo -n | openssl s_client -showcerts -servername localhost -connect localhost:8080 | openssl x509 -outform pem > ./fetched_localhost_cert.pem

# To test the public key to the server
curl --cacert ./fetched_localhost_cert.pem https://localhost:8080/hello

