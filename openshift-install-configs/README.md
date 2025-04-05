# openshift-install Configs

Setup of configuration files for `openshift-install` installer for OKD lab

Couple of assumptions:

- PXE infra is in use (WIP in this repo)
- iPXE is being used for PXE (also WIP)
- no baremetal integration, LB is fully user managed
- DNS is user managed
- DHCP is available and handing out hostnames 