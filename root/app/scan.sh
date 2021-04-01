#!/usr/bin/env bash
#!/usr/bin/with-contenv bash
set -e
if [ $# -ne 2 ]; then
  echo "Usage $0 [user@]hostname remote_path"
  exit 1
fi
HOST="${1}"
if [[ "${HOST}" == *"@"* ]]; then
  HOSTONLY="$(echo ${HOST}|awk -F'@' '{print $2}')"
else
  HOSTONLY="${HOST}"
fi
REMOTE_PATH="${2}"
echo "Mounting sshfs"
mkdir -p /scan/"${HOSTONLY}"
sshfs -o ro,allow_other -o StrictHostKeyChecking=no "${HOST}:${REMOTE_PATH}" /scan/"${HOSTONLY}"
echo "Starting scan"
/app/diskover/diskover.py -d /scan/"${HOSTONLY}" -i diskover-"${HOSTONLY}" -F
umount /scan/"${HOSTONLY}"
