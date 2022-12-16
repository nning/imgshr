# IMGSHR

[![Build Status](https://img.shields.io/github/actions/workflow/status/nning/imgshr/test.yml?branch=main)](https://github.com/nning/imgshr/actions?query=workflow%3A%22Run+tests%22)
[![Maintainability](https://img.shields.io/codeclimate/maintainability/nning/imgshr.svg)](https://codeclimate.com/github/nning/imgshr)
[![Coverage](https://img.shields.io/coveralls/nning/imgshr/master.svg)](https://coveralls.io/r/nning/imgshr)


Simple image gallery sharing application. Galleries are creatable by everyone
and available with a token in the URL. Everyone with the correct URL can change
the gallery name, upload images and set their title. On creation, a boss token
is generated, which can be used to delete the whole gallery, single pictures or
make the gallery read-only later on.

You can test this at https://imgshr.space!

## Features

* Galleries are shared via secret token in URL
  (e.g. [https://imgshr.space/!Njg4NThi](https://imgshr.space/!Njg4NThi))
* Galleries are editable by everyone or -- when they are configured to be
  read-only -- only with a boss token (URL)
* Pictures can be shared with token URLs to prevent giving away a gallery's
  token
* EXIF data is read and shown
* Pictures can be rated
* Infinite scrolling on gallery page
* Lazy image loading
* Responsive design
* Tagging of images
* Filter by tags, date, rating
* Automatic labelling using self-hosted Convolutional Neural Network
  (Inception v3 model)
* GitHub login for taking track of galleries and gallery administration
* Device token authentication for galleries
* Symmetric client-side encrypted galleries with sharable secret based on
  libsodium (XSalsa20 for encryption, Poly1305 for authentication)
* "Responsive Images Service": Resize and convert to webp for inclusion in
  third-party sites
* Milestones can be set by gallery and shown on images (e.g. for showing time
  since a certain event on photos)

## Development

    nvm use
	npm install -g yarn
	yarn
	bundle
	foreman start

## Deployment using docker

### Initial setup

Clone the source code:

    git clone https://github.com/nning/imgshr.git
    cd imgshr

Change the MySQL root password and the admin login credentials in `.env` and
`config/settings.yml`.

Then generate a Rails secret key and paste it into `.env`:

    ./deploy.sh run web rails secret

Now start up all services (in background):

    ./deploy.sh up -d

**The docker volumes `deploy_db`, `deploy_redis`, and `deploy_storage` hold the
production data; make sure, you do not lose them.**

The log can be followed with:

    ./deploy.sh logs -f

### Update the code

    ./deploy.sh down
    git pull
    ./deploy.sh up --build

### traefik example

See `examples/traefik` as a starting point for a deployment with traefik and Let's Encrypt.

## License

Copyright © 2014-2021 [henning mueller](https://nning.io/), released
under the terms of [GNU AGPL 3.0](http://www.gnu.org/licenses/agpl-3.0.html).
