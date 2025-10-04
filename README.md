# docker-php-fpm-alpine
Running PHP5 for old websites

NOTE: When using docker stack (as lighttpd (that version) doesn't like hostnames with "_") :

Alternative 1:
	Add in stack yaml:

```
    networks:
      ha_net:
        aliases:
         - example-com.docker
```

and use "example-com.docker" instead for the hostname.

Alternative 2:
	In haproxy configuration add:

```
backend example-com:
	http-request set-header Host example-com.docker
```

Alternative 3: 
	Use apache branch instead
