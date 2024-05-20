FROM alpine:latest

LABEL org.opencontainers.image.authors="KingPancakeDB" \
      org.opencontainers.image.title="KingPancake Database" \
      org.opencontainers.image.description="KingPancake Database for relational SQL" \
      org.opencontainers.image.documentation="https://github.com/bill88t/kingpancakedb" \
      org.opencontainers.image.base.name="unset" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.source="https://github.com/bill88t/kingpancakedb" \
      org.opencontainers.image.vendor="Ypodiktyo" \
      org.opencontainers.image.version="11.5.0" \
      org.opencontainers.image.url="https://github.com/bill88t/kingpancakedb"

ADD entrypoint.sh /entrypoint.sh

RUN apk add --no-cache mariadb mariadb-client mariadb-server-utils pwgen && \
rm -f /var/cache/apk/* && \
mkdir /docker-entrypoint-initdb.d && \
mkdir /pre-exec.d && \
mkdir /pre-init.d && \
chmod -R 755 /*.d && \
chmod +x /entrypoint.sh

EXPOSE 3306

VOLUME ["/var/lib/mysql"]

ENTRYPOINT ["/entrypoint.sh"]
CMD ["mysqld"]
