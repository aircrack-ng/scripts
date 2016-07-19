#!/bin/sh

if [ -z "$2" ]; then
	echo "Missing parameters."
	echo "$0 <LOCAL_DIR> <URL_TO_SYNC>"
	exit 0
fi

# Create repo
svnadmin create $1

# Copy UUID from other
REPO_UUID=$(svn info $2 2>/dev/null | grep UUID | awk '{print $3}')
if [ -z "${REPO_UUID}" ]; then
	echo "Can't get UUID from remote repo, is it up?"
	exit 1
fi
svnadmin setuuid $1 ${REPO_UUID}

# Prepare for sync
echo '#!/bin/bash' > $1/hooks/pre-revprop-change
chmod +x $1/hooks/pre-revprop-change

# Sync
svnsync init file://${PWD}/$1 $2
svnsync sync file://${PWD}/$1

# Set permission
chown -R www-data.www-data $1

echo DONE
