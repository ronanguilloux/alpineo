FROM alpine:edge
MAINTAINER Ronan Guilloux <ronan.guilloux@gmail.com>

# Environments
ENV TIMEZONE Europe/Paris


RUN	echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk update && \
	apk upgrade && \
	apk add --update tzdata && \
	cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
	echo "${TIMEZONE}" > /etc/timezone
RUN	apk add --update \
	php7 apache2 php7-apache2 mysql mysql-client supervisor \
    php7-apcu php7-mysqli php7-xml php7-zip \
    php7-curl php7-intl php7-mbstring php7-iconv php7-gd php7-mcrypt

    # Cleaning up
RUN apk del tzdata && \
	rm -rf /var/cache/apk/*

RUN sed -i "s/;date.timezone =/date.timezone = Europe\/Paris/" /etc/php7/php.ini && \
    sed -i "s/memory_limit = .*/memory_limit = 2G/" /etc/php7/php.ini

RUN addgroup docker && \
    adduser -s /bin/sh -S -h /home/docker -G docker docker && \
    echo 'docker:secret' | chpasswd

RUN echo 'ServerName alpineo' >> /etc/apache2/httpd.conf

RUN mysql_install_db --user=mysql && \
    mkdir /run/apache2/

EXPOSE 22 80 3306

WORKDIR /home/docker/

ADD docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["supervisord", "--nodaemon", "--configuration", "/etc/supervisor/conf.d/supervisord.conf"]