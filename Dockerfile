FROM debian:latest

RUN set -ex \
    && apt-get clean && apt-get update \
    && apt-get install -y cron \
    && rm -rf /var/lib/apt/lists/* \
    && mkfifo --mode 0666 /var/log/cron.log \
    && sed --regexp-extended --in-place \
    's/^session\s+required\s+pam_loginuid.so$/session optional pam_loginuid.so/' \
    /etc/pam.d/cron


# MySQL Client:
ARG INSTALL_MYSQL_CLIENT=true
RUN if [ ${INSTALL_MYSQL_CLIENT} = true ]; then \
    apt-get update -yqq && \
    apt-get -y install default-mysql-client \
;fi

# PostgreSQL Client:
ARG INSTALL_PGSQL_CLIENT=true
RUN if [ ${INSTALL_PGSQL_CLIENT} = true ]; then \
    apt-get update -yqq && \
    apt-get -y install postgresql-client \
;fi

COPY entrypoint.sh /usr/sbin

ADD backup-job /etc/backup-job
ADD backup.sh /usr/bin

CMD ["entrypoint.sh"]
