# docker build -t imgshr -f deploy/Dockerfile .
# docker run -it -v $(pwd)/deploy/database.yml:/app/config/database.yml imgshr

FROM ruby:3.2.1

ENV RAILS_ENV=production
ENV RAILS_FORCE_SSL=false
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_CONTAINER=true

RUN \
  apt-get update -qq && \
  curl -sL https://deb.nodesource.com/setup_16.x | bash && \
  apt-get install -y build-essential libpq-dev nodejs && \
  rm -rf /var/lib/apt/lists/*

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

EXPOSE 3000

CMD deploy/docker-entrypoint.sh
