#!/bin/bash
  
echo 'Files backup job...'

#Set dump information
BACKUP_NAME="files"
ROLL_DAY=${FILE_BACKUP_ROLL_DAY}
TODAY=`date "+%Y-%m-%d"`
BACKUP_SRC_PATH="${FILE_PATH}"
STORE_PATH="${BACKUP_PATH}/${BACKUP_NAME}"

if [ "${ROLL_DAY}" = "" ] ; then ROLL_DAY=14; fi

#Start Dumpping.......
echo "Today: ${TODAY}"
echo "Start Dumpping......."

#make dest directory
if ! [ -d "$STORE_PATH" ] ; then
    echo "Make dir : $STORE_PATH"
    mkdir -p $STORE_PATH
fi

cd ${BACKUP_SRC_PATH}
TARGET_FILE="${STORE_PATH}/${BACKUP_NAME}-${TODAY}.tar.gz"
/bin/tar -zcvf "${TARGET_FILE}" "./" > /dev/null

echo "Remove old file"
rm -rf `find ${STORE_PATH}/ -mtime +${ROLL_DAY} | xargs`

