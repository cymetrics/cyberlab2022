FROM ubuntu:20.04


RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y apache2 && \
    apt-get install -y mariadb-server mariadb-client php php-mysqli \
    php-gd libapache2-mod-php wget git vim zip curl sudo

RUN curl -fsSL https://code-server.dev/install.sh | sh 

WORKDIR /var/www
RUN wget https://github.com/ethicalhack3r/DVWA/archive/master.zip && \
    unzip master.zip && \
    mv html html_old && \
    mv DVWA-master html

WORKDIR /var/www/html/config
RUN mv config.inc.php.dist config.inc.php

WORKDIR /tmp
COPY ./copy/dvwaPage.inc.php /var/www/html/dvwa/includes/dvwaPage.inc.php
COPY ./copy/start.sh start.sh
RUN chmod 755 /var/www/html/dvwa/includes/dvwaPage.inc.php


WORKDIR /etc/apache2
RUN rm ports.conf
COPY ./copy/ports.conf ports.conf

WORKDIR /etc/apache2/sites-available
COPY ./copy/000-default.conf 000-default.conf

WORKDIR /tmp/nginx_naxsi
RUN apt install -y libpcre3-dev libssl-dev unzip \
    build-essential daemon libxml2-dev libxslt1-dev libgd-dev libgeoip-dev && \
    wget http://nginx.org/download/nginx-1.21.6.tar.gz && \
    wget https://github.com/nbs-system/naxsi/archive/refs/tags/1.3.zip -O naxsi-1.3.zip && \
    tar -xvzf nginx-1.21.6.tar.gz && \
    unzip naxsi-1.3.zip

WORKDIR /tmp/nginx_naxsi/nginx-1.21.6
RUN ./configure --with-cc-opt='-g -O2 -fdebug-prefix-map=/build/nginx-RFWPEB/nginx-1.21.6=. -fstack-protector-strong -Wformat -Werror=format-security -fPIC -Wdate-time -D_FORTIFY_SOURCE=2' --with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,-z,now -fPIC' --add-module=../naxsi-1.3/naxsi_src/ --sbin-path=/usr/sbin/nginx --prefix=/usr/share/nginx --conf-path=/etc/nginx/nginx.conf --http-log-path=/var/log/nginx/access.log --error-log-path=/var/log/nginx/error.log --lock-path=/var/lock/nginx.lock --pid-path=/run/nginx.pid --modules-path=/usr/lib/nginx/modules --http-client-body-temp-path=/var/lib/nginx/body --http-fastcgi-temp-path=/var/lib/nginx/fastcgi --http-proxy-temp-path=/var/lib/nginx/proxy --http-scgi-temp-path=/var/lib/nginx/scgi --http-uwsgi-temp-path=/var/lib/nginx/uwsgi --with-debug --with-pcre-jit --with-http_ssl_module --with-http_stub_status_module --with-http_realip_module --with-http_auth_request_module --with-http_v2_module --with-http_dav_module --with-http_slice_module --with-threads --with-http_addition_module --with-http_geoip_module=dynamic --with-http_gunzip_module --with-http_gzip_static_module --with-http_image_filter_module=dynamic --with-http_sub_module --with-http_xslt_module=dynamic --with-stream=dynamic --with-stream_ssl_module --with-stream_ssl_preread_module --with-mail=dynamic --with-mail_ssl_module && \
    make && make install && make clean && \
    mkdir /var/lib/nginx/ && \
    mkdir /var/lib/nginx/body

# change nginx setting

WORKDIR /etc/nginx
RUN cp /tmp/nginx_naxsi/naxsi-1.3/naxsi_config/naxsi_core.rules /etc/nginx/naxsi_core.rules
COPY ./copy/nginx.conf nginx.conf
COPY ./copy/naxsi.rules naxsi.rules
COPY ./copy/error.html /var/www/html/

WORKDIR /tmp
CMD ["sh", "start.sh"]
