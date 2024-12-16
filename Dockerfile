# Use a imagem base do PHP com FPM (FastCGI Process Manager)
FROM php:8.2-fpm

# Instalar dependências do sistema (como bibliotecas de imagem e MySQL)
RUN apt-get update && apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev zip git

# Instalar as extensões PHP necessárias para o Laravel
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

# Instalar o Composer (gerenciador de dependências do PHP)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Definir o diretório de trabalho dentro do container
WORKDIR /var/www

# Copiar os arquivos do seu projeto para o container
COPY . .

# Instalar as dependências do Laravel via Composer
RUN composer install --no-dev --optimize-autoloader

# Dar permissões para o diretório de storage
RUN chmod -R 777 /var/www/storage

# Expor a porta 9000 para o PHP-FPM
EXPOSE 9000

# Iniciar o PHP-FPM quando o container for iniciado
CMD ["php-fpm"]

