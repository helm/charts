user nginx;
worker_processes 4;
pid /run/nginx.pid;

events {
        worker_connections 1024;
}

http {
        sendfile off;
        tcp_nopush on;
        tcp_nodelay on;
        send_timeout 7200;
        keepalive_timeout 65;
        types_hash_max_size 2048;
        include /etc/nginx/mime.types;
        default_type application/octet-stream;
        access_log /dev/stdout;
        error_log /dev/stdout info;
        gzip off;

        server {
                listen 80 default_server;
                root /var/www;
                autoindex on;
                server_name tarako;
                location / {
                        try_files $uri $uri/ =404;
                }
        }
}
