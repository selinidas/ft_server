# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: lissettesanchez <lissettesanchez@studen    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/08/05 10:34:12 by lisanche          #+#    #+#              #
#    Updated: 2020/08/08 22:17:37 by lissettesan      ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

From debian:buster

WORKDIR /tmp/
#♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡#
#♡♡Install tools♡♡#
#♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡#
RUN apt-get update && \
apt-get upgrade -y && \
apt-get install -y wget && \
apt-get install -y php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip php-mysql

#♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡#
   #♡♡Nginx♡♡#
#♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡#
RUN apt-get install -y php-fpm && \
apt-get install -y nginx-full && \
apt-get install -y openssl && \
rm -f /ect/nginx/site-available/default && \
rm -f /etc/nginx/sites-enabled/default && \
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/C=ES/ST=Spain/L=Madrid/O=42/CN=127.0.0.1" -keyout /etc/ssl/private/nginx_server.key -out /etc/ssl/certs/nginx_server.crt && \
openssl dhparam -out /etc/nginx/dhparam.pem 1000

#♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡#
   #♡♡MySQL♡♡#
#♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡#
RUN apt-get install -y mariadb-server


#♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡#
 #♡♡Wordpress♡♡#
#♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡#
RUN wget -c https://wordpress.org/latest.tar.gz && \
tar -zxf latest.tar.gz && \
mv wordpress /var/www/html/

#♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡#
 #♡♡PhpMyAdmin♡♡#
#♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡#
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz && \
tar xvf phpMyAdmin-4.9.0.1-all-languages.tar.gz && \ 
mv phpMyAdmin-4.9.0.1-all-languages/ /var/www/html/phpMyAdmin;

#♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡#
 #♡♡Config all♡♡#
#♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡#
COPY srcs/wordpress.conf /etc/nginx/sites-enabled/
COPY srcs/wp-config.php /var/www/html/wordpress/

#♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡#
 #♡♡Import & launch sh♡♡#
#♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡#
COPY srcs/init_container.sh /tmp/
ENTRYPOINT ["/bin/sh", "/tmp/init_container.sh"]

EXPOSE 80 443
