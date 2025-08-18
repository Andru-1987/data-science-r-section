#!/bin/bash
set -e

echo "*****************************************************************************"
echo "Setting up R development environment..."

# --- Librería de usuario ---
USER_R_LIB="$HOME/R/library"
mkdir -p "$USER_R_LIB"

# --- PATH para radian ---
export PATH="$HOME/.local/bin:$PATH"

# --- Instalar paquetes R ---
Rscript -e "install.packages(
  c('languageserver','readr','dplyr','DBI','RMySQL','RSQLite','plumber','rmarkdown','knitr','here','tidyverse','tidymodels'),
  repos='https://cloud.r-project.org',
  lib='$USER_R_LIB'
)"

# --- Crear .Rprofile ---
cat > "$HOME/.Rprofile" << 'EOF'
options(
  repos = c(CRAN = "https://cloud.r-project.org"),
  browser = "false",
  max.print = 100,
  scipen = 10,
  digits = 4
)

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
echo "Run 'radian' for an enhanced R console (already in PATH)."
echo "Your R files go inside the R-Clases/ folder."
