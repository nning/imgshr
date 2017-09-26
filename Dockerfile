from ruby:2.4.2-jessie

RUN set -ex; \
	apt-get update; \
  apt-get install -y --no-install-recommends \
          qt5-default \
          libqt5webkit5-dev \
          gstreamer1.0-plugins-base \
          gstreamer1.0-tools gstreamer1.0-x; \
  rm -rf /var/lib/apt/lists/*

ENV INSTALL_PATH /app
ENV PATH=${INSTALL_PATH}/bin:$PATH
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install
COPY . .
