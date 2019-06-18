#!powershell

# Copyright: (c) 2019, Markus Kraus <markus.kraus@gmail.com>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

#Requires -Module Ansible.ModuleUtils.Legacy
#AnsibleRequires -OSVersion 6.2

$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

# Functions
Function Connect-VeeamServer {
    try {
        Add-PSSnapin -PassThru VeeamPSSnapIn -ErrorAction Stop | Out-Null
    }
    catch {
        Fail-Json -obj @{} -message  "Failed to load Veeam SnapIn on the target: $($_.Exception.Message)"  
            
    }

    try {
        Connect-VBRServer -Server localhost
    }
    catch {
        Fail-Json -obj @{} -message "Failed to connect VBR Server on the target: $($_.Exception.Message)"  
    }
}
Connect-VeeamServer

# Create a new result object
$result = @{
    changed = $false
    veeam_facts = @{
        veeam_connection = @()
    }
}

# Get Veeam Connection
try {
    $Connection = Get-VBRServerSession
} catch {
    Fail-Json -obj $result -message "Failed to get connection details on the target: $($_.Exception.Message)"
}

# Create result
$connection_info = @{}
$connection_info["user"] = $Connection.user
$connection_info["server"] = $Connection.server
$connection_info["port"] = $Connection.port

$result.veeam_facts.veeam_connection += $connection_info

# Return result
Exit-Json -obj $result
