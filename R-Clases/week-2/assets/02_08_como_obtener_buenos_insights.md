
## 1. Principio general

Un buen *insight* previo al modelado nace de:

1. **Observar patrones claros o sospechas** en la EDA.
2. **Conectar esos patrones con teoría o lógica del dominio** (no sólo estadística).
3. **Convertirlo en una afirmación comprobable** (hipótesis).

---

## 2. Preguntas universales para cualquier dataset

Te las dejo agrupadas por tipo de patrón a buscar.

---

### A. Relación entre variables independientes y la target

* ¿Cómo cambia la **media/mediana** de la target según categorías de una variable?
  *(Ej.: “Los clientes de la región norte gastan más que los del sur”)*
* ¿La relación parece **lineal o no lineal**?
  *(Ej.: “El precio crece más rápido a partir de cierto umbral de demanda”)*
* ¿Existe un **efecto umbral** (cambio brusco a partir de cierto valor)?
* ¿Se observa **asimetría** o sesgo en la distribución de la target según grupos?

---

### B. Interacciones entre variables

* ¿Cuando A está alto y B está alto, la target se comporta diferente que cuando sólo una de ellas está alta?
  *(Ej.: “La combinación de alto ingreso + alto gasto publicitario tiene un efecto multiplicador”)*
* ¿El efecto de una variable depende del valor de otra (efecto moderador)?
* ¿Variables temporales + estacionales generan picos o valles en la target?

---

### C. Variabilidad y dispersión

* ¿Aumenta la **varianza** de la target con el valor predicho (heterocedasticidad)?
* ¿Existen grupos con mucha más dispersión que otros?
* ¿La varianza residual cambia con el tiempo o en ciertos periodos?

---

### D. Calidad y estructura de los datos

* ¿Existen **valores atípicos** que podrían influir en la relación observada?
* ¿Hay **valores ausentes** concentrados en ciertos grupos o periodos?
* ¿Variables aparentemente distintas están fuertemente correlacionadas entre sí (multicolinealidad)?

---

### E. Factores externos o temporales

* ¿La target cambia de forma notable después de un evento externo?
  *(Ej.: cambio de política, pandemia, lanzamiento de un producto)*
* ¿Hay patrones claros por día de la semana, mes o temporada?
* ¿Existen ciclos largos o tendencias en series temporales?

---

### F. Preguntas de causalidad potencial

*(Aquí es clave advertir que correlación no implica causalidad)*

* Si manipulo X, ¿es razonable esperar un cambio en Y?
* ¿Podría existir una variable oculta Z que explique tanto X como Y?
* ¿Hay una explicación lógica de negocio para el patrón observado?

---

## 3. Cómo convertir una respuesta en hipótesis

**Observación** → **Relación esperada** → **Forma comprobable**
Ejemplo:

* Observación: “Los clientes con más de 3 compras tienden a gastar más en cada ticket.”
* Hipótesis: “El número de compras se asocia positivamente con el gasto promedio por compra.”
* Comprobación: Ajustar regresión y revisar coeficiente de la variable `num_compras`.

---

## 4. Buenas prácticas para obtener insights sólidos

* **Triangular**: usar gráficos, estadísticas descriptivas y `conocimiento del negocio`.
* **Buscar lo inesperado**: patrones que contradigan la intuición inicial.
* **Formular hipótesis negativas**: no sólo buscar lo que confirma ideas previas.
* **Revisar subgrupos**: lo que es cierto globalmente puede no serlo para todos los segmentos.
