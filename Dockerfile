# Influenced by
# https://github.com/nextcloud/docker/blob/master/.examples/dockerfiles/full/fpm-alpine/Dockerfile
#
# - Remove supervisord for user directive compatibility
# - Add exiftool install
#

# FROM nextcloud:fpm-alpine

# RUN set -ex; \
#     \
#     apk add --no-cache \
#         ffmpeg \
#         imagemagick \
#         procps \
#         samba-client \
# #       libreoffice \
#     ;

# RUN set -ex; \
#     \
#     apk add --no-cache --virtual .build-deps \
#         $PHPIZE_DEPS \
#         imap-dev \
#         krb5-dev \
#         openssl-dev \
#         samba-dev \
#         bzip2-dev \
#     ; \
#     \
#     docker-php-ext-configure imap --with-kerberos --with-imap-ssl; \
#     docker-php-ext-install \
#         bz2 \
#         imap \
#     ; \
#     pecl install smbclient; \
#     docker-php-ext-enable smbclient; \
#     \
#     runDeps="$( \
#         scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
#             | tr ',' '\n' \
#             | sort -u \
#             | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
#     )"; \
#     apk add --virtual .nextcloud-phpext-rundeps $runDeps; \
#     apk del .build-deps

# ENV NEXTCLOUD_UPDATE=1



FROM nextcloud:fpm-alpine

# 1. Install runtime packages
RUN set -ex; \
    apk add --no-cache \
        ffmpeg \
        imagemagick \
        procps \
        samba-client \
        exiftool \
    ;

# 2. Use the official PHP extension installer to handle bz2, imap, and smbclient
# This script handles the PHP 8.4+ "IMAP moved to PECL" change automatically.
ADD --link https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions bz2 imap smbclient

ENV NEXTCLOUD_UPDATE=1
