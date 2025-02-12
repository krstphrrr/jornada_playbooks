## Backup logic on ansible host machine

- Edited crontab with the following
```cron
0 1 * * * /home/elrey/j-playbook-main/run_backup.sh
```
- The backup script (ansible config should already reference the creds for become-less playbook runs)
```sh
#!/bin/bash

ANSIBLE_VAULT_PASSWORD_FILE="~/j-playbooks-main/vp.txt"
BECOME_PASSWORD_FILE="~/j-playbooks-main/v.yml"

/usr/bin/ansible-playbook -i ~/j-playbooks-main/inventory/hosts.ini ~/j-playbooks-main/playbooks/organized_backups.yml
```
- End result of running the `organized_backups.yml` is a `date-stamped_backup.tar.gz` file

## Restore logic on any machine provided user has a backup tar file produced by the previous step

`restore.sh` is made to extract specific directories (hostmachines) from the backup tar file

1. Making restore script executable
```sh
chmod +x restore.sh
```

2. Running the script with the required arguments
```sh
./restore.sh /path/to/backup.tar.gz /path/to/restore/directory jornada-geosvr,jornada-ldcdb2
```