# openshift-install Configs

Setup of configuration files for `openshift-install` installer for OKD lab

Couple of assumptions:

- PXE infra is in use (see ansible/roles/pxe for a minimal tftpboot/http server for assets)
- iPXE is being used for PXE
- no baremetal integration, LB is fully user managed
- DNS is user managed
- DHCP is available and handing out hostnames 

To update disk parition/non-trivial MachineConfigs with Butane:

`docker run --interactive --rm quay.io/coreos/butane:latest --pretty --strict < openshift-install-configs/.butane/var-disk-parition.bu > openshift-install-configs/openshift/98-boot-disk-parition-machine-config.yaml`

Replace pull secret and ssh key as needed. To generate assets for install:


1. Extract Installer
```
# Get installer program and extract installer
oc adm release extract --tools <target-okd-image-from-quay.io>
```

2. Create PXE files from configs here

```
./openshift-install agent create pxe-files 
```

3. Upload to PXE infra (make sure permissions are correct)

4. boot into images and wait for bootstrap and install complete

```
./openshift-install agent wait-for bootstrap-complete
./openshift-install agent wait-for install-complete
```