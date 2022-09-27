FROM ubuntu:22.04

# Help to install: https://wiki.openssl.org/index.php/Compilation_and_Installation
RUN apt-get update --yes && apt-get install --yes wget make build-essential checkinstall zlib1g-dev && \
  wget https://www.openssl.org/source/openssl-3.0.5.tar.gz -O /tmp/openssl.tar.gz && \
  tar -xvzf /tmp/openssl.tar.gz -C /tmp && \
  mv /tmp/openssl-3.0.5 /opt/openssl && \
  cd /opt/openssl && \
  ./config --prefix=/opt/ssl --openssldir=/opt/ssl no-shared -DOPENSSL_TLS_SECURITY_LEVEL=2 enable-ec_nistp_64_gcc_128 && \
  make && make install && rmdir /opt/ssl/certs && ln -s /etc/ssl/certs /opt/ssl/certs

CMD ["/bin/bash"]
