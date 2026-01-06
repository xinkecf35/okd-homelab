# zot-registry

Deploys a OCI Image Registry with [project-zot](https://github.com/project-zot/zot) with podman

Note this is mostly inspired from the Helm chart, stripping out things like liveness probes and non-supported K8S
resoucrce to make it play nicer with macvlan network and podman kube.

## Certs

For most runtimes a TLS secured image registry is a given. To fancilate to that, this role has a Kube play + kustomization
to server zot over HTTPS. 

Simply create zot-registry.crt and zot-registry.key in files/kustomize/secrets to provide relevants certs and private key for it to use.
