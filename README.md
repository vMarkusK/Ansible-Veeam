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

Add and remove Credentials on your Veeam Backup & Replication Server.

```
  - name: Add credential
    veeam_credential:
        state: present
        type: windows
        username: Administrator
        password: ChangeMe
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

