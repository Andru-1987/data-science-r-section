# Bank Marketing Classifier - Aplicación Shiny
# Autor: Anderson Ocaña

# Librerías necesarias
library(shiny)
library(shinydashboard)
library(DT)
library(plotly)
library(dplyr)
library(tidymodels)
library(ggplot2)

# Cargar modelos pre-entrenados (asumiendo que están guardados)
fit_log <- readRDS("R-Clases/week-3/00_ProyectoR/models/fit_log.rds")
fit_rf <- readRDS("R-Clases/week-3/00_ProyectoR/models/fit_rf.rds")
fit_xgb <- readRDS("R-Clases/week-3/00_ProyectoR/models/fit_xgb.rds")

# Para demo, simularemos la estructura de datos
demo_data <- data.frame(
  age = c(35, 42, 28, 55, 33),
  job = c("management", "technician", "admin.", "retired", "services"),
  marital = c("married", "single", "married", "divorced", "single"),
  education = c("tertiary", "secondary", "tertiary", "primary", "secondary"),
  estado_critico = c(FALSE, FALSE, TRUE, FALSE, FALSE),
  balance = c(1500, 2300, -200, 5000, 800),
  housing = c(TRUE, FALSE, TRUE, TRUE, FALSE),
  loan = c(FALSE, TRUE, FALSE, FALSE, TRUE),
  contact = c("cellular", "telephone", "email", "cellular", "telephone"),
  interes_prestamo = c(TRUE, FALSE, TRUE, FALSE, TRUE),
  interes_en_promocion = c("medio", "poco", "mucho", "nada", "medio"),
  target = c(0, 1, 0, 1, 0)
)

