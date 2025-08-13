library(shiny)
library(tidymodels)
library(tibble)

# Carga tus modelos (ajusta las rutas)
nb_fit <- readRDS("R-Clases/week-2/clase_8/models/nb_fit.rds")
bayes_fit <- readRDS("R-Clases/week-2/clase_8/models/bayes_fit.rds")

# Variables que vas a pedir para la predicción
vars_input <- c("Ant_HPV", "PAP", "Fumador", "Otros_Ant", "Preservativo", "Embarazos", "Anticoncepción", "Vacuna")

# Para obtener niveles/factores de df original (supongo que df ya cargado y limpio)
df <- readr::read_csv("https://raw.githubusercontent.com/Andru-1987/csv_files_ds/refs/heads/main/BD_HPV.csv", show_col_types = FALSE)
df <- df %>% select(all_of(vars_input))
# Asegurar que todas las variables sean factores con los niveles originales
df <- df %>% mutate(across(everything(), as.factor))

ui <- fluidPage(
  titlePanel("Predicción de HPV- > Naive Bayes y Bayes Logístico"),
  
  sidebarLayout(
    sidebarPanel(
      # Crear inputs dinámicos para cada variable
      lapply(vars_input, function(var) {
        selectInput(
          inputId = var,
          label = var,
          choices = levels(df[[var]])
        )
      }),
      actionButton("predict", "Predecir")
    ),
    mainPanel(
      h2("Predicción Naive Bayes:"),
      verbatimTextOutput("pred_nb"),
      h5("Probabilidades:"),
      tableOutput("prob_nb"),
      
      hr(),

      h2("Predicción Bayes Logístico:"),
      verbatimTextOutput("pred_bayes"),
      h5("Probabilidades:"),
      tableOutput("prob_bayes")
    )
  )
)

server <- function(input, output) {
  
  observeEvent(input$predict, {
    # Crear un tibble con los inputs y asegurar factores con niveles correctos
    new_data <- tibble(
      !!!setNames(
        lapply(vars_input, function(var) factor(input[[var]], levels = levels(df[[var]]))),
        vars_input
      )
    )
    
    # Predicción Naive Bayes
    pred_nb <- predict(nb_fit, new_data, type = "class")
    probs_nb <- predict(nb_fit, new_data, type = "prob")
    
    output$pred_nb <- renderText({
      paste("Clase predicha:", as.character(pred_nb$.pred_class))
    })
    output$prob_nb <- renderTable(probs_nb)
    
    # Predicción Bayes Logístico
    pred_bayes <- predict(bayes_fit, new_data, type = "class")
    probs_bayes <- predict(bayes_fit, new_data, type = "prob")
    
    output$pred_bayes <- renderText({
      paste("Clase predicha:", as.character(pred_bayes$.pred_class))
    })
    output$prob_bayes <- renderTable(probs_bayes)
  })
}

shinyApp(ui, server)
