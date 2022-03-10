#!/bin/sh

if ! [ ${PGSQL_BACKUP_ENABLED} = yes ] ; then
  echo 'ElasticSearch backup job not enabled.'
  exit
fi


#Set dump information
filecont=10
today=`date "+%Y-%m-%d"`
olddate=`date -d "-$filecont day" "+%Y-%m-%d"`
dumpfile="pgsql-sql"
dumpsource="/tmp/postgresql-backup.sql"
dumppath="/data/backup/${dumpfile}/"

username="postgres"
password=""

#Start Dumpping.......
echo "Today: ${today}"
echo "Start Dumpping......."

#make dest directory
if ! [ -d "$dumppath" ] ; then
        echo "make dir : $dumppath"
        mkdir $dumppath
fi

export PGPASSWORD="${password}"
pg_dumpall -h localhost --username=postgres -f ${dumpsource}
/bin/tar -zcvf ${dumppath}${dumpfile}-${today}.tar.gz ${dumpsource}
rm -rf ${dumpsource}
unset PGPASSWORD
rm -rf ${dumppath}${dumpfile}-$olddate.tar.gz

dropbox_uploader.sh -f /root/.dropbox_uploader delete /${dumpfile}/${dumpfile}-${olddate}.tar.gz
dropbox_uploader.sh -f /root/.dropbox_uploader upload ${dumppath}${dumpfile}-${today}.tar.gz /${dumpfile}/${dumpfile}-${today}.tar.gz
