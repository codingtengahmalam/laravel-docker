FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    supervisor \
    cron \
    libpq-dev

# Install Node.js & npm
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions untuk PostgreSQL
RUN apt-get update && apt-get install -y libicu-dev && \
    docker-php-ext-install pdo_pgsql pgsql mbstring exif pcntl bcmath gd zip xml intl

# Install Redis extension
RUN pecl install redis && docker-php-ext-enable redis

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy scheduler script
COPY docker/app/start-scheduler.sh /usr/local/bin/start-scheduler.sh
RUN chmod +x /usr/local/bin/start-scheduler.sh

# Create start script for queue worker
RUN echo '#!/bin/sh\n\
exec supervisord -c /etc/supervisor/supervisord.conf' > /usr/local/bin/start-queue.sh && chmod +x /usr/local/bin/start-queue.sh

# Set working directory
WORKDIR /var/www/html

# Salin kode aplikasi
COPY . /var/www/html

# Note: npm install, composer install, npm run build, and storage:link 
# are handled in entrypoint.sh for better flexibility

# Copy entrypoint script
COPY docker/app/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Use entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Set default command to php-fpm (untuk app container)
CMD ["php-fpm"]
