# The below image is created out of the Dockerfile.base
# It has the dependencies already installed so that codespace will boot up fast
FROM ghcr.io/chatwoot/chatwoot_codespace:latest

# Do the set up required for chatwoot app
WORKDIR /workspace
COPY . /workspace

# Configurar cache do Yarn
RUN yarn config set cache-folder /yarn_cache

# Copiar o cache do Yarn se disponível
COPY yarn_cache /yarn_cache

# Instalar dependências do Yarn
RUN yarn install --network-concurrency 1

# Configurar cache do Bundler
ENV BUNDLE_PATH /bundle_cache

# Instalar dependências do Bundler
RUN gem install bundler && bundle install
