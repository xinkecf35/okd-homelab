#!/bin/bash

imok_ack_script_contents="$( cat int3400-imok-ack.sh | base64  )"
udev_rule_contents="$( cat 99-int3400-imok.rules | base64 )"

cat << EOF > 99-master-int3400-imok-workaround-mc.yaml
apiVersion: machineconfiguration.openshift.io/v1
kind: MachineConfig
metadata:
  name: 99-master-int3400-imok-workaround
  labels:
    machineconfiguration.openshift.io/role: master
spec:
  config:
    ignition:
      version: 3.5.0
    storage:
      files:
        - path: /etc/udev/int3400-imok-ack
          mode: 493
          overwrite: true
          contents:
            source: >-
              data:text/plain;charset=utf-8;base64,${imok_ack_script_contents}

        - path: /etc/udev/rules.d/99-int3400-imok.rules
          mode: 420
          overwrite: true
          contents:
            source: >-
              data:text/plain;charset=utf-8;base64,${udev_rule_contents}
EOF
