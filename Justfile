
tf_bin := require('tofu')
global_iac_dir := justfile_dir() / 'global/iac'
global_ansible_dir := justfile_dir() / 'global/ansible'
global_ansible_secrets_vars_file := justfile_dir() / 'global/ansible/secrets/users.yaml'

export OKD_GLOBAL_IAC_TF_OUTPUT_JSON_FILE := `mktemp`

_tf_init_global_iac:
    {{ tf_bin }} -chdir="global/iac" init

apply-day-1-okd: _tf_init_global_iac
    {{ tf_bin }} -chdir="{{ global_iac_dir }}" apply
    {{ tf_bin }} -chdir="{{ global_iac_dir }}" output -json > "${OKD_GLOBAL_IAC_TF_OUTPUT_JSON_FILE}"
    ansible-playbook "{{ global_ansible_dir }}/day-1-bootstrap-playbook.yaml" --extra-vars="@${OKD_GLOBAL_IAC_TF_OUTPUT_JSON_FILE}" --extra-vars=@{{ global_ansible_secrets_vars_file }}
