FROM rocker/r-ver:latest

RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    sqlite3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspaces/R-Clases

COPY ./R-Clases /workspaces/R-Clases
