#!/bin/bash
  
echo 'MySQL backup job...'

#Set dump information
ROLL_DAY=${MYSQL_BACKUP_ROLL_DAY}
BACKUP_NAME="mysql"
TODAY=`date "+%Y-%m-%d"`
DUMP_FILENAME="mysql"
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

mysqldump --user=${MYSQL_USER} -p"${MYSQL_PASSWORD}" -h ${MYSQL_HOST} -P ${MYSQL_PORT} --all-databases > ${DUMP_FILE}
/bin/tar -zcvf "${TAR_FILE}" ${DUMP_FILE}
rm -rf ${DUMP_FILE}

echo "Remove old file"
rm -rf `find ${STORE_PATH}/ -mtime +${ROLL_DAY} | xargs`

