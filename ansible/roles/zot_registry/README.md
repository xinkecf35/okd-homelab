# zot-registry

Deploys a OCI Image Registry with [project-zot](https://github.com/project-zot/zot) with podman

Note this is mostly inspired from the Helm chart, stripping out things like liveness probes and non-supported K8S
resoucrce to make it play nicer with macvlan network and podman kube.
