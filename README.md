Grape API Skeleton
===================

###Technology###

1. Ruby-2.3.0
2. Postgres (as permanent data store)
4. Grape
5. Thin (as app server in Development)
6. Unicorn (as app server in Production)
7. RabbitMQ (as messaging system)

### Setup ###
Install Dependencies
--------------------

  For mac

      brew install postgres
      brew install rabbitmq

  For Debian

      apt-get install postgres
      apt-get install rabbitmq

  bundle install

Start Servers
-------------
    pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start
    rabbitmq-server


Setup Configuration
-------------------

    ./configure

Setup Database
--------------

    bundle exec rake db:create

    bundle exec rake db:migrate

    bundle exec rake db:test:prepare

Bring up App Server
-------------------
    bundle exec thin start -p3011

Run test
-------------------
    bundle exec rspec
      or
    COVERAGE=true bundle exec rspec
      or
    bundle exec guard [Watches every file save and runs the specs]
    (make changes Guardfile that suits your need)

Ruby StyleGuide check
---------------------
  bundle exec rubocop


Interactive Session via Terminal
--------------------------------

    bundle exec tux
