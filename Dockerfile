FROM ruby:2.3.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /numerai
WORKDIR /numerai
ADD Gemfile /numerai/Gemfile
ADD Gemfile.lock /numerai/Gemfile.lock
RUN bundle install
ADD . /numerai
