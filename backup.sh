#!/bin/bash

if [ ${MYSQL_BACKUP_ENABLED} = yes ] ; then /etc/backup-job/mysql.sh; fi
if [ ${FILE_BACKUP_ENABLED} = yes ] ; then /etc/backup-job/file.sh; fi
