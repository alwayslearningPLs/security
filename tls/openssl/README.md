# Learning OpenSSL

## Check version

```sh
> openssl version
OpenSSL 3.0.2 15 Mar 2022 (Library: OpenSSL 3.0.2 15 Mar 2022)

> openssl version -a

OpenSSL 3.0.2 15 Mar 2022 (Library: OpenSSL 3.0.2 15 Mar 2022)
built on: Thu May  5 08:04:52 2022 UTC
platform: debian-amd64
options:  bn(64,64)
compiler: gcc -fPIC -pthread -m64 -Wa,--noexecstack -Wall -Wa,--noexecstack -g -O2 -ffile-prefix-map
=/build/openssl-Ke3YUO/openssl-3.0.2=. -flto=auto -ffat-lto-objects -flto=auto -ffat-lto-objects -fs
tack-protector-strong -Wformat -Werror=format-security -DOPENSSL_TLS_SECURITY_LEVEL=2 -DOPENSSL_USE_
NODELETE -DL_ENDIAN -DOPENSSL_PIC -DOPENSSL_BUILDING_OPENSSL -DNDEBUG -Wdate-time -D_FORTIFY_SOURCE=
2
OPENSSLDIR: "/usr/lib/ssl"
ENGINESDIR: "/usr/lib/x86_64-linux-gnu/engines-3"
MODULESDIR: "/usr/lib/x86_64-linux-gnu/ossl-modules"
Seeding source: os-specific
CPUINFO: OPENSSL_ia32cap=0xdef82203078bffff:0x840421

> ls -al /etc/lib/ssl

total 12
drwxr-xr-x  3 root root 4096 Jun 13 14:27 .
drwxr-xr-x 77 root root 4096 Jun 13 14:30 ..
lrwxrwxrwx  1 root root   14 Mar 16  2022 certs -> /etc/ssl/certs
drwxr-xr-x  2 root root 4096 Jun 13 14:27 misc
lrwxrwxrwx  1 root root   20 May  5 08:04 openssl.cnf -> /etc/ssl/openssl.cnf
lrwxrwxrwx  1 root root   16 Mar 16  2022 private -> /etc/ssl/private

```

## Install from source

Refer to this [Dockerfile](./install-from-source/Dockerfile)

## Examining command options

```sh
> openssl help        # Display all the available options

> openssl dgst -list  # display all the digest algorithms

> openssl enc -list   # display all the encryption algorithms

> openssl ecparam -list_curves # display all the Elliptic named curves that Openssl Supports.
```

## Key and Certificate Management

Process:

- Generate a private key.
- Create a CSR (Certificate Signing Request) and send it to a CA (Certificate Authority).
- Install the CA-provided certificate in your web server.

### Key generation

We need to make several decissions

#### Key algorithm

OpenSSL supports _RSA_, _DSA_, _ECDSA_, and _EdDSA_ key algorithms.

_DSA_ is obsolete and _EdDSA_ is not yet widely supported.

#### Key size

Today, _2048-bit_ RSA keys are considered secure, or _256 bits_ or ECDSA.

#### Passphrase

Using a passphrase with a key is optional, but strongly recommended.

#### RSA Sample

