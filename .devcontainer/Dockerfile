# The below image is created out of the Dockerfile.base
# It has the dependencies already installed so that codespace will boot up fast
FROM ghcr.io/chatwoot/chatwoot_codespace:latest

# Do the set up required for chatwoot app
WORKDIR /workspace

# Configurar cache do Yarn
RUN yarn config set cache-folder /yarn_cache

# Copiar arquivos de cache do Yarn se disponíveis
COPY yarn_cache /yarn_cache

# Copiar arquivos de dependências e instalar
COPY package.json yarn.lock ./
RUN yarn install --network-timeout 600000

# Configurar cache do Bundler
ENV BUNDLE_PATH /bundle_cache

# Copiar arquivos de dependências Ruby e instalar
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install

# Copiar restante do código
COPY . .
