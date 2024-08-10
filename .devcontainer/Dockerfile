# The below image is created out of the Dockerfile.base
# It has the dependencies already installed so that codespace will boot up fast
FROM ghcr.io/chatwoot/chatwoot_codespace:latest

# Define o diretório de trabalho
WORKDIR /workspace

# Instala a versão correta do Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Copia o código da aplicação e o cache do Yarn
COPY . /workspace
COPY yarn-cache.tar.gz /workspace/

# Extrai o cache e configura o Yarn para usar esse cache
RUN tar -xzf yarn-cache.tar.gz -C /workspace/ && \
    yarn install --offline --modules-folder /workspace/.yarn-cache

# Executa as outras instalações necessárias
RUN gem install bundler && bundle install
