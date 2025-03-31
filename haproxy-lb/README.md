# haproxy-lb

Small deployment to create HAproxy container + configs (WIP)

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
kustomize build > haproxy-service.yaml
sudo podman kube play --network k8s-homelab-net haproxy-service.yaml
```

## TODO:

- look into rootless - need to solve with ipvlan or other
- Quadlet configuration/integrate with systemd