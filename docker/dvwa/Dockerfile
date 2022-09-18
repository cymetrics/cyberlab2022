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

CMD ["sh", "start.sh"]
