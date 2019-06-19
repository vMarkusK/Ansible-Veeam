#!/usr/bin/python
# -*- coding: utf-8 -*-

# Copyright: (c) 2019, Markus Kraus <markus.kraus@gmail.com>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

ANSIBLE_METADATA = {'metadata_version': '1.1',
                    'status': ['preview'],
                    'supported_by': 'community'}

DOCUMENTATION = r'''
---
module: veeam_credential
version_added: '2.5'
short_description: Manages Veeam Credentials
description:
   - With the module you can manage Veeam Credentials.
requirements:
   - Windows Server 2019
   - Veeam Backup & Replication 9.5 Update 4a
notes:
  - In order to understand all the returned properties and values please visit the following site
    U(https://helpcenter.veeam.com/docs/backup/powershell/getting_started.html?ver=95u4)
author:
  - Markus Kraus (@vMarkus_K)
'''

EXAMPLES = r'''
---

'''

RETURN = r'''
----

'''
