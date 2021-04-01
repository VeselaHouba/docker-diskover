#!/usr/bin/with-contenv bash
set -e
if [ $# -ne 2 ]; then
  echo "Usage $0 hostname remote_path"
  exit 1
fi
HOST="${1}"
REMOTE_PATH="${2}"
echo "Mounting sshfs"
mkdir -p /scan/"${HOST}"
sshfs -o ro,allow_other -o StrictHostKeyChecking=no "${HOST}:${REMOTE_PATH}" /scan/"${HOST}"
echo "Starting scan"
/app/diskover/diskover.py -d /scan/"${HOST}" -i diskover-"${HOST}" -F
