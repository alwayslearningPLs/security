# Docker on secure port over TCP using mutual TLS

We can expose the docker daemon in a lot of ways (unix socket, fd or TCP socket).

We are going to understand how to expose it using TCP socket, secure manner using mutual TLS so the server can also authenticate if the client has a cert signed by the same CA as the one signed by the server.

## Lab

We start with a `vagrant up` so we can install docker on a machine in vagrant.

This is going to:

- Install some binaries that we need:
  + software-properties-common
  + gnupg2
  + apt-transport-https
  + lsb-release
  + ca-certificates
- Add a GPG key to the file `/usr/share/keyrings/ubuntu-docker.gpg`
- Add the repository `deb [arch=$(architecture) signed-by=/usr/share/keyrings/ubuntu-docker.gpg] https://download.docker.com/linux/$(distro) $(codename) stable`
  + _architecture_ is `dpkg --print-architecture`, in our case _amd64_
  + _distro_ is `lsb_release -ds | cut -d' ' -f1 | tr [:upper:] [:lower:]`, in our case _ubuntu_
  + _codename_ is `lsb_relase -cs`, in our case _jammy_ because we are using _22.04_.
- Actually installing Docker Community Engine, Docker CLI, Docker compose plugin and Containerd.
- Adding docker group to _vagrant_ user, so we don't need privilege access to it (from machine).
- Adding _docker.service_ file to VM so we can set it up correctly.
- Adding _CA_ certificate.
- _Server private key_ and _Server certificate_.
- _Client private key_ and _Client certificate_.

After this procedure, we can access our docker using the following:

```sh
# Testing using Curl that we are working with mutual TLS
curl --cacert ./certs/.docker/ca.pem \
  --key ./certs/.docker/client_key.pem \
  --cert ./certs/.docker/client_cert.pem https://192.168.56.30:2376/info

# Using docker context (new feature)
docker context create secure-docker-mutual-tls --description "secure docker using mutual TLS" \
  --docker="host=tcp://192.168.56.30:2376,ca=${PWD}/certs/.docker/ca.pem,key=${PWD}/certs/.docker/client_key.pem,cert=${PWD}/certs/.docker/client_cert.pem"

docker context use secure-docker-mutual-tls

docker image pull alpine:3.16

# or using Docker Parameters
docker -H tcp://192.168.56.30:2376\
  --tlsverify \
  --tlscacert=./certs/.docker/ca.pem \
  --tlskey=./certs/.docker/client_key.pem \
  --tlscert=./certs/.docker/client_cert.pem \
  image ls
```

## Additional

How to copy the certs folder to VM vagrant (not tested yet)

`scp -r -i ./.vagrant/machines/default/virtualbox/private_key -P 22 ./certs/ vagrant@192.168.56.30:/home/vagrant/certs`

## Reference

- [Docker official documentation (the best)](https://docs.docker.com/engine/security/protect-access/)
- [Docker daemon reference](https://docs.docker.com/engine/reference/commandline/dockerd/)
- [Docker REST API](https://docs.docker.com/engine/api/v1.41/)

