# The below image is created out of the Dockerfile.base
# It has the dependencies already installed so that codespace will boot up fast
FROM ghcr.io/chatwoot/chatwoot_codespace:latest

# Do the set up required for chatwoot app
WORKDIR /workspace
COPY . /workspace

RUN yarn config set network-timeout 9999999999
RUN apk add g++ make py3-pip
RUN yarn global add node-gyp

RUN yarn && gem install bundler && bundle install
