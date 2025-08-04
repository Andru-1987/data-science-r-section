### Induccion a RMarkDown
Es como maneja el lenguaje es manejado como una especie de notebook en VSC

```yml
---
title: "Presentación de la primera clase de R"
author: "Anderson Ocaña"
date: "`r Sys.Date()`"
output: 
  html_document:
    toc: true
    toc_depth: 3
    toc_float: 
      collapsed: true
      smooth_scroll: true
    theme: journal
    highlight: kate
    df_print: paged
    code_folding: show
---
```

# Introducción

¡Bienvenidos a la primera clase de **R**!  
En esta clase vamos a conocer el lenguaje, su historia, y su utilidad en ciencia de datos.

## ¿Qué es R?

R es un lenguaje de programación orientado a estadísticas, análisis de datos y visualización.
[Intro a R](https://talently.tech/blog/programacion-en-r/)

```r
# Primer código en R
summary(cars)
````

## ¿Por qué usar R?

* Es open source
* Tiene una comunidad muy activa
* Es excelente para análisis estadístico y visualización

# Primeros pasos

## Asignaciones

```r
x <- 10
y <- 2
x + y
```

## Vectores

```r
edades <- c(20, 25, 30, 35)
mean(edades)
```

## Gráficos simples

```r
plot(edades, type = "b", col = "blue")
```

---

# Recursos extra
* [R Utilidades](https://libraryguides.mcgill.ca/c.php?g=699776&p=4968544)
* [RStudio](https://www.rstudio.com/)
* [R for Data Science](https://r4ds.had.co.nz/)
* [R ata Types](https://swcarpentry.github.io/r-novice-inflammation/13-supp-data-structures.html)

---

### Temas disponibles para `theme`

Podés cambiar `theme:` por cualquiera de estos valores:

| Tema         | Descripción breve                         |
|--------------|-------------------------------------------|
| `default`    | Estilo base de Bootstrap                  |
| `cerulean`   | Azul claro, limpio y profesional          |
| `journal`    | Estilo tipo diario, sobrio                |
| `flatly`     | Moderno y plano (flat design)             |
| `readable`   | Muy legible, espaciado                    |
| `spacelab`   | Estilo futurista y espacioso              |
| `united`     | Colores fuertes, tipo startup             |
| `cosmo`      | Moderno, con buen contraste               |
| `lumen`      | Claro y minimalista                       |
| `paper`      | Sencillo y limpio                         |
| `sandstone`  | Elegante con fondo suave                  |
| `simplex`    | Minimalista y funcional                   |
| `yeti`       | Profesional con detalles azules           |
| `darkly`     | Tema oscuro elegante                      |
| `slate`      | Tema oscuro intermedio                    |
| `superhero`  | Tema oscuro con colores vibrantes         |
