# Ansible Veeam Playbooks, Roles and Modules

## About

![Ansible Veeam](/media/AnsibleVeeam.png)

### Project Owner

Markus Kraus [@vMarkus_K](https://twitter.com/vMarkus_K)

MY CLOUD-(R)EVOLUTION [mycloudrevolution.com](http://mycloudrevolution.com/)


## Project Content

### Playbook - Veeam_setup.yml

Install Veeam Backup & Replication 9.5 Update 4a in the unattended mode with Ansible. 

Test / Dev Environment:
 * Ansible 2.8
 * CentOS 7
 * Windows Server 2019

 ![Veeam Setup](/media/VeeamSetup.png)

### Playbook - Veeam_test.yml

Test Playbook for the Veeam Backup & Replication modules. 

Test / Dev Environment:
 * Ansible 2.8
 * CentOS 7
 * Windows Server 2019
 * Veeam Backup & Replication 9.5 Update 4a

 ### Playbook - Veeam_test.yml

Test Playbook to add a new VMware ESXi Server to the Veeam Backup & Replication server. 

Test / Dev Environment:
 * Ansible 2.8
 * CentOS 7
 * Windows Server 2019
 * Veeam Backup & Replication 9.5 Update 4a
 * VMware ESXi 6.7 Update 1

 ### Module - veeam_facts

Collect configuration details from your Veeam Backup & Replication Server.

```
  - name: Get Veeam Facts
    veeam_connection_facts:
    register: my_facts
  - name: Debug Veeam Facts
    debug:
        var: my_facts
```

### Module - veeam_credential

Add and remove credentials on your Veeam Backup & Replication Server.

#### Add, debug and remove credentials

```
  - name: Add credential
    veeam_credential:
        state: present
        type: windows
        username: Administrator
        password: "{{ my_password }}"
        description: dummy description
    register: my_cred
  - name: Debug Veeam Credentials
    debug:
        var: my_cred
  - name: Remove credential
    veeam_credential:
        state: absent
        id: "{{ my_cred.id }}"
```

### Module - veeam_server

Add and remove Servers (VMware ESXi, VMware vCenter, etc. ) on your Veeam Backup & Replication Server.

#### Add VMware ESXi Server 

```
  - name: Add root credential
    veeam_credential:
        state: present
        type: standard
        username: root
        password: "{{ root_password }}"
        description: "Lab User for Standalone Host"
    register: root_cred
  - name: Add esxi server
    veeam_server:
        state: present
        type: esxi
        credential_id: "{{ root_cred.id }}"
        name: 192.168.1.10
    register: esxi_server
    ```
