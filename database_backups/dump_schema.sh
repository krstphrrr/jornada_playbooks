#!/bin/bash

# Load environment variables from .env
if [ -f .env ]; then
    export $(cat .env | xargs)
else
    echo "error: .env file not found."
    exit 1
fi

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <schema_name>"
    exit 1
fi

SCHEMA_NAME=$1
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="${SCHEMA_NAME}_backup_${TIMESTAMP}"
DUMP_FILE="${SCHEMA_NAME}_dump.sql"
VIEW_FILE="${SCHEMA_NAME}_views.sql"
COMPRESSED_FILE="${DUMP_FILE}.gz"

# Create backup directory
mkdir -p $BACKUP_DIR

# Dump all roles and user data
echo "dumping all roles and user data..."
pg_dumpall --roles-only --username=$DB_USER --host=$DB_HOST --port=$DB_PORT --file="${BACKUP_DIR}/roles.sql"

if [ $? -ne 0 ]; then
    echo "failed to dump roles and user data."
    exit 1
fi

# dump schema and data for the specified schema
echo "dumping schema '${SCHEMA_NAME}'..."
pg_dump --username=$DB_USER --host=$DB_HOST --port=$DB_PORT --schema=$SCHEMA_NAME --format=plain --file="${BACKUP_DIR}/${DUMP_FILE}" $DB_NAME

if [ $? -ne 0 ]; then
    echo "Failed to dump schema '${SCHEMA_NAME}'."
    exit 1
fi

# Compress the dump file
echo "compressing dump file..."
gzip -f "${BACKUP_DIR}/${DUMP_FILE}"

# Extract all views in the schema
echo "extracting views for schema '${SCHEMA_NAME}'..."
psql --username=$DB_USER --host=$DB_HOST --port=$DB_PORT --dbname=$DB_NAME --tuples-only --quiet --command="
SELECT 'CREATE OR REPLACE VIEW ' || table_schema || '.' || table_name || ' AS ' || pg_get_viewdef(format('%I.%I', table_schema, table_name), true) || ';'
FROM information_schema.views
WHERE table_schema = '${SCHEMA_NAME}';" > "${BACKUP_DIR}/${VIEW_FILE}"

if [ $? -ne 0 ]; then
    echo "failed to extract views for schema '${SCHEMA_NAME}'."
    exit 1
fi

echo "backup completed. files saved in '${BACKUP_DIR}'."