#ggplot2----
#*Paquete de visualizacion de datos de tidydata, 
#*paquete m?s antiguo del tidyverse, est? en v?as de ser reemplazado por ggvis
#*ggplot(data.frame, aes(nombres de columna)): el aes indica que lo que se pondra entre parentesis ser?n nombres de columnas, otros paquetes del tidyverse no enecsitan hacer esto pero en ggplot2 es requisito
#*+ geom_algo(argumentos, aes(columnas)): indica el tipo de gr?fico que queremos hacer (bar, point, line)
#*+ theme_algo(): cambiar el estilo del gr?fico
#*Personalizacion de ejes y leyendas

#LINKS para aprender m?s----
#*http://zevross.com/blog/2014/08/04/beautiful-plotting-in-r-a-ggplot2-cheatsheet-3/
#*http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf
#*https://github.com/rstudio/cheatsheets/blob/master/data-visualization-2.1.pdf

#Algunos argumentos para los geoms (geom_algo())----
#*color: color de L?NEAS O PUNTOS
#*alpha: transparencia de 0 (transparente) a 1 (s?lido)
#*size: tama?o de puntos
#*shape: tipo de puntos
#*fill: color dentro de un ?rea (BARRAS, INTERVALOS)

#color----
library(ggplot2)
data("diamonds")

#Graf?co b?sico de color negro
ggplot(diamonds, aes(x = carat, y = price)) + geom_point()

#Gr?fico b?sico de color distinto al negro
ggplot(diamonds, aes(x = carat, y = price)) + geom_point(color = 'green')

#Gr?fico de puntos con colores diferenciados por valores de columnas
  #*Para indicar que los colores sean deacuerdo a una columna se ocupa aes()
ggplot(diamonds, aes(x = carat, #en el eje x est? la variable carat (kilates)
                     y = price)) + #en el eje y est?n los precios
  geom_point(aes(color = cut)) + #gr?fico de puntos donde los colores de estos son de acuerdo a la variable corte (cut), una tercera variable distinta a las que conforman los ejes cartesianos
  theme_classic() #clas?co de formato paper, blanco y negro con dos ejes donde no se ponen rayas dentro de los gr?ficos

#Guardar el grafico ggplot() como objeto
p = ggplot(diamonds, aes(x = carat, y = price)) +
  geom_point(aes(color = cut))
  #puedo guardar el grafico como un objeto e ir trabajando en base a el
p + theme_classic()
  #*IMPORTANTE: EXPORTAR EN PDF
  #*Recomendable exportar los gr?ficos en PDF, este trabaja en un formato vectorial, es decir, no importa cuanto nos acerquemos al gr?fico siempre va a mantener su resoluci?n,
  #*Mejor para las publicaciones

#alpha----
#bueno para corregir densidades de puntos muy altas (los puntos se tapan entre s?)
ggplot(diamonds, aes(x = carat, y = price)) +
  geom_point(aes(color = cut), 
             alpha = 0.1) + #alpha va a fuera de aes() ya que queremos que var?e en func??n de las columnas, queremos que el alpha sea igual para todos los datos
  theme_classic()

#size----
data(mtcars)
ggplot(mtcars, aes(x = wt, y = mpg)) + 
  geom_point(aes(size = hp)) + #El tama?o de los puntos est? dado por una tercera variable distintas a las que se encuentran en los ejes
  theme_classic()

#Graficar m?s de 2 variables en un gr?fico 2D----
#Con aes en geom_algo() podemos agregar m?s variables en el gr?fico
ggplot(mtcars, aes(x = wt, y = mpg)) + 
  geom_point(aes(size = hp,
                 color = cyl)) + 
  theme_classic()
#Podemos aobservar 4 variables en total a pesar de ser un gr?fico de dos dimensiones
  #*mpg y wt est?n en los ejes,
  #*hp est? representado por el tama?o y
  #*cyl es seg?n el color

#shape----
ggplot(diamonds, aes(x = carat, y = price)) + 
  geom_point(aes(shape = cut)) + 
  theme_classic()
  #no es recomendable aplicar esto en variables continuas

#fill----
diamonds$clarity %>% unique()
d2 = diamonds %>% filter(clarity == 'I1' | clarity == 'IF')

