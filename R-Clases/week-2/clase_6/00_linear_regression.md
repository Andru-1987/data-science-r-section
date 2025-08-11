# Machine Learning con R — Regresión Lineal

## 1. Introducción

En las clases anteriores vimos técnicas de inferencia estadística como **t-test**, **chi-cuadrado** y **ANOVA** para analizar diferencias entre muestras y poblaciones.
Ahora entramos en el terreno del **modelado predictivo**, cuyo objetivo es usar datos para predecir valores futuros o no observados. Esto es parte del **Machine Learning**, disciplina que automatiza la detección de patrones en datos.

Ejemplos reales:

* Cajeros automáticos que leen texto manuscrito.
* Smartphones que transcriben voz a texto.
* Autos autónomos que reconocen objetos en la vía.

En este módulo nos enfocaremos en el caso más simple y explicativo: **la regresión lineal**.

---

## 2. Fundamentos de la regresión lineal

La **regresión lineal** predice una **variable numérica** (respuesta o *target*) a partir de una o más **variables explicativas** (*features*).

Con **una sola variable explicativa**, el modelo es:

```
y = β0 + β1 * x
```

Donde:

* `β0` → intercepto (valor de y cuando x=0).
* `β1` → pendiente (cambio esperado en y por unidad de x).
* La estimación busca **minimizar la suma de errores cuadrados** (residuos).

Es más útil cuando la relación entre variables es aproximadamente lineal.


---

# Modelos de Regresión en R y Métricas de Evaluación

## Modelos de Regresión Lineal en R

R ofrece múltiples variantes de modelos de regresión lineal, cada una con sus características específicas:

### 1. Regresión Lineal Simple (OLS)
```R
lm(y ~ x, data = dataset)
```
- **Descripción**: Modela la relación entre una variable dependiente y una independiente
- **Uso**: Cuando hay una relación lineal clara entre dos variables

### 2. Regresión Lineal Múltiple
```R
lm(y ~ x1 + x2 + x3, data = dataset)
```
- **Descripción**: Extiende OLS para múltiples variables predictoras
- **Uso**: Cuando varias variables pueden explicar la variable objetivo

### 3. Regresión Robusta
```R
MASS::rlm(y ~ x, data = dataset)
```
- **Descripción**: Menos sensible a outliers que OLS
- **Uso**: Cuando los datos contienen valores atípicos influyentes

### 4. Regresión Ridge
```R
glmnet::glmnet(x, y, alpha = 0)
```
- **Descripción**: Regularización L2 para manejar multicolinealidad
- **Uso**: Cuando predictores están altamente correlacionados

### 5. Regresión Lasso
```R
glmnet::glmnet(x, y, alpha = 1)
```
- **Descripción**: Regularización L1 que realiza selección de variables
- **Uso**: Cuando se quiere simplificar el modelo automáticamente

### 6. Regresión Elastic Net
```R
glmnet::glmnet(x, y, alpha = 0.5)
```
- **Descripción**: Combina regularización L1 y L2
- **Uso**: Cuando se quiere balancear entre Ridge y Lasso

### 7. Regresión Polinómica
```R
lm(y ~ poly(x, degree = 3), data = dataset)
```
- **Descripción**: Modela relaciones no lineales con términos polinómicos
- **Uso**: Cuando la relación entre variables es curvilínea

### 8. Regresión con Splines
```R
mgcv::gam(y ~ s(x), data = dataset)
```
- **Descripción**: Modela relaciones no lineales flexibles
- **Uso**: Cuando la forma funcional de la relación es desconocida

## Métricas Importantes de Evaluación

### 1. R² (R cuadrado)
- **Fórmula**: 1 - (SSres/SStot)
- **Descripción**: Proporción de varianza explicada por el modelo
- **Interpretación**: Entre 0 (malo) y 1 (perfecto), pero puede ser negativo
- **Uso**: Comparación general entre modelos

### 2. R² Ajustado
- **Fórmula**: 1 - [(1-R²)(n-1)/(n-p-1)]
- **Descripción**: R² penalizado por número de predictores
- **Interpretación**: Similar a R² pero más justo para modelos complejos
- **Uso**: Comparar modelos con diferente número de predictores

### 3. Error Cuadrático Medio (MSE)
- **Fórmula**: mean((y - ŷ)²)
- **Descripción**: Promedio de errores al cuadrado
- **Interpretación**: Siempre positivo, menor es mejor
- **Uso**: Principal métrica para optimización

### 4. Raíz del Error Cuadrático Medio (RMSE)
- **Fórmula**: sqrt(MSE)
- **Descripción**: MSE en unidades originales
- **Interpretación**: Más interpretable que MSE
- **Uso**: Reportar error en escala original

### 5. Error Absoluto Medio (MAE)
- **Fórmula**: mean(|y - ŷ|)
- **Descripción**: Promedio de errores absolutos
- **Interpretación**: Menos sensible a outliers que MSE
- **Uso**: Cuando los outliers son problemáticos

### 6. Error Absoluto Medio Porcentual (MAPE)
- **Fórmula**: mean(|(y - ŷ)/y|) * 100
- **Descripción**: Error porcentual promedio
- **Interpretación**: Fácil de comunicar a no técnicos
- **Uso**: Cuando se necesita error en porcentaje

### 7. Criterio de Información de Akaike (AIC)
- **Fórmula**: 2k - 2ln(L)
- **Descripción**: Balance entre bondad de ajuste y complejidad
- **Interpretación**: Menor valor indica mejor modelo
- **Uso**: Selección de modelos anidados

### 8. Criterio de Información Bayesiano (BIC)
- **Fórmula**: k*ln(n) - 2ln(L)
- **Descripción**: Similar a AIC con mayor penalización por complejidad
- **Interpretación**: Menor valor indica mejor modelo
- **Uso**: Selección de modelos con mayor penalización a complejidad

## Implementación en R

Para calcular estas métricas:

```R
# Ejemplo con modelo lineal
modelo <- lm(y ~ ., data = datos)

# Métricas básicas
summary(modelo)  # Muestra R², R² ajustado

# Otras métricas
library(caret)
predictions <- predict(modelo, newdata = datos)
postResample(pred = predictions, obs = datos$y)  # RMSE, R², MAE

# Para AIC/BIC
AIC(modelo)
BIC(modelo)

# MAPE personalizado
mape <- function(y, yhat) { mean(abs((y - yhat)/y)) * 100 }
mape(datos$y, predictions)
```

Cada modelo y métrica tiene su lugar dependiendo del contexto analítico y los objetivos específicos del proyecto.