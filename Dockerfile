FROM centos:7

ARG NGINX_CERT
ARG NGINX_KEY
ARG NMS_URL

# Initial packages setup
RUN yum -y update \
	&& yum install -y wget ca-certificates epel-release curl

# NGINX Instance Manager agent setup
RUN mkdir -p /deployment /etc/ssl/nginx

# Agent installation
RUN bash -c 'curl -k $NMS_URL/install/nginx-agent | sh' && echo "Agent installed from NMS"

# Startup script
COPY ./container/start.sh /deployment/
RUN chmod +x /deployment/start.sh && touch /.dockerenv

# Download certificate and key from the customer portal (https://account.f5.com)
# and copy to the build context
COPY $NGINX_CERT /etc/ssl/nginx/nginx-repo.crt
COPY $NGINX_KEY /etc/ssl/nginx/nginx-repo.key

# Install prerequisite packages:
RUN yum -y update \
	&& yum autoremove -y \
	&& yum -y clean all \
	&& rm -rf /var/cache/yum \
	&& wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-7.4.repo \
#	&& wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-7.repo \
#	&& yum install -y app-protect app-protect-attack-signatures
	&& yum install -y nginx-plus nginx-plus-module-njs nginx-plus-module-prometheus

# Forward request logs to Docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80
STOPSIGNAL SIGTERM

CMD /deployment/start.sh
