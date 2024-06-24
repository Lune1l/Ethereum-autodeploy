
# Ethereum auto-deploy

This repo contains the necessary tools to deploy an Ethereum full-node using Nethermind & Nimbus.

## Repo tour

```
.
└── holesky-autodeploy/
    ├── ansible-role/ <- Contains ansible playbook, roles and config required for install
    ├── terraform/ <- Contains the Terraform file to deploy hosts
    ├── hosts.ini <- Config for ansible
    └── README.md <- The file you are reading now
```

## Ansible playbook

```
.
├── ethereum-fullnode.yml
├── roles
│   ├── generate_jwt
│   │   └── tasks
│   │       └── main.yml
│   ├── nethermind
│   │   ├── tasks
│   │   │   ├── configure.yml
│   │   │   ├── fetch_nethermind.yml
│   │   │   └── main.yml
│   │   └── templates
│   │       └── nethermind_service.j2
│   ├── nimbus
│   │   ├── tasks
│   │   │   ├── configure.yml
│   │   │   ├── fetch_nimbus.yml
│   │   │   └── main.yml
│   │   └── templates
│   │       └── nimbus_service.j2
│   ├── node_exporter
│   │   └── tasks
│   │       └── main.yml
│   └── system_setup
│       └── tasks
│           └── main.yml
└── vars.yml
```

The playbook 'ethereum-fullnode.yml' will deploy the fullnode on two hosts :
- eth_nethermind
- eth_nimbus

This playbook have been tested with 3 hosts deployed on a proxmox and using two disks:
- One for the system e.g : `/dev/sda`
- One for the chain data e.g : `/dev/sdb`
Please check the second disk is using this dev location before running the playbook.

It use several roles :
- system_setup : Will create a user, by defaut ethereum, format and mount the chain data disk under /mnt/block-volume and install the required packages.
- node_exporter : Will install node exporter for system monitoring. It use this script : https://gist.githubusercontent.com/galexrt/44d62a0681146bfdbe98d0b549a01999/raw/88d675dc06a43a03265a607f28222cf21cf07cac/node_exporter.sh
- generate_jwt : Will generate the JWT token used by Nimbus and Nethermind on the ansible host and distribute it to the eth_nethermind and eth_nimbus machines.
- nimbus : Get the latest binary, configure the user home and setup the nimbus service.
- nethermind : Get the latest binary, configure the user home and setup the nethermind service.

## Terraform

The terraform config file has not been tested.
It should setup two hosts with same specs and two disks according the the setup described above. 

## Get started

1. Git clone the repo:
```
git clone https://github.com/Lune1l/holesky-autodeploy
```
2. Edit the `hosts.ini` file
You need to edit the `hosts.ini` file to be able to run the playbook, please change the host ip and password.
3. Edit the `vars.yml` file
Please edit the `vars.yml` file according to your need :
- by default, the playbook will setup the nodes for holesky.
- please set the nethermind rpc url according to your nethermind's host ip address.
4. Run the playbook
At root of the project run ```ansible-playbook -i hosts.ini ansible-role/ethereum-fullnode.yml```

## Post-scriptum

Once the playbook has been run, the two services will start, Nethermind will start syncing and Nimbus will crash due to unreachability of Nethermind as it is not synced yet. Once Nethermind is synced with chain, Nimbus should start syncing.
Complete sync has not been tested due to the limitation of my baremetal server.

