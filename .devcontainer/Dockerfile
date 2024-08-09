# The below image is created out of the Dockerfile.base
# It has the dependencies already installed so that codespace will boot up fast
FROM ghcr.io/chatwoot/chatwoot_codespace:latest

# Do the set up required for chatwoot app
WORKDIR /workspace
COPY . /workspace

# Set Yarn network timeout to 3 hours
RUN yarn config set network-timeout 10800000

# Retry logic for Yarn install with 5 retries
RUN for i in {1..5}; do yarn install && break || sleep 10; done

RUN gem install bundler && bundle install
