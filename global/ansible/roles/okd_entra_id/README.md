# OKD Entra ID Ansible Role

This role is used to bootstrap the OKD cluster to establish Microsoft Entra as an SSO Provider
for OpenShift Authentication. 

Creation of relevant configuration is delegated to the manual creation/other automation
(for this project, see `globa/iac` for Tofu files configuring Entra), this role is purely
setup to create required client secret Kubernetes Secret and apply relevant configuration
to add Entra as OIDC IdP authentication provider in `OAuth/cluster` resource.

This role does also add cluster-admin role bindings for a minimal set of user identifies
as reconciled from Microsoft Entra
