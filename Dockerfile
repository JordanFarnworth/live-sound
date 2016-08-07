FROM ruby:2.3.0
MAINTAINER jyf0000@gmail.com

ENV LC_ALL C.UTF-8

RUN apt-get update
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash
ENV PHANTOMJS_VERSION 1.9.7
RUN apt-get install -y build-essential nodejs vim git wget libfreetype6 libfontconfig bzip2 && \
  mkdir -p /srv/var && \
  wget -q --no-check-certificate -O /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 && \
  tar -xjf /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 -C /tmp && \
  rm -f /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 && \
  mv /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64/ /srv/var/phantomjs && \
  ln -s /srv/var/phantomjs/bin/phantomjs /usr/bin/phantomjs && \
  git clone https://github.com/n1k0/casperjs.git /srv/var/casperjs && \
  ln -s /srv/var/casperjs/bin/casperjs /usr/bin/casperjs && \
  apt-get autoremove -y && \
  apt-get clean all

RUN mkdir -p /usr/src/app
ADD . /usr/src/app/
RUN rm /usr/src/app/.rspec && echo '--require spec_helper' > /usr/src/app/.rspec
RUN rm -rf /usr/src/app/node_modules
WORKDIR /usr/src/app

ENV RAILS_ENV test
RUN bundle install --system
RUN bundle exec rake assets:precompile
CMD mkdir /usr/src/app/tmp
