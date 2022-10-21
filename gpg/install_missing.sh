#!/bin/bash

arg_len=$#
if [[ $((arg_len % 2)) -eq 1 ]]; then
  echo "error trying to pass arguments. You have to pass an even number of arguments. ./install_missing.sh <key-id> <output-name-id>" 
fi

for((i=1; i < arg_len; i++)); do
  key=${!i}; i=$((i+1)); name=${!i}

  echo "Receiving ${key} from ubuntu repository and installing in /usr/share/keyrings/${name}.gpg"

  gpg --keyserver hkps://keyserver.ubuntu.com:443 --recv-key ${key}
  gpg --yes --output /usr/share/keyrings/${name}.gpg --export ${key}
done

