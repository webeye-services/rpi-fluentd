### Fluentd docker image for Raspberry Pi

This container image is to create endpoint to collect logs on your host is based on oficial fluent image and resin Ruby

```
docker run -d -p 24224:24224 -v /data:/fluentd/log wsrak/rpi-fluentd
```

Default configurations are to:

* listen port `24224` for fluentd forward protocol
* store logs with tag `docker.**` into `/fluentd/log/docker.*.log` (and symlink `docker.log`)
* store all other logs into `/fluentd/log/data.*.log` (and symlink data.log)

## Configurable ENV variables

Environment variable below are configurable to control how to execute fluentd process:

### FLUENTD_CONF

It's for configuration file name, specified for `-c`.

If you want to use your own configuration file (without any optional plugins), you can use it over this ENV variable and -v option.

1. write configuration file with filename `yours.conf`
2. execute `docker run` with `-v /path/to/dir:/fluentd/etc` to share `/path/to/dir/yours.conf` in container, and `-e FLUENTD_CONF=yours.conf` to read it

### FLUENTD_OPT

Use this variable to specify other options, like `-v` or `-q`.

## How to build your own image

It is very easy to use this image as base image. Write your `Dockerfile` and configuration files, and/or your own plugin files if needed.

```
FROM fluent/fluentd:latest
MAINTAINER your_name <...>
USER ubuntu
WORKDIR /home/ubuntu
ENV PATH /home/ubuntu/ruby/bin:$PATH
RUN gem install fluent-plugin-secure-forward
EXPOSE 24284
CMD fluentd -c /fluentd/etc/$FLUENTD_CONF -p /fluentd/plugins $FLUENTD_OPT
```

Files below are automatically included in build process:

`fluent.conf`: used instead of default file
`plugins/*`: copied into `/fluentd/plugins` and loaded at runtime
