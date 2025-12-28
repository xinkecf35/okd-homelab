# Smallstep CA Helm Release Ansible Role

This Ansible Role is to bootstrap a PKI into OKD cluster for general 
cluster certificate issuance needs for the cluster and clients connecting to the
CA provisioned by the the `smallstep-ca` Helm charts

This Role takes already provisioned Root CA certificate, Intermediate CA public/private key pair, 
and a few other secrets around certificate issuance to bootstrap a PKI into a brand new
OKD cluster.

The role will automatically and (securely with vaulted strings):

- generate relevant parameters to configure JWKS, ACME and additional provisoners automatically
- template a values-file
- install the Helm chart with the desired parameters

## Setup (WIP)

### Root CA 
- setup `step` and `step-kms-plugin` - [1][1],[2][2]
- Follow this [guide for creating Root CA keys, cert ][3] (note on securely deleting the root key - just do `rm`. Practical reality with SSDs makes shred kind of pointless)


### Intermediate CA creation
- For intermediate CA certs, use [`step certificate create`][4] to create Intermediate CA CSR
```bash
step certificate create "dontxinkeship Issuing CA" intermediate.csr intermediate_ca_key --csr
```
- sign the CSR with the Yubikey 
```
# Don't forget to change pin
step certificate sign --profile intermediate-ca --kms 'yubikey:pin-value=123456' intermediate.csr ~/.step/certs/root_ca.crt  'yubikey:slot-id=9c'  > intermediate_ca.crt
```
- Inspect the cert:
```
❯ step certificate inspect intermediate_ca.crt
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 129281752106110005432240058441823924036 (0x6142c27feb74c000377dac62961faf44)
    Signature Algorithm: ECDSA-SHA384
        Issuer: CN=donxinkeship Root CA
        Validity
            Not Before: Apr 13 21:32:54 2025 UTC
            Not After : Apr 11 21:32:54 2035 UTC
        Subject: CN=dontxinkeship Issuing CA
        Subject Public Key Info:
            Public Key Algorithm: ECDSA
                Public-Key: (256 bit)
                X:
                    26:0f:7a:02:65:d8:2c:17:39:86:31:ea:29:99:7b:
                    d5:47:45:98:2f:0b:22:e3:a2:36:53:8f:79:7e:b6:
                    eb:be
                Y:
                    36:cd:dd:5d:8e:a3:82:ee:8c:56:28:69:b6:78:1e:
                    04:fb:d7:b2:ad:26:14:76:90:eb:92:bf:ce:ff:91:
                    73:09
                Curve: P-256
        X509v3 extensions:
            X509v3 Key Usage: critical
                Certificate Sign, CRL Sign
            X509v3 Basic Constraints: critical
                CA:TRUE, pathlen:0
            X509v3 Subject Key Identifier:
                2A:FE:DA:CC:82:5C:08:46:43:35:ED:50:F8:DA:EB:5B:36:33:DF:A5
            X509v3 Authority Key Identifier:
                keyid:CB:6D:6B:00:30:87:13:71:4C:D2:4D:78:AF:47:D0:C3:1A:85:38:8E
    Signature Algorithm: ECDSA-SHA384
         30:64:02:30:5b:c1:cb:53:a5:2b:06:cd:39:dd:cf:ca:4e:d6:
         d2:e8:01:ff:47:73:f8:49:ab:9f:1a:fa:ff:60:81:ee:15:ba:
         71:f8:a6:5c:76:03:52:c5:a3:02:77:05:37:cb:16:51:02:30:
         05:02:33:fe:75:8b:43:5e:02:44:a0:6c:0a:a8:7a:80:bf:c4:
         b7:ad:c1:da:f4:e8:1f:9f:74:67:ac:47:c3:65:16:18:09:28:
         13:85:5d:64:8a:34:c9:3b:52:61:5d:ad
```


[1]: https://smallstep.com/docs/step-ca/installation/#macos
[2]: https://github.com/smallstep/step-kms-plugin/
[3]: https://github.com/smallstep/certificates/discussions/1591
[4]: https://prof.infra.smallstep.com/docs/tutorials/intermediate-ca-new-ca#:~:text=This%20tutorial%20will%20walk%20you%20through%20three%20ways,create%20an%20intermediate%20CA%20to%20your%20existing%20PKI.
