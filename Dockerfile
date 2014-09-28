FROM ruby

RUN mkdir /blog
WORKDIR /blog

ADD Gemfile /blog/Gemfile
ADD Gemfile.lock /blog/Gemfile.lock
RUN bundle install

RUN git config --global user.email "leonsbox@gmail.com"
RUN git config --global user.name "Leonid Bugaev"