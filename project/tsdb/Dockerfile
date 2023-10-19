FROM postgres:15

RUN apt update && \
    apt install -y gnupg postgresql-common apt-transport-https lsb-release wget && \
    /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh -v 15 -y && \
    echo "deb https://packagecloud.io/timescale/timescaledb/debian/ $(lsb_release -c -s) main" | tee /etc/apt/sources.list.d/timescaledb.list  && \
    wget --quiet -O - https://packagecloud.io/timescale/timescaledb/gpgkey | apt-key add -  && \
    apt update  && \
    apt install -y timescaledb-2-postgresql-15 && \
    cp /usr/share/postgresql/postgresql.conf.sample /etc/postgresql/postgresql.conf && \
    timescaledb-tune --quiet --yes --conf-path /etc/postgresql/postgresql.conf

CMD [ "--config_file=/etc/postgresql/postgresql.conf" ]


