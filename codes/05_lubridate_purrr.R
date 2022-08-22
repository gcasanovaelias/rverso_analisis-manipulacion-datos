#Packages----
install.packages('purrr')
install.packages('rticles')
install.packages('animation')
library(readr) #paquete del tidyverse, la funcion read_csv() funciona mejor con los pipelines
library(lubridate)
library(tidyverse)
library(purrr) #loops amigables
library(rticles) #plantillas de revistas científicas en latex o PDF
library(stringr) #adyacente al tidyverso que nos permite trabajar con caracteres
library(raster)
library(animation) #animaciones

#1. Ejercicio----
  #*Leer el archivo IB15Tem.csv de la carpeta T&H
    #*Temperatura media medida cada hora en el ae IB15
  #*Asegurarse que las fechas estén en formato fecha y no texto (lubridate)
  #*Eliminar columnas innecesarias
  #*Agregar una columna con el ID del sitio (IB15)

setwd("~/Casanova/Estudio Personal/Rverso/BIO 4022_2019/Clase 6 - loops (purrr) y bibliografia/T&H")
IB15Tem <- read_csv("IB15Tem.csv")

IB15Tem$`Date/Time`
  #que la columna aparezca entre comillas indica que a R no le gusta ese formato, le complica
  #caracteres que molestan: ñ, acentos, parentesis (relacionado a funciones), slashs, espacios

# make.names(): R propone nombres
make.names('Días Año Nuevo (DDE)')

colnames(IB15Tem) %>% make.names()

# Manejo de datos
IB15Tem = read_csv("IB15Tem.csv") %>% #read_csv() funciona con el pipeline
  rename(Temperatura = Value, Date.Time = 'Date/Time') %>% # Nombre nuevo = Nombre antiguo
  select(Date.Time, Temperatura) %>% #Seleccionar columnas de interes (eliminar columnas innecesarias)
  mutate(Date.Time = lubridate::dmy_hms(Date.Time)) %>% #cambiar el formato de la columna fecha a una apropiada con dmy_hms() (lubridate)
  mutate(ID = 'IB15') #Agregar una columna con el ID del sitio, toda esa columna es igual a 'IB15'

p + mutate(Day = lubridate::day(Date.Time)) %>% #Extraer el día de la fecha y crear una nueva columna
  mutate(logTemp = log(Temperatura)) #transformacion a logaritmo y creación de ua nueva columna
  

  #*IMPORTANTE: lubridate transforma el caracter a un formato fecha del tipo continuo, R reconoce que es una fecha
  #*mutate(): toma una columna y lo transforma a otra cosa pudiendo sobreescribir o escribir nuevas
  #*dmy_hms(): formato de fecha 'dia-mes-año - hora-minuto-segundo)
    #*formato 'dttm': 'date time'

  #*IMPORTANTE: mutate() trabaja sobre los valores de la fila para cada columna mientras que summarise() actua sobre toda la columna

#Graficar
ggplot(IB15Tem, aes(x = Date.Time, y = Temperatura)) + 
  geom_point()

ggplot(IB15Tem, aes(x = Date.Time, y = Temperatura)) +
  geom_line(color = 'dark blue') +
  theme_minimal()

#Loops en tidyverse: map()----
  #map(.x, .f): función principal de purrr
    #*para cada elemento de .x has .f
    #*.x: puede ser un vector, lista o dataframe
    #*.f: usualmente una función
    #*Siempre entrega una lista 

x = c(1:10)

purrr::map(.x = x, .f = sqrt)
  #no se pone los parentesis
  #*IMPORTANTE: [[1]]: 1er elemento de la lista, [[2]]: 2do elemento de la lista
  #*¿Por qué entrega una lista siendo que el tidyverse trabaja con fata frames?
    #* Para que se puede agregar maps subsiguientes

# Aplicación seguida de ciclos con %>% 
purrr::map(.x = x, .f = sqrt) %>% map(.f = log)

  #1. Leer archivos----
    #Necesitamos un vector o lista que contenga todos los archivos que vamos a leer
