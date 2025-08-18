# Análisis de Churn de Clientes en Telecomunicaciones

## Objetivo

Desarrollar un sistema de scoring de propensión al churn que:
1. Calcule el score de propensión al churn (valor continuo en porcentaje)
2. Clasifique si un cliente tiene alto riesgo de churn o no (binario)

## Diccionario de Variables Relevantes

| Variable | Tipo | Descripción | Relevancia para Churn |
|----------|------|-------------|-----------------------|
| **customerID** | String | Identificador único | Baja |
| **gender** | Categórica | Género del cliente | Media |
| **SeniorCitizen** | Binaria | Si es adulto mayor (1) o no (0) | Alta |
| **Partner** | Binaria | Si tiene pareja (Yes/No) | Media |
| **Dependents** | Binaria | Si tiene dependientes (Yes/No) | Media |
| **tenure** | Entero | Meses como cliente | Alta |
| **PhoneService** | Binaria | Si tiene servicio telefónico | Media |
| **MultipleLines** | Categórica | Si tiene múltiples líneas | Baja |
| **InternetService** | Categórica | Tipo de servicio de internet | Alta |
| **OnlineSecurity** | Categórica | Si tiene seguridad online | Alta |
| **OnlineBackup** | Categórica | Si tiene backup online | Media |
| **DeviceProtection** | Categórica | Si tiene protección de dispositivo | Media |
| **TechSupport** | Categórica | Si tiene soporte técnico | Alta |
| **StreamingTV** | Categórica | Si tiene streaming TV | Baja |
| **StreamingMovies** | Categórica | Si tiene streaming de películas | Baja |
| **Contract** | Categórica | Tipo de contrato (Month-to-month, 1 year, 2 year) | Alta |
| **PaperlessBilling** | Binaria | Si tiene facturación sin papel | Media |
| **PaymentMethod** | Categórica | Método de pago | Alta |
| **MonthlyCharges** | Float | Cargos mensuales | Alta |
| **TotalCharges** | Float | Cargos totales | Alta |
| **Churn** | Binaria | Variable objetivo (Yes/No) | Target |

---


1. **Etapas claras (Exploración → Preprocesamiento → Modelado → App)**
   Asegura que el sistema de scoring sea reproducible y mantenible.

2. **Dataset de churn adaptado a facturación**
   El mapeo de variables es correcto: datos demográficos, servicios contratados y facturación, todos relevantes para el churn.

3. **Modelado con Scikit-learn y Pipelines**
   El uso de `ColumnTransformer` y `Pipeline` es una buena práctica porque encapsula el preprocesamiento y permite guardar el modelo de manera consistente.

4. **Evaluación de modelos**
   Las métricas que usaste (ROC AUC, Accuracy, Precision, Recall) son adecuadas.
   También conviene agregar **F1-score** y la **matriz de confusión** para ver el equilibrio entre falsos positivos y negativos.

5. **App de scoring**

   * La opción con **Streamlit** es adecuada porque todo está en Python.
   * Devuelve tanto el **score continuo (%)** como la **clasificación binaria**, lo cual es práctico.
   * Incluiste el detalle de probabilidades de churn vs no churn, lo cual mejora la interpretabilidad.
