library(shiny)
library(tidymodels)
library(workflows)
library(dplyr)

# ==============================
# 1. Cargar modelo entrenado
# ==============================
final_rf <- readRDS("R-Clases/week-2/clase_10/models/rf_model.rds")
loan_recipe <- workflows::extract_recipe(final_rf)

# ==============================
# 2. UI
# ==============================
ui <- fluidPage(
  titlePanel("Predicción Loan Status - Random Forest"),

  sidebarLayout(
    sidebarPanel(
      selectInput("Gender", "Gender:", choices = c("Male", "Female"), selected = "Male"),
      selectInput("Married", "Married:", choices = c("Yes", "No"), selected = "Yes"),
      selectInput("Dependents", "Dependents:", choices = c("0", "1", "2", "3+"), selected = "0"),
      selectInput("Education", "Education:", choices = c("Graduate", "Not Graduate"), selected = "Graduate"),
      selectInput("Self_Employed", "Self Employed:", choices = c("Yes", "No"), selected = "No"),
      numericInput("ApplicantIncome", "Applicant Income:", value = 5000),
      numericInput("CoapplicantIncome", "Coapplicant Income:", value = 0),
      numericInput("LoanAmount", "Loan Amount:", value = 150),
      numericInput("Loan_Amount_Term", "Loan Amount Term:", value = 360),
      selectInput("Credit_History", "Credit History:", choices = c("0", "1"), selected = "1"),
      selectInput("Property_Area", "Property Area:", choices = c("Urban", "Semiurban", "Rural"), selected = "Urban"),
      sliderInput("threshold", "Threshold de clasificación:", min = 0, max = 1, value = 0.3, step = 0.01),
      actionButton("predict_btn", "Predecir")
    ),

    mainPanel(
      h4("Resultado:"),
      verbatimTextOutput("prediction"),
      h4("Probabilidad:"),
      verbatimTextOutput("probability")
    )
  )
)

# ==============================
# 3. SERVER
# ==============================
server <- function(input, output) {
observeEvent(input$predict_btn, {

  # Crear tibble con datos nuevos (sin dummy)
  new_data <- tibble(
    Gender = factor(input$Gender, levels = c("Male","Female")),
    Married = factor(input$Married, levels = c("Yes","No")),
    Dependents = factor(input$Dependents, levels = c("0","1","2","3+")),
    Education = factor(input$Education, levels = c("Graduate","Not Graduate")),
    Self_Employed = factor(input$Self_Employed, levels = c("Yes","No")),
    ApplicantIncome = as.numeric(input$ApplicantIncome),
    CoapplicantIncome = as.numeric(input$CoapplicantIncome),
    LoanAmount = as.numeric(input$LoanAmount),
    Loan_Amount_Term = as.numeric(input$Loan_Amount_Term),
    Credit_History = as.numeric(input$Credit_History),
    Property_Area = factor(input$Property_Area, levels = c("Urban","Semiurban","Rural"))
  )

  # Predicción directa con workflow (aplica la receta internamente)
  prob <- predict(final_rf, new_data, type = "prob")$.pred_Y

  class <- ifelse(prob > input$threshold, "Y", "N")

  output$prediction <- renderText({ paste("Clasificación:", class) })
  output$probability <- renderText({ paste0(round(prob*100,2), "%") })

})


}

# ==============================
# 4. Lanzar app
# ==============================
shinyApp(ui, server)
