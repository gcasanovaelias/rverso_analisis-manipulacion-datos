# Packages----
install.packages("tidyverse")
library(tidyverse)
# Este paquete descarga y carga los paquetes que pertenecen al tidyverse (dplyr, ggplot, tidyr, entre otros)
# IMPORTANTE: el pipeline '%>%' funciona con todo el tidyverso

#* Paquetes en el corazon del tidyverso:
#* dplyr
#* tidyr (complemento/ant?tesis de dplyr)
#* ggplot2
#* readr (cuando importamos ya estamos usando este paquete, se descarga autom?ticamente)
#* purrr (relativamente nuevo, muy bueno para ocupar en loops y trabajar con varios datos)

#* Paquetes adyacentes al tidyverso: (no son del tidyverso propiamente tal pero han sido creados pensando en ?l funcionando con los mismos principios)
#* stringr (una de las cosas que puede ser m?s complicado dentro de R es modificar columnas que son palabras (una fecha por ejemplo, un error de tipeo). Este paquete sirve para arreglar esto)
#* lubridate (para fechas y fechas/horas, simple de usar, puede incluso funcionar bien cuando se tiene fechas de distinto formato)
#* forcats (para variables categ?ricas)
#* hms (para horas)
#* Si empezamos a trabajar con el tidyverso el trabajo se simplifica y todo sale m?s r?pido

# tidyr----
# El paquete tidyr tiene dos funciones solamente
# Hadley Wickam escribi? este paquete junto con reshape y reshape2 (versiones anteriores y peores de tidyr)
# a diferencia de los dem?s paquetes, esta evoluci?n de paquetes ha ido enfocada en la sencillez
# gather() y spread() trabajan transformando una tabla ancha a una larga y viceversa, respectivamente
# Hay muchas veces en que querermos transformar tablas de ancho a largo o viceversa a pesar de estar en formato tidy

# gather()----
# Junta, alarga las columnas verticalmente al juntar
mini_iris <- iris[c(1, 51, 101), ]
class(mini_iris)
MI <- mini_iris %>% gather(
  key = flower_att, # key va a indicar el nombre de la columna categ?rica del nuevo data.frame
  value = measurement, # value va a indicar el nombre ('measurement') para la columna de valores num?ricos en el nuevo data frame
  -c(Species, Petal.Length)
) # hacer lo anterior con todas las variables excepto con la variable Species y Petal.Length
#* Quiero que las columnas se conviertan en variables categ?ricas y los valores se conviertan en valores de esas categorias
#* IMPORTANTE: todas las ex-columnas (largo y ancho de petalos y sepalos) se han congregado en el flower_att indicado. ESto no ocurre con la variable Species debido al signo menos '-'

MI <- mini_iris %>% gather(
  key = flower_att,
  value = measurement,
  Petal.Length, Petal.Width, Sepal.Length, Sepal.Width
) # Forma alternativa en donde se indican las columnas que quiero que se integren al key (columna formada) en vez de indicar cuales no quiero

# spread()----
# hace lo contrario que gather()
M <- MI %>% spread(flower_att, measurement)
M
# obtengo la tabla original antes de aplicar el gather()

# separate() & unite() ----
MI %>% separate(
  col = flower_att,
  into = c("Petal", "Medici?n"),
  sep = 5
)


# Ejercicios----
counts_df <- data.frame(
  day = c("Monday", "Tuesday", "Wednesday"),
  A = c(2, 1, 3),
  B = c(20, 25, 30),
  C = c(4, 4, 4)
)
# Esto es una tabla de contingencia, no es un tidydata
# No se puede graficar este untidy data, si yo tomo columnas no voy a poder realizar comparaciones
# Se tienen 3 variables; el dia, los senderos (A, B y C) y la cuenta (n?meros)
# Se transforman los tratamientos A, B y C a variables de una columna mientras que los avistamientos se transforman en otra columna
df <- counts_df %>%
  gather(
    key = tratamiento, # sendero es el nombre de la columna agrupada
    value = count, # cuenta de avistamiento de wolf, hare, y fox
    -day
  ) %>%
  arrange(day) # el dia es la ?nica variable que la conservamos tal como est?
# IMPORTANTE: una de las gracias del tidyverso es que los nombres de las columnas no se ponen entre comillas

# Grafico----
library(ggplot2)
ggplot(df, aes(x = tratamiento, y = count)) +
  geom_boxplot()
#* ggplot() es antiguo, cuando se cre? no exist?a el pipeline pero ocupa un s?mbolo de suma '+'
#* geom_scatterpoints(), geom_boxplot(), geom_jitter()
#* gracias al gather() nosostros pudimos trabajar con variables x e y
# Ejercicio 2----
install.packages("dismo")
library(dismo) # paquete para modelacion de distribucion de especies
huemul <- gbif("Hippocamelus", # el primer argumento es el g?nero de la especie de inter?s
  "bisulcus", # segundo argumento indica la segunda parte del binomio
  down = T
) # descargar la base de datos convertida en un data frame
# IMPORTANTE: podemos dscargar datos de cualquier especie que queramos
#* gbif: uno de varios sitios web que se dedica a copilar puntos de concentraci?n de especies de todo el mundo
#* al inicar una especie la base de datos te entrega todos los puntos registrados para esa especie adem?s de un mont?n de informaci?n adicional
#* las bases de datos disponibles no son tan tidy como uno esperar?a
colnames(huemul)
View(huemul)

gbif("Castor", "canadensis",
  download = F
) # en vez de descargar la base de datos solo obtengo informacion acerca del n?mero de observaciones que existen
#* IMPORTANTE: desde gbif tambien podemos obtener bases de datos de especies vegetales, existen otras fuentes de bases de datos entre ellas BIEN
#* Existen problema de sinonimia en muchas bases de datos (gbif incluido) pero BIEN es la que m?s a trabajado en corregir ese y otros problemas (adem?s tiene una funcion en R)
# a. Quedarse con solo las observaciones que tienen coordenadas geogr?ficas
sola <- huemul %>%
  dplyr::select(lon, lat, basisOfRecord) %>%
  filter(!is.na(lat) & !is.na(lon))
#* is.na(): me entrega resultados booleanos (true or false)
#* !is.na(): al poner el signo '!' se seleccionan las observaciones que no sean na

# b. Cuantas observaciones son humanas y cuantas de especimen de museo
huemul$basisOfRecord %>% unique()

solb <- huemul %>%
  group_by(basisOfRecord) %>%
  summarise(N = n())
# n(): entrega el tama?o del grupo

# Map_r----
install.packages("mapr",
  dependencies = T
) # indicar si tambien se quiere instalar los paquetes en los que se basa
library(mapr)
library(spocc)
dat <- occ(
  query = "Hippocamelus bisulcus",
  from = "gbif",
  has_coords = T,
  limit = 50
)
map_ggmap(dat)
