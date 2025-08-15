FROM rocker/r-ver:latest

# Evitar prompts interactivos durante build
ENV DEBIAN_FRONTEND=noninteractive

# CAPA 1: Actualizar sistema (cambia poco frecuentemente)
RUN apt-get update && apt-get upgrade -y

# CAPA 2: Instalar dependencias del sistema base (casi nunca cambian)
RUN apt-get install -y \
    wget \
    curl \
    git \
    sqlite3 \
    && rm -rf /var/lib/apt/lists/*

# CAPA 3: Instalar dependencias de desarrollo (cambian raramente)
RUN apt-get update && apt-get install -y \
    libfontconfig1-dev \
    libcairo2-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libmariadb-dev \
    && rm -rf /var/lib/apt/lists/*

# CAPA 4: Instalar MariaDB client y fuentes (cambian raramente)
RUN apt-get update && apt-get install -y \
    mariadb-client \
    fonts-dejavu \
    && rm -rf /var/lib/apt/lists/*

# CAPA 5: Instalar Python (versión específica, cambia ocasionalmente)
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev libssl-dev libxml2-dev libfontconfig1-dev libcairo2-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev libharfbuzz-dev libfribidi-dev \
    python3 \
    python3-pip \
    python3-venv \
    pipx \
    && rm -rf /var/lib/apt/lists/*

# CAPA 6: Configurar PATH para pipx (cambia raramente)
ENV PATH="/root/.local/bin:$PATH"

# CAPA 7: Instalar radian con pipx (puede cambiar si actualizas la versión)
RUN pipx install radian && pipx ensurepath

# CAPA 8: Instalar pandoc (versión específica, cambiar solo cuando quieras actualizar)
RUN wget https://github.com/jgm/pandoc/releases/download/3.1.11.1/pandoc-3.1.11.1-1-amd64.deb && \
    dpkg -i pandoc-3.1.11.1-1-amd64.deb && \
    rm pandoc-3.1.11.1-1-amd64.deb

# CAPA 9: Instalar paquetes R base (tinytex cambia poco frecuentemente)
RUN Rscript -e "install.packages('tinytex', repos='https://cloud.r-project.org')" && \
    Rscript -e "tinytex::install_tinytex()"

# CAPA 10: Copiar archivos de configuración (cambia cuando modificas el script)
COPY post-create.sh /workspaces/post-create.sh
RUN chmod +x /workspaces/post-create.sh

# CAPA 11: Establecer directorio de trabajo (casi nunca cambia)
WORKDIR /workspaces/R-Clases