```sh
> openssl genpkey -out fd.key -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -aes-128-cbc

# It generates a file "fd.key" with the content of the encrypted private key

> cat ./fd.key

-----BEGIN ENCRYPTED PRIVATE KEY-----
MIIFLTBXBgkqhkiG9w0BBQ0wSjApBgkqhkiG9w0BBQwwHAQIu3ZZZSSs9uoCAggA
MAwGCCqGSIb3DQIJBQAwHQYJYIZIAWUDBAECBBD9zvaUHSSK0kdKcZ7Fk0PlBIIE
0NQVyCBNjv5SuCw3muYb0O53QI8p4i0YJGApUiXJ3hPoGmDIdubjIDk1kVdV2YxV
CgevNpcLBci0Hnx4k2inzwcQWxqD+zq3b/1VKch91x/4gyCh93qmr91ITAg9ngbt
/NXb41OvLy5/9xk0TUTv8huG54Q4F6tBnCtolYOSXTYN3J27nusNDy0Z6woMcL6i
XcAec8EdRN9IoiPen5/AWQhBHD1YFSjKr+ZRdB91NQmuwQJK2Wfbbn/BN6+DokTy
9pPl0krHd4FNsnwvzoNRb+Uf5iZC5BQOv8+pe49H2jaeIicT5j9CuLVf5ZOEHcZt
svM3ZIp9rVuLzveUy0jm/Lbq4r7+npC61nkODKNG1BCdWoXIRyqGHDoQLps5i2iE
dwcAJ+XlhH1bccmOVKFxTNq57M2rTN1ttY5KnXotiOUSJk5TLn2l0wYqiflAHh4q
VcI2UJUFgPANk7bS3P1kaIA3hGFssBidEBGqGI6dMXQ63286CMYsn5JDao+HsmQO
lUpPcd7iIWq4FT7WFZooyRqMIPRjLG/CiGTzx+Snn500EENICcW31no3VJzmftop
eJhgdhWpTc3Hf7oZOv2L4hBPi6UB6JkSMW91JE5+RK/igFYtCEGBmoDimJpATl9V
XyPiejL5b67rLGT2uA033k/j7wDlXD1uJ6kKdzOJ6uqdqAClyb0pTga8cX//NVgA
TmrpcHx35OLGsNp1x15rgz0tUxGOzqA4Zm3ZWRUd/jJ4wFBJXNegOiEz8X1HR/Nx
GT3Gi4yyS/MTaZ8rEDGSI9TlTYpycZGCwWdCOd+FxrZYvswSLeeLsf1hGWqPV3HL
7whJnXLGZeRGEK4HOwZlOkn+Ujs7mnisB2bSFXqrAYl0665ylkHU6XHgrxJFRt8T
3P1KNx0joiZxB+9k2cazQyyPm8L0oygQ2EbebwX4kwSjqc+QjuiNMmVZf5YBLYkM
qGmPIvjbY4JE0TrXXI13/KRhqTcRwMXJrNJ0uAHV3G8OWaHqAhApCGf4CGH+q1/4
9R00jQzyAj56Yd0aEQFfW/XvfiXJCEPoUloAgik8QJVbDkfPhIvdrMUlrOlsmPQo
lvrlWURKbSc72qRpwauMEyqyYIszkG3dFwC4M+n5/A3DuTbC/UlMgQCaaBnTAbOd
qAT60++HZ52Ang+P2wjIYHqzMxjD9/mkS7TQEjqAhf45bZmJr6mQ5DJAvVlpm38N
m0vUwIKR9hGX1e3AAJCayHBHVdbWwkgESRUIUvVUgOoH1+U4UVNVpya4HQUZRU22
QEC9yGrWcmk2L+fQSnfoxSovjttMyv+Y+QtSCMVSgNHfd3x1XhqBuDxdYCsHBPFC
h3v3/XrbZCLp52d8XWOqz8SvmEngkvopKPgk+UUy1NIYbIhy+fHmoWklhrcbgzYP
dD9IkwC8bAKDJV89uNZXvqN25tn0VSiFUJb0tkxRnqg0HAKFQvXwSwh+GQnyCtXW
TvdL6f4la68zje5uqTQggSPBJYaP6Hz9TeXw2yF3Ysy8JwHqiNwEW75nm84YQGfq
8YJa/YAYGEpy3qbaoFUb503GycoXzV0sXBXyA0xSyl/XyWJenPVXwYeElcYeyxET
NKv7mHzD4gWcwT4ePf8zeF/16YbJ7htI0tNgNr2WcOy6
-----END ENCRYPTED PRIVATE KEY-----

> openssl pkey -in ./fd.key -noout text

Private-Key: (2048 bit, 2 primes)
modulus:
    00:c7:ca:96:e7:ca:02:af:5a:26:01:d3:35:1f:c0:
    4a:e8:4b:01:16:fe:f8:93:66:0a:ae:58:eb:8d:90:
    10:d8:86:2a:13:e7:5b:5e:c4:ba:81:17:4c:45:17:
    e3:35:e0:a9:aa:91:f3:d3:ea:ac:e8:38:9e:c5:38:
    87:e1:d9:56:83:8d:b7:46:43:81:f5:47:60:2b:7e:
    e7:49:a7:93:b0:ad:c7:c4:72:d0:bc:a0:55:b5:ae:
    42:7a:d3:50:0d:81:f9:b5:9f:b7:92:85:c4:84:70:
    7b:12:9a:22:2f:33:6f:cf:b1:8a:61:d3:fe:ca:00:
    95:84:ee:1c:c3:47:6c:e2:2d:2b:f6:b4:98:65:14:
    f9:ee:25:72:7a:b7:6f:10:99:23:69:b4:24:f3:fd:
    e6:02:50:68:e0:b0:a2:9e:aa:b1:1e:68:7f:16:7d:
    8c:a3:e4:35:23:c9:ff:c1:58:cc:72:ea:2f:b9:3c:
    14:1c:33:df:d1:b6:05:d2:fa:16:1f:07:3e:f4:14:
    b4:9c:c6:cc:cc:d8:4f:97:9e:96:e0:a4:bb:cc:eb:
    dd:dc:5b:50:d7:a8:af:af:39:6c:c5:f4:69:64:16:
    01:9e:d6:fb:ed:78:11:06:28:c4:a6:b9:12:97:08:
    b1:22:63:61:89:f2:58:94:83:35:75:8f:35:71:4a:
    6d:25
publicExponent: 65537 (0x10001)
privateExponent:
    0a:a9:87:a3:28:17:3b:97:72:86:cf:68:3a:e1:0e:
    be:55:de:61:85:4a:eb:c6:da:d4:12:1f:c4:06:c7:
    b7:5e:75:99:69:53:e9:7b:53:3e:b7:69:15:18:e0:
    c1:cb:d3:12:2c:c6:d7:ec:e2:bc:63:e5:29:3e:4a:
    96:25:7c:a5:f9:a6:a9:c3:c9:88:36:fe:6d:63:d0:
    e1:0f:e5:e4:5c:69:d8:54:8e:4a:3a:be:48:3b:5c:
    05:e5:08:15:28:76:14:98:c8:f9:b3:54:d9:02:8d:
    b6:e0:ed:e9:19:f4:22:1f:e5:f4:31:95:9b:df:2b:
    1b:94:7f:89:76:62:db:b1:18:47:c5:63:33:1e:e2:
    e0:14:91:d5:51:96:d9:78:95:51:83:00:19:55:f4:
    01:bc:61:2a:15:a0:f9:05:67:c8:56:e4:02:c6:af:
    e1:a0:26:a7:19:ea:92:2b:a4:ba:ef:8a:07:5b:e7:
    35:2f:00:4c:e3:4f:be:5e:fc:12:89:08:92:dd:6e:
    dc:86:aa:9a:4a:ff:d0:5b:2b:c0:3d:f8:a3:0b:14:
    68:a6:8b:a0:3b:12:12:b0:a5:40:9e:c0:70:c5:f4:
    bb:69:71:93:92:51:1a:cc:85:fc:90:a7:d8:ec:89:
    86:95:31:0c:a5:a8:9d:9f:d2:1c:f0:0b:67:5f:10:
    43
prime1:
    00:ed:c1:77:15:47:15:d5:86:c5:02:16:cb:74:c1:
    99:11:f5:d0:19:d7:52:0c:46:8d:8b:bf:73:18:f4:
    1c:07:15:ef:c3:af:a8:42:e2:eb:77:c6:91:7a:85:
    16:0d:b6:a4:10:25:44:dd:34:28:f7:0b:b7:87:b3:
    65:3c:4b:93:b1:a3:fb:f7:bc:5c:6d:08:b1:bd:9a:
    14:1e:6a:e8:11:5c:41:8c:ae:18:2c:6a:82:dd:4d:
    a6:73:55:26:44:f5:91:57:1f:a3:75:a9:d1:5e:60:
    3a:a3:a1:49:9d:4b:7d:81:80:6e:40:c1:e2:f9:15:
    ba:4b:63:47:2d:e9:ed:03:a3
prime2:
    00:d7:1f:57:b7:da:8a:81:8c:0d:2f:95:8d:c3:68:
    67:66:05:d1:8d:b4:41:2e:1d:15:1b:17:98:00:b5:
    08:79:ab:76:e9:c2:33:ea:fa:d4:7c:dc:5b:0e:52:
    d3:62:cb:ea:ff:7d:47:b9:68:31:27:a7:f9:d5:cc:
    3b:69:1a:a0:3a:ca:f4:45:21:e2:f4:22:bf:77:93:
    d9:25:c1:7a:49:61:dd:30:f5:3f:22:06:fd:52:99:
    96:c8:e4:90:24:3f:34:84:55:d5:49:5d:63:16:d8:
    05:dc:23:5c:9d:e9:9d:f6:dc:6c:ae:c1:58:f3:95:
    bc:74:2b:f6:19:5b:a2:18:97
exponent1:
    00:e4:80:4d:7c:cb:a6:f6:62:e2:30:d1:cb:94:59:
    04:4e:38:9b:5a:5a:90:e6:6f:60:56:71:17:a3:61:
    e9:15:fe:45:43:23:2d:69:ab:41:77:0a:06:83:64:
    28:ff:e1:0a:e8:e1:88:bf:b8:03:ae:fb:39:d6:57:
    d9:f2:0b:08:d5:6f:af:18:37:95:f4:cc:a8:56:7b:
    20:de:e3:0c:4a:b3:09:e4:b4:e5:52:ba:c3:2f:02:
    13:f9:40:5a:d9:67:d1:d9:93:f4:bb:7f:0c:53:d1:
    d4:49:b3:17:56:ef:58:9d:ff:da:f6:ad:e1:00:57:
    9b:86:1c:d2:2a:14:6a:d0:55
exponent2:
    00:d6:68:fe:dc:d8:8d:44:21:7a:e2:fa:84:99:46:
    ee:07:d9:b4:cb:2f:e5:e7:38:45:59:03:63:15:11:
    5a:a9:2a:25:13:47:e4:c7:47:c9:91:c9:6f:58:0f:
    65:71:0b:1d:e6:17:cf:ed:13:d4:2a:5a:59:c0:a6:
    16:70:e3:80:e0:18:78:ee:8e:9f:ce:04:f4:21:12:
    d3:53:b6:4b:53:e8:9e:b5:b5:3a:7f:87:c7:e5:14:
    00:1d:aa:f1:9f:ae:ff:81:06:ab:d6:bb:a5:8f:97:
    30:00:01:9e:c6:25:9a:b3:f9:6e:b9:9f:2c:31:5c:
    04:c1:25:2f:dc:86:60:41:71
coefficient:
    36:5e:bb:1c:c0:10:11:9f:95:a0:58:39:e6:98:b8:
    cb:72:0e:aa:4a:62:92:c7:a6:fb:46:47:fc:bc:1c:
    66:f4:9b:4e:2f:d9:90:70:59:dd:db:64:46:23:8b:
    62:73:c3:80:88:4d:66:c2:1c:74:6d:80:f4:5d:c2:
    6b:1c:47:ea:5c:f3:a5:01:11:87:20:86:60:44:b9:
    0f:1f:d3:9e:b4:0d:ab:d7:bf:da:b8:be:46:0d:87:
    b8:a1:03:72:fc:db:73:17:e1:28:eb:57:e5:02:5d:
    18:93:e8:69:d9:23:b8:db:3b:54:60:0e:95:dc:0a:
    26:61:61:d0:a9:ef:77:74

> openssl pkey -in ./fd.key -pubout -out ./fd-public.key

```

