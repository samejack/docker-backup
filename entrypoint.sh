#!/usr/bin/env bash

# default
if [ ! "${TZ}" ]; then TZ='UTC'; fi
if [ ! "${JOB_SCHEDULE}" ]; then JOB_SCHEDULE='27 4 * * *'; fi
if [ ! "${BACKUP_PATH}" ]; then BACKUP_PATH='/mnt/backup'; fi
if [ ! "${FILE_BACKUP_ENABLED}" ]; then FILE_BACKUP_ENABLED='no'; fi
if [ ! "${MYSQL_BACKUP_ENABLED}" ]; then MYSQL_BACKUP_ENABLED='no'; fi


# setup time zone
echo "TIME_ZONE=${TZ}"
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

if [ ! -d ${BACKUP_PATH} ]; then
    mkdir -p "${BACKUP_PATH}"
fi

# make link to custom location of /etc/cron.d if provided
if [ "${CRON_PATH}" ]; then
    rm -rf /etc/cron.d
    ln -sfTv "${CRON_PATH}" /etc/cron.d
fi

echo "${JOB_SCHEDULE} root /usr/bin/backup.sh" > /etc/cron.d/backup
chmod +x /etc/cron.d/backup

# remove write permission for (g)roup and (o)ther (required by cron)
chmod -R go-w /etc/cron.d

# setting user for additional cron jobs
case $1 in
-u=*|--user=*)
    crontab_user="-u ${1#*=}"
    shift
    ;;
-u|--user)
    crontab_user="-u $2"
    shift 2
    ;;
-*)
    echo "Unknown option: ${1%=*}" > /dev/stderr
    exit 1
    ;;
*)
    crontab_user=""
    ;;
esac

# adding additional cron jobs passed by arguments
# every job must be a single quoted string and have standard crontab format,
# e.g.: start-cron --user user "0 \* \* \* \* env >> /var/log/cron.log 2>&1"
{ for cron_job in "$@"; do echo -e ${cron_job}; done } \
    | sed --regexp-extended 's/\\(.)/\1/g' \
    | crontab ${crontab_user} -

# update default values of PAM environment variables (used by CRON scripts)
env | while read -r line; do  # read STDIN by line
    # split LINE by "="
    IFS="=" read var val <<< ${line}
    # remove existing definition of environment variable, ignoring exit code
    sed --in-place "/^${var}[[:blank:]=]/d" /etc/security/pam_env.conf || true
    # append new default value of environment variable
    echo "${var} DEFAULT=\"${val}\"" >> /etc/security/pam_env.conf
done

# start cron
service cron start

# trap SIGINT and SIGTERM signals and gracefully exit
trap "service cron stop; kill \$!; exit" SIGINT SIGTERM

# start "daemon"
while true
do
    # watch /var/log/cron.log restarting if necessary
    cat /var/log/cron.log & wait $!
done
