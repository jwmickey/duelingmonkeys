FROM ubuntu:jammy

RUN apt-get update && apt-get upgrade -y && \
    apt-get install ruby-full build-essential zlib1g-dev curl git nodejs npm libmagickwand-dev -y

RUN npm install -g bower

RUN gem install jekyll bundler

EXPOSE 4000

ENTRYPOINT [ "bash" ]
