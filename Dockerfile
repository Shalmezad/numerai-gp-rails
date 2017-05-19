FROM ruby:2.3.3
# For rails
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs 
# For numerai fetch rake task:
RUN apt-get update -qq && apt-get install -y unzip
RUN mkdir /numerai
WORKDIR /numerai
ADD Gemfile /numerai/Gemfile
ADD Gemfile.lock /numerai/Gemfile.lock
RUN bundle install
ADD . /numerai
