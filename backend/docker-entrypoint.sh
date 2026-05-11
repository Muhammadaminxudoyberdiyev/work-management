#!/bin/bash

if [ ! -d "vendor" ]; then
    composer install
fi 

echo "Waiting for database connection..."
until php artisan db:monitor; do
>&2 echo "MySql is unvaliable - sleeping"
sleep 1 
done

echo "Running migration"
php artisan migrate --force

exec php-fpm