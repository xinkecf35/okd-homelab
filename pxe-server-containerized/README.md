# TFTPD + HTTP Server for PXE infra

Manifests to create a minimal TFTPD server with HTTP server to provide PXE environment.

Based on work from [kalaksi/docker-tftpd][1], modified for use to play with `podman kube play`

## Setup 
- create macvlan network (to directly expose container w/ dedicated IP)
```bash
# command suggested by ChatGPT to create macvlan network and correct routing with limited address range
# br-vlan20 bridge interface created externally with 192.168.2.0/24 subnet
sudo podman network create -d macvlan \
  --ipam-driver host-local \
  --subnet=192.168.2.0/24 \
  --ip-range=192.168.2.16/28 \
  --gateway=192.168.2.1 \
  -o parent=br-vlan20 \
  k8s-homelab-net
```
- create rootful container (need rootful since we want direct host interface access)
```
kustomize build > pxe-service.yaml
sudo podman kube play --network k8s-homelab-net pxe-service.yaml
```

## Notable changes from `docker-compose.yaml`

A couple notable diffs now from the reference [`docker-compose.yaml`][2] file:

- The tftpd and http containers share a single network namespace (this is consistent with `podman kube play`)
- PXE menu is created as a ConfigMap and overlaid top of the `/tftpboot/pxelinux.cfg` directory
-  tftp server is allowed to listen on UDP 69 (for convenience w/ the macvlan setup) and thus relevant sysctls are allowed
- Not really using pxelinux at this time, most relevant stuff is ipxe-files

## TODO: 
- setup static IP with pod
- Quadlet configuration


[1]: https://github.com/kalaksi/docker-tftpd/tree/master
[2]: https://github.com/kalaksi/docker-tftpd/blob/bcdf213aaebb3906ef18217452afbb45d801ff5f/docker-compose.yml