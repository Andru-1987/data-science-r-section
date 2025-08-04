FROM rocker/r-ver:latest

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libmariadb-dev \
    mariadb-client \
    sqlite3 \
    wget \
    fonts-dejavu \
    && rm -rf /var/lib/apt/lists/*

# Instalar pandoc
RUN wget https://github.com/jgm/pandoc/releases/download/3.1.11.1/pandoc-3.1.11.1-1-amd64.deb && \
    dpkg -i pandoc-3.1.11.1-1-amd64.deb && \
    rm pandoc-3.1.11.1-1-amd64.deb

# Instalar TinyTeX para soporte PDF
RUN Rscript -e "install.packages('tinytex', repos='https://cloud.r-project.org')" && \
    Rscript -e "tinytex::install_tinytex()"

# Establecer carpeta de trabajo (volumen se montará desde fuera)
WORKDIR /workspaces/R-Clases
