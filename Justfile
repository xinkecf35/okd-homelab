
tf_bin := require('tofu')
global_iac_dir := justfile_dir() / 'global/iac'
global_ansible_dir := justfile_dir() / 'global/ansible'
global_ansible_secrets_vars_file := justfile_dir() / 'global' / 'ansible' / 'secrets' / 'users.yaml'

ansible_vault_id := 'okd-homelab'
ansible_vault_password_helper := justfile_dir() / "scripts" / "ansible-vault-dashlane-client.sh"
default_vault_id_arg := ansible_vault_id + "@" + ansible_vault_password_helper

export OKD_GLOBAL_IAC_TF_OUTPUT_JSON_FILE := `mktemp`

_tf_init_global_iac:
    {{ tf_bin }} -chdir="global/iac" init

apply-day-1-okd: _tf_init_global_iac
    {{ tf_bin }} -chdir="{{ global_iac_dir }}" apply
    {{ tf_bin }} -chdir="{{ global_iac_dir }}" output -json > "${OKD_GLOBAL_IAC_TF_OUTPUT_JSON_FILE}"
    ansible-playbook "{{ global_ansible_dir }}/day-1-bootstrap-playbook.yaml" --extra-vars="@${OKD_GLOBAL_IAC_TF_OUTPUT_JSON_FILE}" --extra-vars=@{{ global_ansible_secrets_vars_file }}

vault-encrypt-string secret_string :
    ansible-vault encrypt_string --vault-id {{default_vault_id_arg}} {{secret_string}}