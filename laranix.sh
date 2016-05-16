# get httpd user
HTTPDUSER=`ps aux | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1`

# get current directory
cwd=$(pwd)"/"

# get project directory location
# $2 is a project name
project=$cwd$2

# domain name
domain=$2".dev"

function laravel {
	cache=$project"/bootstrap/cache"
	storage=$project"/storage"
	public=$project"/public"

    # create laravel project
	sudo composer create-project --prefer-dist laravel/laravel $1
	echo "Laravel Project created at "$project

	sudo chmod 777 $cache -R && chmod 777 $storage -R
	echo "Change Laravel $cache & $storage to writable"

	sudo chown ${HTTPDUSER}:${HTTPDUSER} $project -R
	echo "Change Laravel owner to web server"

	virtualhost create $1.dev $public
	echo "Automate generate domain for Laravel project"
} 

function lumen {
	storage=$project"/storage"
	public=$project"/public"

	# create laravel project
	composer create-project --prefer-dist laravel/lumen $1
	echo "Lumen Project created at "$project

	chmod 777 $storage -R
	echo "Change Lumen $storage to writable"

	sudo chown ${HTTPDUSER}:${HTTPDUSER} $project -R
	echo "Change Lumen owner to web server"

	virtualhost create $1.dev $public
	echo "Automate generate domain for Lumen project"
}

function cake {
	# need to check php -m, on module intl enabled or not..if enabled, proceed, else exit with error message
	tmp=$project"/tmp"
	logs=$project"/logs"
	public=$project"/webroot"

	sudo composer create-project --prefer-dist cakephp/app $1
	echo "CakePHP 3 Project created at "$project

	sudo setfacl -R -m u:${HTTPDUSER}:rwx tmp
	sudo setfacl -R -d -m u:${HTTPDUSER}:rwx tmp
	echo "Set CakePHP 3 tmp owner & permission"

	sudo setfacl -R -m u:${HTTPDUSER}:rwx logs
	sudo setfacl -R -d -m u:${HTTPDUSER}:rwx logs
	echo "Set CakePHP 3 logs owner & permission"

	virtualhost create $1.dev $public
	echo "Automate generate domain for CakePHP 3 project"
}

function slim {
	public=$project"/public"

	sudo composer create-project --prefer-dist slim/slim-skeleton $1
	echo "Slim Framework 3 Project created at "$project

	sudo chown ${HTTPDUSER}:${HTTPDUSER} $project -R
	echo "Change Slim Framework 3 owner to web server"

	virtualhost create $1.dev $public
	echo "Automate generate domain for Slim Framework project"
}

function t {
	echo "===::Generating: "$1"::==="
	echo "===::Project Name: "$2"::==="
}
t $1 $2
# $1 parameter will be the type of project want to create laravel, lumen, cake or slim
if($1 = "laravel") then
	laravel $2
elif($1 = "lumen") then
	lumen $2
elif($1 = "cake") then
	cake $2
elif($1 = "slim") then
	slim $2
else
	echo "No project type defined. Nothing to do. Bye."
fi