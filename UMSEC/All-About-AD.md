## Get Windows : Active Directory (AD) Server
Authors: Cameron Sullivan (RIP), Kody Moseley, Joe Patton, Llewellyn Searing, Nick Dieff

# New DC setup
Uses Powershell to create a clean domain controller in a fresh environment.

Pre-requisites:
  - Make sure the computer name of the DC is correct (hostname).
  - Have a static IP address.

1. Install the “AD-Domain-Services” feature
    1. `Install-WindowsFeature AD-Domain-Services -IncludeManagementTools`
2. Import the Powershell module
     1. `Import-Module ADDSDeployment`
3. Install AD with specified domain name
     1. `Install-ADDSForest -DomainName <my domain>`

The default users will be:
  - Administrator
  - Guest
  - Krbtgt
  - Possible service accounts (sshd...)

There will be a great number of default groups (~48), under the CNs “Users” and 
“Builtin”. AD default group descriptions: http://bit.ly/2mKnoD1.

# Backup DC Setup
If you already have a working AD forest with at least one domain controller,
you can easily create some secondary controllers that can be used in case of failures.

**The local admin password, safemode password, and AD Admin password MUST all be 
different. When creating a credential, be sure to include the domain name in the 
username: <domain name>\<user name>.**

1. Install the “AD-Domain-Services” features
     1. `Install-WindowsFeature AD-Domain-Services -IncludeManagementTools`
2. Import the Powershell module
     1. `Import-Module ADDSDeployment>`
3. Create a Powershell Credential with the administrator password for your domain
     1. `$cred = New-Object -TypeName System.Management.Automation.PSCredential
-ArgumentList “<domain name>\Administrator”, (read-host -asSecureString “Admin Password”)`
4. Promote the current computer to a domain controller inside of your domain
     1. `Install-ADDSDomainController -Credential $cred -DomainName "<domain name>"`
     2. `-InstallDNS` is also available as an option here. The DNS records will be
  replicated  between servers if the zone is AD connected
# AD Administration from Powershell
Powershell ad module reference: https://bit.ly/2NWtH3X 

To use these Powershell commands, you will need to have RSAT installed:
`Get-WindowsCapability -Name Rsat.ActiveDirectory* -Online | Add-WindowsCapability -Online`
On Server 2008 / Win7 you will need to run the command after: Import-module ActiveDirectory

**Filtering**
Many of the commands from the ActiveDirectory module have a -Filter subcommand. 
This takes as an argument a string in “Powershell Expression Language”. 
Here are some examples:
`Get-ADUser -Filter *`  # returns all users
`Get-ADUser -Filter {GivenName -like "Chris"}` #Users with the first name chris
`Get-ADUser -Filter {Name -like "Patenaude*"}` # get all of Joe’s relatives # note that 
the name parameter stores the name in the form <Last>, <first>

**Find AD users**
` Get-ADUser -Filter *`

To get extra properties like “sn”, “LastLogonDate”, or “whenChanged”, add them as 
arguments to the -Properties option, or use `-Properties *` to view all. Note that 
not all properties appear for every user.

Here’s a few useful searches:

`Get-AdUser -filter { PasswordNeverExpires -eq $true -and Enabled -eq $true}`

**Add New Users**
`New-ADUser -Name "<name>" -SamAccountName "<username>" -AccountPassword 
(Read-Host -AsSecureString) -Enabled $True -GivenName “<first name>” -Surname 
“<last name>” -Path "CN=Users,DC=<domain>,DC=<tld>" -UserPrincipalName 
"<username>@<domain>"`

**Add Users to Groups**
First, find the name of a group you want. Then:
`Add-ADGroupMember "<group name>" -Members <member1, member2...>`

**Check group members**
`Get-ADGroupMember -Identity <group name>`
Optionally add the -Recursive argument to also show members of subgroups.
`Get-ADGroupMember -Identity <group name> -Recursive | Select Name`

**Kick them out of a group**
`Remove-ADGroupMember -Identity DocumentReaders -Members DavidChew`

**Reset a user’s password**
` Set-ADAccountPassword <user> -Reset -NewPassword (ConvertTo-SecureString 
-AsPlainText ‘<new password>’ -Force)`

**Set a user’s password expiration**
`Set-ADUser <user> -PasswordNeverExpires $true`

**Add a new computer object**
`Add-ADComputer`

**Enable User**
`Enable-ADUser -Identity <user>`

# Tasks
Active Directory quick-reference from Microsoft: http://bit.ly/2m2alPQ

# Special Task: Join a Client to an AD Domain
Need to finish










