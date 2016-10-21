FROM tutum/lamp

RUN apt-get update && apt-get install -y \
		curl \
        git \
        nano \
        less \
        imagemagick \
        apache2 \
        php5-dev \
        php5-cli \
        php5-fpm \
        php5-mysql \
		php5-xdebug \
		php5-curl \
		php5-gd \
		php5-mcrypt \
		php5-imagick \
		libapache2-mod-php5 \
		mcrypt \
		phpunit \
		pkg-config \
		libmagickwand-dev \
		libmagickcore-dev


RUN sed -i '1 a xdebug.remote_autostart=true' /etc/php5/apache2/conf.d/20-xdebug.ini
RUN sed -i '1 a xdebug.remote_mode=req' /etc/php5/apache2/conf.d/20-xdebug.ini
RUN sed -i '1 a xdebug.remote_handler=dbgp' /etc/php5/apache2/conf.d/20-xdebug.ini
RUN sed -i '1 a xdebug.remote_connect_back=1 ' /etc/php5/apache2/conf.d/20-xdebug.ini
RUN sed -i '1 a xdebug.remote_port=9000' /etc/php5/apache2/conf.d/20-xdebug.ini
RUN sed -i '1 a xdebug.remote_host=127.0.0.1' /etc/php5/apache2/conf.d/20-xdebug.ini
RUN sed -i '1 a xdebug.remote_enable=1' /etc/php5/apache2/conf.d/20-xdebug.ini
RUN sed -i '1 a xdebug.idekey=netbeans-xdebug' /etc/php5/apache2/conf.d/20-xdebug.ini

RUN curl -o /usr/bin/original_wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x /usr/bin/original_wp
RUN echo "/usr/bin/original_wp --allow-root \"\$@\"" > /usr/bin/wp
RUN chmod +x /usr/bin/wp

RUN echo "error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT & ~E_NOTICE" > /etc/php5/cli/conf.d/myerrorconf.ini

RUN curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

RUN php5enmod mcrypt

RUN alias wp='wp --allow-root'

COPY createwp /usr/bin/createwp
RUN chmod +x /usr/bin/createwp

RUN mkdir /dump
RUN chmod 777 -R /dump
RUN chmod 777 -R /var/www/html

ENV TERM xterm


WORKDIR /var/www/html/