ggplot(d2, aes(x = cut, #variable categ?tica en el eje x
               y = price)) + 
  geom_boxplot(aes(fill = clarity)) + 
  theme_classic()

#Geom_algo() para UNA variable categ?rica Y UNA continua----
#*geom_boxplot()
#*geom_jitter()
#*geom_violin()
#*geom_bar()

#geom_jitter()----
#realiza una dispersi?n de puntos (a pesar de ser una de las variables categ?ricas)
iris
ggplot(iris, aes(x = Species, #variable categ?rica
                 y = Petal.Length)) + #variable cuantitativa
  geom_point(aes(color = Species))
  #Se observa que los puntos se sobreponen unos con 
    #Los puntos que presentan igual valor en el eje y SI QUEDAN en el mismo lugar
ggplot(iris, aes(x = Species, #variable categ?rica
                 y = Petal.Length)) + #variable cuantitativa
  geom_jitter(aes(color = Species))
  #*Con geom_jitter los puntos no quedan ordenados en una sola l?nea ni tampoco se sobreponen, 
  #*en este caso se visualiza mejor la idea con geom_jitter()
    #*Los puntos que presentan igual valor en el eje y NO QUEDAN en el mismo lugar

#geom_violin()----
#funciona como un histograma (pero de lado y con un espejo)
ggplot(iris, aes(x = Species, y = Petal.Length)) + 
  geom_violin(fill = 'dark red')
  #podemos observar que setosa posee una distribuci?n normal
  #forma bastante interesante de visualizar nuestros datos

#Combinaci?n de geom_algo()----
ggplot(iris, aes(x = Species, y = Petal.Length)) + 
  geom_violin() + 
  geom_point(aes(color = Species), position = "jitter")
  #*IMPORTANTE: el orden de los geoms s? importa, el ?ltimo sumando va visualizandose encima del anterior
  #*ggplot2 funciona como un programa gr?fico por capas
  #*podemos combinar varios geoms

ggplot(iris, aes(x = Species, y = Petal.Length)) + 
  geom_jitter(aes(color = Species)) + 
  geom_violin(alpha = 0.2) #con las gr?ficos que poseen un contorno y un llenado el alpha a la consistencia-transparencia

#geom_boxplot----
ggplot(iris, aes(x = Species, y = Petal.Length)) + 
  geom_boxplot(aes(color = Species))

#Geom_algo para DOS variables continuas----
#*geom_point()
#*geom_smooth()
#*geom_line()
#*geom_hex()
#*geom_rug()

#geom_hex()----
#Parecido a un histograma pero de dos ejes, se tiene un hexagono con colores particulares que muestran el conteo de puntos 
ggplot(diamonds, aes(carat, price)) + 
  geom_hex()
  #el color de los hex?gonos indica la cantidad o conteo de observaciones

#geom_smooth()----
#muestra la tendencia de nuestros datos
ggplot(mtcars, aes(wt, mpg)) + 
  geom_smooth() + #obtego un loess
  geom_point()
  #la l?nea de tendencia es la azul mientras que el error se muestra en gris
  #*IMPORTANTE: en general cuando nosostros colocamos geom_smooth() sin atributos y tenemos pocas observaciones obtenemos un loess
  #*loess es una medida de la media local y es muy poco ?til, no es muy interesante
    #se puede cambiar f?cilmente
ggplot(mtcars, aes(wt, mpg)) + 
  geom_smooth(method = 'lm') + #otros modelos: glm, gam, loess, lm
  geom_point()
  #IMPORTANTE: ahora la linea azul representa el modelo y lo gris indica el esrror est?ndar de la regresi?n

ggplot(mtcars, aes(wt, mpg)) + 
  geom_smooth(method = 'lm') +
  geom_point(aes(color = factor(cyl))) #la variable cyl no es continua, es un valor discreto el numero de cilindros 
  #IMPORTANTE: cyl aparece como continua pero en realidad es discreta,
  #factor(): Podemos indicarle a ggplot que tome la variable como una variable categ?rica (factor)

