# The below image is created out of the Dockerfile.base
# It has the dependencies already installed so that codespace will boot up fast
# Utilize a imagem personalizada do Codespace
FROM ghcr.io/wkarts/hub_codespace:latest

# Defina o diretório de trabalho
WORKDIR /workspace

# Copie os arquivos de configuração do yarn
COPY package.json yarn.lock ./

# Instale as dependências usando cache
RUN yarn config set cache-folder /workspace/.yarn-cache && \
    yarn install --silent

# Copie o restante da aplicação
COPY . /workspace

# Instale as dependências do Ruby
RUN gem install bundler && bundle install
