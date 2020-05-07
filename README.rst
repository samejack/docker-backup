.. image:: https://img.shields.io/badge/license-APACHE-blue.svg
   :target: http://www.apache.org/licenses/LICENSE-2.0

.. image:: https://travis-ci.org/samejack/docker-backup.svg?branch=master
   :target: https://travis-ci.org/samejack/docker-backup

.. image:: https://img.shields.io/docker/build/samejack/backup.svg
   :target: https://hub.docker.com/r/samejack/backup/

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
PROJECT_NAME                        Project name (backup file prefix)
FILE_BACKUP_ENABLED   no            Files backup enable
FILE_BACKUP_ROLL_DAY  14            Fiil backup roll days
FILE_PATH             /backup-files Backup file source path
MYSQL_BACKUP_ENABLED  no            Mysql backup enable
MYSQL_BACKUP_ROLL_DAY 14            Mysql backup roll days
MYSQL_USER                          Mysql login username
MYSQL_PASSWORD                      Mysql login password
MYSQL_HOST            mysql         Mysql host
MYSQL_PORT            3306          Mysql post
MYSQL_DATABASE        default       (Optional) Backup all databases if not setup
AWS_ACCESS_KEY_ID                   AWS IAM access key
AWS_SECRET_ACCESS_KEY               AWS IAM secret key
AWS_S3_UPLOAD_ENABLED no            Auto upload to S3 enable
AWS_S3_BUCKET                       S3 bucket name
AWS_S3_OBJECT_PREFIX                S3 object prefix path (start with /)
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
