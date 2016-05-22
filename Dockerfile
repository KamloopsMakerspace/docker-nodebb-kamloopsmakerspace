FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y supervisor wget build-essential git imagemagick nodejs nodejs-legacy npm

# redis
RUN cd /tmp && wget http://download.redis.io/redis-stable.tar.gz && tar xvzf redis-stable.tar.gz
RUN cd /tmp/redis-stable && make && make install
RUN cp -f /tmp/redis-stable/src/redis-sentinel /usr/local/bin
RUN mkdir -p /etc/redis && cp -f /tmp/redis-stable/*.conf /etc/redis && rm -rf /tmp/redis-stable*
RUN sed -i 's/^\(bind .*\)$/# \1/' /etc/redis/redis.conf && \
    sed -i 's/^\(daemonize .*\)$/# \1/' /etc/redis/redis.conf && \
    sed -i 's/^\(dir .*\)$/# \1\ndir \/data\/redis/' /etc/redis/redis.conf && \
    sed -i 's/^\(logfile .*\)$/# \1/' /etc/redis/redis.conf

# nodebb
RUN git clone -b v0.9.x https://github.com/NodeBB/NodeBB /opt/nodebb
# bug in npm: docker images will not build unless you do all the npm installs in single command. Use && for all npm install.
RUN cd /opt/nodebb && npm install -g node-gyp && npm install --production && npm install redis@2.4.2 && npm install connect-redis

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY run-nodebb.sh /sbin/run-nodebb.sh
COPY run-redis.sh /sbin/run-redis.sh
COPY config.json /opt/nodebb/config.json

RUN chmod 755 /sbin/run-nodebb.sh
RUN chmod 755 /sbin/run-redis.sh

# nodebb
EXPOSE 4567
# redis
EXPOSE 6379

VOLUME /data
VOLUME /opt/nodebb

CMD ["supervisord", "-n"]
