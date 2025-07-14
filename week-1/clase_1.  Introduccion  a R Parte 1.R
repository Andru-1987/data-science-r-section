#Operaciones básicas con R

suma <-3+5  #Sumamos
3-2   #restamos
3/2   #dividimos
3*2   #multiplicamos
3^2   #elevamos al cuadrado
3**2  #elevamos al cuadrado
9%%4  #operador resto


######################################
#Precedencia de los operadores
#Paréntesis
#potencias
#multiplicación
#suma

3+2*5

(3+2)*5

2/8**2

############################################
# Generamos distintos tipos de variables
a <- 1
a <- 10 #creamos una variable numérica
A <- "2" #Creamos una variable de caracteres
b <- TRUE #Creamos una variable lógica (FALSE)
c <- Sys.Date() #Creamos una variable Fecha (tomamos la fecha del ordenador con la función Sys.Date())

ls() #Observamos todas las variables que se encuentran en la memoria de R

#Investigamos la estructura de los objetos creados con la función str()
str(a)
str(A)
str(b)
str(c)

class(a)
class(A)
##########################################
#Trabajamos con vectores y matrices

#El objeto vector
a <- c(1,2,3,4) #creamos un vector de 4 elementos

c <- c(a, 7,8,9)#creamos un vector uniendo uno que ya existe con un número nuevo

#Concatenar dos vectores
a<-c(1,2,6)#creamos un vector
b<-c(4,5)#creamos otro vector
c <- c(a,b)#concatenamos ambos vectores

#Operaciones con vectores
a+3 #Le sumamos a cada elemento del vector a en número 3

a^2 #elevamos cada elemento del vector b al cuadrado

#Operaciones entre vectores
a<-1:3#1:3 es un vector igual a c(1,2,3)
b<-c(4,5,6)
a+b
a*b

#######################
#Tarea para el hogar
#¿Que hace si operamos vectores de diferentes longitudes?
#Operaciones con vectores de distinta longitud
a<-c(1:4)#Es lo mismo que escribir c(1,2,3,4)
b<-c(1,-1)
a*b# En este caso los elementos de a son el doble que los de b

b<-c(1, -1, 0)
a*b#los elementos de a y b no son múltiplos
#####################################

#Comparar vectores
a<-c(1,2,3,4)
b<-c(1,2,4,3)
a == b

#Creamos un vector a partir de dos variables
a<-"hola"
b<-"mundo"

c<-c(a, b)
print(c)

#La función seq()
#La función seq() devuelve (retorna) un vector, y por lo tanto podemos operar con él
seq(from=1,to=7, by=2)

seq(from=1,to=7, by=4)#especificamos un salto de a 4

#tres formas de generar el mismo vector
a<-seq(1,4)#si no especificamos nada, el salto es de a 1
b<-c(1,2,4,3)
c<-1:4 #El salto es de a uno

a==b
b==c

#Operaciones básicas con vectores
a<-c(1:5)
length(a) #Nos dice la longitud (cantidad de elementos) de un vector
sum(a)#suma todos los elementos del vector
mean(a)#nos dice la media de los elementos del vector
sd(a)#nos dice el desvío
median(a)#...la mediana


#Obtener un valor por su posición
a<-c(3,28,1)#Igual hubiera sido a<-c(3:1)
aa <- a[2]#Obtenemos el valor que está en la segunda posición
aaa <- a[2]*8
a[2] <- 99

#Acceder a múltiples elementos
a[c(1,3)]<-999

###################################################
#MATRICES
###################################################

a<-matrix(data=0, nrow=5, ncol=4)

b<-matrix(data=20:1, nrow=5, ncol=4)

#Asigamos nombres a las columnas
colnames(b)<-c("C1", "C2", "C3", "C4")

#Asignamos nombres a las filas
rownames(b)<-c("F1", "F2", "F3", "F4", "F5")

#accedemos a posiciones particulares
b[1,2]# accedemos al elemento de la primera fila y segunda columna

b[,2]#seleccionamos todos los elementos de la segunda columna
b[1,]#seleccionamos todos los elementos de la primera fila

#Modificar valores por posición
b[1,2] <- b[1,2]*3

b[,2] <- c(0,0,0,0,9) #reemplazo por un vector de 5 elementos

#Acceder a multiples elementos

b[c(1,3), c(2,4)]<-999
###############################################
#Data Frames
##############################################

#crear un DF a partir de vectores
x <- c(1,2,3,4,5)#creamos un vector de números
y <- c("A", "B", "C", "D", "E")#generamos un vector de letras
df <- data.frame(numeros = x, letras = y) #Generamos un DF con ambos vectores

