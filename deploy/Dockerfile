# docker build -t imgshr -f deploy/Dockerfile .
# docker run -it -v $(pwd)/deploy/database.yml:/app/config/database.yml imgshr

FROM ruby:3.2.1 as builder

ENV RAILS_ENV=production
ENV RAILS_FORCE_SSL=false
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_CONTAINER=true

RUN \
  rm /etc/apt/apt.conf.d/docker-clean && \
  apt-get update -qq && \
  curl -sL https://deb.nodesource.com/setup_16.x | bash && \
  apt-get install -y build-essential nodejs

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock package.json yarn.lock ./
RUN \
  bundle config set without 'development test' && \
  bundle install && \
  npm install -g yarn && \
  yarn

COPY . .
RUN \
  SECRET_KEY_BASE="null" bundle exec rails assets:precompile && \
  SECRET_KEY_BASE="null" bundle exec rails assets:clean


FROM ruby:3.2.1

RUN useradd -m ruby

COPY --from=builder --chown=root:root /usr/local/bundle /usr/local/bundle
COPY --from=builder --chown=ruby:ruby /app /app
COPY --from=builder /var/cache/apt/archives/nodejs_16*-deb-1nodesource1_amd64.deb /tmp/nodejs.deb

RUN \
  apt-get install /tmp/nodejs.deb && \
  rm /tmp/nodejs.deb

USER ruby
WORKDIR /app

EXPOSE 3000

CMD deploy/docker-entrypoint.sh
