## Everything WinRM

**Type of Systems**: Windows  
**Necessary Skills**: Powershell  
**Complete Goal**: Setup and manage a windows box with WinRM

## Enabling WinRM
1. On the computer you’re going to remote into, enable WinRM:  
```
Enable-PSRemoting
```  
2. Enter a powershell session on the connected box:
```
Enter-PSSession <computer name> -Credential <domain\user>
```  
## Enable RDP Remotely
1. In a remote session, enable RDP:  
```
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -Value 0
```
2. Activate the powershell rule:  
```
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
```
3. Enable Authentication over RDP  
```
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "UserAuthentication" -Value 1
```

## View the Sessions
```
Get-PSSession -ComputerName <hostname>
```

## View privileged users
```
(Get-PSSessionConfiguration -Name Microsoft.Powershell).Permission
```




























