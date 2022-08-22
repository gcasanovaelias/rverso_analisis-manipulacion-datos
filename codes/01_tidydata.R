# Packages----
install.packages("epitools")
library(epitools)

install.packages("stargazer")
library(stargazer)
# Apuntes introduccion----
# Vectores, dataframes, matrices y listas son conjuntos de datos
# Un vector es el an?logo a una columna y tanto matrices como dataframes estan compuestos por columnas
#* IMPORTANTE: los dataframes pueden contener columnas con distintas clases de datos pero dentro de una misma columna no pueden existir m?s de una clase de datos
#* en estos casos R transforma la clase de los datos para que sean el mismo
# vectores y matrices s?lo pueden ser de un tipo de datos (numericos, logicos, caracteres), mientras que los data frames pueden tener columnas con distintos tipos de datos
# en las listas podemos incluir lo que queramos, en una misma lista podemos encontrar que esta compuesta por vectores, matrices, dataframes u objetos ?nicos

# Vectores----
# Subsetear: tomar elementos del conjunto
# para subsetear vectores solamente se necesita un indicador (x)
data(uspop)
uspop[5]
uspop[5:10]
uspop[c(3, 5, 8)]

# Data frame----
# Subsetear: ahora se debe indicar tanto filas como columnas '[,]'
# para subsetear data frames se necesitan dos indicadores (x, y)
data(iris)
iris[, 3] # se selecciona una columna y esta corresponde a un vector
iris[, 3:5] # dataframe m?s peque?o
iris[1:10, 3:5]
iris$Species # vector de la columna de las especies

# No todos los subseteos entregan las mismas estructuras de datos
class(iris[, 5]) # vector del tipo factor
class(iris[3, ]) # data frame
class(iris["Species"]) # data frame

# Por lo que el n?mero de indicadores dentro del subseteo no es el mismo
iris[, 5][1] # un indicador x para los vectores
iris["Species"][1, 1] # dos indicadores (x, y) para los data frame

# Modificaci?n de columnas de un data.frame
mtcars$mpg
mtcars$mpg^2
mtcars$mpg^0.2

# Tidy data----
#* el concepto de tidy data se refiere a que siempre es preferible que nuestros datos esten organizados como data frames
#* el c?mo se organice el data frame tambien es importante; columnas: variables, filas: observaciones y cada celda va a ser un valor
#* A pesar de que pareciera ser obvio, existen varios casos en que los datos no los encontramos as?
#* Cuando nosotros queremos hacer graficos necesitamos que cada una de las columnas sea un resultado, una fila por cada observaci?n
#* Tablas m?s largas pero mucho m?s apropiadas para graficar y analizar estad?sticamente

# Transformar tablas de contingencia (untidy) a tablas apropiadas (tidy)
install.packages("epitools")
library(epitools)

data("HairEyeColor")
HairEyeColor
#* Tabla de contingencia separada por sexos, dificil de analizar
#* Son tablas peque?as buenas para resumir pero no para realizar an?lisis

expand.table(HairEyeColor)
#* expand.table() es una funci?n del paquete epitools

# Prueba de limpieza----
# Si se puede realizar un an?lissi de regresi?n lineal con los datos eso significa que el data frame esta ordenado de manera adecuada
# lm: modelo regresi?n lineal, glm: modelo lineal generalizado (modelo de clasificaci?n)
data(iris)
m1 <- lm(Petal.Length ~ Species, data = iris)
summary(m1)

install.packages("stargazer")
library(stargazer)
stargazer(m1, type = "html", single.row = T)
# lm
data(mtcars)
model1 <- lm(mpg ~ wt + hp, data = mtcars)
summary(model1)
# glm
model2 <- glm(mpg ~ wt + hp, data = mtcars)
summary(model2)
# Dato: Existe el AICc (AIC corregido) que es preferible al AIC

# dplyr----
# paquete con pocas funciones muy poderosas para el ordenamiento de datos
# https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf
# Summarize y group_by----
library(dplyr)
library(knitr)

