# docker build -t imgshr -f deploy/Dockerfile .
# docker run -it -v $(pwd)/deploy/database.yml:/app/config/database.yml imgshr

FROM ruby:3.2.2

ENV RAILS_ENV=production
ENV RAILS_FORCE_SSL=false
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_CONTAINER=true

COPY deploy/node_setup_20.x.sh /tmp
RUN \
  apt-get update -qq && \
  /tmp/node_setup_20.x.sh && \
  apt-get install -y build-essential nodejs && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  useradd -m ruby && \
  mkdir /app

WORKDIR /app
COPY . .
RUN \
  bundle config set without 'development test' && \
  bundle install && \
  npm install -g yarn && \
  yarn && \
  chown -R ruby:ruby .

USER ruby
RUN \
  SECRET_KEY_BASE="null" bundle exec rails assets:precompile && \
  SECRET_KEY_BASE="null" bundle exec rails assets:clean

EXPOSE 3000

CMD deploy/docker-entrypoint.sh
