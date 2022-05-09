# ============================================= 构建镜像 =============================================
ARG RESTY_IMAGE_BASE="alpine"
ARG RESTY_IMAGE_TAG="3.15.4"

FROM ${RESTY_IMAGE_BASE}:${RESTY_IMAGE_TAG} AS base

LABEL maintainer="zxk175 zxk175@qq.com"

# Docker构建参数
ARG RESTY_VERSION="1.19.9.1"
ARG RESTY_OPENSSL_VERSION="1.1.1n"
ARG RESTY_OPENSSL_PATCH_VERSION="1.1.1f"
ARG RESTY_PCRE_VERSION="8.44"
ARG RESTY_PCRE_SHA256="aecafd4af3bd0f3935721af77b889d9024b2e01d96b58471bd91a3063fb47728"
ARG RESTY_J="2"

ARG RESTY_PREFIX="/usr/local/openresty"
ARG RESTY_DEPS_PREFIX="/usr/local/openresty/deps"

ARG RESTY_CONFIG_OPTIONS="\
    --prefix=${RESTY_PREFIX} \
    --conf-path=${RESTY_PREFIX}/nginx/conf/nginx.conf \
    --http-log-path=${RESTY_PREFIX}/nginx/logs/access.log \
    --error-log-path=${RESTY_PREFIX}/nginx/logs/error.log \
    --lock-path=/var/run/openresty/nginx.lock \
    --pid-path=/var/run/openresty/nginx.pid \
    --with-luajit \
    --with-pcre-jit \
    --with-compat \
    --with-file-aio \
    --with-http_addition_module \
    --with-http_auth_request_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_geoip_module=dynamic \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_image_filter_module=dynamic \
    --with-http_mp4_module \
    --with-http_random_index_module \
    --with-http_realip_module \
    --with-http_secure_link_module \
    --with-http_slice_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_sub_module \
    --with-http_v2_module \
    --with-http_xslt_module=dynamic \
    --with-ipv6 \
    --with-mail \
    --with-mail_ssl_module \
    --with-md5-asm \
    --with-pcre-jit \
    --with-sha1-asm \
    --with-stream \
    --with-stream_ssl_module \
    --with-threads \
    "
ARG RESTY_CONFIG_OPTIONS_MORE=""
ARG RESTY_LUAJIT_OPTIONS="--with-luajit-xcflags='-DLUAJIT_NUMMODE=2 -DLUAJIT_ENABLE_LUA52COMPAT'"

# These are not intended to be user-specified
ARG _RESTY_CONFIG_DEPS="--with-pcre \
    --with-cc-opt='-DNGX_LUA_ABORT_AT_PANIC -I${RESTY_DEPS_PREFIX}/pcre/include -I${RESTY_DEPS_PREFIX}/openssl/include' \
    --with-ld-opt='-L${RESTY_DEPS_PREFIX}/pcre/lib -L${RESTY_DEPS_PREFIX}/openssl/lib -Wl,-rpath,${RESTY_DEPS_PREFIX}/pcre/lib:${RESTY_DEPS_PREFIX}/openssl/lib' \
    "

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories \
    && apk update \
    && apk add --no-cache --virtual .build-deps \
            build-base \
            coreutils \
            curl \
            gd-dev \
            geoip-dev \
            libxslt-dev \
            linux-headers \
            make \
            perl-dev \
            readline-dev \
            zlib-dev \
    && apk add --no-cache \
            gd \
            geoip \
            libgcc \
            libxslt \
            zlib

