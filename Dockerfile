# Base image for PHP and Nginx
FROM php:7.4-fpm

# Install dependencies
RUN apt-get update && apt-get install -y \
    nginx \
    curl \
    unzip \
    git \
   supervisor \
    && apt-get clean

# Install PHP extensions
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Configure Nginx
RUN mkdir -p /var/www/html 
RUN mkdir -p /etc/nginx/sites-available 
RUN mkdir -p /etc/nginx/sites-enabled

RUN rm /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-available/default
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./default.conf /etc/nginx/sites-available/default
# RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Download and set up CodeIgniter 3

WORKDIR /var/www/html
# RUN curl -sL https://github.com/bcit-ci/CodeIgniter/archive/3.1.13.zip -o codeigniter.zip && \
#     unzip codeigniter.zip && \
#     mv CodeIgniter-3.1.13/* . && \
#     rm -rf codeigniter.zip CodeIgniter-3.1.13

# COPY ./codeigniter.zip .
COPY CodeIgniter-3.1.13/ .

# Set permissions
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 775 /var/www/html

# Supervisor configuration
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# RUN useradd -m www-data
# USER www-data

# Expose ports
EXPOSE 80

# Start Supervisor (which manages Nginx and PHP-FPM)
# CMD ["/usr/bin/supervisord"]
# CMD ["nginx", "-g", "daemon off;"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]

# docker-php-entrypoint php-fpm