As asymetric encryption we could have used `-aes-128-cbc`, `-aes-192-cbc`, and `-aes-256-cbc`. We can list all of them using `openssl enc -list | grep -E '-aes-[0-9]+-cbc'`

By default, OpenSSL will set the publicExponent of new RSA keys to _65537_. This is what's known as a _Short Public Exponent_, and it significantly improves the performance of RSA verification.

Don't use _genrsa_ command (it is a legacy one). Furthermore, _genrsa_ outputs keys in a __lefacy format__: If you see `BEGIN ENCRYPTED PRIVATE KEY` at the top of the file, you're dealing with _PKCS #8_, which is the new format. If you see `BEGIN RSA PRIVATE KEY`, that's the legacy format.

#### ECDSA example

```sh
> openssl genpkey -out fd-ec.key -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -aes-128-cbc

> openssl pkey -in ./fd-ec.key -noout -text

Private-Key: (256 bit)
priv:
    72:97:d6:71:b2:20:a6:aa:3a:8a:77:d1:59:cb:72:
    58:ee:85:4b:77:47:a1:76:12:6d:5d:89:0e:3a:5d:
    ea:34
pub:
    04:eb:47:d5:c9:26:77:c0:48:d2:37:1c:e0:85:60:
    87:12:df:dd:f3:56:ec:9a:b2:ee:4e:6c:12:2b:f7:
    fa:b8:ec:a6:1d:ba:9c:ff:66:64:9d:33:58:3e:ef:
    f1:e0:1b:27:f1:4d:13:00:45:7c:6f:e5:6b:c6:05:
    5e:ff:ff:93:17
ASN1 OID: prime256v1
NIST CURVE: P-256


```

