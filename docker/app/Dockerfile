FROM dunglas/frankenphp:php8.3

WORKDIR /app

# Install Node.js 20 + npm + PHP extensions + Composer + Supervisor
RUN apt-get update && apt-get install -y curl gnupg supervisor && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    install-php-extensions \
        @composer \
        pdo_pgsql \
        gd \
        intl \
        zip \
        opcache \
        bcmath \
        exif \
        pcntl \
        sodium \
        redis && \
    mkdir -p /var/log/supervisor && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV COMPOSER_ALLOW_SUPERUSER=1 \
    SERVER_NAME=":8000"

# Copy all application files
COPY . .

# Install PHP & Node dependencies
RUN composer install --no-interaction --prefer-dist --optimize-autoloader --no-dev
RUN npm install && npm run build

# Supervisor config
RUN mkdir -p /etc/supervisor/conf.d
COPY docker/supervisor/queue-and-scheduler.conf /etc/supervisor/conf.d/queue-and-scheduler.conf

# Create supervisord.conf
RUN echo "[supervisord]" > /etc/supervisor/supervisord.conf && \
    echo "nodaemon=true" >> /etc/supervisor/supervisord.conf && \
    echo "logfile=/var/log/supervisor/supervisord.log" >> /etc/supervisor/supervisord.conf && \
    echo "pidfile=/var/run/supervisord.pid" >> /etc/supervisor/supervisord.conf && \
    echo "" >> /etc/supervisor/supervisord.conf && \
    echo "[include]" >> /etc/supervisor/supervisord.conf && \
    echo "files = /etc/supervisor/conf.d/*.conf" >> /etc/supervisor/supervisord.conf

# Jangan generate key di tahap build — sebaiknya via ENV atau entrypoint
# RUN php artisan key:generate

EXPOSE 8000
CMD ["php", "artisan", "octane:frankenphp", "--host=0.0.0.0", "--port=8000"]
