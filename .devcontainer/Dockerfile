# The below image is created out of the Dockerfile.base
# It has the dependencies already installed so that codespace will boot up fast
FROM ghcr.io/chatwoot/chatwoot_codespace:latest

# Define o diretório de trabalho
WORKDIR /workspace

# Copia os arquivos de código
COPY . /workspace

# Instala as dependências usando Yarn
RUN yarn && gem install bundler && bundle install

