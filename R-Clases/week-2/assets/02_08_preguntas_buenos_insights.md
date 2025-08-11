# Checklist de Preguntas para Generar Hipótesis en Cualquier Dataset

## 1. Relación entre variables independientes y la target

* [ ] ¿Cómo cambia la media/mediana de la target según cada variable categórica?
* [ ] ¿La relación entre la target y cada variable numérica parece lineal o no lineal?
* [ ] ¿Existen umbrales claros a partir de los cuales la target cambia abruptamente?
* [ ] ¿Se observan asimetrías o sesgos en la distribución de la target por grupos?

---

## 2. Interacciones entre variables

* [ ] ¿Dos variables combinadas generan un efecto diferente que la suma de sus efectos individuales?
* [ ] ¿El efecto de una variable depende del valor de otra (efecto moderador)?
* [ ] ¿Las variables temporales o estacionales afectan la relación con la target?

---

## 3. Variabilidad y dispersión

* [ ] ¿Aumenta o disminuye la varianza de la target con el valor predicho?
* [ ] ¿Existen grupos con mucha mayor dispersión que otros?
* [ ] ¿La dispersión de la target cambia a lo largo del tiempo o por periodos específicos?

---

## 4. Calidad y estructura de los datos

* [ ] ¿Existen valores atípicos que puedan influir de manera desproporcionada?
* [ ] ¿Los valores ausentes se concentran en ciertos grupos o periodos?
* [ ] ¿Hay variables fuertemente correlacionadas entre sí (riesgo de multicolinealidad)?

---

## 5. Factores externos o temporales

* [ ] ¿La target cambia significativamente después de un evento externo relevante?
* [ ] ¿Se observan patrones por día de la semana, mes, estación o año?
* [ ] ¿Existen ciclos o tendencias a largo plazo?

---

## 6. Preguntas de causalidad potencial

* [ ] Si manipulo X, ¿es lógico esperar un cambio en Y?
* [ ] ¿Podría haber una variable oculta que explique la relación?
* [ ] ¿Hay soporte teórico o de negocio para el patrón observado?

---

## 7. Registro de hipótesis

Para cada insight observado:

1. **Observación inicial:**
2. **Hipótesis formulada:**
3. **Forma de comprobarla (métrica o test):**
4. **Resultado esperado:**
