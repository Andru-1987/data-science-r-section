#!/bin/bash

# Post-creation script for R dev container
set -e

echo "🚀 Setting up R development environment..."

# Install R packages (simplified version for your current setup)
Rscript -e "
# Install your current package list
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

# Set up Git (if not already configured)
if [ -z "$(git config --global user.name)" ]; then
    echo "⚠️  Git user not configured. Set up with:"
    echo "git config --global user.name 'Your Name'"
    echo "git config --global user.email 'your.email@example.com'"
fi

# Create common directories in R-Clases if they don't exist
mkdir -p R-Clases/{data,output,scripts,reports}

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
  
  cat("📊 R Environment Ready!\n")
  cat("📁 Working directory:", getwd(), "\n")
  cat("📂 R-Clases folder available\n")
}
EOF

echo "✅ Setup complete! Your R development environment is ready."
echo "🔧 Run 'radian' for an enhanced R console experience."
echo "📁 Your R files should be in the R-Clases/ folder"