#
# rpidockers/postgresql Dockerfile
#
 
FROM sdhibit/rpi-raspbian 

RUN apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y postgresql postgresql-client libpq-dev

ENV USERNAME superuser
ENV PASSWORD password

VOLUME /data

EXPOSE 5432

ADD run.sh /bin/

CMD /bin/run.sh