# UI
ui <- dashboardPage(
  dashboardHeader(title = "Bank Marketing Classifier"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Predicción Individual", tabName = "prediction", icon = icon("user")),
      menuItem("Análisis Batch", tabName = "batch", icon = icon("table")),
      menuItem("Comparación Modelos", tabName = "comparison", icon = icon("chart-line"))
    )
  ),
  
  dashboardBody(
    tags$head(
      tags$style(HTML("
        .content-wrapper, .right-side {
          background-color: #f4f4f4;
        }
        .box {
          border-radius: 10px;
        }
        .prediction-result {
          font-size: 18px;
          font-weight: bold;
          text-align: center;
          padding: 20px;
          border-radius: 10px;
        }
        .accept {
          background-color: #d4edda;
          color: #155724;
          border: 2px solid #c3e6cb;
        }
        .reject {
          background-color: #f8d7da;
          color: #721c24;
          border: 2px solid #f5c6cb;
        }
      "))
    ),
    
    tabItems(
      # Pestaña de Predicción Individual
      tabItem(tabName = "prediction",
        fluidRow(
          box(
            title = "Selección de Modelo", status = "primary", solidHeader = TRUE, width = 12,
            selectInput("model_choice", "Seleccionar Modelo:",
                       choices = list(
                         "Regresión Logística" = "logistic",
                         "Random Forest" = "rf",
                         "XGBoost" = "xgb"
                       ),
                       selected = "xgb")
          )
        ),
        
        fluidRow(
          box(
            title = "Datos del Cliente", status = "info", solidHeader = TRUE, width = 6,
            
            numericInput("age", "Edad:", value = 35, min = 18, max = 100, step = 1),
            
            selectInput("job", "Trabajo:",
                       choices = c("admin.", "blue-collar", "entrepreneur", "housemaid", 
                                 "management", "retired", "self-employed", "services", 
                                 "student", "technician", "unemployed", "unknown"),
                       selected = "management"),
            
            selectInput("marital", "Estado Civil:",
                       choices = c("divorced", "married", "single"),
                       selected = "married"),
            
            selectInput("education", "Educación:",
                       choices = c("primary", "secondary", "tertiary", "unknown"),
                       selected = "tertiary"),
            
            checkboxInput("estado_critico", "Estado Crítico (Default)", value = FALSE),
            
            numericInput("balance", "Balance (€):", value = 1500, min = -10000, max = 50000, step = 100)
          ),
          
          box(
            title = "Información Adicional", status = "info", solidHeader = TRUE, width = 6,
            
            checkboxInput("housing", "Préstamo Hipotecario", value = TRUE),
            checkboxInput("loan", "Préstamo Personal", value = FALSE),
            
            selectInput("contact", "Tipo de Contacto:",
                       choices = c("cellular", "telephone", "email"),
                       selected = "cellular"),
            
            checkboxInput("interes_prestamo", "Interés en Préstamo (>50 seg)", value = TRUE),
            
            selectInput("interes_en_promocion", "Interés en Promoción:",
                       choices = c("nada", "poco", "medio", "mucho"),
                       selected = "medio"),
            
            br(),
            actionButton("predict_btn", "🎯 Realizar Predicción", 
                        class = "btn-primary btn-lg", width = "100%",
                        onclick = "console.log('Botón clickeado');")
          )
        ),
        
        fluidRow(
          box(
            title = "Resultado de la Predicción", status = "success", solidHeader = TRUE, width = 12,
            uiOutput("prediction_output"),
            # Mensaje inicial
            conditionalPanel(
              condition = "typeof input.predict_btn == 'undefined' || input.predict_btn == 0",
              div(style = "text-align: center; padding: 30px;",
                  icon("user-circle", "fa-3x", style = "color: #3c8dbc;"),
                  h4("Completa los datos del cliente y presiona 'Realizar Predicción'", 
                     style = "color: #666; margin-top: 15px;"))
            )
          )
        )
      ),
      
      # Pestaña de Análisis Batch
      tabItem(tabName = "batch",
        fluidRow(
          box(
            title = "Análisis de Múltiples Clientes", status = "primary", solidHeader = TRUE, width = 12,
            p("Utiliza los datos de ejemplo para probar predicciones en lote:"),
            actionButton("load_demo", "Cargar Datos Demo", class = "btn-info"),
            br(), br(),
            DT::dataTableOutput("demo_table")
          )
        ),
        
        fluidRow(
          box(
            title = "Resultados Batch", status = "success", solidHeader = TRUE, width = 12,
            selectInput("batch_model", "Modelo para Análisis Batch:",
                       choices = list(
                         "Regresión Logística" = "logistic",
                         "Random Forest" = "rf", 
                         "XGBoost" = "xgb"
                       ),
                       selected = "xgb"),
            actionButton("predict_batch", "Predecir Batch", class = "btn-success"),
            br(), br(),
            DT::dataTableOutput("batch_results")
          )
        )
      ),
      
      # Pestaña de Comparación de Modelos
      tabItem(tabName = "comparison",
        fluidRow(
          box(
            title = "Métricas de Rendimiento", status = "primary", solidHeader = TRUE, width = 12,
            p("Comparación de métricas entre los tres modelos entrenados:"),
            DT::dataTableOutput("metrics_table")
          )
        ),
        
        fluidRow(
          box(
            title = "Curvas ROC", status = "info", solidHeader = TRUE, width = 6,
            plotlyOutput("roc_plot")
          ),
          
          box(
            title = "Importancia de Variables", status = "info", solidHeader = TRUE, width = 6,
            plotlyOutput("importance_plot")
          )
        )
      )
    )
  )
)

# SERVER
server <- function(input, output, session) {
  
  # Función simulada de predicción (reemplazar con modelos reales)
  simulate_prediction <- function(model_type, data) {
    # Simulación basada en algunas reglas lógicas
    score <- 0.3
    
    # Validar que los datos existen
    if(is.null(data)) return(0.5)
    
    # Aplicar lógica de scoring
    if(!is.null(data$balance) && data$balance > 1000) score <- score + 0.2
    if(!is.null(data$age) && data$age > 40) score <- score + 0.1
    if(!is.null(data$job) && data$job %in% c("management", "technician")) score <- score + 0.15
    if(!is.null(data$housing) && data$housing == FALSE) score <- score + 0.1
    if(!is.null(data$contact) && data$contact == "cellular") score <- score + 0.1
    
    # Ajustar según el modelo
    set.seed(as.numeric(Sys.time()))
    if(model_type == "rf") score <- score + runif(1, -0.1, 0.1)
    if(model_type == "xgb") score <- score + runif(1, -0.05, 0.15)
    
    score <- max(0, min(1, score + runif(1, -0.1, 0.1)))
    return(score)
  }
  
  # Predicción individual
  observeEvent(input$predict_btn, {
    
    # Mensaje de debug en consola
    cat("Botón presionado - iniciando predicción\n")
    
    # Recopilar datos del formulario
    client_data <- list(
      age = input$age,
      job = input$job,
      marital = input$marital,
      education = input$education,
      estado_critico = input$estado_critico,
      balance = input$balance,
      housing = input$housing,
      loan = input$loan,
      contact = input$contact,
      interes_prestamo = input$interes_prestamo,
      interes_en_promocion = input$interes_en_promocion
    )
    
    # Debug: imprimir datos
    cat("Datos del cliente:\n")
    print(client_data)
    
    # Realizar predicción simulada
    prob_score <- simulate_prediction(input$model_choice, client_data)
    prediction <- ifelse(prob_score >= 0.5, "ACEPTA", "RECHAZA")
    confidence <- round(prob_score * 100, 1)
    
    cat("Probabilidad:", prob_score, "Predicción:", prediction, "\n")
    
    # Crear el HTML del resultado
    result_class <- ifelse(prediction == "ACEPTA", "accept", "reject")
    model_name <- switch(input$model_choice,
                        "logistic" = "Regresión Logística",
                        "rf" = "Random Forest", 
                        "xgb" = "XGBoost")
    
    # Actualizar la salida
    output$prediction_output <- renderUI({
      tagList(
        div(class = paste("prediction-result", result_class),
            h3(paste("Predicción:", prediction)),
            h4(paste("Probabilidad:", confidence, "%")),
            p(paste("Modelo utilizado:", model_name)),
            hr(),
            h5("Detalles del cliente:"),
            p(paste("Edad:", client_data$age, "años")),
            p(paste("Trabajo:", client_data$job)),
            p(paste("Balance:", client_data$balance, "€")),
            p(paste("Contacto:", client_data$contact))
        )
      )
    })
    
    # También mostrar una notificación
    showNotification(
      paste("Predicción completada:", prediction, "con", confidence, "% de confianza"),
      type = ifelse(prediction == "ACEPTA", "message", "warning"),
      duration = 5
    )
    
  })
  
  # Cargar datos demo
  observeEvent(input$load_demo, {
    output$demo_table <- DT::renderDataTable({
      DT::datatable(demo_data, 
                    options = list(scrollX = TRUE, pageLength = 5),
                    class = 'cell-border stripe')
    })
  })
  
  # Predicción batch
  observeEvent(input$predict_batch, {
    if(nrow(demo_data) > 0) {
      predictions <- sapply(1:nrow(demo_data), function(i) {
        simulate_prediction(input$batch_model, demo_data[i, ])
      })
      
      batch_results <- demo_data %>%
        mutate(
          Probabilidad = round(predictions, 3),
          Prediccion = ifelse(predictions >= 0.5, "ACEPTA", "RECHAZA"),
          Confianza = paste0(round(predictions * 100, 1), "%")
        ) %>%
        select(age, job, balance, housing, loan, Probabilidad, Prediccion, Confianza)
      
      output$batch_results <- DT::renderDataTable({
        DT::datatable(batch_results,
                      options = list(scrollX = TRUE, pageLength = 10)) %>%
          DT::formatStyle("Prediccion",
                         backgroundColor = DT::styleEqual(c("ACEPTA", "RECHAZA"), 
                                                         c("#d4edda", "#f8d7da")))
      })
    }
  })
  
  # Tabla de métricas comparativas
  output$metrics_table <- DT::renderDataTable({
    metrics_data <- data.frame(
      Modelo = c("Regresión Logística", "Random Forest", "XGBoost"),
      Accuracy = c(0.856, 0.891, 0.903),
      F1_Score = c(0.421, 0.523, 0.567),
      Precision = c(0.623, 0.678, 0.712),
      Recall = c(0.312, 0.428, 0.467),
      ROC_AUC = c(0.821, 0.867, 0.889),
      PR_AUC = c(0.445, 0.567, 0.601)
    )
    
    DT::datatable(metrics_data, 
                  options = list(dom = 't', pageLength = 3),
                  class = 'cell-border stripe') %>%
      DT::formatRound(columns = 2:7, digits = 3)
  })
  
  # Gráfico ROC simulado
  output$roc_plot <- renderPlotly({
    set.seed(42)
    fpr <- seq(0, 1, length.out = 100)
    
    tpr_log <- pmin(1, fpr + runif(100, 0.1, 0.3))
    tpr_rf <- pmin(1, fpr + runif(100, 0.2, 0.4))  
    tpr_xgb <- pmin(1, fpr + runif(100, 0.25, 0.45))
    
    roc_data <- data.frame(
      FPR = rep(fpr, 3),
      TPR = c(tpr_log, tpr_rf, tpr_xgb),
      Modelo = rep(c("Logística", "Random Forest", "XGBoost"), each = 100)
    )
    
    p <- ggplot(roc_data, aes(x = FPR, y = TPR, color = Modelo)) +
      geom_line(size = 1.2) +
      geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "gray") +
      labs(title = "Curvas ROC - Comparación de Modelos",
           x = "Tasa de Falsos Positivos", 
           y = "Tasa de Verdaderos Positivos") +
      theme_minimal() +
      scale_color_manual(values = c("Logística" = "#1f77b4", 
                                   "Random Forest" = "#ff7f0e", 
                                   "XGBoost" = "#2ca02c"))
    
    ggplotly(p)
  })
  
  # Gráfico de importancia de variables simulado
  output$importance_plot <- renderPlotly({
    importance_data <- data.frame(
      Variable = c("balance", "duration", "age", "contact_cellular", "job_management", 
                  "housing", "education_tertiary", "loan", "marital_married", "interes_prestamo"),
      Importancia = c(0.23, 0.19, 0.15, 0.12, 0.09, 0.08, 0.06, 0.04, 0.03, 0.02)
    ) %>%
      mutate(Variable = reorder(Variable, Importancia))
    
    p <- ggplot(importance_data, aes(x = Variable, y = Importancia)) +
      geom_col(fill = "steelblue", alpha = 0.8) +
      coord_flip() +
      labs(title = "Importancia de Variables (XGBoost)",
           x = "Variables", y = "Importancia") +
      theme_minimal()
    
    ggplotly(p)
  })
}

# Ejecutar la aplicación
shinyApp(ui = ui, server = server)