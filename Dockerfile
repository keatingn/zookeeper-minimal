FROM nkeating/java-minimal

MAINTAINER Noel Keating

ENV ZOOKEEPER_VERSION 3.4.6

RUN apk --update add bash

RUN /usr/sbin/adduser -s /sbin/nologin -D -H zookeeper zookeeper

RUN mkdir /opt \
  && wget -O /opt/zookeeper-${ZOOKEEPER_VERSION}.tar.gz \
  http://ftp.heanet.ie/mirrors/www.apache.org/dist/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz
RUN tar xz -C /opt -f /opt/zookeeper-${ZOOKEEPER_VERSION}.tar.gz \
  zookeeper-${ZOOKEEPER_VERSION}/bin \
  zookeeper-${ZOOKEEPER_VERSION}/conf \
  zookeeper-${ZOOKEEPER_VERSION}/lib \
  zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.jar \
  && chown -R zookeeper:zookeeper /opt/zookeeper-${ZOOKEEPER_VERSION} \
  && ln -s /opt/zookeeper-${ZOOKEEPER_VERSION} /opt/zookeeper \
  && rm /opt/zookeeper-${ZOOKEEPER_VERSION}.tar.gz \
  && mkdir -p /var/lib/zookeeper \
  && chown -R zookeeper:zookeeper /var/lib/zookeeper

ADD zoo.cfg /opt/zookeeper-${ZOOKEEPER_VERSION}/conf

VOLUME /var/lib/zookeeper

EXPOSE 2181 2888 3888

USER zookeeper
WORKDIR /opt/zookeeper

CMD ["./bin/zkServer.sh", "start-foreground"]
