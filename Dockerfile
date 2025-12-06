# ==============================================
# BASE IMAGE
# ==============================================
FROM php:8.2-apache

# ==============================================
# SYSTEM DEPENDENCIES
# ==============================================
RUN apt-get update && apt-get clean && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libicu-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# ==============================================
# PHP EXTENSIONS
# ==============================================
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        gd \
        mysqli \
        pdo \
        pdo_mysql \
        intl \
        zip \
        opcache

# ==============================================
# ENABLE APACHE MODULES
# ==============================================
RUN a2enmod rewrite headers ssl expires

# ==============================================
# COMPOSER INSTALLATION
# ==============================================
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# ==============================================
# WORKDIR
# ==============================================
WORKDIR /var/www/html

# ==============================================
# COPY APPLICATION FILES
# ==============================================
COPY . /var/www/html

# ==============================================
# SET PERMISSIONS FOR COMMON DIRECTORIES
# ==============================================
RUN mkdir -p logs \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 755 logs || true

# ==============================================
# PHP CONFIGURATION
# ==============================================
RUN echo "display_errors = Off" >> /usr/local/etc/php/conf.d/custom.ini \
    && echo "upload_max_filesize = 64M" >> /usr/local/etc/php/conf.d/custom.ini \
    && echo "post_max_size = 64M" >> /usr/local/etc/php/conf.d/custom.ini \
    && echo "memory_limit = 512M" >> /usr/local/etc/php/conf.d/custom.ini \
    && echo "max_execution_time = 180" >> /usr/local/etc/php/conf.d/custom.ini \
    && echo "date.timezone = UTC" >> /usr/local/etc/php/conf.d/custom.ini
   
# ==============================================
# OPCACHE OPTIMIZATION (FOR PRODUCTION)
# ==============================================
RUN echo "opcache.enable=1" >> /usr/local/etc/php/conf.d/opcache.ini \
    && echo "opcache.validate_timestamps=0" >> /usr/local/etc/php/conf.d/opcache.ini \
    && echo "opcache.max_accelerated_files=10000" >> /usr/local/etc/php/conf.d/opcache.ini \
    && echo "opcache.memory_consumption=256" >> /usr/local/etc/php/conf.d/opcache.ini \
    && echo "opcache.interned_strings_buffer=16" >> /usr/local/etc/php/conf.d/opcache.ini

# ==============================================
# ENABLE XDEBUG FOR DEVELOPMENT (OPTIONAL)
# ==============================================
ARG INSTALL_XDEBUG=false
RUN if [ "$INSTALL_XDEBUG" = "true" ]; then \
      pecl install xdebug && docker-php-ext-enable xdebug && \
      echo "xdebug.mode=debug,develop" >> /usr/local/etc/php/conf.d/xdebug.ini && \
      echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/xdebug.ini && \
      echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/xdebug.ini; \
    fi
   
# ==============================================
# CUSTOM VIRTUAL HOST EXAMPLE
# ==============================================
RUN echo '<VirtualHost *:80>\n\
    DocumentRoot /var/www/html\n\
    <Directory /var/www/html>\n\
        Options Indexes FollowSymLinks\n\
        AllowOverride All\n\
        Require all granted\n\
    </Directory>\n\
    ErrorLog /var/www/html/logs/error.log\n\
    CustomLog /var/www/html/logs/access.log combined\n\
</VirtualHost>' > /etc/apache2/sites-available/000-default.conf

# ==============================================
# HEALTHCHECK EXAMPLE
# ==============================================
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD curl -f http://localhost/healthcheck.php || exit 1

# ==============================================
# EXPOSE PORT
# ==============================================
EXPOSE 80

# ==============================================
# DEFAULT COMMAND
# ==============================================
CMD ["apache2-foreground"]
