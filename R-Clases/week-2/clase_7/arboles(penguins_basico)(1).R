# El objetivo de este análisis es predecir la especie de pingüino 
# (Adelie, Chinstrap o Gentoo) basándose en otras variables 
# (como longitud del pico, longitud de la aleta, isla, sexo, etc.).

# Cargar las bibliotecas necesarias
library(tidyverse)
library(caret)

# Cargar el conjunto de datos de palmerpenguins
data("penguins")

# Realizar un análisis exploratorio básico
summary(penguins)
str(penguins)
head(penguins)

# Convertir las variables categóricas en factores
penguins$species <- as.factor(penguins$species)
penguins$island <- as.factor(penguins$island)
penguins$sex <- as.factor(penguins$sex)

# Eliminar filas con valores nulos
penguins <- na.omit(penguins)


# Fijar una semilla para la reproducibilidad
set.seed(123)

# Dividir los datos en conjunto de entrenamiento (80%) y prueba (20%)
trainIndex <- createDataPartition(penguins$species, p = 0.8, list = FALSE)
training_data <- penguins[trainIndex, ]
testing_data <- penguins[-trainIndex, ]

# Crear un modelo de árbol de decisión
model <- train(
  species ~ .,
  data = training_data,
  method = "rpart"
)

# Realizar predicciones en el conjunto de prueba
predictions <- predict(model, newdata = testing_data)

# Calcular la matriz de confusión
confusion_matrix <- confusionMatrix(predictions, testing_data$species)
confusion_matrix

# Calcular la precisión del modelo
accuracy <- confusion_matrix$overall["Accuracy"]
accuracy

library(rpart)

# Crear un modelo de árbol de decisión con rpart
tree_model <- rpart(species ~ ., data = training_data, method = "class")

library(rpart.plot)

# Graficar el árbol
rpart.plot(tree_model)