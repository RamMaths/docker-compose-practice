FROM ubuntu
RUN apt-get update && apt-get install -y nginx && apt-get install apache2 -y
RUN
RUN

ADD apache.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/apache.sh

ADD nginx.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/nginx.sh

CMD ["echo", "prueba de comando"]

EXPOSE 80
