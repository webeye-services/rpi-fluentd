# Pull base image
FROM hypriot/rpi-ruby 
MAINTAINER Vena <rak@webeye.services>

RUN apt-get update -y && \
    apt-get install -y ruby-dev g++ make && \
    gem install fluentd fluent-plugin-secure-forward fluent-plugin-elasticsearch && \
    apt-get remove --purge -y  $(apt-mark showauto) && \ 
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN useradd ubuntu -d /home/ubuntu -m -U && \
    chown -R ubuntu:ubuntu /home/ubuntu

# for log storage (maybe shared with host)
RUN mkdir -p /fluentd/etc /fluentd/plugins && \
    chown -R ubuntu:ubuntu /fluentd

WORKDIR /home/ubuntu


USER ubuntu

COPY fluent.conf /fluentd/etc/
ONBUILD COPY fluent.conf /fluentd/etc/
ONBUILD COPY plugins /fluentd/plugins/

WORKDIR /home/ubuntu

ENV FLUENTD_OPT=""
ENV FLUENTD_CONF="fluent.conf"

EXPOSE 24224


CMD exec fluentd -c /fluentd/etc/$FLUENTD_CONF -p /fluentd/plugins $FLUENTD_OPT

