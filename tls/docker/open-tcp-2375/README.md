# Docker on insecure port over TCP

We can expose the docker daemon in a lot of ways (unix socket, fd or TCP socket).

We are going to understand how to expose it using TCP socket, insecure manner so we can access it remotely (we can also access it using ssh, but not in this lab)

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

After this procedure, we can access our docker using the following:

```sh
# Using docker context (new feature)
docker context create insecure-docker --description "insecure docker" --docker="host=tcp://192.168.56.10:2375"

docker context use insecure-docker

docker image pull alpine:3.16

# or using Docker parameters
docker -H tcp://192.168.56.30:2375 image pull alpine:3.15
```