mean1 <- dplyr::summarize(iris, mean.petal = mean(Petal.Length))
# summarize():resume una variable

mean1 <- group_by(iris, Species)
# group_by():re?ne observaciones seg?n una variable
mean1 <- dplyr::summarize(mean1, # dataframe en la cual vamos a operar
  mean.petal = mean(Petal.Length)
) # creacion de una columna
# group_by():re?ne observaciones seg?n una variable
# usadas en conjunto son muy poderosas
kable(mean1)
# crea una tabla de un dataframe

mean2 <- group_by(iris, Species)
mean2 <- dplyr::summarize(mean2, # dataframe en la cual vamos a trabajar
  mean.petal = mean(Petal.Length), # creaci?n de una columna
  sd.petal = sd(Petal.Length),
  sum.petal = sum(Petal.Length)
)
mean2 # creaci?n de una columna
kable(mean2)

# Pipeline (%>%)----
# Ahorra l?neas, se parte con un dataframe
# Se agregan funciones hasta llegar al resultado deseado
# Nos permite realizar varias funciones de manera sucesiva sin necesidad de ir creando objetos
# Por cada pipeline creado es equivalente a ahorrar tener que crear un objeto (si aplico 6 pipelines me ahooroo crear 6 objetos)
mean1 <- iris %>%
  group_by(Species) %>%
  summarize(
    mean.petal = mean(Petal.Length),
    sd.petal = sd(Petal.Length),
    sum.petal = sum(Petal.Length)
  )
# summarize_all()----
# funci?n que permite realizar tareas m?s potentes, trabaja con todas las columnas
mean_all <- iris %>%
  group_by(Species) %>%
  summarise_all(funs(mean))
# se obtiene la media de TODAS las columnas

# Filter----
# selecciona segpun una o m?s variables
# funciona a trav?s de expresiones booleanas (el resultado es verdadero o falso)
# IMPORTANTE: Trabaja en base a columnas pero selecciona filas (o elimna filas)
df <- iris %>%
  filter(Species != "versicolor") %>%
  group_by(Species) %>%
  summarise_all(funs(mean))

df1 <- iris %>%
  filter(Species %in% c("versicolor", "virginica")) %>%
  group_by(Species) %>%
  summarise_all(funs(mean))
#* %in% trabaja con vectores, selecciona si se cumple que la observaci?n se encuentre dentro del vector (sea igual a uno de los valores)

# Duda respondida durante la clase 3 ?C?mo poner m?s de una funci?n en summarise_all?----
df <- iris %>%
  group_by(Species) %>%
  select(contains("Petal")) %>%
  summarise_all(funs(mean, sd))
df

df <- iris %>%
  group_by(Species) %>%
  summarise_all(funs(mean, sd))
df

# Select----
# selecciona columnas dentro de un data.frame
# IMPORTANTE: a diferencia de filter(), select() selecciona columnas
iris %>%
  filter(Species %in% c("versicolor", "setosa")) %>%
  group_by(Species) %>%
  select(Petal.Length, Sepal.Length, Sepal.Width) %>%
  summarise_all(funs(mean))
# IMPORTANTE: el orden s? importa, al aplicar select() antes del group_by() o filter() se genera un error ya que estas dos funciones emplean una columna que no era inluida en select()

# nasa2 %>% filter(month %in% c(5,6,7) & year == 2000) %>% group_by(month) %>% select(contains('temp)) %>% summarise_all(mean)

# EJERCICIOS PROPUESTO----
data("storms")
View(storms)
# 1
storms %>%
  filter(status == "hurricane") %>%
  group_by(year) %>%
  select(wind, pressure) %>%
  summarise_all(funs(mean))
# 2
iris %>%
  filter(Species == "virginica") %>%
  summarise(length.mean = mean(Petal.Length))
# 3
ma <- filter(mtcars, am == 1)
au <- filter(mtcars, am == 0)

ma_lm <- lm(mpg ~ wt, data = ma)
au_lm <- lm(mpg ~ wt, data = au)

# ystargazer(ma_lm,au_lm,type='html',single.row=T)
