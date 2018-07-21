IMGSHR
======

[![Build Status](https://img.shields.io/travis/nning/imgshr/master.svg)](https://travis-ci.org/nning/imgshr)
[![Maintainability](https://img.shields.io/codeclimate/maintainability/nning/imgshr.svg)](https://codeclimate.com/github/nning/imgshr)
[![Coverage](https://img.shields.io/coveralls/nning/imgshr/master.svg)](https://coveralls.io/r/nning/imgshr)


Simple image gallery sharing application. Galleries are creatable by everyone
and available with a token in the URL. Everyone with the correct URL can change
the gallery name, upload images and set their title. On creation, a boss token
is generated, which can be used to delete the whole gallery, single pictures or
make the gallery read-only later on.

You can test this at https://imgshr.space!

Features
--------

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
)

Development
-----------

    nvm use
	npm install -g yarn
	yarn
	bundle
	foreman start

Setup
-------

Make sure you have a running version of docker as well as docker-compose installed. For a working development environment run the following commands:

```
$ git clone https://github.com/nning/imgshr.git
$ cd imgshr
$ docker-compose up
$ docker-compose run imgshr rake db:setup
```

Point your browser to `http://localhost:3000`

To run the tests:

```
$ docker-compose run imgshr rails test
```

Please make sure you set up the database properly before running the tests.

License
-------

Copyright © 2014-2016 [henning mueller](https://nning.io/), released
under the terms of [GNU AGPL 3.0](http://www.gnu.org/licenses/agpl-3.0.html).
