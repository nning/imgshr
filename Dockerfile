from ruby:2.5.0-stretch

RUN set -ex; \
	apt-get update; \
  apt-get install -y --no-install-recommends \
          apt-transport-https ca-certificates

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - ; \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list; \
  curl -sL https://deb.nodesource.com/setup_8.x | bash -

RUN set -ex; \
	apt-get update; \
  apt-get install -y --no-install-recommends \
          qt5-default \
          libqt5webkit5-dev \
          gstreamer1.0-plugins-base \
          gstreamer1.0-tools gstreamer1.0-x \
          nodejs \
          yarn; \
  rm -rf /var/lib/apt/lists/*

ENV INSTALL_PATH /app
ENV PATH=${INSTALL_PATH}/bin:$PATH
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH
COPY Gemfile Gemfile.lock package.json yarn.lock ./
RUN yarn
RUN bundle
COPY . .
