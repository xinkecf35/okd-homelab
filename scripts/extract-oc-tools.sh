#!/bin/zsh


OKD_RELEASE_IMAGE='quay.io/okd/scos-release:4.20.0-okd-scos.17'

if [[ -z "${OKD_INSTALL_TOOLS_DIR}" ]]; then 
    OKD_INSTALL_TOOLS_DIR="$(mktemp -d)"
else 
   mkdir -p "${OKD_INSTALL_TOOLS_DIR}"
fi

cd "${OKD_INSTALL_TOOLS_DIR}"
oc adm release extract --tools --dir="$OKD_INSTALL_TOOLS_DIR" "$OKD_RELEASE_IMAGE"

echo "Extracted OKD client tools to ${OKD_INSTALL_TOOLS_DIR}"