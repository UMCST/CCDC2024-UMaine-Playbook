# Network Safety Script
The purpose of this script is to asisst in preventing self lockout when applying network rules.

Replace <your network rule> with the command you want to test
```
<your network rule>

Start-Sleep -Seconds 3

Set-NetFirewallProfile -Enabled False
```
