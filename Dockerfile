FROM php:7.4-fpm

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y nano vim curl git acl zip gnupg cron

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
    
RUN set -x \
    && apt-get install -y zlib1g-dev libicu-dev g++ \
    && docker-php-ext-install intl

RUN set -x \
    && apt-get install -y libpng-dev libmcrypt-dev libxslt-dev

RUN set -x \
    && docker-php-ext-install xsl pdo_mysql soap mysqli
    
RUN set -x && \
    apt-get install -y libfreetype6-dev libjpeg62-turbo-dev

RUN set -x && \
    pecl install xdebug && \
    docker-php-ext-enable xdebug

RUN apt-get update \
    && apt-get install -y --no-install-recommends libmagickwand-dev

RUN set -x && \
    pecl install imagick && \
    docker-php-ext-enable imagick

RUN set -x \
    && docker-php-ext-install pcntl

RUN set -x \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');"

RUN curl -sL https://deb.nodesource.com/setup_12.x -o nodesource_setup.sh && \
    bash nodesource_setup.sh && \ 
    apt-get -y --force-yes install nodejs && \
    npm install n -g
    
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt install yarn        
    
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp
