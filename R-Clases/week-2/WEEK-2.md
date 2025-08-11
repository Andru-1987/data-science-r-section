# Machine Learning con R
---

# 1. Paquetes recomendados 

* `tidymodels` (parsnip, recipes, workflows, tune) — flujo moderno y modular. ([geocompx.org][1])
* `xgboost` (R package: interfaz y optimizaciones; versión CRAN reciente). Útil para regresión con gran performance. ([CRAN][3], [dmlc.r-universe.dev][4])
* `e1071` o `parsnip::svm_*` para SVM (regresión: `eps-regression` / `nu-regression`), o usar implementaciones desde `kernlab`/`parsnip`. ([CRAN][5], [parsnip.tidymodels.org][6])
* `caret` y `mlr3` como alternativas con ecosistemas consolidados (si el público ya las conoce). ([Medium][2], [geocompx.org][1])

---

# 2. Estructura de modelos de machine learning

## 2.1 Carga de la data

Objetivo: mostrar cómo importar data desde CSV/Parquet/DB y comprobaciones iniciales.
Checklist:

* Origen(es): CSV, Parquet, DB (Postgres), API.
* Revisar dimensiones (`nrow`, `ncol`) y tipos (`character`, `numeric`, `factor`, `Date`).
* Primer vistazo: `glimpse()` / `str()` / `summary()` para detectar variables objetivo y predictores.

Preguntas para la clase:

* ¿Qué variable queremos predecir? (definir `y`)
* ¿Es problema de regresión puro (continua) o se necesita transformar la target?

---

## 2.2 Muestra de las variables principales

Objetivo: identificar features de interés y target.
Checklist:

* Tabla con: nombre, tipo, % missing, resumen estadístico (mean, sd, min, max), cardinalidad (para categóricas).
* Gráfica rápida: histograma (target), boxplots por variable categórica, scatter de variables continuas vs target.
* Identificar variables candidatas para interacción o transformaciones (log, sqrt, polinómicas).

---

## 2.3 EDA (Exploratory Data Analysis)

Objetivo: entender relaciones, distribución y calidad de datos.
Actividades:

* Distribución de la variable objetivo (asimetría, kurtosis).
* Correlación entre numéricas (matriz de correlación), detec. multicolinealidad (VIF).
* Análisis de relaciones bivariadas (scatter + smooth) y por grupos (boxplots).
* Detección de patrones temporales o geográficos si aplican.
  Entregable de clase: lista de al menos 5 insights potenciales a convertir en hipótesis.

---

## 2.4 Obtención de hipótesis (generar insights accionables)

_Algunas ideas para encontrar algunas conjeturas_
  * [Obtencion de buenos insights](./assets/02_08_como_obtener_buenos_insights.md)
  * [Checklist para obtener insights](./assets/02_08_preguntas_buenos_insights.md)

* “La variable X se asocia positivamente con la target; esperamos coeficiente > 0.”
* “Variables A y B interactúan: su efecto conjunto es mayor que la suma.”
* “Existe heterocedasticidad: varianza residual aumenta con la predicción.”

---

## 2.5 Planteo de hipótesis nula

Para cada hipótesis planteada:

* H0: no hay relación entre X y Y (coeficiente = 0).
* H1: existe relación (coeficiente ≠ 0 o >0 / <0 según sentido).
  En clase: explicar tests de significancia (p-values) en regresión lineal y limites de interpretarlos en ML.

---

## 2.6 Insights obtenidos

Cómo presentar:

* Tabla con hipótesis, evidencia (estadística descriptiva), y decisión (rechazar/aceptar H0).
* Visuales que respalden cada insight.

---

## 2.7 Feature engineering

Patrón de trabajo:

* Crear variables temporales (día, mes, lag, rolling) si es series.
* Interacciones y polinomios (cuando tenga sentido).
* Agregar agregados por grupo (mean\_by\_customer, count\_by\_region).
* Transformaciones (log, Box-Cox) para normalizar target o features sesgadas.
  Consejo práctico: usar `recipes` (tidymodels) para encadenar transformaciones reproducibles.

---

## 2.8 Outliers — detección y tratamiento

Detección:

* Boxplot, z-score, IQR rule, métodos basados en modelos (isolation forest) o `recipes::step_YeoJohnson` para robustez.
  Tratamiento:
* Verificar si los outliers son errores de registro → corregir/Eliminar.
* Winsorizing / capping (valores por percentiles) para reducción de efecto.
* Transformación (log) para reducir impacto.

---

## 2.9 Label Encoding (categóricas)

Opciones según algoritmo:

* Modelos lineales / SVM: one-hot encoding (o `recipes::step_dummy()`).
* Árboles / XGBoost (2025: XGBoost ha mejorado soporte categórico; si se usa versión con categórica nativa, preferir ese flujo). ([XGBoost Documentation][7], [CRAN][3])
* Target encoding / mean encoding: usar con regularización y validación estricta (evitar data leakage).

---

## 2.10 Missing treatment

Estrategias:

* Imputación simple: mediana (num), modo (cat).
* Imputación basada en modelos: kNN imputation, MICE.[MICE](assets/02_10_MICE.md)
* `recipes::step_impute_*()` para pipelines reproducibles.
* Añadir indicador de missing (`is_na_feature`) cuando el missing puede ser informativo.

---

## 2.11 Capping
[capping vs winsoring](assets/02_11_winsorizing_capping.Rmd)
* Aplicar winsorizing por percentiles (ej. 1% y 99%) o capping por `pmax/pmin`.
* Registrar la estrategia en el pipeline para reproducibilidad.

---

## 2.12 Data Splitting: Train / Validation / Test

Recomendación práctica:

* Estrato por variable relevante (por ejemplo si hay grupos): `initial_split()` (tidymodels) con `strata =`.
* División típica: Train 60–70%, Validation 15–20%, Test 15–20%; o K-fold CV (ver abajo).
* Para series temporales: usar validación basada en time-slices (rolling origin).
* Guardar seeds y splits para reproducibilidad.

---

## 2.13 Machine Learning Algorithms (selección)

Modelos a cubrir en clase (comparativa y fortalezas):

* **Linear Regression (OLS / regularized: Ridge, Lasso)** — bueno para interpretabilidad y rapidez.

  * Temas a enseñar: supuestos (linealidad, independencia, homocedasticidad), diagnóstico de residuos, VIF.
* **Support Vector Regression (SVR)** — útil para relaciones no lineales con kernels (radial, polynomial); requiere escalado.

  * Paquetes: `e1071::svm()` o `parsnip::svm_rbf/svm_linear`. ([CRAN][5], [parsnip.tidymodels.org][6])
* **XGBoost (Gradient Boosting)** — alto performance, maneja missing internamente; trabaja muy bien en tabular. ([CRAN][3], [dmlc.r-universe.dev][4])
* **Random Forest / Ranger** — robusto, poco tuning necesario.
* **LightGBM / CatBoost** — mencionar como alternativas dependiendo de la data (si se usan en R).
* **Modelos lineales generalizados y ensembles** (stacking): explicar cuándo conviene.


---

## 2.14 Cross Validation

* K-fold CV (k=5 o 10) para estimar rendimiento; `rsample::vfold_cv()` o `caret::trainControl()`.
* Para tuning hyperparámetros: nested CV (si se requiere estimación no sesgada de generalización).
* Para series temporales: time-series CV (`sliding` / `rolling_origin`).
* En tidymodels: `tune::tune_grid()` / `tune::tune_bayes()` para búsqueda eficiente.

---

## 2.15 AUC — ROC (cuando se use)

* ACLARACIÓN: **AUC / ROC es una métrica para clasificación**. En regresión no se aplica.
* Si la tarea se transforma a clasificación (ej.: predicción de umbrales), explicar cuándo conviene usar ROC/AUC y cómo interpretarla.

---

## 2.16 Métricas de validación (regresión)

Prioritarias:

* **RMSE** (root mean squared error) — penaliza grandes errores.
* **MAE** (mean absolute error) — más robusta a outliers.
* **R² / Adjusted R²** — proporción de varianza explicada.
* **MAPE** (porcentual) — cuidado si valores cercanos a cero.
* **Medidas adicionales**: explained variance, RMSLE (si target log), cobertura de intervalos de predicción.
  Consejo: siempre reportar ± intervalo (bootstrap o CV folds) para las métricas.


### Hyperparameter tuning (Hipertunning)

* **Objetivo:** Encontrar la combinación óptima de hiperparámetros para mejorar el rendimiento del modelo sin sobreajustar.
* **Estrategias comunes:**

  * **Grid Search:** búsqueda exhaustiva sobre un conjunto predefinido de combinaciones.
  * **Random Search:** muestreo aleatorio dentro de rangos definidos.
  * **Bayesian Optimization:** búsqueda inteligente basada en modelos probabilísticos (ej. con paquetes `tune` y `tune.bayes`).
* **Paquetes recomendados en R:**

  * `tidymodels::tune_grid()` para grid search.
  * `tidymodels::tune_bayes()` para optimización bayesiana.
  * `caret::train()` con método `tuneLength` o `tuneGrid`.
  * `mlr3tuning` para flujos avanzados.
* **Validación:**

  * Usar validación cruzada (k-fold CV) dentro del proceso de tuning para evaluar desempeño realista.
  * Para series temporales, usar validaciones temporales (rolling origin).
* **Ejemplos de hiperparámetros clave:**

  * **XGBoost:**
    `eta` (learning\_rate), `max_depth`, `subsample`, `colsample_bytree`, `nrounds`, `lambda`, `alpha`.
  * **SVM:**
    `cost` (C), `epsilon` (ε en regression), `gamma` (kernel radial), tipo de kernel.
  * **Regresión lineal regularizada:**
    `lambda` (penalización), `alpha` (mezcla entre Ridge y Lasso).

---

## 2.17 Guardado de modelo

Buenas prácticas:

* Serializar el modelo y el pipeline de preprocesamiento juntos (`saveRDS()`), o usar `vetiver` para empaquetado y deployment.
* Guardar versión de paquetes y seed (archivo `sessionInfo()` o `renv.lock`).
* Documentar: fecha, dataset usado, splits, hyperparámetros, métricas en validation/test.

---

# 3. Notas específicas por algoritmo (puntos clave para explicar en clase)

## Linear Regression (OLS / Ridge / Lasso)

* Ventajas: interpretabilidad, rapidez.
* Críticas: sensibilidad a outliers, multicolinealidad.
* Enseñar: diagnóstico de residuos, pruebas de heterocedasticidad, regularización (glmnet) para manejo de multicolinealidad.

## SVM Regression

* Preparación: **escalar** features (SVM sensible a escala).
* Kernels: linear, radial (RBF), polynomial — mostrar efecto en capacidad no-lineal.
* Tuning: C (cost), epsilon (tolerancia), gamma (kernel) — usar grid/bayes tuning.
* Paquetes: `e1071`, o `parsnip`/`kernlab` para integración con tidymodels. ([CRAN][5], [parsnip.tidymodels.org][6])

## XGBoost Regressor

* Input: `xgb.DMatrix` o usar `parsnip`/`workflows` para integración.
* Ventajas: speed, manejo nativo de missing (en versiones CRAN/R-universe recientes hay mejoras en soporte categórico).
* Hyperparams importantes: `eta` (learning\_rate), `max_depth`, `subsample`, `colsample_bytree`, `nrounds`, regularización (`lambda`, `alpha`).
* Feature importance y SHAP para interpretabilidad (mostrar `xgboost::xgb.importance()` y `shap`).

---

# 4. Ejemplo de checklist por sesión práctica (resumido)

1. Importar dataset → quick-glimpse.
2. Definir target y features candidatas.
3. EDA + hipótesis (3 hipótesis).
4. Preprocesamiento con `recipes` (imputación, encoding, scaling).
5. Split (train/val/test) con `rsample`.
6. Baseline model: Linear Regression (reportar RMSE, MAE, R2).
7. Modelos avanzados: SVM, XGBoost (tuning CV).
8. Comparación en validation; seleccionar final; evaluar en test.
9. Guardar modelo y pipeline; documentar sesión.

---

# 5. Material didáctico adicional y recomendaciones prácticas

* Enseñar con 2 datasets: uno pequeño y explicable (para ver residuos y supuestos) y otro real/mediano (para mostrar XGBoost y CV).
* Mostrar errores comunes: data leakage (imputar usando train+test), no escalar para SVM, usar target-encoding sin validación.
* Introducir interpretación (SHAP / Permutation importance) para modelos árbol/boosting.
* Mantener reproducibilidad: `set.seed`, `renv`/`packrat`, y `sessionInfo()`.

---

# 6. Referencias y recursos (rápidos)

* Comparativas y workflows modernos: artículos sobre `tidymodels`, `caret`, `mlr3`. ([geocompx.org][1], [Medium][2])
* Documentación `xgboost` (R package; CRAN / R-universe) — para detalles de instalación y notas sobre soporte categórico. ([CRAN][3], [XGBoost Documentation][7])
* `e1071` (SVM) documentación CRAN para parámetros y tipos de regresión. ([CRAN][5])

---

[1]: https://geocompx.org/post/2025/sml-bp1/?utm_source=chatgpt.com "Spatial machine learning with R: caret, tidymodels, and mlr3"
[2]: https://medium.com/data-science/caret-vs-tidymodels-create-complete-reusable-machine-learning-workflows-5c50a7befd2d?utm_source=chatgpt.com "Caret vs. tidymodels — create reusable machine learning workflows"
[3]: https://cran.r-project.org/web/packages/xgboost/refman/xgboost.html?utm_source=chatgpt.com "Help for package xgboost"
[4]: https://dmlc.r-universe.dev/xgboost?utm_source=chatgpt.com "xgboost: Extreme Gradient Boosting - dmlc - R-universe"
[5]: https://cran.r-project.org/web/packages/e1071/e1071.pdf?utm_source=chatgpt.com "[PDF] e1071.pdf - CRAN"
[6]: https://parsnip.tidymodels.org/reference/svm_linear.html?utm_source=chatgpt.com "Linear support vector machines — svm_linear - parsnip - tidymodels"
[7]: https://xgboost.readthedocs.io/en/latest/R-package/?utm_source=chatgpt.com "XGBoost R Package — xgboost 3.1.0-dev documentation"
