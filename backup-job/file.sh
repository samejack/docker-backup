#!/bin/bash
  
echo 'Files backup job...'

#Set dump information
BACKUP_NAME="files"
if [ "${PROJECT_NAME}" != "" ] ; then
  BACKUP_NAME="${PROJECT_NAME}_${BACKUP_NAME}"
fi
ROLL_DAY=${FILE_BACKUP_ROLL_DAY}
TODAY=`date "+%Y-%m-%d"`
BACKUP_SRC_PATH="${FILE_PATH}"
STORE_PATH="${BACKUP_PATH}/${BACKUP_NAME}"

if [ "${ROLL_DAY}" = "" ] ; then ROLL_DAY=14; fi
if [ "${BACKUP_SRC_PATH}" = "" ] ; then BACKUP_SRC_PATH="backup-files"; fi

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

# Upload to AWS S3
if [ ${AWS_S3_UPLOAD_ENABLED} = yes ] ; then
  /usr/local/bin/aws s3 cp ${TARGET_FILE} s3://${AWS_S3_BUCKET}${AWS_S3_OBJECT_PREFIX}/${TODAY}_${BACKUP_NAME}.tar.gz
fi

echo "Remove old file"
rm -rf `find ${STORE_PATH}/ -mtime +${ROLL_DAY} | xargs`

