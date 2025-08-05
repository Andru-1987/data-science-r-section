#!/bin/bash

# Post-creation script for R dev container
set -e
echo "*****************************************************************************"
echo "Setting up R development environment..."

# Create symlink so VS Code can find radian where it expects
mkdir -p /usr/local/bin
ln -sf /root/.local/bin/radian /usr/local/bin/radian

# Install R packages
Rscript -e "
install.packages(c(
  'readr', 
  'dplyr', 
  'DBI', 
  'RMySQL', 
  'RSQLite', 
  'plumber', 
  'languageserver', 
  'rmarkdown', 
  'knitr', 
  'here', 
  'tidyverse'
), repos='https://cloud.r-project.org')
"


# Set up .Rprofile for project
cat > .Rprofile << 'EOF'
# Project .Rprofile
options(
  repos = c(CRAN = "https://cloud.r-project.org"),
  browser = "false",
  max.print = 100,
  scipen = 10,
  digits = 4
)

# Load commonly used packages
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

echo "Setup complete. Your R development environment is ready."
echo "You can run 'radian' for an enhanced R console."
echo "Your R files should go inside the R-Clases/ folder."
