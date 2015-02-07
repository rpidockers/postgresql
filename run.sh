#!/bin/bash


if [ ! -f /data/conf/postgresql.conf ]; then
    echo 'Initial configuration'

    cp -r /var/lib/postgresql/9.1/main /data/data

    cp -r /etc/postgresql/9.1/main /data/conf
    sed -i 's/\/etc\/postgresql\/9.1\/main/\/data\/conf/g' /data/conf/postgresql.conf
    echo "listen_addresses = '0.0.0.0'" >> /data/conf/postgresql.conf
    echo "host all  all    0.0.0.0/0  md5" >> /data/conf/pg_hba.conf

    chown -R postgres:postgres /data

    echo 'Starting postgres as a background job'
    set -m
    su - postgres -c '/usr/lib/postgresql/9.1/bin/postgres -D /data/conf/' &
    sleep 5

    echo "Creating superuser $USERNAME with password $PASSWORD"
    su - postgres -c 'psql -q' <<EOF
    DROP ROLE IF EXISTS $USERNAME;
    CREATE ROLE $USERNAME WITH ENCRYPTED PASSWORD '$PASSWORD';
    ALTER ROLE $USERNAME WITH SUPERUSER;
    ALTER ROLE $USERNAME WITH LOGIN;
EOF

    echo 'Resuming postgres background job'
    fg %1
else
    su - postgres -c '/usr/lib/postgresql/9.1/bin/postgres -D /data/conf/'
fi

