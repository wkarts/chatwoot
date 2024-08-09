# The below image is created out of the Dockerfile.base
# It has the dependencies already installed so that codespace will boot up fast
FROM ghcr.io/chatwoot/chatwoot_codespace:latest

# Do the set up required for chatwoot app
WORKDIR /workspace
COPY . /workspace

# Configurações de retry para yarn install
RUN yarn config set network-timeout 300000 && \
    for i in 1 2 3; do yarn install && break || sleep 10; done && \
    gem install bundler && bundle install
