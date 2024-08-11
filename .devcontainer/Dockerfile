# Use a imagem codespace personalizada como base
FROM ghcr.io/wkarts/chatwoot/custom-codespace:latest

# Defina o diretório de trabalho
WORKDIR /workspace

# Copie o código da aplicação para o diretório de trabalho
COPY . /workspace

# Instale as dependências da aplicação
RUN yarn install --silent --modules-folder /workspace/.yarn-cache && \
    gem install bundler && bundle install

# Comando de entrada padrão (ajuste conforme necessário)
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
