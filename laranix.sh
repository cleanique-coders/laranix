# get current directory
cwd=$(pwd)"/"

# set project directory location
project=$cwd$1
cache=$project"/bootstrap/cache"
storage=$project"/storage"
public=$project"/public"
domain=$1".dev"

# create laravel project
composer create-project --prefer-dist laravel/laravel $1
echo "Project created at "$project

chmod 777 $cache -R && chmod 777 $storage -R
echo "Change $cache & $storage to writable"

virtualhost create $1.dev $public
echo "Automate generate domain for Laravel project"
