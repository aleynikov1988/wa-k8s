#!/usr/bin/bash

ANSIBLE_GALAXY="/usr/bin/ansible-galaxy"
ANSIBLE_ROOT="~/ansible"

install_req() {
    echo "===== Installing ansible requirements ====="
    eval "$ANSIBLE_GALAXY role install -r $ANSIBLE_ROOT/requirements.yml"
    eval "$ANSIBLE_GALAXY collection install -r $ANSIBLE_ROOT/requirements.yml"
}

install_req