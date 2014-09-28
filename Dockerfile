FROM ruby

RUN mkdir /blog
WORKDIR /blog

ADD Gemfile /blog/Gemfile
ADD Gemfile.lock /blog/Gemfile.lock
RUN bundle install