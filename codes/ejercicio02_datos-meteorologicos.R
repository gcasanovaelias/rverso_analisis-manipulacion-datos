#Packages----
library(readxl) #leer los archivos
library(dplyr) #manipular los datos
library(string) #transformar los textos
library(lubridate) #generar las fechas

#Leer la pestaña estaciones meteorológicas----
EM = read_excel("Casanova/Estudio Personal/Rverso/BIO 4022/Clase 3 - hadleyverso y tidyverso/dim_aire_factor_estado.xlsx", 
                sheet = "T001")
  #*IMPORTANTE: con click izquierdo en la pestaña de Files da la opción de 'Import Dataset...',
  #*al apretar la opción emerge una ventana que te permite modificar el nombre del objeto y seññalar que pestaña del excel deseas importar
  #*te escribe automáticamente un código en la consola

#Cambiar el nombre de una columna en particular----
colnames(EM)[1] #selecciona el nombre de la primera columna
colnames(EM)[1] = 'Est_Meteoro'
  #Este nombre de columna se cambia debido a que en las bases de datos siguientes la estación meteorológica tiene la columna con ese nombre

#Importar variables (TempMedia)----
  #se deben importar las pestañas del excel 
TempMedia = read_excel("Casanova/Estudio Personal/Rverso/BIO 4022/Clase 3 - hadleyverso y tidyverso/dim_aire_factor_estado.xlsx", sheet = "E10000003")
  #Lo primero que hago es observar que variables me interesan y seleccionar aquellas que sí además de cambiar nombres
TempMedia = TempMedia %>% dplyr::select(-c("Código_variable","Unidad_medida")) %>% 
  rename(TempMedia = Valor)

#*IMPORTANTE.----
#* LA CLASE SE REALIZÓ EL 2017 ASI QUE LOS DATOS EMPLEADOS CAMBIARON EL FORMATO Y YA VIENEN CON UNA COLUMA DE AÑO Y MES PERO PARA TENER LOS CODIGOS ESTOS IGUAL SE REALIZAN PARA TEMPMEDIA

#Eliminar fechas con valor de mes 13----
TempMedia = TempMedia[!str_detect(TempMedia$Fecha,'_13'),]
  #*IMPORTANTE: con ! antes de una funcion booleana los T y F se intercambian

#Reemplazar días 00 por 01----
str(TempMedia) #indica qué tipo de variables son cada una de las columnas del dataframe
TempMedia$Fecha = str_replace(TempMedia$Fecha, #string
                              '_00', #pattern
                              '_01') #replacement

#Transformar a formato fecha la columna correspondiente----
TempMedia$Fecha = ymd(TempMedia$Fecha)
  #ymd(): fecha en formato Year-Month-Day
    #* IMPORTANTE: existen otras funciones con un orden distinto: dmy(), mdy(), entre otras. Cual ocupar depende del formato de la fecha
summary(TempMedia)
  #ahora que la columna Fecha está en formato fecha el summary() indica la fecha de inicio, la final y los quantiles correspondientes

#Generar las columnas para mes y año----
TempMedia$Año = year(TempMedia$Fecha)
  #Se crea una nueva columna con el año
TempMedia$Mes = month(TempMedia$Fecha)

#Unir las bases de datos (TempMedia)----
TempMedia = left_join(TempMedia,EM) %>% 
  dplyr::select(Año, Mes, TempMedia, Ciudad_localidad)
  #*La unión se realiza con TempMedia como referencia, se van a agregar columnas de EM pero basados en TempMedia
  #*Joining, by = 'Est_Meteoro': por eso tuvimos que cambiar el nombre de las columnas

#Importar variables (HumMedia)----
HumMedia = read_excel("Casanova/Estudio Personal/Rverso/BIO 4022/Clase 3 - hadleyverso y tidyverso/dim_aire_factor_estado.xlsx", 
                       sheet = "E10000006")
HumMedia = HumMedia %>% dplyr::select(-c('Código_variable',"Unidad_medida")) %>% rename(HumMedia = Valor)

#Unir las bases de datos (HumMedia)----
HumMedia = left_join(HumMedia,EM) %>%
  dplyr::select(Año, Mes, HumMedia, Ciudad_localidad)
#Unir todo (TempMedia + HumMedia)----
TempHum = full_join(TempMedia, HumMedia)
  #Me da la posibilidad de ocupar todos los datos de ambos dataframes
  #Joining, by = c("Año", "Mes", "Ciudad_localidad")

#Guardar objetos----
# .rds es el formato nativo de R por lo que es más rápido de importar y exportar. La ventaja de este formato es que no sólo puede incluir tablas o figuras sino que podemos crear archivos a partir de cualquier objeto creado en R (ggplots, model objects, matrices, funciones, etc). Las funciones de RDS son; saveRDS(), readRDS() e infoRDS().

saveRDS(TempHum,'TempHum.rds')


TempHum = readRDS('TempHum.rds')

#ESTE es el rds realizado en la clase
TempHume <- readRDS("~/Casanova/Estudio Personal/Rverso/BIO 4022/Clase 3 - hadleyverso y tidyverso/TempHume.rds")