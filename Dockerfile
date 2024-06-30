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
COPY ./src /app

WORKDIR /app

# Install Laravel dependencies
RUN composer install --no-dev --optimize-autoloader

ENTRYPOINT ["php", "artisan", "octane:frankenphp"]