setwd("~/Casanova/Estudio Personal/Rverso/BIO 4022_2019/Clase 6 - loops (purrr) y bibliografia/T&H")
ArchivosTemp = list.files(pattern = 'Tem.csv')
  #IMPORTANTE: el argumento pattern puede incluir más que solo la terminación del archivo

Temperaturas = map(.x = ArchivosTemp, #Vector de nuestros archivos de temperatura
                   .f = read_csv) #función de leer los csv, no se ponen parentesis
  #*IMPORTANTE: Se crea una lista cuyos componentes son data frames
  #*En una lista con dataframes puedo aplicar un loop, a cada uno de los componentes de la lista puedo aplicarle una función
  #*Cada uno de los elementos de la lista es un df por lo que puedo aplicar las funciones dplyr que he ocupado hasta ahoara en el map para que se apliquen a cada uno de los elementos de la lista

  #2. Aplicar argumentos dentro de map()----
  #*Hay un problema; nosotros pusimos un rename() y dentro de este hay argumentos pero en map() nosotros ponemos la función sin paréntesis
  #*poner un rename() sin argumentos no sirve de nada

  #*IMPORTANTE: si nosotros le agregamos argumentos a una función le agrego '~' y antes de la función agrego '.x' en vez de los datos
    #*purrr entiende que .x son nuestros datos debido al primer argumento que colocamos

Temperaturas = map(.x = ArchivosTemp, #Los datos son asignados a .x
                   .f = read_csv) %>%
  map(~rename(.data = .x, 
              Temperatura = Value, Date.Time = 'Date/Time'))
  #En este caso '~' indica que vamos a poner un parentesis con argumentos dentro

Temperaturas = ArchivosTemp %>% map(.f = read_csv) %>%
  map(~rename(.x, Temperatura = Value, Date.Time = 'Date/Time')) %>%
  map(~select(.x, Date.Time, Temperatura)) %>%
  map(~mutate(.x, Date.Time = dmy_hms(Date.Time)))

  #IMPORTANTE: esto es una lista, no un data frame. View() no funciona con listas

ArchivosTemp[2]; Temperaturas[[2]]

  #3. Aplicarle el ID----

IDs = stringr::str_replace(string = ArchivosTemp, #objeto que presenta los string que vamos a ocupar
                           pattern = 'Tem.csv', #pattern que vamos a detectar
                           replacement = '') #patron por el que vamos a reemplazar
  #*reemplazo 'Tem.csv' por nada (un espacio) para que queden solo los nombres de los ae
  #*en programacion un string hace referencia a un caracter

    #3.1. map2(.x, .y, .f)----
  #Ahora necesitamos trabajar con 2 archivos
  #.y: segundo archivo, puede ser un vector, lista o data frame pero que posee la misma cantidad de observaciones que .x (cada una de las observaciones de .x interactúa con una de .y)

Temperaturas = ArchivosTemp %>% 
  # Leer los csv contenidos en el objeto
  map(.f = read_csv) %>%
  # Cambiar los nombres
  map(~rename(.x, Temperatura = Value, Date.Time = 'Date/Time')) %>%
  # Seleccionar las columnas
  map(~select(.x, Date.Time, Temperatura)) %>%
  # Modificar una columna y transformarla a un formato fecha con purrr
  map(~mutate(.x, Date.Time = dmy_hms(Date.Time, truncated = 1))) %>%
  # Agregar una columna con los nombres que se encuentran en el objeyo IDs
  map2(.y = IDs, ~mutate(.x, ID = .y))

Temperaturas[[2]] %>% View()

  #4. Transformar una lista con data frames a un data frame----
    #4.1. purrr::reduce() ----
x = c(1:10)
map(.x = x, .f = sqrt) %>% 
  reduce(c) #c: c() de concatenar
#*IMPORTANTE: reduce() agarra todos los elementos y los junta (reduce) con alguna funcion
#*c() sirve para crear un vector

  #Para crear 1 solo data frame a partir de otros podemos ocupar rbind() ya que estos df poseen columnas iguales
    #FINAL----
