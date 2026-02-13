FROM ubuntu:jammy

RUN apt-get update && apt-get upgrade -y && \
    apt-get install ruby-full build-essential zlib1g-dev curl git nodejs npm libmagickwand-dev -y

RUN gem install jekyll bundler aws-sdk-s3

ENV GEM_HOME=/usr/local/bundle \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_APP_CONFIG=/usr/local/bundle \
    PATH=/usr/local/bundle/bin:$PATH

WORKDIR /site

COPY Gemfile Gemfile.lock* ./

RUN bundle install

EXPOSE 4000

ENTRYPOINT [ "bash" ]
