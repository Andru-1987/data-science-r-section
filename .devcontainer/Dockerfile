FROM rocker/r-ver:latest

# Evitar prompts interactivos durante build
ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependencias del sistema

RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libmariadb-dev \
    mariadb-client \
    sqlite3 \
    wget \
    curl \
    git \
    fonts-dejavu \
    python3 \
    python3-pip \
    python3-venv \
    pipx \
    && rm -rf /var/lib/apt/lists/*

# Instalar radian usando pipx (recomendado para aplicaciones Python)
RUN pipx install radian && pipx ensurepath

# O alternativamente, usar pip con --break-system-packages (menos recomendado)
# RUN pip3 install --no-cache-dir --break-system-packages radian

# Instalar pandoc
RUN wget https://github.com/jgm/pandoc/releases/download/3.1.11.1/pandoc-3.1.11.1-1-amd64.deb && \
    dpkg -i pandoc-3.1.11.1-1-amd64.deb && \
    rm pandoc-3.1.11.1-1-amd64.deb

# Instalar TinyTeX para soporte PDF
RUN Rscript -e "install.packages('tinytex', repos='https://cloud.r-project.org')" && \
    Rscript -e "tinytex::install_tinytex()"

# Agregar pipx y radian al PATH
ENV PATH="/root/.local/bin:$PATH"


COPY post-create.sh /workspaces/post-create.sh
RUN chmod +x /workspaces/post-create.sh

# Establecer carpeta de trabajo
WORKDIR /workspaces/R-Clases
