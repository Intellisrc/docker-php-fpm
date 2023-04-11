# About

This image uses Alpine Linux (3.12) with lighttpd and php-fpm (7.3).

## Usage:

```
FROM intellisrc/ioncube-fpm-alpine:3.12
```

### Docker swarm

Example:

```yaml
version: '3.9'
    
services:
  site:
    image: intellisrc/ioncube-fpm-alpine:3.12
    volumes:
      - type: bind
        source: "/mnt/site/example.com/"
        target: "/var/www/"
    environment:
      PHP_MIN_WORKERS: 1
      PHP_MAX_WORKERS: 10
    deploy:
      mode: replicated
      replicas: 3
      endpoint_mode: dnsrr
      placement:
        constraints: 
          - node.role == worker
```
