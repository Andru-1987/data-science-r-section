print("Hola mundo, mi primer archivo R --> orientado a datos")

# esto es una asigancion a derecha
10 -> CONST_VALUE
# esto es una asignacio a la izq (lo normal!!!)
nombre_variable <- 1+2+3+4+5

    
print("esto es una constante: ")
print(CONST_VALUE)
print("lista de variables")
print(nombre_variable)

soy_un_boolean <- 7 <= 8 #TRUE
print(soy_un_boolean)


date_variable <- Sys.Date()
print(date_variable)

str(date_variable)

# Datos del tipo vectorial

vector_numerico <- c(1,2,3,4,8)
vector_range <- 1:100
vector_seq <- seq(from = 0, to= 200, by=10)

str(vector_numerico)
str(vector_range)
str(vector_seq)

length(vector_seq)
sum(vector_seq)
median(vector_seq)
sd(vector_seq)


vector_radial <- vector_seq * pi
vector_radial

matriz_data <- matrix(data= 20:1, nrow = 5 , ncol = 4)
matriz_data

colnames(matriz_data) <- c("campo_1","campo_2","campo_3","campo_4")
matriz_data

matriz_data[1,2]

matrix_dataframe <- as.data.frame(matriz_data)


matrix_dataframe$campo_1

str(matrix_dataframe)

summary(matrix_dataframe)


order_df <- read_csv("https://raw.githubusercontent.com/Andru-1987/csv_files_ds/refs/heads/main/Orders.csv")

summary(order_df)








