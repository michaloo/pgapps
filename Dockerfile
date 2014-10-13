FROM ubuntu:14.04

RUN apt-get update && apt-get install -y curl build-essential

# postgres installation from: https://github.com/docker-library/postgres/blob/master/9.3/Dockerfile
# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r postgres && useradd -r -g postgres postgres

# grab gosu for easy step-down from root
RUN curl -o /usr/local/bin/gosu -SL 'https://github.com/tianon/gosu/releases/download/1.1/gosu' \
	&& chmod +x /usr/local/bin/gosu

RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.utf8

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - && \
    apt-get update && \
	apt-get install -y postgresql-common && \
	sed -ri 's/#(create_main_cluster) .*$/\1 = false/' /etc/postgresql-common/createcluster.conf && \
    apt-get install -y \
    postgresql-9.3 \
	postgresql-contrib-9.3 \
    postgresql-9.3-ip4r \
    postgresql-9.3-plsh \
    postgresql-9.3-plv8 \
    postgresql-9.3-preprepare \
    postgresql-server-dev-9.3

RUN echo 'deb http://ppa.launchpad.net/chris-lea/node.js/ubuntu trusty main' > /etc/apt/sources.list.d/nodejs.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C7917B12 && \
    apt-get update -y && \
    apt-get install nodejs -y && \
    npm install -g plv8x

# RUN apt-get install libreadline-dev libncurses5-dev libpcre3-dev libssl-dev perl make && \
# 	curl http://openresty.org/download/ngx_openresty-1.7.2.1.tar.gz | tar -zx && \
# 	cd ngx_openresty-1.7.2.1/ && \
# 	./configure \
#     --with-http_postgres_module \
#     --with-pcre-jit \
#     --with-ipv6 \
# 	--with-http_stub_status_module \
#     --with-http_ssl_module \
#     --with-http_realip_module \
#     --without-http_fastcgi_module \
#     --without-http_uwsgi_module \
#     --without-http_scgi_module \
# 	--with-http_addition_module \
# 	--with-http_auth_request_module \
# 	--without-lua_resty_memcached \
# 	--without-lua_resty_redis \
# 	--without-lua_resty_mysql \
# 	--with-http_stub_status_module && \
# 	make && \
# 	make install && \
# 	rm -rf /ngx_openresty*

RUN mkdir -p /var/run/postgresql && chown -R postgres /var/run/postgresql
ENV PATH /usr/lib/postgresql/9.3/bin:$PATH
ENV PGDATA /var/lib/postgresql/data
VOLUME /var/lib/postgresql/data

#RUN echo "\ndaemon off;" >> /usr/local/openresty/nginx/conf/nginx.conf

COPY . /pgapps

ENTRYPOINT ["/bin/bash"]

EXPOSE 5432
EXPOSE 80
EXPOSE 443
CMD ["/pgapps/start.sh"]
