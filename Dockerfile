FROM dunglas/frankenphp

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# PHP Extensions required for Laravel 11.x
RUN install-php-extensions \
    pcntl \
    bcmath \
    ctype \
    fileinfo \
    json \
    mbstring \
    openssl \
    pdo \
    tokenizer \
    xml

RUN apt-get update && apt-get install -y \
    zip \
    unzip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy the application source code
COPY ./src /var/www/html

WORKDIR /var/www/html

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && mkdir -p /var/www/html/storage \
    && chmod -R 755 /var/www/html/storage \
    && mkdir -p /var/www/html/vendor \
    && chmod -R 755 /var/www/html/vendor

RUN composer install --no-interaction

# Check if vendor/autoload.php exists
RUN ls -al vendor

RUN cp .env.example .env

RUN php artisan key:generate

ENTRYPOINT ["php", "artisan", "octane:frankenphp"]