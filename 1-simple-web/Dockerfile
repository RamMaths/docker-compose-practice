FROM ubuntu
RUN apt-get update
RUN apt-get install -y nginx
ADD ./my-app/ /var/www/html
ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]
EXPOSE 80
