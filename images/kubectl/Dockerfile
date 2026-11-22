ARG KUBECTL_VERSION=1.36.6

FROM registry.k8s.io/kubectl:v${KUBECTL_VERSION} as kubectl


FROM registry.access.redhat.com/ubi9/ubi-minimal:latest

COPY --from=kubectl /bin/kubectl /usr/local/bin/kubectl

ENTRYPOINT [ "/bin/sh" ]
