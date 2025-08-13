library(shiny)
library(plotly)
library(tidyverse)
library(mclust)

# Cargar datos y PCA
wineUrl <- 'http://archive.ics.uci.edu/ml/machine-learning-databases/wine/wine.data'
column_names <- c('Cultivo', 'Alcohol', 'Malic.acid','Ash', 'Alcalinity.of.ash','Magnesium', 'Total.phenols','Flavanoids', 'Nonflavanoid.phenols','Proanthocyanin', 'Color.intensity','Hue', 'OD280.OD315.of.diluted.wines','Proline')
# retiramos la columna Cultivo -> pues es el campo que nos va a dar su sector o segmento.
wine <- read.table(wineUrl, header=FALSE, sep=',', stringsAsFactors=FALSE, col.names=column_names) %>% as_tibble()


wine_features <- wine %>% select(-Cultivo)
wine_scaled <- scale(wine_features)
pca_3d <- prcomp(wine_scaled, center = TRUE, scale. = TRUE)
pca_data <- as_tibble(pca_3d$x[, 1:3])

# UI
ui <- fluidPage(
  titlePanel("Visualización de Clustering con PCA 3D"),
  sidebarLayout(
    sidebarPanel(
      selectInput("modelo", "Seleccionar modelo:", choices = c("KMeans", "GMM")),
      sliderInput("clusters", "Cantidad de clusters:", min = 2, max = 10, value = 3)
    ),
    mainPanel(
      plotlyOutput("pcaPlot")
    )
  )
)

# Server
server <- function(input, output) {
  output$pcaPlot <- renderPlotly({
    if (input$modelo == "KMeans") {
      modelo <- kmeans(pca_data, centers = input$clusters)
      pca_data$cluster <- as.factor(modelo$cluster)
    #   colores <- "Viridis"
    } else {
      modelo <- Mclust(pca_data, G = input$clusters)
      pca_data$cluster <- as.factor(modelo$classification)
    #   colores <- "Inferno"
    }

    plot_ly(pca_data, x = ~PC1, y = ~PC2, z = ~PC3,
            color = ~cluster, # colors = colores,
            type = "scatter3d", mode = "markers") %>%
      layout(title = paste(input$modelo, "con", input$clusters, "clusters"))
  })
}

# Run app
shinyApp(ui = ui, server = server)
