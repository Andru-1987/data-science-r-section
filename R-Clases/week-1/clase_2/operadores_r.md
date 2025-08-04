### 1. Operadores Básicos Matemáticos y Lógicos
```r
+  -  *  /  ^  # Aritméticos (suma, resta, multiplicación, división, potencia)
%%  %/%        # Módulo y división entera
==  !=  <  >  <=  >=  # Comparación
!  &  |        # Lógicos (NOT, AND, OR)
```

### 2. Operadores Especiales (Tipo `%xxx%`)
```r
%>%           # Pipe (magrittr/tidyverse)
%<>%          # Pipe con asignación (asigna el resultado al objeto inicial)
%T>%          # Tee pipe (permite side effects)
%$%           # Exposición de variables (para acceder a columnas directamente)
%||%          # Operador OR (devuelve el primer elemento no-NULL)
%in%          # Pertenece a (equivalente a `match()`)
%*%           # Multiplicación de matrices
%o%           # Producto externo (`outer()`)
%x%           # Producto Kronecker
%/%           # División entera
%%            # Módulo (resto de división)
```

### 3. Operadores para Fórmulas
```r
~             # Crear fórmulas (y ~ x)
:             # Interacción en fórmulas (x1:x2)
*             # Interacción + términos principales (x1*x2 equivale a x1 + x2 + x1:x2)
^             # Expansión de interacciones
```

### 4. Operadores para Data Frames y Listas
```r
$             # Extraer elemento por nombre
[[ ]]         # Extraer elemento por índice/nombre
[ ]           # Subsetting
@             # Acceso a slots (S4 objects)
```

### 5. Operadores Personalizados
Puedes crear los tuyos:
```r
`%mi_operador%` <- function(a, b) { a^2 + b^2 }
3 %mi_operador% 4  # Devuelve 25
```

### 6. Operadores de Asignación
```r
<-  =   <<-   # Asignación (normal y global)
->  ->>       # Asignación hacia la derecha
```

### 7. Operadores para Strings (paquete `stringr`)
```r
%>%           # Pipe (también usado aquí)
%+%           # Concatenación de strings
```

### Ejemplo práctico con varios operadores:
```r
library(magrittr)

datos <- data.frame(x = 1:10, y = rnorm(10))

resultado <- datos %$%
  .[x > 5, ] %T>%
  plot(y ~ x) %>%
  lm(y ~ x, data = .) %$%
  coefficients %*% c(1, 5)
```

### Diferencias clave:
- `%>%` vs `|>`: El pipe nativo (|>) de R 4.1+ es más limitado (no soporta el punto (.) para posicionamiento de argumentos)
- `%in%` es esencial para filtrar: `iris[iris$Species %in% c("setosa", "versicolor"), ]`
- `%*%` es fundamental para álgebra lineal
