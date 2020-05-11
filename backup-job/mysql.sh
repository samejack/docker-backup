#!/bin/bash
  
echo 'MySQL backup job...'

#Set dump information
ROLL_DAY=${MYSQL_BACKUP_ROLL_DAY}
BACKUP_NAME="mysql"
TODAY=`date "+%Y-%m-%d"`
DUMP_FILENAME="mysql"
if [ "${PROJECT_NAME}" != "" ] ; then
  DUMP_FILENAME="${PROJECT_NAME}_${DUMP_FILENAME}"
fi
STORE_PATH="${BACKUP_PATH}/${BACKUP_NAME}"
DUMP_FILE="${STORE_PATH}/${DUMP_FILENAME}-${TODAY}.sql"
TAR_FILE="${STORE_PATH}/${DUMP_FILENAME}-${TODAY}.tar.gz"

if [ "${ROLL_DAY}" = "" ] ; then ROLL_DAY=14; fi
if [ "${MYSQL_PORT}" = "" ] ; then MYSQL_PORT=3306; fi
if [ "${MYSQL_HOST}" = "" ] ; then MYSQL_HOST="mysql"; fi

#Start Dumpping.......
echo "Today: ${TODAY}"
echo "Start Dumpping......."

#make dest directory
if ! [ -d "${STORE_PATH}" ] ; then
    echo "make dir : ${STORE_PATH}"
    mkdir -p ${STORE_PATH}
fi

if [ "${MYSQL_DATABASE}" = "" ] ; then
  DATABASE_PARAM='--all-databases'
else
  DATABASE_PARAM="-B ${MYSQL_DATABASE}"
fi

mysqldump --user=${MYSQL_USER} -p"${MYSQL_PASSWORD}" -h ${MYSQL_HOST} -P ${MYSQL_PORT} ${DATABASE_PARAM} > ${DUMP_FILE}
/bin/tar -zcvf "${TAR_FILE}" ${DUMP_FILE}
rm -rf ${DUMP_FILE}

# Upload to AWS S3
if [ ${AWS_S3_UPLOAD_ENABLED} = yes ] ; then
  /usr/local/bin/aws s3 cp ${TAR_FILE} s3://${AWS_S3_BUCKET}${AWS_S3_OBJECT_PREFIX}/${DUMP_FILENAME}.tar.gz
fi

echo "Remove old file"
rm -rf `find ${STORE_PATH}/ -mtime +${ROLL_DAY} | xargs`

