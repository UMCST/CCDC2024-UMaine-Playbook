## Windows: Log and Alert When Accounts are Created  
With a focus on admin account creation  

**Type of Systems**: Windows AD Domain Controller
**Necessary Skills**: Use of the Group Policy and Event Viewer tools, and a centralized logging forwarder (Splunk or Syslog).

**Complete Goal**: To log when new user accounts are created and send those logs to the centralized logging server.

**Steps**:  
1. Log in to the AD domain controller as the domain admin.
2. Open the Group Policy Management Console (CMD: `gmpc`).
3. In the directory pane on the left, navigate: _Forest: (domainName)_ > _Domains_ >
(_domainName_) When (_domainName_) is the AD domain name.
4. Right click on “Default Domain Policy” and select “Edit.”
5. Navigate to _Computer Configuration_ > _Policies_ >_ Windows Settings_ > _Security
Settings_ > _Local Policies_ > _Security Options_
6. Open “Audit: Force audit policy subcategory settings” and enable it.
7. Navigate to _Security Settings_ > _Advanced Audit Policy Configuration_ >_ Audit Policies_ >
_Account Management_
9. Open “Audit User Account Management,” and enable “Success.” This logs account creation.
10. Open “Audit Security Group Management,” and enable “Success.” This logs when a user account
is added to a group.
11. After changing the group policy, you must refresh the policy on the domain.
Use CMD: `gpupdate /force`
12. If you want to check for account events, open event viewer (CMD: `eventvwr`). Navigate
 to Windows Logs > Security. If you see events with IDs 4720 (account created),
 4724 (account’s password was changed), or 4738 (account was changed), this means that we are
logging account creation. If you see events with IDs 4732 (A user was added to a group),
 or 4735 (A group was changed), this means we are logging group management.
13. To add account creation events to the centralized logging server, you need to add
the security log to your forwarder. The log is located at:
 C:_\Windows\System32\winevt\Logs\Security.evtx_

**Appendix:**

![unnamed (1)](https://github.com/UMCST/CCDC2024-UMaine-Playbook/assets/79597328/2e67a44e-a17c-4616-9014-7172014dd762)
Step 9: Your Group Policy window should look like this after you set the two account 
management policies.






