Temperaturas = ArchivosTemp %>% map(.f = read_csv) %>%
  map(~rename(.x, Temperatura = Value, Date.Time = 'Date/Time')) %>%
  map(~select(.x, Date.Time, Temperatura)) %>%
  map(~mutate(.x, Date.Time = dmy_hms(Date.Time, 
                                      truncated = 1))) %>% #truncated = 1: numero de formatos que pueden ser truncados, puede o no tener segundos en este caso
  map2(.y = IDs, ~mutate(.x, ID = .y)) %>%
  reduce(rbind)

#*IMPORTANTE: existían archivos que no poseen medición de segundos mientras que hay otros que sí, debido a esto se emplea el argumento truncated = 1, que indica esta diferencia de formatos para que R no se confunda
  #*truncated = 3: indicaria que algunos datos de la fecha solo poseen registro hasta el 'día' por lo que el resto de los datos puede estar o no presente. se asume que son las 12 de la noche

#Ahora Temperaturas es un data frame y no una lista
  #map() siempre entrega una lista (formato muy desagradable), 
  #reduce(): reducir una lista en algo más dependiendo de la función que lo transforma.
    #permite juntar elementos de esa lista y transformalos en df o vectores

#for loops----
  #map() es más intuitivo con el tidyverse
  #for loops es algo muy empleado en programación
  
#for(i in 1:n){funcion, reemplazando cada elemento por una i}

setwd("~/Casanova/Estudio Personal/Rverso/BIO 4022_2019/Clase 6 - loops (purrr) y bibliografia")
list.files(pattern = 'bio')
bio.stack = readRDS("bio.stack.rds") #stack de rasters de temperatura media anual
plot(bio.stack)

  #IMPORTANTE: los stacks funcionan muy parecido a lo que sería una lista
plot(bio.stack[[1]])

  #1. Misma escala----
raster::cellStats(bio.stack[[1]], stat = 'min', na.rm = T)
raster::cellStats(bio.stack[[8]], stat = 'max', na.rm = T)
#cellStats(): estadígrafos de un mapa raster

floor(cellStats(bio.stack[[1]], stat = 'min', na.rm = T))
#floor(): redondea el valor a la unidad y hacia el valor más bajo

ceiling(cellStats(bio.stack[[8]], stat = 'max', na.rm = T))
#ceiling(): redondea el valor a la unidad y hacia el valor más alto

#la escala debiese ser en números enteros y no decimales
#Supuesto: las temperaturas más bajas y más altas serán encontradas en el año 2000 y 2070 respectivamente (bio.stack[[1]] y bio.stack[[8]])

brks = round(
  seq(floor(cellStats(bio.stack[[1]], stat = 'min', na.rm = T)), #primer valor de la secuencia 'floor' o base
      ceiling(cellStats(bio.stack[[8]], stat = 'max', na.rm = T)), #último valor de la secuencia 'ceiling' o base 
      length.out = 10), #número de valores que queremos obtener en la secuencia
  0) #redondear hasta la unidad

#Si son 10 elementos en el break, ¿cuantos colores quiero que hayan?
nb = length(brks) - 1

#Paleta de colores:
colors = heat.colors(nb) %>% #paleta de colores 'calor', obtener 9 colores distintos
  rev() #revertir el orden de los elementos, que los colores más rojos sean los con mayor temperatura

plot(bio.stack, col = colors, breaks = brks)

  #2. Graficar de a uno los raster al interior del stack----
years = seq(2000, 2070, by = 10) %>% #secuencia de los años como valores numéricos
  as.character() #que los valores numéricos se transformen en caracter (string), ahora salen entre comillas

  #Receta
plot(bio.stack[[1]], 
     col = colors, 
     breaks = brks,
     main = paste('Mean Temperatura', years[1]))
  #paste(): junta dos valores

for(i in 1:8){ #1:8 indica todos los valores que va a tomar i
  plot(bio.stack[[i]], 
       col = colors, 
       breaks = brks,
       main = paste('Mean Temperatura', years[i]))
}

animation::saveGIF(
  for(i in 1:8){
    plot(bio.stack[[i]], 
         col = colors, 
         breaks = brks,
         main = paste('Mean Temperatura', years[i]))
}, 
movie.name = 'Mean_temp.gif',
img.name = 'Rplot',
convert = 'convert',
clean = T) #borrar todas las fotos despues que hizo el GIF

