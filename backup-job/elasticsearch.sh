#!/bin/bash

if ! [ ${ELASTICSEARCH_BACKUP_ENABLED} = yes ] ; then
  echo 'ElasticSearch backup job not enabled.'
  exit
fi


PREFIX=${ENV_PROJECT}
CEPH_BACKUP=${ENV_ENABLE_REMOTE_BACKUP}
ELASTICSEARCH_HOST=${ENV_ELASTICSEARCH_HOST}
TUNNEL_HOST=${ENV_TUNNEL_HOST}
INDICES=( ${ENV_INDICES} )
DATE=`date +%F`

for i in "${INDICES[@]}"
do
  # index mapping
  /usr/local/bin/elasticdump \
  --input=http://${ELASTICSEARCH_HOST}:9200/${i} \
  --output=/backup_data/elasticsearch/${PREFIX}_${i}_mapping_${DATE}.json \
  --type=mapping

  # index data
  /usr/local/bin/elasticdump \
  --input=http://${ELASTICSEARCH_HOST}:9200/${i} \
  --output=/backup_data/elasticsearch/${PREFIX}_${i}_data_${DATE}.json \
  --type=data
done

### Check if the CEPH backup is enabled
if [ $CEPH_BACKUP = "1" ]
then
  ### Check CEPH if it is avaliable
  nc -z -w3 ${TUNNEL_HOST} 22 ; RETVAL=$?
  if [ "$RETVAL" = "0" ]
  then
    ssh -L *:7480:192.168.20.18:7480 -Nf idsbg@${TUNNEL_HOST}
    TUNNELID=`pgrep -f "7480 -Nf"`

    ### Compress all dump json file to gz (you can see the contents of gz files)
    ### and duplicate one copy to CEPH storage (if CEPH is available)
    find /backup_data/elasticsearch/ -type f -name *_${DATE}.json | xargs gzip
    # s3cmd put /backup_data/elasticsearch/*_${DATE}.*.gz s3://services-backup
    /usr/local/bin/s3cmd -c /opt/scripts/S3_Config put /backup_data/elasticsearch/*_${DATE}.*.gz s3://services-backup
    kill -4 ${TUNNELID}
  else
    find /backup_data/elasticsearch/ -type f -name *_${DATE}.json | xargs gzip
  fi
fi

