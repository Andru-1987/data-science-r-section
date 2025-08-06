#' @param n Número de filas del dataset base (default: 200)
#' @param seed Semilla para reproducibilidad (default: 123)
#' @param add_duplicates Lógico, si agregar filas duplicadas (default: TRUE)
#' @param add_empty_rows Lógico, si agregar filas vacías (default: TRUE)
#' @param show_summary Lógico, si mostrar resumen de problemas (default: TRUE)
#' 
#' @return data.frame con problemas típicos de datos reales
#' 
#' @examples
#' # Uso básico
#' df <- generar_dataset_ejemplo()
#' 
#' # Personalizado
#' df <- generar_dataset_ejemplo(n = 100, seed = 456, show_summary = FALSE)
#' 
#' @export
generar_dataset_ejemplo <- function(n = 200, seed = 123, add_duplicates = TRUE, 
                                   add_empty_rows = TRUE, show_summary = TRUE) {
  
  # Establecer semilla para reproducibilidad
  set.seed(seed)
  
  # Función auxiliar para generar fechas aleatorias
  generar_fechas_aleatorias <- function(n, desde = "2020-01-01", hasta = "2024-12-31") {
    fecha_inicio <- as.Date(desde)
    fecha_fin <- as.Date(hasta)
    fechas_random <- sample(seq(fecha_inicio, fecha_fin, by="day"), n, replace = TRUE)
    return(format(fechas_random, "%d/%m/%Y"))
  }
  
  # Crear dataset base con problemas típicos
  df <- data.frame(
    # ID con algunos duplicados
    id = c(1:(n-10), sample(1:10, 10, replace = TRUE)),
    
    # Nombres con problemas de formato
    nombre = c(
      sample(c("JUAN PÉREZ", "maría garcía", " Ana López ", "Pedro  Martín", 
               "Carmen  Rodríguez", "José Antonio", "  Isabel Fernández  ", 
               "Luis Miguel", "ANA MARÍA", " carlos ruiz", "  SOFIA TORRES "), 
               n-20, replace = TRUE),
      rep(NA, 15),  # Valores faltantes
      rep("", 5)    # Valores vacíos
    ),
    
    # Edades con outliers y NA
    edad = c(
      sample(18:65, n-25, replace = TRUE),
      c(-5, 150, 999),  # Outliers evidentes
      sample(0:17, 7, replace = TRUE),  # Menores (posibles outliers)
      rep(NA, 15)       # Valores faltantes
    ),
    
    # Salarios con formato inconsistente y outliers
    salario_texto = c(
      paste0("$", sample(30000:80000, n-30, replace = TRUE)),
      paste0(sample(25000:90000, 15, replace = TRUE), ".00"),
      paste0("$ ", sample(35000:75000, 10, replace = TRUE)),
      c("$1,500,000", "$5", "$999,999"),  # Outliers
      rep(NA, 2)
    ),
    
    # Departamentos con inconsistencias
    departamento = sample(c("Ventas", "VENTAS", "ventas", "Marketing", "MARKETING", 
                           "Recursos Humanos", "rrhh", "RRHH", "Sistemas", "IT", 
                           "sistemas", "Finanzas", "finanzas", NA), n, replace = TRUE),
    
    # Fechas de ingreso con formatos inconsistentes y errores
    fecha_ingreso = c(
      generar_fechas_aleatorias(n-25, "2015-01-01", "2023-12-31"),
      c("2025-01-01", "2030-05-15", "31/13/2022"),  # Fechas futuras/inválidas
      rep(NA, 12),
      rep("", 10)
    ),
    
    # Email con problemas de formato
    email = c(
      paste0(sample(c("juan", "maria", "pedro", "ana", "carlos"), n-20, replace = TRUE),
             sample(1:999, n-20, replace = TRUE),
             sample(c("@gmail.com", "@hotmail.com", "@empresa.com"), n-20, replace = TRUE)),
      c("email_invalido", "sin@", "@sinusuario.com", "espacios en@email.com"),
      rep(NA, 16)
    ),
    
    # Teléfonos con formatos variados
    telefono = c(
      paste0("011-", sample(1000:9999, n-30, replace = TRUE), "-", sample(1000:9999, n-30, replace = TRUE)),
      paste0("+54", sample(1100000000:1199999999, 20, replace = TRUE)),
      c("123", "teléfono", "011-1234", ""),
      rep(NA, 6)
    ),
    
    # Género con valores inconsistentes
    genero = sample(c("M", "F", "Masculino", "Femenino", "m", "f", "H", "Mujer", NA), n, replace = TRUE),
    
    # Estado civil
    estado_civil = sample(c("Soltero", "Casado", "Divorciado", "Viudo", NA), n, replace = TRUE),
    
    # Experiencia laboral (años)
    experiencia = c(
      sample(0:40, n-15, replace = TRUE),
      c(-2, 99, 150),  # Outliers
      rep(NA, 12)
    ),
    
    # Puntaje de evaluación (1-10)
    puntaje = c(
      sample(1:10, n-20, replace = TRUE),
      c(0, 15, -1),  # Valores fuera del rango
      rep(NA, 17)
    ),
    
    # Notas adicionales con espacios y formato inconsistente
    notas = c(
      sample(c("Excelente empleado", "  Buen desempeño  ", "NECESITA MEJORAS", 
               "promedio", "", " ", "Sin comentarios"), n-10, replace = TRUE),
      rep(NA, 10)
    ),
    
    stringsAsFactors = FALSE
  )
  
  # Añadir filas duplicadas si se solicita
  if (add_duplicates) {
    filas_duplicadas <- df[1:5, ]
    df <- rbind(df, filas_duplicadas)
  }
  
  # Crear filas completamente vacías si se solicita
  if (add_empty_rows) {
    filas_vacias <- data.frame(
      id = rep(NA, 3),
      nombre = rep(NA, 3),
      edad = rep(NA, 3),
      salario_texto = rep(NA, 3),
      departamento = rep(NA, 3),
      fecha_ingreso = rep(NA, 3),
      email = rep(NA, 3),
      telefono = rep(NA, 3),
      genero = rep(NA, 3),
      estado_civil = rep(NA, 3),
      experiencia = rep(NA, 3),
      puntaje = rep(NA, 3),
      notas = rep(NA, 3),
      stringsAsFactors = FALSE
    )
    df <- rbind(df, filas_vacias)
  }
  
  # Mezclar las filas
  df <- df[sample(nrow(df)), ]
  rownames(df) <- NULL
  
  # Mostrar resumen si se solicita
  if (show_summary) {
    cat("Dataset generado con", nrow(df), "filas y", ncol(df), "columnas\n")
    cat("Dimensiones:", dim(df), "\n")
    
    cat("\n=== RESUMEN DE PROBLEMAS EN EL DATASET ===\n")
    cat("Total de NA por columna:\n")
    print(colSums(is.na(df)))
    
    cat("\nEjemplos de problemas específicos:\n")
    cat("- Nombres con formato inconsistente:", sum(grepl("^ | $|  ", df$nombre)), "casos\n")
    cat("- Salarios en formato texto:", sum(!is.na(df$salario_texto)), "casos\n")
    cat("- Edades fuera de rango (0-100):", sum(df$edad < 0 | df$edad > 100, na.rm = TRUE), "casos\n")
    cat("- IDs duplicados:", sum(duplicated(df$id, incomparables = NA)), "casos\n")
    cat("- Filas completamente duplicadas:", sum(duplicated(df)), "casos\n")
  }
  
  return(df)
}