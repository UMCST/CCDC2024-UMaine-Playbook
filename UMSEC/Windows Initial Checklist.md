## Windows Initial Checklist
(Past checklist… https://docs.google.com/document/d/1Cb-l9I-3WZpkUoZF13otxeazFGACwFaoaKNAcq0LBb8)

Get basic info about your system

```
systeminfo
```
  - Hostname (Host name:)
  - OS Version (OS Name: and OS Version:)
  - OS Configuration (OS Configuration:)
  - IP Addresses (Network Card(s):)

```
Get-netAdapter
```
  - MAC Addresses (MacAddress Column)

```
Get-service | where-object {$_.status -eq ‘running’}
```
  - SSH Server
  - WinRM (powershell remote management)
  - DNS
  - DHCPServer
  - IIS

```
gsmbs
```
  - There are three default SMB shares, ADMIN$, C$, and IPC$.. In a 
DC, there are also NETLOGON and SYSVOL. Ignore these.

Secure old account and create new local admin account:
```
  Set-LocalUser -Name <username> -Password (Read-Host -AsSecureString)
```
```
  New-LocalUser <username> -Password (Read-Host -AsSecureString)
```
```
  Add-LocalGroupMember -Group "Administrators" -Member 
"NEW_ACCOUNT_NAME"
```

Get and lock existing local users **(NOT ON DC… OR ELSE!)** :
```
glu | disable-localuser 
```
Then re-enable your accounts
```
enable-localuser <my account>
```

If you’re a domain controller:
	Congrats! It’s your job to change alllllllll the passwords. Change the domain admin 
password first.

```
Set-ADAccountPassword -Identity Administrator -Reset 
-NewPassword (ConvertTo-SecureString -AsPlainText ‘<new systepassword>’ -Force)
```

  - Then, check who is a member of important builtin groups
```
Get-ADGroupMember “<group name>”
```
  - Domain Admins
  - Schema Admins
  - Enterprise Admins
  - Administrators

If they don’t need to be there,
```
Remove-ADGroupMember -Identity “Domain Admins” -Members <...>
```

  - Finally, make a new domain admin account for your team’s usage.
```
New-ADUser -Name <name> -SamAccountName <name>@<domain> -Enabled $True
-AccountPassword (Read-Host “pass” -AsSecureString)
```
```
Add-ADGroupMember “Domain Admins” -Members <your admin account>
```

  - (**Optional**) Turn on default group policy
This is best done from the group policy GUI console. Enable and enforce the links
for the “Default Domain Policy” and “Default Domain Controller Policy” GPO objects
in your domain. First, be sure to change the setting under “Default Domain Policy”
> “Computer” > “Windows” > “Security” > “Password Policy” > “Minimum Password Age” to 0.

Install Useful Software
```
iwr -OutFile ‘install.ps1’ ‘https://chocolatey.org/install.ps1’
```
```
Set-ExecutionPolicy Bypass -Scope Process -Force
```
```
.\install.ps1
```

Start an installer for some software in the background
```
Start-Job { choco install -y firefox autoruns tcpview 
winlogbeat }
```
```
Set-ExecutionPolicy Restricted -Scope Process -Force 
```
#wait until the job is done

If you are not on a domain controller, you may want to install AD Powershell tools
```

```


```

```














