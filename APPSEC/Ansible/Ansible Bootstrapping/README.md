# Ansible-bootstrap

The main purpose of this playbook is to bootstrap clients, by adding the deployer user to them. This works for both Windows and Linux clients. Linux clients will also have python3 installed/updated.

To run the playbook, simply enter:

`ansible-playbook -i inventory.ini main.yml --ask-vault-pass`

To use an ssh key run:

`ansible-playbook -i inventory.ini main.yml --key-file ~/.ssh/yourkey`

---

In order to add a new client to be bootstrapped you will need to add the hostname to the inventory.ini file, followed by variables for the ssh password. If adding a linux client, you will also need to add the sudo password (same variable). Follow the same naming convention as you see in the file. Once you add hostname and variables in the inventory.ini file, you will then have to declare the variables with the correct password within the Ansible vault file ansible_vars.yml.

If there is a new client added to the inventory, you will first need to SSH to the
client from the Ansible host to add a fingerprint

In main.yml, change the remote_user variable to some user with elevated privileges when deploying.