P-256 (also known as _secp256r1_ or _prime256v1_) and P-384 (_secp384r1_).

_x25519_, _x448_, _ed25519_, and _ed448_ are also supported.

### Creating CSR

```sh
> openssl req -new -key ./fd.key -out fd.csr

# Or one liner

> openssl req -new -key ./fd.key -out fd.csr -subj "/C=ES/ST=OU/L=Ourense/O=My house/OU=Work office/CN=my.house.com/emailAddress=estonoesmiputocorreo@gmail.com"

> openssl req -noout -text -in ./fd.csr

Certificate Request:
    Data:
        Version: 1 (0x0)
        Subject: C = ES, ST = OU, L = Ourense, O = My house, OU = Work office, CN = my.house.com, emailAddress = estonoesmiputocorreo@gmail.com
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (2048 bit)
                Modulus:
                    00:c7:ca:96:e7:ca:02:af:5a:26:01:d3:35:1f:c0:
                    4a:e8:4b:01:16:fe:f8:93:66:0a:ae:58:eb:8d:90:
                    10:d8:86:2a:13:e7:5b:5e:c4:ba:81:17:4c:45:17:
                    e3:35:e0:a9:aa:91:f3:d3:ea:ac:e8:38:9e:c5:38:
                    87:e1:d9:56:83:8d:b7:46:43:81:f5:47:60:2b:7e:
                    e7:49:a7:93:b0:ad:c7:c4:72:d0:bc:a0:55:b5:ae:
                    42:7a:d3:50:0d:81:f9:b5:9f:b7:92:85:c4:84:70:
                    7b:12:9a:22:2f:33:6f:cf:b1:8a:61:d3:fe:ca:00:
                    95:84:ee:1c:c3:47:6c:e2:2d:2b:f6:b4:98:65:14:
                    f9:ee:25:72:7a:b7:6f:10:99:23:69:b4:24:f3:fd:
                    e6:02:50:68:e0:b0:a2:9e:aa:b1:1e:68:7f:16:7d:
                    8c:a3:e4:35:23:c9:ff:c1:58:cc:72:ea:2f:b9:3c:
                    14:1c:33:df:d1:b6:05:d2:fa:16:1f:07:3e:f4:14:
                    b4:9c:c6:cc:cc:d8:4f:97:9e:96:e0:a4:bb:cc:eb:
                    dd:dc:5b:50:d7:a8:af:af:39:6c:c5:f4:69:64:16:
                    01:9e:d6:fb:ed:78:11:06:28:c4:a6:b9:12:97:08:
                    b1:22:63:61:89:f2:58:94:83:35:75:8f:35:71:4a:
                    6d:25
                Exponent: 65537 (0x10001)
        Attributes:
            (none)
            Requested Extensions:
    Signature Algorithm: sha256WithRSAEncryption
    Signature Value:
        22:6b:fd:93:a3:3a:16:c3:2c:15:6b:8c:3a:5d:6c:67:a2:50:
        81:d8:fc:a8:b3:90:69:a4:0b:df:46:ad:ff:50:0e:d5:98:58:
        6e:9a:b5:c9:89:b0:d4:6c:1a:f6:65:72:8b:42:2b:16:69:09:
        47:3c:73:5b:eb:66:c4:8d:f9:20:98:b0:71:93:38:a2:ed:ba:
        b6:10:3e:55:33:25:12:9c:5b:75:9a:a2:19:ec:8b:8f:f2:eb:
        ca:06:d6:0d:2e:38:4d:f7:3a:b5:6f:99:41:b1:05:83:9a:86:
        95:aa:80:37:91:58:b6:d8:69:8e:ed:b7:14:fd:48:86:6e:c1:
        0e:ce:7d:f5:bf:9b:63:59:38:db:18:6e:2d:59:80:4e:25:88:
        d8:53:34:da:3b:be:69:8a:ca:15:43:cb:b4:1f:7e:1e:d2:f1:
        c7:e5:10:4b:36:cc:93:a4:8f:77:c9:15:c3:31:0a:25:1a:4c:
        a3:5b:32:d9:e7:ca:84:32:b1:de:01:ec:d1:f5:50:f4:01:75:
        d9:10:24:04:b5:35:87:e6:a4:cb:56:79:49:98:09:cb:5e:4b:
        0f:fd:d3:de:e5:9b:75:99:05:39:1c:9a:59:9f:c0:25:f3:f7:
        ea:b1:d5:9a:b9:0d:0c:c9:dc:c5:6f:8f:3d:6d:f1:4a:dc:9e:
        76:00:57:c7

# If you're renewing a certificate and you don't want to make any changes to the information presented in it.
> openssl x509 -x509toreq -in fd.crt -out fd.csr -signkey fd.key
```

