#!/bin/bash

# Post-creation script for R dev container (non-root user)
set -e

echo "*****************************************************************************"
echo "Setting up R development environment..."

# --- Crear carpeta de librería de usuario ---
USER_R_LIB="$HOME/R/library"
mkdir -p "$USER_R_LIB"

# --- Asegurarse de que ~/.local/bin esté en PATH ---
export PATH="$HOME/.local/bin:$PATH"

# --- Instalar paquete individual ---
Rscript -e "install.packages('languageserver', repos='https://cloud.r-project.org', lib='$USER_R_LIB')"

# --- Instalar paquetes R principales ---
Rscript -e "install.packages(
  c('readr','dplyr','DBI','RMySQL','RSQLite','plumber','rmarkdown','knitr','here','tidyverse','tidymodels'),
  repos='https://cloud.r-project.org',
  lib='$USER_R_LIB'
)"

# --- Crear .Rprofile en home del usuario ---
cat > "$HOME/.Rprofile" << 'EOF'
# Project .Rprofile
options(
  repos = c(CRAN = "https://cloud.r-project.org"),
  browser = "false",
  max.print = 100,
  scipen = 10,
  digits = 4
)

# Cargar paquetes comúnmente usados
if (interactive()) {
  suppressMessages({
    if(requireNamespace("here", quietly = TRUE)) require(here)
    if(requireNamespace("dplyr", quietly = TRUE)) require(dplyr)
  })

  cat("R Environment Ready!\n")
  cat("Working directory:", getwd(), "\n")
  cat("R-Clases folder available\n")
}
EOF

echo "*****************************************************************************"
echo "Setup complete. Your R development environment is ready."
echo "You can run 'radian' for an enhanced R console (already in your PATH)."
echo "Your R files should go inside the R-Clases/ folder."
