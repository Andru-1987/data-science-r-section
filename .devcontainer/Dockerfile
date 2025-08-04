FROM rocker/r-ver:latest

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libmariadb-dev \
    mariadb-client \
    sqlite3 \
    && rm -rf /var/lib/apt/lists/*

# Establecer carpeta de trabajo
WORKDIR /workspaces/R-Clases

# Copiar tu código al contenedor
COPY ./R-Clases /workspaces/R-Clases
