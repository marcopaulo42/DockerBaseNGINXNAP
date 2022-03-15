# syntax=docker/dockerfile:1
# For Ubuntu 20.04:
FROM ubuntu:focal

# Install prerequisite packages:
RUN apt-get update && apt-get install -y apt-transport-https lsb-release ca-certificates wget gnupg2

# Download and add the NGINX signing key:
RUN wget https://cs.nginx.com/static/keys/nginx_signing.key && apt-key add nginx_signing.key

# Add NGINX Plus repository:
RUN printf "deb https://pkgs.nginx.com/plus/ubuntu `lsb_release -cs` nginx-plus\n" | tee /etc/apt/sources.list.d/nginx-plus.list

# Add NGINX App-protect repository:
RUN printf "deb https://pkgs.nginx.com/app-protect/ubuntu `lsb_release -cs` nginx-plus\n" | tee /etc/apt/sources.list.d/nginx-app-protect.list

# Download the apt configuration to `/etc/apt/apt.conf.d`:
RUN wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx

# Update the repository and install the most recent version of the NGINX App Protect WAF package (which includes NGINX Plus):
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y app-protect

# Forward request logs to Docker log collector:
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Copy configuration files:
COPY nginx.conf /etc/nginx/
#COPY custom_log_format.json /etc/nginx/
COPY entrypoint.sh /root/

CMD ["sh", "/root/entrypoint.sh"]
