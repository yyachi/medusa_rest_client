FROM ruby:2.3

#RUN bundle config --global frozen 1
WORKDIR /usr/src/app
COPy ./data/dotorochirc /root/.orochirc
COPY . .
RUN bundle install
CMD ["/bin/sh"]