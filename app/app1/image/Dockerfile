FROM nginx:alpine AS builder

ENV VTS_VERSION 0.1.18

# Download sources
RUN wget "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -O nginx.tar.gz && \
  wget "https://github.com/vozlt/nginx-module-vts/archive/v${VTS_VERSION}.tar.gz" -O vts.tar.gz

# For latest build deps, see https://github.com/nginxinc/docker-nginx/blob/master/mainline/alpine/Dockerfile
RUN apk add --no-cache --virtual .build-deps \
  gcc \
  libc-dev \
  make \
  openssl-dev \
  pcre-dev \
  zlib-dev \
  linux-headers \
  curl \
  gnupg \
  libxslt-dev \
  gd-dev \
  tzdata \
  git \
  geoip-dev

# Reuse same cli arguments as the nginx:alpine image used to build
RUN mkdir /usr/src \
    && CONFARGS=$(nginx -V 2>&1 | sed -n -e 's/^.*arguments: //p') tar -zxC /usr/src -f nginx.tar.gz \
    && tar -xzvf "vts.tar.gz" \
    && VTSDIR="$(pwd)/nginx-module-vts-${VTS_VERSION}" && \
  cd /usr/src/nginx-$NGINX_VERSION && \
  ./configure --with-compat $CONFARGS --add-dynamic-module=$VTSDIR && \
  make && make install

####################################################################################
FROM nginx:alpine

ARG githash
ARG TZ='America/New_York'
ENV DEFAULT_TZ ${TZ}

COPY --from=builder /usr/local/nginx/modules/ngx_http_vhost_traffic_status_module.so /usr/local/nginx/modules/ngx_http_vhost_traffic_status_module.so

RUN rm /etc/nginx/conf.d/default.conf
COPY index.html /usr/share/nginx/html/
COPY entrypoint.sh /entrypoint.sh
COPY nginx.conf /etc/nginx/nginx.conf

RUN apk update \
    && apk add --no-cache curl tzdata git \
    && cp /usr/share/zoneinfo/${DEFAULT_TZ} /etc/localtime \
    && echo ${DEFAULT_TZ} > /etc/timezone \
    && echo "OK, I'm running." > /usr/share/nginx/html/health.html \
    && chmod 644 /usr/share/nginx/html/index.html \
    && sed -i "s/githash/${githash}/" /etc/nginx/nginx.conf \
    && git clone git://github.com/vozlt/nginx-module-vts.git /etc/nginx/nginx-module-vts |tee \
    && chmod +x /entrypoint.sh \
    && rm -rf /var/cache/apk/*

ENTRYPOINT [ "/entrypoint.sh" ]

EXPOSE 8080

STOPSIGNAL SIGTERM