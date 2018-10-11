# docker build -t imgshr -f deploy/Dockerfile .
# docker run -it -v $(pwd)/deploy/database.yml:/app/config/database.yml imgshr

FROM ruby:2.5

RUN \
  apt-get update -qq && \
  curl -sL https://deb.nodesource.com/setup_10.x | bash && \
  apt-get install -y build-essential libpq-dev nodejs && \
  rm -rf /var/lib/apt/lists/*

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock package.json yarn.lock ./
RUN \
  bundle install --without development test && \
  npm install -g yarn && \
  yarn

COPY . .

EXPOSE 3000

CMD deploy/docker-entrypoint.sh
