# docker build --no-cache -t imgshr -f deploy/Dockerfile .
# docker run -it -v $(pwd)/deploy/database.yml:/app/config/database.yml imgshr

FROM ruby:3.4.1-slim

ENV RAILS_ENV=production
ENV RAILS_FORCE_SSL=false
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_CONTAINER=true

COPY deploy/node_setup_20.x.sh /tmp
RUN \
  apt-get update -qq && \
  /tmp/node_setup_20.x.sh && \
  apt-get install -y build-essential nodejs=20* git libmariadb-dev imagemagick && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  rm /tmp/node_setup_20.x.sh && \
  useradd -m ruby && \
  mkdir /app

WORKDIR /app
COPY app app
COPY bin bin
COPY config config
COPY db db
COPY lib lib
COPY public public
COPY babel.config.js babel.config.js
COPY config.ru config.ru
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
COPY package.json package.json
COPY postcss.config.js postcss.config.js
COPY Procfile Procfile
COPY Rakefile Rakefile
COPY yarn.lock yarn.lock
COPY deploy/docker-entrypoint.sh docker-entrypoint.sh

RUN \
  bundle config set without 'development test' && \
  bundle install && \
  npm install -g yarn && \
  yarn && \
  mkdir storage && \
  chown -R ruby:ruby . && \
  rm -rf /usr/local/bundle/cache /usr/local/share/.cache /var/lib/apt/lists/* /usr/share/doc /usr/share/man

USER ruby
RUN \
  SECRET_KEY_BASE=null NODE_OPTIONS=--openssl-legacy-provider bundle exec rails assets:precompile && \
  SECRET_KEY_BASE=null bundle exec rails assets:clean

EXPOSE 3000

CMD ["./docker-entrypoint.sh"]