#o en forma directa
df <- data.frame(numeros=c(1,2,3,4,5),
                 letras=c("A", "B", "C", "D", "E"))

nrow(df)#nos dice el numero de filas del DF
ncol(df)#nos dice la cantidad de columnas de DF

dim(df)# nos devuelve un vector con los valores filas y columnas de DF

colnames(df)#nos dice los nombres de las columnas del DF
rownames(df)#nos dice los nombres de las columnas de DF

names(df)

summary(df)

#Agregar una columna al DF
meses <- c("Enero", "Febrero", "Marzo", "Abril", "Mayo")#Creamos un vector con los primeros 5 meses
df$Meses <- meses  #Agregamos una columna con el vector de meses creado
df$meses <- c("Ene", "Feb", "Mar", "Abr", "May") #También lo podemos agregar en forma directa
df$nueva <- df$numeros/3

###################################################
#Lectura y escritura de archivos externos .csv
###################################################

#Escribir un DF a un archivo .csv
write.table(x=df,file="/media/cesar/cesar_SD/Curso de R/Instituto data science/Introducción a R/mis_df.csv", sep=";")

ruta<-"/media/cesar/cesar_SD/Curso de R/Instituto data science/Introducción a R/mis_df.csv"
write.table(x=df,file=ruta, sep=";")

# Observo el directorio de trabajo
getwd()
#write.table(x=df,file=mis_df.csv, sep=";")#Guarda en ruta por defecto
# Modifico el directorio de trabajo para trabajar más cómodo
setwd("/media/cesar/cesar_SD/Curso de R/Instituto data science/Introducción a R") #Recuerden que la ruta se marca con la barra "/" o "\\" (shift + 7)

#Ahora R va a leer y escribir en esta carpeta por defecto

mi_df <- read.csv("mis_df.csv")

mi_df <- read.csv("mis_df.csv", sep=";")

#Otra forma de agregar columnas
z<- c(100, 200, 300, 400, 500)
c<-cbind(df, cientos= z)#usamos la función cbind() para unir DF

c$nueva <- 2000:2004


##################################################
#LISTAS
##################################################

a<-list(1, "b", Sys.Date(), TRUE)
str(a)
a[1]#hacemos referencia al elemento 1
a[[1]]#Accedemos al valor del elemento 1 
a[1][1]#También accedemos al elemento 1

a<-list(1, b, Sys.Date(), TRUE)

length(a)

#Agregamos un elemento a la lista
a<-c(a, "X")
a<-list(a, "XX")#También funciona

#Listas con vectores
a<-list(c(1,2,3), "b", Sys.Date(), TRUE)
a[[1]][2]#accedemos al elemento 1 de la lista, accedemos al elemento 2 del objeto


###############################################
#CONVERSIONES
###############################################


#as.data.frame()
#as.factor()

#as.vector()
#as.character()
#as.numeric()
#as.Date()
#as.matrix()


#Pasar un string a Fecha

fecha_en_letras <- "2020-04-09"
str(fecha_en_letras)

fecha_en_Date<-as.Date(fecha_en_letras)
str(fecha_en_Date)

a<-"b"
b<-as.numeric("a")
b


#Convertir un DF a una matriz

hh<-as.matrix(h)#convertimos el DF h en un matriz
hh

h<-airquality

head(h)
str(h)

m<-as.matrix(h)
m[1:6,]
str(m)

#agregamos una columna con letras en el DF h
h$letras <- "a"
head(h)

m<-as.matrix(h)
m[1:6,]
str(m)



#############################################
#############################################
#############################################
#FUNCIONES Y PAQUETES QUE TENEMOS QUE CONOCER

#PAQUETE BASE

#Funcion subset() para filtrar filas y columnas

#función order() para ordenar data frames
#?order

#Funciones para generar números aleatorios: rnorm(), runif(), rbinom()

#Función ifelse() para construir variables condicionales

#Función merge() para fundir archivos

# Función aggregate() para generar tablas de resúmenes

###################################################
#Funciones para hacer gráficos
#barplot() para hacer gráficos de barras
#plot() para graficar nube de puntos
#pie() para graficar un gráfico de torta
#hist() para graficar un histograma
#boxplot() para graficar un boxplot


###################################################
#PAQUETE reshape2

#install.packages("reshape2")

#Función dcast() y acast() para generar tablas pivot

#Función melt() para trasponer data frames

##################################################
#PAQUETE xlsx
#install.packages("xlsx")

#Función write.xlsx() para guardar datos en un archivo .xlsx