ggplot(mtcars, aes(wt, mpg)) + 
  geom_smooth(method = 'lm', 
              aes(color = 'dark red', #color de la l?nea (modelo de regresi?n)
                  fill = factor(cyl))) #color seg?n el n?mero de cilindr
  #*IMPORTANTE: Se forma una regresi?n lineal para cada uno de mis factores
  #*el error estandar aument? bastante, debido a que se tienen menos observaciones


  #*IMPORTANTE: geom_smooth() da poca flexibilidad
  #*hay otras funciones que nos brindan m?s felxibilidad a lo que queremos visualizar
#stat_smooth(), m?s control que con geom_smooth()----
TempHume = readRDS("~/Casanova/Estudio Personal/Rverso/BIO 4022_2019/Clase 3 - hadleyverso y tidyverso/TempHume.rds")
  #.rds: formato nativo de R, mantiene los formatos trabajados en las columnas para la base de datos
    #si mando un csv un formato fecha se cambia a un formato de caracter por lo que nuevamente uno u otra persona tiene que darse el trabajo de cambiarlo
  #*Permite guardar, en viar y mantener los archivos y sus columnas en el formato trabajado
  #*Puedo guardar cualquier cosa que quiera como un .rds
saveRDS(p, 'p.rds')
plot1=readRDS('p.rds')

class(TempHume)
TempHume$Ciudad_localidad %>% levels() #NULL
TempHume$Ciudad_localidad %>% unique() #funciona

PA = TempHume %>% filter(Ciudad_localidad == 'Punta Arenas')

#stat_smooth
ggplot(PA, aes(x = mes, y = TempMedia)) +
  geom_point() +
  stat_smooth(method = 'lm', 
              formula = y ~ x + I(x^2)) #Indico la expresi?n cuadr?tica
  #*Cuando trabajamos con stat_smooth() podemos agregar una expresi?n cuadr?tica, c?bica un comportamiento logaritmico u otr
  #*se observa que los meses en el eje x est?n como variable cuantitativa (un mes no est? indicado como7.5)

#Mes como factor (variable categ?rica a pesar de ser n?mero)
ggplot(PA, aes(x = factor(mes), #mes como factor (categorica)
               y = TempMedia)) + 
  geom_boxplot() + 
  xlab('Mes') + 
  ylab('Temperatura media')
  #ahora aparecen todos los meses (como n?mero) en el eje x

#Fecha como variable dependiente
ggplot(PA, aes(x = Fecha,
               y = TempMedia)) + 
  geom_line()
  #ggplot es bien inteligente a la hora de graficar en base a fechas

#Aplicando tambien tidyr----
SATH = TempHume %>% filter(Ciudad_localidad == 'Quinta Normal') %>% 
  gather(key = Unidad, #se crea una nueva columna categ?rica llamada Unidad
         value = medida,#se crea una nueva columna con valores num?ricos llamada medida
         TempMedia, HumMedia) #se emplear?n las columnas de TempMedia y HumMedia para crear las columnas anteriores
  #*las nuevas columnas ser?n conformadas por TempMedia y HumMedia, 
  #*en una columna aparecer?n como variables categoricas y en la otra apareceran sus valores num?ricos
  #*las dem?s columnas de TempHume quedan iguales

#Ahora que el arreglo de la columna cambi? podemos realizar otros an?lisis
ggplot(SATH, aes(x = mes, y = medida)) + 
  geom_point() + 
  stat_smooth(method = 'lm', formula = y ~ x + I(x^2),
              aes(fill = Unidad, color = Unidad)) + #IMPORTANTE: es aqu? que se le indica a ggplot que queremos distintos colores para los distintos valores de la columna Unidad
  ggtitle('Temperatura y Humedad media') #agregar un t?tulo

#Combinar gr?ficos----
#IMPORTANTE:para evitar que los valores de los ejes y sean muy distintos entre los gr?ficos se agrega la funci?n ylim()
ari = TempHume %>% filter(Ciudad_localidad == 'Arica') %>% 
  ggplot(aes(mes, TempMedia)) + geom_jitter() + 
  stat_smooth(method = 'lm', formula = y ~ x + I(x^2)) + 
  ggtitle('Arica') + ylim(c(-12,30))

