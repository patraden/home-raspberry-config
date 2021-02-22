## *installation guide for raspberry PI on ubuntu server*
* [install ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-ubuntu)
```bash
sudo apt update
sudo apt upgrade
sudo apt install software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
cd /etc/ansible/
ansible --version
```

## *configuring inventory and ssh keys for ansible clients*
* [inventory](https://docs.ansible.com/ansible/2.3/intro_inventory.html)
* [ssh keys](https://docs.ansible.com/ansible/latest/collections/ansible/posix/authorized_key_module.html)
```bash
sudo mkdir playbooks
sudo apt install whois -y
sudo apt install sshpass
sudo vim /etc/ansible/inventory.ini
---
[clients]
 raspberry3 ansible_host=raspberry3.lan ansible_connection=ssh ansible_user=ubuntu
[master]
 raspberry4 ansible_host=localhost ansible_connection=local ansible_user=ubuntu
---
sudo vim /etc/ansible/ansible.cfg
---
[defaults]
inventory = /etc/ansible/inventory.ini
---
ansible all -m shell -a id
cd /etc/ansible/playbooks/
sudo vim /etc/ansible/playbooks/deploy-ssh-keys.yml
ansible-playbook deploy-ssh-keys.yml --ask-pass --flush-cache
```

## *playbooks for docker configuration*
* [docker install on ubuntu](https://docs.docker.com/engine/install/ubuntu/)
```bash
```
