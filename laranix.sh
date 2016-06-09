# get httpd user
HTTPDUSER=`ps aux | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1`

# get current directory
cwd=$(pwd)"/"

# get project directory location
# $2 is a project name
project=$cwd$2

# $3 is domain name, default is .dev
if [[ -z "$3" ]]
	then
		domain=".dev"
	else
		domain="$3"
fi

# $4 is IP Address
if [[ -z "$4" ]]
	then
		ipaddress="127.0.0.1"
	else
		ipaddress="$4"
fi

function slim {
	local public=$project"/public"
	local name=$1

	sudo composer create-project --prefer-dist slim/slim-skeleton $name
	echo "Slim Framework 3 Project created at "$project

	sudo chown ${HTTPDUSER}:${HTTPDUSER} $project -R
	echo "Change Slim Framework 3 owner to web server"

	generate_virtualhost $name

	exit
}

function laravel {
	local cache=$project"/bootstrap/cache"
	local storage=$project"/storage"
	local public=$project"/public"
	local name=$1

    # create laravel project
	sudo composer create-project --prefer-dist laravel/laravel $name
	echo "Laravel Project created at "$project

	sudo chmod 777 $cache -R && chmod 777 $storage -R
	echo "Change Laravel $cache & $storage to writable"

	sudo chown ${HTTPDUSER}:${HTTPDUSER} $project -R
	echo "Change Laravel owner to web server"

	generate_virtualhost $name

	exit
} 


function lumen {
	local storage=$project"/storage"
	local public=$project"/public"
	local name=$1

	# create laravel project
	composer create-project --prefer-dist laravel/lumen $name
	echo "Lumen Project created at "$project

	chmod 777 $storage -R
	echo "Change Lumen $storage to writable"

	sudo chown ${HTTPDUSER}:${HTTPDUSER} $project -R
	echo "Change Lumen owner to web server"

	generate_virtualhost $name

	exit
}

function cake {
	# need to check php -m, on module intl enabled or not..if enabled, proceed, else exit with error message
	local tmp=$project"/tmp"
	local logs=$project"/logs"
	local public=$project"/webroot"
	local name=$1

	sudo composer create-project --prefer-dist cakephp/app $name
	echo "CakePHP 3 Project created at "$project

	sudo setfacl -R -m u:${HTTPDUSER}:rwx tmp
	sudo setfacl -R -d -m u:${HTTPDUSER}:rwx tmp
	echo "Set CakePHP 3 tmp owner & permission"

	sudo setfacl -R -m u:${HTTPDUSER}:rwx logs
	sudo setfacl -R -d -m u:${HTTPDUSER}:rwx logs
	echo "Set CakePHP 3 logs owner & permission"

	generate_virtualhost $name

	exit
}

function wp {
	local name=$1
	local public=$cwd$name
	local default=$cwd"wordpress"

	echo "Downloading WordPress..."
	wget http://wordpress.org/latest.tar.gz

	echo "Extract WordPress..."
	tar xzvf latest.tar.gz

	echo "Rename default($default) WordPress directory name($public)"
	mv $default $public

	sudo chown ${HTTPDUSER}:${HTTPDUSER} $public -R
	echo "Change WordPress owner to web server"

	generate_virtualhost $name

	echo "Remove latest.tar.gz"
	rm latest.tar.gz

	exit
}

function generate_virtualhost {
	local name=$1

	echo "Generate SSL Certificates"
	generate_ssl_cert $name

	echo "Automate generate domain for project"
	virtualhost create $name$domain $public	$ipaddress
}

function generate_ssl_cert {
	local name=$1

	if [ ssl_enabled ]
		then
			sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/$name$domain.key -out /etc/apache2/ssl/$name$domain.crt
	fi
}

function ssl_enabled {
	if [ dpkg -l | grep -i openssl ]
	  then
	    return true
	fi

	return false
}

# $1 parameter will be the type of project want to create laravel, lumen, cake or slim
if [[ $1 = "slim" ]]; then
	slim $2
elif [[ $1 = "laravel" ]]; then
	laravel $2
elif [[ $1 = "lumen" ]]; then
	lumen $2
elif [[ $1 = "cake" ]]; then
	cake $2
elif [[ $1 = "wp" ]]; then
	wp $2
fi