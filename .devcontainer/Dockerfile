# The below image is created out of the Dockerfile.base
# It has the dependencies already installed so that codespace will boot up fast
FROM ghcr.io/chatwoot/chatwoot_codespace:latest

# Set environment variable for Yarn network timeout
ARG YARN_NETWORK_TIMEOUT=10800000
ENV YARN_NETWORK_TIMEOUT=$YARN_NETWORK_TIMEOUT

# Do the set up required for chatwoot app
WORKDIR /workspace
COPY . /workspace

# Configure Yarn network timeout and install dependencies
RUN yarn config set network-timeout $YARN_NETWORK_TIMEOUT && \
    yarn && \
    gem install bundler && \
    bundle install
