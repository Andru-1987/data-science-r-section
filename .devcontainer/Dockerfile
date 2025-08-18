FROM rocker/r-ver:latest

ENV DEBIAN_FRONTEND=noninteractive

# --- Sistema base ---
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y \
    wget curl git sqlite3 \
    && rm -rf /var/lib/apt/lists/*

# --- Dependencias de desarrollo ---
RUN apt-get update && apt-get install -y \
    libfontconfig1-dev libcairo2-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev \
    libcurl4-openssl-dev libssl-dev libxml2-dev libmariadb-dev libharfbuzz-dev libfribidi-dev \
    python3 python3-pip python3-venv pipx \
    mariadb-client fonts-dejavu \
    && rm -rf /var/lib/apt/lists/*

# --- Instalar Pandoc globalmente ---
RUN wget https://github.com/jgm/pandoc/releases/download/3.1.11.1/pandoc-3.1.11.1-1-amd64.deb \
    && dpkg -i pandoc-3.1.11.1-1-amd64.deb \
    && rm pandoc-3.1.11.1-1-amd64.deb

# --- Copiar script post-create ---
COPY post-create.sh /workspaces/post-create.sh
RUN chmod +x /workspaces/post-create.sh

# --- Crear usuario no root ---
ARG USERNAME=devuser
ARG USER_UID=1000
ARG USER_GID=1000

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && chown -R $USERNAME:$USERNAME /workspaces

# --- Cambiar a usuario no root ---
USER $USERNAME
WORKDIR /workspaces/R-Clases

# --- Instalar radian como devuser ---
RUN pipx install radian
ENV PATH="$HOME/.local/bin:$PATH"
