# The below image is created out of the Dockerfile.base
# It has the dependencies already installed so that codespace will boot up fast
#FROM ghcr.io/chatwoot/chatwoot_codespace:latest

# Use uma imagem base compatível com ARM64
FROM arm64v8/ruby:3.3.3-alpine3.19

# Define o diretório de trabalho
WORKDIR /workspace

# Instala dependências
RUN apk update && apk add --no-cache \
    openssl \
    tar \
    build-base \
    tzdata \
    postgresql-dev \
    postgresql-client \
    nodejs \
    yarn \
    git \
    && mkdir -p /var/app \
    && gem install bundler

# Copia o código da aplicação
COPY . /workspace

# Configura o cache do Yarn e instala as dependências
RUN yarn config set cache-folder $(pwd)/.yarn-cache && \
    yarn install --modules-folder $(pwd)/.yarn-cache --silent --ignore-engines --ignore-scripts

# Roda outras tarefas de instalação
RUN gem install bundler && bundle install

# Comando final para o container
CMD ["your-start-command-here"]
