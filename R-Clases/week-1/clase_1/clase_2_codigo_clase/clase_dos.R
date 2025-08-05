print("CREAR UN DATAFRAME")

numeros <- 1:3  # rango -> range (python)
columnas <- c("a","b","c") # vector -> serializable | iterable

dataframe <- data.frame(numeros=numeros, columnas=columnas) # pandas.DataFrame

dataframe

str(dataframe)

nrow(dataframe)
ncol(dataframe)
dim(dataframe)


summary(dataframe)

# cbind -> nos permite unir columnas a nuestro df

secuencia_numerica <- seq(from=200, to=400, by=100) 
secuencia_numerica


df_agregado <- cbind(dataframe,data_value_number=secuencia_numerica)
df_agregado

df_agregado["numeros"]
df_agregado$numero_radianes<- dataframe$numeros ** pi 


df_agregado

# --- archivo csv de la nub
