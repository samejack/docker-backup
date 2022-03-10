#!/bin/sh

if ! [ ${MONGO_BACKUP_ENABLED} = yes ] ; then
  echo 'MongoDB backup job not enabled.'
  exit
fi


# Definded Dump Configuartion
rollingDays=7
dumpFilename="mongodb"
dumpTmpDir="/tmp/mongo-dump-tmp"
backupPath="/data/backup/mongodb"
username="admin"
password=""
hostname="localhost"
database="mydb"

#Start Dumpping.......
today=`date "+%Y-%m-%d"`
echo "Today: ${today}"
echo "Start Dumpping......."

# Make backup directory
if ! [ -d "${backupPath}" ] ; then
    echo "make dir : ${backupPath}"
    mkdir -p "${backupPath}"
fi
if ! [ -d "${dumpTmpDir}" ] ; then
    echo "make dir : ${dumpTmpDir}"
    mkdir -p "${dumpTmpDir}"
fi

# Make parameter
dn="-h ${hostname}"
if [ "${username}" != "" ] && [ "${password}" != "" ] ; then
    dn="${dn} -u ${username} -p ${password}"
fi
if [ "${database}" != "" ] ; then
    dn="${dn} -d ${database}"
fi

# Run script
rm -rf -R ${dumpTmpDir}
command="mongodump ${dn} -o ${dumpTmpDir}"
echo $command
$command
if [ $? == 0 ] ; then
    cd "${dumpTmpDir}"
    /bin/tar -zcvf "${backupPath}/${dumpFilename}-${today}.tar.gz" *
    find ${backupPath}/${dumpFilename}-* -mtime +${rollingDays} -exec rm -f {} \;
fi
rm -rf -R ${dumpTmpDir}

dropbox_uploader.sh -f /root/.dropbox_uploader delete /${dumpfile}.tar.gz
dropbox_uploader.sh -f /root/.dropbox_uploader upload "${backupPath}/${dumpFilename}-${today}.tar.gz" /${dumpFilename}.tar.gz

