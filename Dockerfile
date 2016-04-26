FROM debian:jessie

ENV version 1.0.2

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install apache2 libapache2-mod-php5 php5 php5-common php5-gd php5-mcrypt php5-xsl php5-xmlrpc php5-xdebug php5-tidy php5-sqlite php5-apcu php5-mysqlnd php5-imagick php5-curl git && \
    a2enmod rewrite && \
    php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php && \
    php -r "if (hash_file('SHA384', 'composer-setup.php') === '7228c001f88bee97506740ef0888240bd8a760b046ee16db8f4095c0d8d525f2367663f22a46b48d072c816e7fe19959') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php --version=${version} && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer && \
    apt-get purge -y && \
    apt-get clean && \
    rm -rf /var/www/html

EXPOSE 80
ADD start.sh /start.sh
RUN chmod 0755 /start.sh
CMD ["bash", "start.sh"]