RUN cd /tmp \
    && curl -fSL "https://www.openssl.org/source/openssl-${RESTY_OPENSSL_VERSION}.tar.gz" -o openssl-${RESTY_OPENSSL_VERSION}.tar.gz \
    && tar xzf openssl-${RESTY_OPENSSL_VERSION}.tar.gz \
    && cd openssl-${RESTY_OPENSSL_VERSION} \
    && if [ $(echo ${RESTY_OPENSSL_VERSION} | cut -c 1-5) = "1.1.1" ] ; then \
        echo 'patching OpenSSL 1.1.1 for OpenResty' \
        && curl -s https://raw.githubusercontent.com/openresty/openresty/master/patches/openssl-${RESTY_OPENSSL_PATCH_VERSION}-sess_set_get_cb_yield.patch | patch -p1 ; \
    fi \
    && if [ $(echo ${RESTY_OPENSSL_VERSION} | cut -c 1-5) = "1.1.0" ] ; then \
        echo 'patching OpenSSL 1.1.0 for OpenResty' \
        && curl -s https://raw.githubusercontent.com/openresty/openresty/ed328977028c3ec3033bc25873ee360056e247cd/patches/openssl-1.1.0j-parallel_build_fix.patch | patch -p1 \
        && curl -s https://raw.githubusercontent.com/openresty/openresty/master/patches/openssl-${RESTY_OPENSSL_PATCH_VERSION}-sess_set_get_cb_yield.patch | patch -p1 ; \
    fi \
    && ./config \
      no-threads shared zlib -g \
      enable-ssl3 enable-ssl3-method \
      --prefix=${RESTY_DEPS_PREFIX}/openssl \
      --libdir=lib \
      -Wl,-rpath,${RESTY_DEPS_PREFIX}/openssl/lib \
    && make -j${RESTY_J} \
    && make -j${RESTY_J} install_sw

RUN cd /tmp \
    && curl -fSL https://downloads.sourceforge.net/project/pcre/pcre/${RESTY_PCRE_VERSION}/pcre-${RESTY_PCRE_VERSION}.tar.gz -o pcre-${RESTY_PCRE_VERSION}.tar.gz \
    && echo "${RESTY_PCRE_SHA256}  pcre-${RESTY_PCRE_VERSION}.tar.gz" | shasum -a 256 --check \
    && tar xzf pcre-${RESTY_PCRE_VERSION}.tar.gz \
    && cd /tmp/pcre-${RESTY_PCRE_VERSION} \
    && ./configure \
        --prefix=${RESTY_DEPS_PREFIX}/pcre \
        --disable-cpp \
        --enable-jit \
        --enable-utf \
        --enable-unicode-properties \
    && make -j${RESTY_J} \
    && make -j${RESTY_J} install

RUN mkdir -p ${RESTY_PREFIX} \
    && cd /tmp \
    && curl -fSL https://openresty.org/download/openresty-${RESTY_VERSION}.tar.gz -o openresty-${RESTY_VERSION}.tar.gz \
    && tar xzf openresty-${RESTY_VERSION}.tar.gz \
    && cd /tmp/openresty-${RESTY_VERSION} \
    && eval ./configure -j${RESTY_J} ${_RESTY_CONFIG_DEPS} ${RESTY_CONFIG_OPTIONS} ${RESTY_CONFIG_OPTIONS_MORE} ${RESTY_LUAJIT_OPTIONS} \
    && make -j${RESTY_J} \
    && make -j${RESTY_J} install


# ============================================= 最终镜像 =============================================
ARG RESTY_IMAGE_BASE="alpine"
ARG RESTY_IMAGE_TAG="3.15.4"

FROM ${RESTY_IMAGE_BASE}:${RESTY_IMAGE_TAG}

LABEL maintainer="zxk175 zxk175@qq.com"

ARG RESTY_PREFIX=="/usr/local/openresty"

WORKDIR ${RESTY_PREFIX}

COPY --from=base ${RESTY_PREFIX}/ .
COPY conf/nginx.conf ${RESTY_PREFIX}/nginx/conf/nginx.conf

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories \
    && apk update \
    && apk add --no-cache \
            gd \
            geoip \
            libgcc \
            libxslt \
            zlib

RUN mkdir -p /var/run/openresty \
    && mkdir -p ${RESTY_PREFIX}/logs \
    && addgroup -g 1000 -S www && adduser www -D -G www -u 1000 -s /bin/sh \
    && ln -sf ${RESTY_PREFIX}/nginx/sbin/nginx /usr/local/bin/nginx \
    && ln -sf /dev/stdout ${RESTY_PREFIX}/nginx/logs/access.log \
    && ln -sf /dev/stderr ${RESTY_PREFIX}/nginx/logs/error.log

# 为方便起见，将其他二进制文件添加到 PATH
ENV PATH=$PATH:${RESTY_PREFIX}/luajit/bin:${RESTY_PREFIX}/nginx/sbin

# CMD ["nginx", "-g", "daemon off;"]

# 使用SIGQUIT而不是默认的SIGTERM来清除请求
# https://github.com/openresty/docker-openresty/blob/master/README.md#tips--pitfalls
STOPSIGNAL SIGQUIT