jua = TempHume %>% filter(Ciudad_localidad == 'Isla Juan Fern?ndez') %>%
  ggplot(aes(x = mes, y = TempMedia)) + geom_jitter() + 
  stat_smooth(method = 'lm', formula = y ~ x + I(x^2)) + 
  ggtitle('Isla Juan Fern?ndez') + ylim(c(-12,30))

san = TempHume %>% filter(Ciudad_localidad == 'Quinta Normal') %>%
  ggplot(aes(mes, TempMedia)) + geom_jitter() + 
  stat_smooth(method = 'lm', formula = y ~ x + I(x^2)) + 
  ggtitle('Quinta Normal') + ylim(c(-12,30))

con = TempHume %>% filter(Ciudad_localidad == 'Concepci?n') %>%
  ggplot(aes(mes, TempMedia)) + geom_jitter() + 
  stat_smooth(method = 'lm', formula = y ~ x + I(x^2)) +
  ggtitle('Concepci?n') + ylim(c(-12,30))

pun = TempHume %>% filter(Ciudad_localidad == 'Punta Arenas') %>%
  ggplot(aes(mes, TempMedia)) + geom_jitter() +
  stat_smooth(method = 'lm', formula = y ~ x + I(x^2)) + 
  ggtitle('Punta Arenas') + ylim(c(-12,30))

ant = TempHume %>% filter(Ciudad_localidad == 'Ant?rtica Chilena') %>%
  ggplot(aes(mes, TempMedia)) + geom_jitter() + 
  stat_smooth(method = 'lm', formula = y ~ x + I(x^2)) + 
  ggtitle('Ant?rtica Chilena') + ylim(c(-12,30))

library(gridExtra)
  #IMPORTANTE: s?lo sirve para gr?ficos de ggplot
  #este paquete da mucha versatilidad en armar un gr?fico y nos la da a nosotros
grid.arrange(ari,jua, san, con, pun, ant, nrow =2, ncol=3)
  #grid.arrange(): arma un solo gr?fico a partir de los objetos que contienen gr?ficos ggplot

#Modificar el eje X---- 
TempHume %>% filter(Ciudad_localidad == 'Ant?rtica Chilena') %>% 
  ggplot(aes(mes, TempMedia)) + geom_jitter() + 
  stat_smooth(method = 'lm', formula = y ~ x + I(x^2)) +
  ggtitle('Ant?rtica Chilena') + ylim(c(-12,30)) + 
  scale_x_continuous(breaks = seq(1,12),
                     labels = c('Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic'))

#Modificar semanas a meses
+ scale_x_continuous(breaks = seq(from = 2.5, to = 49.5, by = 4), labels = c('Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic'))
  #2.5 es la mitas del mes de enero, si le agrego 4 unidades m?s (6.5) indica la mitad del mes de febrero
  #by = 4: incremento de 4
#geom_ribbon()----
p = ggplot(Weekly, aes(x = Semana, y = mean)) + 
      geom_ribbon(aes(ymin = min,ymax = max,fill = 'red')) + #este geom crea una banda (parecida a la gris observada en stat_smooth y geom_smooth) donde nosotros le indicamos los valores que queremos que tome, en este caso se?alado con columnas min y max
      geom_ribbon(aes(ymin = mean - sd, ymax = mean + sd, fill = 'blue')) + #puedo hacer operaciones dentro de las columnas, en este caso estamos graficando los valores m?s extremos al agregar la sd
      geom_line() #no es necesario indicarle cual es la variable x y cual es la y debido a que 
  
#Manipulaci?n de leyendas----
p + scale_fill_manual(name = 'Leyenda', #nombre de la leyenda en vez de 'fill'
                      values = c('blue', 'red'), #en ese orden
                      labels = c('Error est?ndar', 'Extremos')) + # nombre de los labels
    theme(legend.position = 'bottom') #donde posicionar la leyenda
  #una leyenda fill debido a que es un llenado (tambien exite para color y alpha)
  #theme(): estilo 

#Modificar eje y----
p + scale_y_log10() #el eje y se hace logaritmico
    scale_y_reverse() #se invierte el eje y
  #Esto tambien se puede hacer con el eje X
#si sabemos ocupar ggplot podemos ocupar ggmap
