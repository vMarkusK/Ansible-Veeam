# Ansible Veeam Playbooks, Roles and Modules

## About

![Ansible Veeam](/media/AnsibleVeeam.png)

Besides an Ansible Playbook for the unattended installation of Veeam Backup & Replication servers, this repository contains my Ansible modules for the management of Veeam Backup & Replication.

The Veeam modules are based on the Veeam PowerShell cmdlets ([Veeam PowerShell Reference](https://helpcenter.veeam.com/docs/backup/powershell/cmdlets.html?ver=95u4)). All modules are designed to be executed on a Veeam Veeam Backup & Replication server with installed console and PowerShell Snapin, no remote connection.

### Project Owner

Markus Kraus [@vMarkus_K](https://twitter.com/vMarkus_K)

MY CLOUD-(R)EVOLUTION [mycloudrevolution.com](http://mycloudrevolution.com/)

## Project Content

The Ansible Veeam Modules of this Repository are shipped as a Ansible Role now. The [Ansible Veeam Role](https://github.com/mycloudrevolution/veeam) is a GIT submodule of this Repository and is also published on the [Ansible Galaxy](https://galaxy.ansible.com/mycloudrevolution/veeam). 

Installation of the Role:
```
ansible-galaxy install mycloudrevolution.veeam 
```

To display the documentation of the "non-default" Ansible modules you can use this syntax:

```
ansible-doc veeam_credential -M /<path to the project root folder>/roles/veeam/library/
```

### Module - veeam_facts

Collect configuration details from your Veeam Backup & Replication Server.

Playbook tasks:

```
  roles:
  - veeam
  tasks:
  - name: Get Veeam Facts
    veeam_connection_facts:
    register: my_facts
  - name: Debug Veeam Facts
    debug:
        var: my_facts
```

Return (Example):

```
ok: [10.0.2.16] => {
    "my_facts": {
        "changed": false,
        "failed": false,
        "veeam_facts": {
            "veeam_connection": [
                {
                    "port": 9392,
                    "server": "localhost",
                    "user": "VEEAM01\\Administrator"
                }
            ],
            "veeam_credentials": [
                {
                    "description": "Lab User for Standalone Host",
                    "encryptedpassword": null,
                    "id": "ae0fa0f8-d0ed-4014-9e0c-b84d56bc9084",
                    "name": "root",
                    "username": "root"
                }
            ],
            "veeam_repositories": [
                {
                    "description": "Created by Veeam Backup",
                    "friendlypath": "C:\\Backup",
                    "host": "Veeam01",
                    "name": "Default Backup Repository",
                    "type": "Windows"
                }
            ],
            "veeam_servers": [
                {
                    "description": "Backup server",
                    "id": "6745a759-2205-4cd2-b172-8ec8f7e60ef8",
                    "name": "Veeam01",
                    "type": "Microsoft Windows Server"
                },
                {
                    "description": "Created by Powershell at 25.06.2019 22:39:24.",
                    "id": "aedd0693-657c-4384-9e53-cd6bb605a637",
                    "name": "192.168.234.101",
                    "type": "VMware ESXi Server"
                }
            ]
        }
    }
}
```

### Module - veeam_credential

Add and remove credentials on your Veeam Backup & Replication Server.

#### Add, debug and remove credentials

 ![Veeam Add Credentials ](/media/VeeamAddCred.png)

```
  roles:
  - veeam
  tasks:
  - name: Add Credential
    veeam_credential:
        state: present
        type: windows
        username: Administrator
        password: "{{ my_password }}"
        description: My dummy description
    register: my_cred
  - name: Debug Veeam Credentials
    debug:
        var: my_cred
  - name: Get Veeam Facts
    veeam_connection_facts:
    register: my_facts
  - name: Debug Veeam Credential Facts
    debug:
        var: my_facts  | json_query(query)
  - name: Remove Credential
    veeam_credential:
        state: absent
        id: "{{ my_cred.id }}"
```

### Module - veeam_server

Add and remove Servers (VMware ESXi, VMware vCenter, etc. ) on your Veeam Backup & Replication Server.

#### Add VMware ESXi Server 

 ![Veeam Add ESXi ](/media/VeeamAddEsxi.png)

```
  roles:
  - veeam
  tasks:
  - name: Add root credential
    veeam_credential:
        state: present
        type: standard
        username: root
        password: "{{ root_password }}"
        description: "Lab User for Standalone Host"
    register: root_cred
  - name: Debug root credential
    debug:
        var: root_cred
  - name: Add esxi server
    veeam_server:
        state: present
        type: esxi
        credential_id: "{{ root_cred.id }}"
        name: 192.168.1.10
    register: esxi_server
  - name: Get Veeam Facts
    veeam_connection_facts:
    register: my_facts
  - name: Debug Veeam Servers from Facts
    debug:
        var: my_facts.veeam_facts.veeam_servers
```

#### Add VMware vCenter Server 

 ![Veeam Add vCenter ](/media/VeeamAddVcenter.png)

 ```
  roles:
  - veeam
  tasks:
  - name: Add vCenter credential
    veeam_credential:
        state: present
        type: standard
        username: Administrator@vSphere.local
        password: "{{ vcenter_password }}"
        description: "Lab User for vCenter Server"
    register: vcenter_cred
  - name: Debug vcenter credential
    debug:
        var: vcenter_cred
  - name: Add vCenter server
    veeam_server:
        state: present
        type: vcenter
        credential_id: "{{ vcenter_cred.id }}"
        name: 192.168.234.100
    register: vcenter_server
  - name: Get Veeam Facts
    veeam_connection_facts:
    register: my_facts
  - name: Debug Veeam Servers from Facts
    debug:
        var: my_facts.veeam_facts.veeam_servers
```

### Playbook - Veeam_setup.yml

Install Veeam Backup & Replication 9.5 Update 4a in the unattended mode with Ansible. 

Test / Dev Environment:
 * Ansible 2.8
 * CentOS 7
 * Windows Server 2019

 ![Veeam Setup](/media/VeeamSetup.png)

### Playbook - Veeam_get_facts.yml

Playbook for gather Veeam Backup & Replication facts. 

Test / Dev Environment:
 * Ansible 2.8
 * CentOS 7
 * Windows Server 2019
 * Veeam Backup & Replication 9.5 Update 4a

### Playbook - Veeam_add_esxi.yml

Playbook to add a new VMware ESXi Server to the Veeam Backup & Replication server. 

Test / Dev Environment:
 * Ansible 2.8
 * CentOS 7
 * Windows Server 2019
 * Veeam Backup & Replication 9.5 Update 4a
 * VMware ESXi 6.7 Update 1

 ### Playbook - Veeam_add_vcenter.yml

Playbook to add a new VMware vCenter Server to the Veeam Backup & Replication server. 

Test / Dev Environment:
 * Ansible 2.8
 * CentOS 7
 * Windows Server 2019
 * Veeam Backup & Replication 9.5 Update 4a
 * VMware vCenter 6.7 Update 1

### Playbook - Veeam_add_cred.yml

Playbook to add and remove new credentials to the Veeam Backup & Replication server. 

Test / Dev Environment:
 * Ansible 2.8
 * CentOS 7
 * Windows Server 2019
 * Veeam Backup & Replication 9.5 Update 4a
