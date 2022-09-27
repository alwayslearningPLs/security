#!/bin/bash

# Generate a private key with algorithm RSA 4096 bits, passhrase abc123.
openssl genpkey -out ./ca-key.pem -algorithm RSA -pkeyopt rsa_keygen_bits:4096 -aes-128-cbc -pass pass:abc123.

# Display a private key with passphrase
openssl pkey -in ./ca-key.pem -passin pass:abc123. -noout -text

rm -rf ./ca-key.pem

# Generate the file where the passphrase is
test -f passphrase.txt && rm ./passphrase.txt
echo "abc123." > ./passphrase.txt

# Generate a private key with algorithm RSA 4096 bits, passphrase as input file
openssl genpkey -out ./ca-key.pem -algorithm RSA -pkeyopt rsa_keygen_bits:4096 -aes-128-cbc -pass file:./passphrase.txt

# Display a private key with passphrase as file
openssl pkey -in ./ca-key.pem -noout -text -passin file:./passphrase.txt

rm -rf ./passphrase.txt ./ca-key.pem

# Generate a private key with algorithm RSA 4096 bits, passphrase as stdin
openssl genpkey -out ./ca-key.pem -algorithm RSA -pkeyopt rsa_keygen_bits:4096 -aes-128-cbc -pass stdin

openssl pkey -in ./ca-key.pem -noout -text -passin stdin

rm -rf ./ca-key.pem
