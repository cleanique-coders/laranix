Laranix
===========

Bash Script to allow create Laravel 5, Lumen, Slim Framework 3, CakePHP 3 and WordPress together with project's Virtual Host

## Dependencies ##

1. [Forked RoveWire VirtualHost](https://github.com/cleanique-coders/virtualhost)

2. Enable SSL Module
	```
	$ sudo a2enmod ssl
	```

## Installation ##

1. Download the script


2. Apply permission to execute:

    ```
    $ chmod +x /path/to/laranix.sh
    ```

3. To make use the script globally

    ```
    $ sudo cp /path/to/laranix.sh /usr/local/bin/laranix
    ```

## Usage ##

Basic command line syntax:

    $ sudo laranix [laravel|lumen|cake|slim|cake|wp] [project-name] [extension] [ip-address]

`[extension]` and `[ip-address]` is optional. By default it will use `.dev` and `127.0.0.1`

## TODO ##

1. Optionally accept `domain-name`

2. Optionally accept `ip-address`

3. Optionally accept `port`

