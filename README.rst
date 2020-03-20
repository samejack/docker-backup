.. image:: https://img.shields.io/badge/license-APACHE-blue.svg
   :target: http://www.apache.org/licenses/LICENSE-2.0

.. image:: https://travis-ci.org/samejack/docker-backup.svg?branch=master
   :target: https://travis-ci.org/samejack/docker-backup

.. image:: https://img.shields.io/docker/build/samejack/docker-backup.svg
   :target: https://hub.docker.com/r/samejack/docker-backup/

docker-backup
=============

Backup docker image. Can be backup batabase, files, postgresql(TODO),
elasticsearch(TODO), mongodb(TODO).

===================== ============= =======================
Environment           Default       Description
===================== ============= =======================
TZ                    UTC           Time Zone
JOB_SCHEDULE          27 4 \* \* \* Schedule of crond
BACKUP_PATH           /mnt/backup   Backup path
FILE_BACKUP_ENABLED   no            Files backup enable
FILE_BACKUP_ROLL_DAY  14            Fiil backup roll days
FILE_PATH             /home         Backup file source path
MYSQL_BACKUP_ENABLED  no            Mysql backup enable
MYSQL_BACKUP_ROLL_DAY 14            Mysql backup roll days
MYSQL_USER                          Mysql login username
MYSQL_PASSWORD                      Mysql login password
MYSQL_HOST            mysql         Mysql host
MYSQL_PORT            3306          Mysql post
===================== ============= =======================

How to build docker image
-------------------------

git clone and make

::

   make

or get from Docker Hub

::

   docker pull samejack/backup

.. |License| image:: https://poser.pugx.org/samejack/php-argv/license
   :target: https://packagist.org/packages/samejack/php-argv
