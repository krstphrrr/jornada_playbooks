## Backing up a PG database per schema

- `dump_schema.sh` will dump an entire schema (tables and table data) within a compressed tar file, along with users/roles and views as separate sql files. 

- Usage:
```sh
./dump_schema.sh schemaname
```

- Requires `.env` file in the same directory as `dump_schema.sh`:
```bash
SCHEMA_NAME="schemaname"
DB_NAME="dbname"
DB_USER="username"
DB_PORT="port"
DB_HOST="host"
DB_PASSWORD="pw"
```

## Ansible playbook

- replace schemaname and paths on the `organized_pgbackups.yml`

- command to manually run playbook:
```sh
ansible-playbook -v -i ~/j-playbooks-main/inventory/hosts.ini -ask-become-pass ~/j-playbooks-main/playbooks/organized_pgbackups.yml --extra-vars "schema_name=your_schema_name backup_dir_base=/path/to/backup/directory"
```

- end result is a `schemaname_backup_timestamp.tar.gz` 


# todo

- shell script to supply to cronjob 
- multiple script runs; one for each schema to back up
- restore logic
