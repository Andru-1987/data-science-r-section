# Clasificacion

Los modelos de clasificación son un tipo de modelado predictivo que organiza los datos en clases predefinidas según los valores de las características.

Los modelos de clasificación son un tipo de modelo de machine learning que divide los puntos de datos en grupos predefinidos denominados clases. Los clasificadores son un tipo de modelo predictivo que aprende características de clase a partir de los datos de entrada y aprende a asignar posibles clases a los nuevos datos en función de esas características aprendidas1. Los algoritmos de clasificación se utilizan ampliamente en la ciencia de datos para predecir patrones y resultados. De hecho, tienen una gran variedad de casos de uso en el mundo real, como la clasificación de pacientes por posibles riesgos para la salud y el filtrado de spam.

Las tareas de clasificación pueden ser binarias o multiclase. En los problemas de clasificación binaria, un modelo predice entre dos clases. Por ejemplo, un filtro de spam clasifica los correos electrónicos como spam o no spam. Los problemas de clasificación multiclase clasifican los datos entre más de dos etiquetas de clase. Por ejemplo, un clasificador de imágenes podría clasificar imágenes de mascotas mediante el uso de una gran cantidad de etiquetas de clase, como perro, gato, llama, ornitorrinco y más.

Algunas fuentes, especialmente en línea, se refieren a la clasificación como una forma de aprendizaje supervisado de machine learning. Pero los clasificadores no pertenecen exclusivamente al dominio del aprendizaje supervisado. Los enfoques de aprendizaje no supervisado a los problemas de clasificación han sido un foco clave de la investigación reciente.


## 1) Técnicas de clasificación (más sencillas / buenas para comenzar)


* **Regresión logística multinomial**: interpretable, fácil de ajustar; buen baseline para multiclass.
* **k-Nearest Neighbors (kNN)**: conceptualmente simple, sin entrenamiento "pesado", sensible a escalado.
* **Naive Bayes**: rápido, bueno en texto / variables categóricas (asume independencia condicional).
* **Árboles de decisión**: interpretable, poco preprocesamiento.
* **Random Forest**: robusto, manejo de interactions no lineales, poco tuning inicial.
* **Gradient Boosting (xgboost / lightgbm)**: mayor performance en muchos casos, requiere tuning.
* **SVM** (con kernels): potente en problemas de clasificación con espacios no lineales, pero menos intuitivo y costoso.

Recomendación práctica: siempre arranques con un baseline interpretable (logistic multinomial o árbol simple) y luego pruebes RF / xgboost.

---

## 2) Métricas útiles para clasificación multiclass

* **Accuracy**: proporción de aciertos.
* **Precision / Recall / F1**: por clase; después promediar (macro, weighted).
* **Macro F1**: promedio simple de F1 por clase (tratamiento igualitario).
* **Weighted F1 / Recall**: promedia ponderada por soporte (útil si clases desbalanceadas).
* **Kappa**: acuerdo observado vs esperado por azar.
* **Log loss**: penaliza probabilidades mal calibradas.
* **ROC AUC multiclass**: generalmente se calcula “one-vs-all” y se promedia (macro o weighted).
* **Matriz de confusión**: para ver errores de clase a clase (imprescindible).

> En `yardstick` se usan funciones como `accuracy()`, `precision()`, `recall()`, `f_meas()`, `roc_auc()` (con `estimator` para multiclass), y `conf_mat()`.

---
