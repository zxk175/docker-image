ARG IMAGE_TAG=3.15.4

FROM alpine:${IMAGE_TAG}

LABEL maintainer="zxk175 zxk175@qq.com"

ARG ALPINE_MIRRORS_VERSION="v3.15"

# 更新alpine的软件源为阿里云
RUN echo https://mirrors.aliyun.com/alpine/${ALPINE_MIRRORS_VERSION}/main/ > /etc/apk/repositories \
    && echo https://mirrors.aliyun.com/alpine/${ALPINE_MIRRORS_VERSION}/community/ >> /etc/apk/repositories \
    && apk update \
    && apk upgrade \
    && apk add tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apk del tzdata \
    && rm -rf /var/cache/apk/*

COPY scripts/ll /usr/bin/ll

RUN chmod a+x /usr/bin/ll

CMD ["/bin/sh"]
