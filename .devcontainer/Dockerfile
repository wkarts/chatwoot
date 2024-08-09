# The below image is created out of the Dockerfile.base
# It has the dependencies already installed so that codespace will boot up fast
F# Base image
FROM ghcr.io/chatwoot/chatwoot_codespace:latest

# Set the working directory
WORKDIR /workspace

# Copy the application code
COPY . /workspace

# Set environment variables for Yarn
ENV YARN_CACHE_FOLDER=/workspace/.cache/yarn
ENV YARN_NETWORK_TIMEOUT=10800000  # Set the timeout to 3 hours

# Install dependencies with retry and cache
RUN mkdir -p $YARN_CACHE_FOLDER && \
    yarn config set yarn-offline-mirror $YARN_CACHE_FOLDER && \
    yarn config set network-timeout $YARN_NETWORK_TIMEOUT && \
    until yarn install --network-timeout $YARN_NETWORK_TIMEOUT; do \
        echo "Retrying yarn install..."; \
        sleep 10; \
    done && \
    gem install bundler && bundle install
