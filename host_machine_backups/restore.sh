#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 3 ]; then
  echo "Usage: $0 /path/to/backup.tar.gz /path/to/restore/directory hostname1,hostname2,..."
  exit 1
fi

# Path to the backup tar file
BACKUP_FILE="$1"

# Destination directory for extraction
DEST_DIR="$2"

# Comma-separated list of hostnames
HOSTNAMES="$3"

# Lookup table mapping hostnames to directories
declare -A HOSTNAME_TO_DIR=(
  ["jornada-geosvr"]="192-168-177-76_jornada-geosvr"
  ["jornada-ldcdb2"]="192-168-177-189_jornada-ldcdb2"
  ["jornada-wind"]="192-168-177-141_jornada-wind"
  ["jornada-dust"]="192-168-177-142_jornada-dust"
  ["jornada-fire"]="192-168-177-143_jornada-fire"
  ["jornada-vision"]="192-168-177-144_jornada-vision"
  ["jornada-dln"]="192-168-177-145_jornada-dln"
  ["jornada-edit"]="192-168-177-146_jornada-edit"
  ["jornada-photos"]="192-168-177-147_jornada-photos"
  ["jornada-rma"]="192-168-177-148_jornada-rma"
  ["jornada-ans"]="192-168-177-149_jornada-ans"
  ["jornada-web"]="192-168-177-153_jornada-web"
  ["jornada-ldc"]="192-168-177-154_jornada-ldc"
  ["jornada-ldcdb"]="192-168-177-155_jornada-ldcdb"
  ["jornada-ltb"]="192-168-177-156_jornada-ltb"
  ["jornada-learn"]="192-168-177-157_jornada-learn"
  ["jornada-aim"]="192-168-177-158_jornada-aim"
  ["jornada-apps"]="192-168-177-159_jornada-apps"
  ["jornada-time"]="192-168-177-173_jornada-time"
  ["jornada-runr"]="192-168-177-174_jornada-runr"
  ["jornada-rap"]="192-168-177-175_jornada-rap"
  ["jornada-cow"]="192-168-177-176_jornada-cow"
  ["jornada-sa"]="192-168-177-177_jornada-sa"
  ["jornada-smtp"]="192-168-177-178_jornada-smtp"
  ["jornada-go"]="192-168-177-179_jornada-go"
  ["jornada-airflw"]="192-168-177-180_jornada-airflw"
  ["jornada-ldc2"]="192-168-177-184_jornada-ldc2"
  ["jornada-pgbnc2"]="192-168-177-188_jornada-pgbnc2"
  ["jornada-pgfo"]="192-168-177-190_jornada-pgfo"
  ["jornada-agriskdb"]="192-168-177-191_jornada-agriskdb"
  ["jornada-logs"]="192-168-177-192_jornada-logs"
  ["jornada-swch"]="192-168-177-193_jornada-swch"
  ["jornada-main"]="192-168-177-196_jornada-main"
  ["jornada-nfs"]="192-168-177-197_jornada-nfs"
  ["jornada-pgbnc"]="192-168-177-216_jornada-pgbnc"
  ["jornada-wsc"]="192-168-177-217_jornada-wsc"
  ["jornada-pheno"]="192-168-177-247_jornada-pheno"
  ["jornada-uptime"]="192-168-177-31_jornada-uptime"
  ["jornada-ldcdb3"]="192-168-177-32_jornada-ldcdb3"
  ["jornada-dirt"]="192-168-177-77_jornada-dirt"
)

# Convert comma-separated list of hostnames to an array
IFS=',' read -r -a HOSTNAME_ARRAY <<< "$HOSTNAMES"

# Extract specific directories from the tar file
for HOSTNAME in "${HOSTNAME_ARRAY[@]}"; do
  DIR="${HOSTNAME_TO_DIR[$HOSTNAME]}"
  if [ -n "$DIR" ]; then
    tar -xzf "$BACKUP_FILE" -C "$DEST_DIR" "$DIR"
  else
    echo "Warning: No directory mapping found for hostname '$HOSTNAME'"
  fi
done

echo "Extraction complete."