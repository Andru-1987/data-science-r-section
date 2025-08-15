## **Challenge de Cursada – R para Análisis de Datos y Machine Learning**

### **Objetivo**

Desarrollar un sistema de **scoring de riesgo crediticio** usando un dataset de préstamos de un banco.
El sistema debe:

1. **Calcular el score de propensión al riesgo** (valor continuo en porcentaje).
2. **Clasificar si un cliente es riesgoso o no** (binario).

---

### **Datos**

* Base de datos en formato **SQLite comprimida en `.gz`**.
* Descomprimir con:

```r
gunzip("path/to/database.sqlite.gz", remove = FALSE)
```

---

### **Diccionario de variables**

| Variable         | Tipo                    | Descripción                                                         | Relevancia para riesgo   |
| ---------------- | ----------------------- | ------------------------------------------------------------------- | ------------------------ |
| **id**           | Entero                  | Identificador único del cliente.                                    | Baja (solo trazabilidad) |
| **age**          | Entero                  | Edad del cliente.                                                   | Alta                     |
| **job**          | Categórica              | Ocupación del cliente (`technician`, `blue-collar`, `admin`, etc.). | Alta                     |
| **marital**      | Categórica              | Estado civil (`single`, `married`, `divorced`).                     | Media                    |
| **education**    | Categórica              | Nivel educativo (`primary`, `secondary`, `tertiary`).               | Alta                     |
| **has\_default** | Categórica (`yes`/`no`) | Historial de default previo.                                        | Alta                     |
| **balance**      | Entero                  | Saldo promedio en cuenta bancaria.                                  | Alta                     |
| **housing**      | Categórica (`yes`/`no`) | Préstamo hipotecario vigente.                                       | Alta                     |
| **loan**         | Categórica (`yes`/`no`) | Préstamo personal vigente.                                          | Alta                     |
| **contact**      | Categórica              | Medio de contacto (`cellular`, `telephone`, `unknown`).             | Baja                     |
| **day**          | Entero                  | Día del último contacto.                                            | Baja                     |
| **month**        | Categórica              | Mes del último contacto.                                            | Baja                     |
| **duration**     | Entero (segundos)       | Duración del último contacto.                                       | Baja                     |
| **campaign**     | Entero                  | Nº de contactos en la campaña actual.                               | Baja                     |
| **pdays**        | Entero                  | Días desde último contacto previo (-1 si no hubo).                  | Media                    |
| **previous**     | Entero                  | Nº de contactos previos antes de la campaña actual.                 | Media                    |
| **poutcome**     | Categórica              | Resultado de la campaña previa (`success`, `failure`, `unknown`).   | Media                    |
| **y**            | Binaria (`0`/`1`)       | Variable objetivo: 1 = acepta préstamo / 0 = no.                    | Target                   |

---

### **Flujo de trabajo requerido**

#### 1. **Carga y exploración**

* Conectar a la base SQLite.
* Revisar estructura y tipos de datos.
* Analizar valores faltantes y outliers.

#### 2. **Preprocesamiento**

* Limpieza y normalización.
* Codificación de variables categóricas.
* Selección de variables relevantes para scoring.

#### 3. **Modelado**

* Usar `tidymodels` (`recipes`, `workflows`, `parsnip`).
* Entrenar al menos **2 modelos candidatos**.
* Evaluar métricas: ROC AUC, accuracy, recall, precision.
* Guardar el mejor modelo como `.rds`.

#### 4. **App Shiny**

* Input manual de características del cliente.
* Salida:

  * Score de riesgo (%).
  * Clasificación: **Riesgoso / No riesgoso**.
