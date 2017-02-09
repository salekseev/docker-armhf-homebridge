FROM hypriot/rpi-node:6.9.4

MAINTAINER Stas Alekseev <me@salekseev.com>

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

RUN apt-get update &&\
	apt-get install -y --no-install-recommends \
        avahi-daemon \
        avahi-discover \
        build-essential \
        libavahi-compat-libdnssd-dev \
        libnss-mdns && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN npm install -g --unsafe-perm \
        homebridge \
        hap-nodejs \
        node-gyp && \
    cd /usr/local/lib/node_modules/homebridge/ && \
    npm install --unsafe-perm bignum && \
    cd /usr/local/lib/node_modules/hap-nodejs/node_modules/mdns && \
    node-gyp BUILDTYPE=Release rebuild

EXPOSE 5353 51826

RUN mkdir -p /var/run/dbus
RUN mkdir -p /root/.homebridge

VOLUME /root/.homebridge
WORKDIR /root/.homebridge

COPY plugins.txt /root/.homebridge/plugins.txt
COPY config.json /root/.homebridge/config.json
COPY start.sh /root/.homebridge/start.sh

CMD /root/.homebridge/start.sh