We can also create a _CSR_ using config files

```conf
[req]
prompt                  = no
distinguished_name      = dn
req_extensions          = ext
input_password          = abc123. # Here the password

[dn]
CN                      = my.house.com
emailAddress            = estonoesmiputocorreo@gmail.com
O                       = Ourense
L                       = Ourense
ST                      = OU
C                       = ES

[ext]
subjectAltName          = DNS:my.house.com,DNS:my.house.com
```

Now you can create the _CSR_ directly from the command line: `openssl req -new -config ./fd.conf -key ./fd.key -out ./fd.csr`

### Signing your own certificates

We can create a certificate from a private key and a CSR: `openssl x509 -req -days 365 -signkey ./fd.key -in ./fd.csr -out ./fd.crt`

```sh
> openssl x509 -in ./fd.crt -noout -text

Certificate:
    Data:
        Version: 1 (0x0)
        Serial Number:
            2a:d8:a2:a2:28:cd:ef:c4:b7:04:a2:b0:d3:c1:96:39:a3:4b:97:5e
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: CN = my.house.com, emailAddress = estonoesmiputocorreo@gmail.com, O = Ourense, L = Ourense, ST = OU, C = ES
        Validity
            Not Before: Sep 27 04:36:06 2022 GMT
            Not After : Sep 27 04:36:06 2023 GMT
        Subject: CN = my.house.com, emailAddress = estonoesmiputocorreo@gmail.com, O = Ourense, L = Ourense, ST = OU, C = ES
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (2048 bit)
                Modulus:
                    00:c7:ca:96:e7:ca:02:af:5a:26:01:d3:35:1f:c0:
                    4a:e8:4b:01:16:fe:f8:93:66:0a:ae:58:eb:8d:90:
                    10:d8:86:2a:13:e7:5b:5e:c4:ba:81:17:4c:45:17:
                    e3:35:e0:a9:aa:91:f3:d3:ea:ac:e8:38:9e:c5:38:
                    87:e1:d9:56:83:8d:b7:46:43:81:f5:47:60:2b:7e:
                    e7:49:a7:93:b0:ad:c7:c4:72:d0:bc:a0:55:b5:ae:
                    42:7a:d3:50:0d:81:f9:b5:9f:b7:92:85:c4:84:70:
                    7b:12:9a:22:2f:33:6f:cf:b1:8a:61:d3:fe:ca:00:
                    95:84:ee:1c:c3:47:6c:e2:2d:2b:f6:b4:98:65:14:
                    f9:ee:25:72:7a:b7:6f:10:99:23:69:b4:24:f3:fd:
                    e6:02:50:68:e0:b0:a2:9e:aa:b1:1e:68:7f:16:7d:
                    8c:a3:e4:35:23:c9:ff:c1:58:cc:72:ea:2f:b9:3c:
                    14:1c:33:df:d1:b6:05:d2:fa:16:1f:07:3e:f4:14:
                    b4:9c:c6:cc:cc:d8:4f:97:9e:96:e0:a4:bb:cc:eb:
                    dd:dc:5b:50:d7:a8:af:af:39:6c:c5:f4:69:64:16:
                    01:9e:d6:fb:ed:78:11:06:28:c4:a6:b9:12:97:08:
                    b1:22:63:61:89:f2:58:94:83:35:75:8f:35:71:4a:
                    6d:25
                Exponent: 65537 (0x10001)
    Signature Algorithm: sha256WithRSAEncryption
    Signature Value:
        81:19:41:db:e9:66:fd:e1:26:55:04:d4:3a:70:a4:1f:92:d6:
        a1:fc:64:36:86:6d:86:b8:86:0f:1d:1f:0c:06:82:c2:86:ad:
        6d:f9:1a:da:9b:1a:07:f1:28:d8:5d:ea:11:41:06:8a:38:e3:
        d6:b1:5e:11:a1:56:79:ef:9b:2c:6f:06:d7:fa:bb:be:f0:df:
        85:40:85:75:bf:61:53:3d:ec:4b:a1:f7:46:ee:41:7c:be:5f:
        2d:f0:3c:f4:ef:85:a5:67:6e:4f:4b:f5:43:c0:d4:1a:61:0d:
        3d:ee:a9:02:10:2d:90:60:6a:81:bd:2b:db:5c:3c:70:82:0a:
        c7:22:53:82:63:ea:c1:62:49:50:42:44:60:29:b2:6e:a8:d8:
        01:42:70:09:dd:a0:e8:9d:ec:e0:4d:9f:3d:99:fc:5d:d5:af:
        dd:96:80:86:f0:b3:ee:43:6a:85:05:77:5b:1e:fb:00:43:fa:
        bb:58:70:5f:a4:f0:6b:6d:53:4f:99:8e:40:c7:c5:4f:42:5d:
        50:00:b1:80:1f:8d:a3:9c:cb:ea:b0:46:24:94:09:84:2f:52:
        33:85:4d:87:79:dc:4b:1e:f3:6b:7d:b9:2f:c8:93:50:57:8a:
        ca:4e:9e:2e:8b:27:52:e2:07:a0:8b:0f:db:a1:76:4a:5b:0a:
        b4:59:1a:29
```

## Vocabulary

- _PEM_ is Privacy-Enhanced Mail (it is a type of format).
- _CSR_ is a Certificate Signing Request.
- _CA_ is a Certificate Authority.

- _PKCS_ is Public-Key Cryptography Standards.

- _DSA_ is Digital Signature Algorithm.
- _RSA_ is Rivest Shamir Adleman.
- _ECDSA_ is Elliptic Curve Digital Signature Algorithm.
- _EdDSA_ is Edward-curve Digital Signature Algorithm.

