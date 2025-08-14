library(shiny)
library(plotly)
library(tidyverse)
library(mclust)
library(viridis)

# Rutas de modelos
model_dir <- "R-Clases/week-2/clase_9/models"
kmeans_path <- file.path(model_dir, "modelo_kmeans.rds")
gmm_path <- file.path(model_dir, "modelo_gmm.rds")
pca_path <- file.path(model_dir, "preprocesamiento_pca.rds")

# Cargar datos
wineUrl <- 'http://archive.ics.uci.edu/ml/machine-learning-databases/wine/wine.data'
column_names <- c('Cultivo', 'Alcohol', 'Malic.acid','Ash', 'Alcalinity.of.ash','Magnesium',
                  'Total.phenols','Flavanoids', 'Nonflavanoid.phenols','Proanthocyanin',
                  'Color.intensity','Hue', 'OD280.OD315.of.diluted.wines','Proline')
wine <- read.table(wineUrl, header=FALSE, sep=',', stringsAsFactors=FALSE, col.names=column_names) %>% as_tibble()
wine_features <- wine %>% select(-Cultivo)
wine_scaled <- scale(wine_features)
pca_3d <- prcomp(wine_scaled, center = TRUE, scale. = TRUE)
pca_data <- as_tibble(pca_3d$x[, 1:3])

# Cargar modelos guardados
kmeans_model <- readRDS(kmeans_path)
gmm_model <- readRDS(gmm_path)

# UI
ui <- fluidPage(
  titlePanel("Visualización de Clustering con PCA 3D"),
  sidebarLayout(
    sidebarPanel(
      selectInput("modelo", "Seleccionar modelo:", choices = c("KMeans", "GMM")),
      h4("Nueva observación"),
      numericInput("Alcohol", "Alcohol:", value = 13),
      numericInput("Malic.acid", "Malic.acid:", value = 2),
      numericInput("Ash", "Ash:", value = 2.5),
      numericInput("Alcalinity.of.ash", "Alcalinity.of.ash:", value = 16),
      numericInput("Magnesium", "Magnesium:", value = 100),
      numericInput("Total.phenols", "Total.phenols:", value = 2.5),
      numericInput("Flavanoids", "Flavanoids:", value = 2),
      numericInput("Nonflavanoid.phenols", "Nonflavanoid.phenols:", value = 0.3),
      numericInput("Proanthocyanin", "Proanthocyanin:", value = 1.5),
      numericInput("Color.intensity", "Color.intensity:", value = 5),
      numericInput("Hue", "Hue:", value = 1),
      numericInput("OD280.OD315.of.diluted.wines", "OD280/OD315:", value = 3),
      numericInput("Proline", "Proline:", value = 750),
      actionButton("predict_btn", "Predecir cluster")
    ),
    mainPanel(
      plotlyOutput("pcaPlot"),
      verbatimTextOutput("new_pred")
    )
  )
)

# Server
server <- function(input, output) {

  # Mostrar clusters existentes en PCA 3D
  output$pcaPlot <- renderPlotly({
    df <- pca_data
    df$cluster_kmeans <- as.factor(kmeans_model$cluster)
    df$cluster_gmm <- as.factor(gmm_model$classification)
    
    # Selección de cluster para visualización
    df$cluster <- if(input$modelo == "KMeans") df$cluster_kmeans else df$cluster_gmm
    colors <- if(input$modelo == "KMeans") viridis(length(unique(df$cluster))) else inferno(length(unique(df$cluster)))
    
    plot_ly(df, x = ~PC1, y = ~PC2, z = ~PC3,
            color = ~cluster, colors = colors,
            type = "scatter3d", mode = "markers") %>%
      layout(title = paste(input$modelo, "Clusters"))
  })
  
  # Predicción de nueva observación al presionar el botón
  observeEvent(input$predict_btn, {
    new_obs <- tibble(
      Alcohol = input$Alcohol,
      Malic.acid = input$Malic.acid,
      Ash = input$Ash,
      Alcalinity.of.ash = input$Alcalinity.of.ash,
      Magnesium = input$Magnesium,
      Total.phenols = input$Total.phenols,
      Flavanoids = input$Flavanoids,
      Nonflavanoid.phenols = input$Nonflavanoid.phenols,
      Proanthocyanin = input$Proanthocyanin,
      Color.intensity = input$Color.intensity,
      Hue = input$Hue,
      OD280.OD315.of.diluted.wines = input$OD280.OD315.of.diluted.wines,
      Proline = input$Proline
    )
    
    # Asegurar mismo orden de columnas
    new_obs <- new_obs %>% select(all_of(colnames(wine_features)))
    
    # Escalar y proyectar PCA
    new_scaled <- scale(new_obs, center = attr(wine_scaled, "scaled:center"),
                                  scale = attr(wine_scaled, "scaled:scale"))
    # Evitar problemas con vectores de una sola fila
    new_pca <- predict(pca_3d, new_scaled)[,1:3, drop = FALSE]
    colnames(new_pca) <- colnames(pca_data)
    
    # Predecir cluster usando modelos guardados
    cluster <- if(input$modelo == "KMeans") {
      dists <- sapply(1:nrow(kmeans_model$centers), function(i){
        rowSums((new_pca - kmeans_model$centers[i, ])^2)
      })
      which.min(dists)
    } else {
      predict(gmm_model, new_pca)$classification
    }
    
    output$new_pred <- renderText({
      paste("La nueva observación pertenece al cluster:", cluster)
    })
  })
}

# Run app en puerto específico
shinyApp(ui = ui, server = server, options = list(port = 5555, host = "127.0.0.1"))
