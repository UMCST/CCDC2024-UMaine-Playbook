# FreeIPA info
The majority of crucial information can be found in this tutorial: Install FreeIPA Server on Oracle Linux(https://docs.oracle.com/en/learn/ol-freeipa/#disable-anonymous-binds)
Backup and restore relevant pages: 
- ipa-backup(1) — freeipa-server — Debian experimental — Debian Manpages         https://manpages.debian.org/experimental/freeipa-server/ipa-backup.1.en.html
- ipa-restore(1) — freeipa-server — Debian experimental — Debian Manpages        https://manpages.debian.org/experimental/freeipa-server/ipa-restore.1.en.html
- Backing and restoring FreeIPA. So I recently had to test the backup… | by Muhammad Umer | Medium      https://medium.com/@umer2834/backing-and-restoring-freeipa-e8504c61dcd8

### Notes: 
- The key settings, including the base dn for the FreeIPA server are stored in the /etc/ipa/default.conf file.
- The $RND_SUBNET is an enviornment variable set in the free lab environment that represents the 4 character randomized string in the FQDN.
- The nsslapd-allow-anonymous-access attribute controls this behavior. Acceptable values include:
  - on: allows all anonymous binds (default)
  - rootdse: allows anonymous binds only for root DSE information
  - off: disallows any anonymous binds
- The FreeIPA server creates the following user groups during installation.
  - admins
  - ipausers
  - trust admins

## Quick start commands:
### Show the status of all the services.
    sudo ipactl status

### Accessing the Command-Line Interface:
#### Authenticate the admin user against the Kerberos realm.
    kinit admin
#### List the ticket’s information
    klist
#### Get a list of all the existing users on the FreeIPA server.
    ipa user-find

### Security Settings and Hardening:
#### Check if anonymous binds are enabled.
    ldapsearch -x -h $(hostname -f) -b dc=$RND_SUBNET,dc=linuxvirt,dc=oraclevcn,dc=com
#### Modify the configuration and disable anonymous binds.
```
cat << 'EOF' | tee ~/disable_anon_bind.ldif > /dev/null
dn: cn=config
changetype: modify
replace: nsslapd-allow-anonymous-access
nsslapd-allow-anonymous-access: [on/off/rootdse]
EOF
```
#### Apply the LDIF changes.
    ldapmodify -x -D "cn=Directory Manager" -W -H ldap:// -ZZ -f ~/disable_anon_bind.ldif
-x sets simple or anonymous authentication.  
-D sets the bind dn.  
-W prompts for the LDAP admin password.  
-H uses the LDAP Uniform Resource Identifier (URI) to connect rather than the LDAP server host.  
-ZZ starts a TLS request and forces a successful response.  
#### Restart the FreeIPA server.
    sudo systemctl restart ipa.service
#### Verify the modification by anonymously querying the directory
    ldapsearch -x -h $(hostname -f) -b dc=ad,dc=watwizards,dc=org

### Create Users and Groups
FreeIPA defines a user group as a set of users with standard password policies, privileges, and other characteristics.
	A user group can include:
- Users
- Other user groups
- External users which outside of FreeIPA

FreeIPA support 3 groups types:    
- POSIX (default)
- Non-POSIX
- External
#### Adding user group (to specify a different group type, use --nonposix to create a non-POSIX group, --external to create an external group):
    ipa group-add [group name] -[option]
#### Getting a list of all existing user groups:
    Ipa group-find
#### Adding a new user account:
    ipa user-add [usernaqme]
#### Add the new user to the new user group:
    ipa group-add-member groupname --users= username

### Backup and Restore
#### Creating a Backup
A full backup will shutdown all services prior to taking a backup. Take a note of the users that exist on the FreeIPA server.

#### Perform the backup by running:  
- Ipa-backup [OPTION]
- Where the options are:
  - --data
    - Back up data only. The default is to back up all IPA files plus data.
  - --gpg
    - Encrypt the back up file. Set GNUPGHOME environment variable to use a custom keyring and gpg2 configuration.
  - --logs
    - Include the IPA service log files in the backup.
  - --online
    - Perform the backup on-line. Requires the --data option.
  - --disable-role-check
    - Perform the backup even if this host does not have all the roles in use in the cluster. This is not recommended.
  - --v, --verbose
    - Print debugging information
  - -d, --debug
    - Alias for --verbose
  - -q, --quiet
    - Output only errors
  - --log-file=FILE
    - Log to the given file

The backups are by default created in /var/lib/ipa/backup directory. A new directory is created every time when the backup operation is run and it’s name includes the time stamp. Two files will be present, one will be the tar archive and the other will be a small header file. Copy both these files to where you want to perform the restore operation and shutdown the original server.

#### Restoring from backup:
Perform the restore by typing:
- Ipa-restore [OPTION] [Backup directory]ipa
- Where options are:
  - -p, --password=PASSWORD
    - The Directory Manager password.
  - --data
    - Restore the data only. The default is to restore everything in the backup.
  - --no-logs
    - Exclude the IPA service log files in the backup (if they were backed up).
  - --online
    - Perform the restore on-line. Requires data-only backup or the --data option.
  - --instance=INSTANCE
    - Restore only the databases in this 389-ds instance. The default is to restore all found (at most this is the IPA REALM instance and the PKI-IPA instance). Requires data-only backup or the --data option.
  - --backend=BACKEND
    - The backend to restore within an instance or instances. Requires data-only backup or the --data option.
  - --v, --verbose
    - Print debugging information
  - -d, --debug
    - Alias for --verbose
  - -q, --quiet
    - Output only errors
  - --log-file=FILE
    - Log to the given file
- And BACKUP_LOCATION is the location of the backup FILE


































