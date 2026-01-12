FROM php:8.2-apache

# Habilitar módulos de Apache necesarios
RUN a2enmod rewrite

# Copiar los archivos de la aplicación
COPY . /var/www/html/

# Establecer permisos
RUN chown -R www-data:www-data /var/www/html/
RUN chmod -R 755 /var/www/html/

# Crear directorio para datos si es necesario
RUN mkdir -p /var/www/html/data && \
    chown -R www-data:www-data /var/www/html/data && \
    chmod -R 775 /var/www/html/data

# Exponer puerto
EXPOSE 80

# Comando por defecto
CMD ["apache2-foreground"]
