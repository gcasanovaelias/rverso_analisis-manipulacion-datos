#Packages----
library(tidyverse)
library(broom) #m?s datos de modelos y en formato data frame
library(epitools) #ordenar
library(sjPlot) #excelente para variables respuesta 0 - 1 (familia binomial), no tan bueno para familias continuas
library(MuMIn) #Multi Model Inference: paquete para seleccionar modelos seg?n IC
library(kableExtra)
library(gridExtra)
library(caret) #se agrupan 238 modelos distintos provenientes de distintos paquetes, 1 sola gram?tica
library(rattle) #permite visualizar un ?rbol de decisiones
library(rpart.plot)

#1. Modelo lineal simple ----

# https://rpubs.com/derek_corcoran/Clase5

TempHume = readRDS("~/Casanova/Estudio Personal/Rverso/Analisis y manipulacion de datos - BIO 4022/Rverso-Analisis-y-manipulacion-de-datos/TempHume.rds")

TempHume$Ciudad_localidad %>% unique()
Pun =TempHume %>% filter(Ciudad_localidad == 'Punta Arenas')

#Simple
lineal = lm(TempMedia ~ mes, data = Pun)
summary(lineal)
# anova(): se ocupa para objetos de modelo
anova(lineal)

#Cuadr?tico (sigue siendo una regresi?n lineal)
cuad = lm(TempMedia ~ mes + I(mes^2), data = Pun)
summary(cuad)
anova(cuad)

stargazer::stargazer(lineal, cuad, type = 'text',
                     single.row = T, model.names = T,
                     model.numbers = F)

  #Agregar comportamiento logaritmico----
  #*Sigue siendo modelo lineal

Datos <- readRDS("beavers.rds")

lm(Weight ~ I(log(Age)), data = Datos)
#* I(): es una herramienta que permite incorporar comportamientos al modelo sin necesidad de agregar columnas extras, modificar o transformar los datos. Dentro de esta podemos poner una funci?n o relaci?n aritm?tica que incida en los datos.
#* Se incorpora el comportamiento logaritmico en contraposici?n a la transformaci?n la cual modifica los valores de los par?metros obtenidos as? como presentar el inconveniente de que algunas observaciones (puntos) presentan un mayor peso que otros en la modelaci?n (propiedades de los logaritmos).
#* Incorporar las transformaciones de esta manera tambien permite que los ejes mantengan los valores originales y no los transformados, lo que permite un visualizaci?n m?s intuitiva de los datos graficados a la hora de analizar. Esto es una gran ventaja en comparaci?n a los m?todos ocupados en Excel (generaci?n de nuevas columnas con valores transformados).

  #Graficos de dispersi?n y modelos----
ggplot(Beavers, aes(x = Weight, y = Age)) + 
  geom_point(aes(color = Habitat)) + 
  stat_smooth(method = 'lm', 
              formula = y ~ I(log(x)),
              se = F)

#Gr?fico de dispersi?n
ggplot(mtcars, aes(x = wt, y = mpg)) + 
  geom_point()

#Grafico del modelo
ggplot(mtcars, aes(x = wt, y = mpg)) + 
  geom_smooth(method = 'lm')

  #Paquete broom----
# Paquete que congenia con el tidyverse enfocado en la modelaci?n de datos. Permite acceder de manera ordenada y f?cil a los valores, m?tricas y par?metros derivados de los modelos al disponer de la informaci?n en formato tidy. Dispone de una mayor cantidad de informaci?n en comparaci?n a la funci?n summary().

  #Modelo
eficiencia = lm(mpg ~ wt, data = mtcars)

  #Forma desordenada (untidy)
eficiencia
summary(eficiencia)
anova(eficiencia)
  #Formato lista, no permite extraer los valores de manera ordenada. tendrian que copiarse a mano (posibilidad de error por transcripcion). Cuando son miles de modelos distintos, esto no tiene mucho sentido

  # tidy() y glance()
resumen = broom::tidy(eficiencia)
parametros = broom::glance(eficiencia) #
  #*IMPORTANTE: obtenemos un data frame con estos valores lo cual nos permite extraerlos como un excel, csv, ponerlo en una tabla, ordenarlos con otros resultados

    #augment()
# Funci?n m?s potente del paquete broom a la vaez que la menos resumida. Permite aumentarla informaci?n disponible del modelo adicionando nuevas columnas al data frame original donde se encontraban las variables modeladas.
    #*observados, 
    #*predichos, 
    #*error estandar de esa prediccion (se.fit) es decir fitted +/- se.fit,
    #*residuos (como se distribuye el error en nuestros datos), 
    #*leverages (hat), 
    #*distancia de cook,
    #*res.est 
masDatos = broom::augment(eficiencia)

  #Grafico segmentado de residuos, predichos vs observado----
ggplot(masDatos, aes(x = wt, y = mpg)) +
  # Puntos en el eje y con la variable mpg observada (siguen siendo los indicados en ggplot)
  geom_point(aes(color = 'blue')) +
  # Puntos con los valores predichos (se se?ala un cambio en la variable y)
  geom_point(aes(y = .fitted, color = 'red')) +
  # Cambio de los colores y la leyenda
  scale_color_manual(
    name = 'Residuales',
    values = c('blue', 'red'),
    labels = c('Observado', 'Predicho')
  ) +
  # geom_segment(): l?nea recta entre puntos (x,y) y (xend,yend). Un an?logo con l?neas curvas es geom_curve(). (x,y) son los valores se?alados en ggplot()
  geom_segment(aes(xend = wt, yend = .fitted)) 

  #Las l?neas negras representan la dimensi?n de mis residuales
  #Los residuos debiesen tener una distribucion normal

  #Exportar data frames
setwd("~/Casanova/Estudio Personal/Rverso/BIO 4022/Clase 5 - modelos")

write.csv(tidy_para, 'tidy_para.csv')
  #IMPORTANTE: es mucho m?s limpio para otros programas leer csv que otros formatos
  #Cualquier data frame que nosostros creemos podemos extraerlo como un csv

  #Trabajando con los data frames de los parametros----
tidy_lineal = tidy(lineal)
tidy_lineal$Model = 'Lineal'
  #*Al escoger una columna no existente la estoy creando, con los valores que se le indican

tidy_cuad = tidy(cuad)
tidy_cuad$Model = 'Cuadratico'
  #*IMPORTANTE: puedo sobreescribir los valores

#Unir data frames
  #Existen dos funciones bind; rbind() y cbind() para unir filas y columnas respectivamente (Tambien se pueden usar bind_rows() y bind_cols())
  #rbind(): unir una encima de la otra, deben tener igual n?mero de columnas
  #cbind(): unir una al lado de la otra, deben tener igual n?mero de filas
resumen = bind_rows(tidy_lineal, tidy_cuad)
  #ambos data frames tiene la misma cantidad de columnas por lo qeu se pueden unir por filas

write.csv(resumen, 'resumen.csv')
  #IMPORTANTE: R puede no realizar la acci?n solicitada si es que tenemos abierto el archivo que queremos sobreescribir, o incluso si es que tenemos el mouse encima de el


  # Supuestos ----

# Posteriormente a la construcci?n del modelo es que debemos evaluar los supuestos para poder determinar si este es v?lido o no. Esta evaluci?n consiste en (1) distribuci?n normal de los residuos y (2) homocedasticidad de la varianza.

# Este paso suele ser ignorado pero es importante tener en consideraci?n que es m?s importante que incluso algunas m?tricas como rl R2 o RMSE. De no cumplirse alguno de los supuestos es que se procede a realizar correcciones o incluso se puede llegar al punto de decidir estudiar otro tipo de modelo.

hist(masDatos$.resid)
#hist() selecciona, en base a bibliografia y a algoritmos, cual es el mejor n?mero de barras para representar los datos

shapiro.test(masDatos$.resid)
#*H0: distribuci?n normal
#*p-value > 0.05: datos tienen una distribuci?n normal

#2. Modelo lineal generalizado----
# La principal diferencia entre los modelos lineales simples y los generalizados es que estos ?ltimos permiten que la VD (aquella que queremos predecir) puedan ser de otros tipos de variable. Mientras que en los modelos lineales simples la variable independiente es ?nicamente del tipo cuantitativo continuo en los modelos lineales genelarizados (glm) esta variable puede ser discreta, booleana, etc.

# Por ejemplo, los modelos lineales simples no podr?an ayudarnos a predecir el n?mero de pajaros a avistar en una jornada (discreto) ni el ?xito o fracaso de una medida (valores de 0 o 1)

# La funci?n glm() es an?loga a la lm() pero nos permite aplicar modelos lineales generalizados a partir de indicar la distribuci?n de los errores en el argumento family. Por default, el valor del argumento es de distribuci?n "gaussian" la cual se?ala que son datos del tipo cuantitativo continuo, es decir, estar?amos frente a un modelo de regresi?n lineal simple.

# Los glm pueden presentar variables dependientes de distinto tipo a los lm, pero siempre cuantitativa (discreta, continua o de ?xito/fracaso). En caso de quere  realizar una regresi?n con una variable categ?rica (factor), en un llamado modelo de clasificaci?n, debemos aplicar la funci?n gls(.

# A diferencia de los lm, los glm no presentan R2 pero s? hay otras m?tricas de valor.

# La familia no es un tema trivial, es un factor sumamente relevante para indicarlo en la construcci?n del modelo. La funci?n glm() autom?ticamente aplica el argumento link de cada una de las familias se?aladas.

#Tipos de familia;
  #*gaussian: variable dependiente continua, negativos o positivos
  #*binomial: variable dependiente de 0 o 1 (probabilidad)
  #*poisson: variable dependiente cuantitativa discreta (conteo)
  #*Gamma: variable dependiente continua s?lo positiva
  #*inverse.gaussian
  #*poisson
  #*quasi
  #*quasipoisson
  #*quasibinomial

  #Familia Binomial----
Titanic
class(Titanic)

View(Titanic)

# Los datos se encuentran en formato table muy poco ?til, por lo que lo transformaremos a un formato m?s c?modo

Titanic2 = epitools::expand.table(Titanic) %>% tibble()
  #expand.table(): agrupa todos los datos de tablas distintas a una sola tabla organizada, aplicable a objetos de clase table

str(Titanic2)

# Todas las variables son del tipo categ?rica. Para apliicar un glm necesitamos que, al menos, una de las variables sea cuantitativa.

# La variable de inter?s es la sobrevivencia de los pasajeros la cual se puede transformar a un 1 o 0 dependiendo de si sobrevivi? o no, respectivamente. Dicha conversi?n permitir? contar con una variable cuantitativa y aplicar la familia poisson.

Titanic2$Survived = ifelse(test = Titanic2$Survived == 'Yes', 
                           # Valor si la condici?n es verdadera
                           yes = 1, 
                           # Valor si la condici?n es falsa
                           no = 0)
  #ifelse(): permite observar si se cumple una condici?n en los datos
  #se reemplazan los valores originales de la columna Survived por los resultados de la condici?n

str(Titanic2)

knitr::kable(head(Titanic2))
# Lo interesante de este caso es que todas las variables independientes son factores (categoricos) y la variable independiente es un n?mero

# Visualizaci?n
ggplot(Titanic2, aes(x = Class, y = Survived)) + 
  # Recordar que este gr?fico es como un hidtograma vertical, el ancho indica frecuencia, no cantidad
  geom_violin(aes(fill = Sex))

# Modelo
model_titanic = glm(Survived ~., # "~." indica que el resto de variables son las explicativas (+). De querer incorporar interacciones se deben especificar manualmente.
                    family = binomial(),
                    data = Titanic2)

# Recordar que cuando una variable explicativa es del tipo categ?rica entonces el modelo nos muestra el par?metro estimado en relaci?n a un valor base. Por ejemplo, la probabilidad de que la segunda clase (Class2nd) sobreviviera era 1.02 unidades menor que la que presentaba la primera clase (Class1st).

# Debido a que hay m?ltiples variables (Class, Sex y Age), es que de cada una de estas se estar? seleccionando una clase base con la que realizar la comparaci?n respecto a las dem?s que se encuentran en la variable correspondiente. De este modo; 1st(Class), Male(Sex) y Child(Age) son las clases bases para sus variables respectivas.

model_titanic
summary(model_titanic)

tidy(x = model_titanic, 
     conf.int = T, 
     conf.level = 0.95)
glance(x = model_titanic)

# ?Cuales son los valores predichos que indican la probabilidad de sobrevivencia?
augment(x = model_titanic,
        se_fit = T,
        interval = "confidence") %>% View()

# .fitted se mueve entre 0 y 1 indicando la probabilidad de sobrevivir. Un valor de 3.05 indica que dicha observaci?n presenta 3 veces m?s probabilidad de sobrevivir mientras que un valor de de -2.15 indica que la probabilidad de sobrevivir es 2 veces menor.

stargazer::stargazer(model_titanic, type = 'text', single.row = T)

# Visualizaci?n modelo de familia binomial
# sjPlot es un buen paquete para graficar modelos binomiales
sjPlot::sjp.glm(model_titanic)

#3. Selecci?n de modelos seg?n variables----

# Selecci?n de variables en el set de datos que explican de mejor manera la variaci?n de la variables respuesta. No hay una ?nica forma de realizar este procedimiento, es un tema altamente discutido.

# MuMIn (Multi-Model Inference) es un paquete que sirve para la selecci?n de variables en los modelos mediante m?tricas de AICc (default), AIC o BIC. Estos criterios de informaci?n (IC), al igual que el R2, indican que tan bien se ajusta el modelo a las observaciones pero realizando una penalizaci?n de acuerdo al n?mero de variables de modo de evitar el sobreajuste. Dicho de otro modo, premia los modelos simples y castiga los modelos complejos.

# Seg?n la filosof?a del MuMIn, no importa si nuestras variables son o no significativas. Si nuestro mejor modelo presenta par?metros que no son significativos s?lo se reporta

# options() permite modificar opciones globales en las que R realiza los computos. En general, los glm o cualquier otro tipo de modelos falla cuando en los datos se encuentran NAs. Para evitar esto se le indica a R que la acci?n que debiese tomar en caso de encontrar NA es la de se?alar error y no continuar con la operaci?n. Otras opciones para lidiar con NAs son na.omit, na.exclude y na.pass

options(na.action = 'na.fail')

# Se parte del modelo que posee la totalidad de variables que se quieren estudiar

eficiencia = glm(mpg ~ ., data = mtcars) # glm() empleado como lm al utilixar la family gaussian (VD continua)

# Mediante la funci?n dredge(), MuMIN calcula el fit de cada uno de los modelos posibles construidos a partir de la selecci?n de variables dependientes. Estos modelos se ordenan de acuerdo a los valores de IC que presentan (de manera decreciente). Entre menor sea el valor del criterio de informaci?n mejor.En s? estos valores no dicen mucho siendo principalmente empleados para comparar entre un modelo y otro. Existen varios tipos de modelos que pueden funcionar con dredge(), se desconoce si sirven para modelos no lineales (nls)

sel = MuMIn::dredge(global.model = eficiencia)

# Generaci?n de 1024 modelos distintos. Puedo limitar el n?mero de variables a emplear de acuerdo al n?mero de observaciones (1 variable por cada 15 observaciones)

# La columna delta corresponde a la diferencia entre el criterio de selecci?n del mejor modelo y el correspondiente a esa fila. En general reportamos un delta IC de 2 (intervalo que limita que modelos vamos a mostrar), es decir, s?lo reportamos los modelos que presenten un delta menor o igual a 2 con respecto al valor m?nimo (mejor) de IC.

sel = subset(x = sel, delta <= 2)

# El peso (weight) de todos los modelos reportados es igual a 1. De este modo, al realizar el subseteo, los valores observados incrementan considerablemente. Este weight siempre ser? m?s alto en el mejor (primer) modelo donde lo ideal es que sea mucho mayor al segundo mejor modelo. Si los dos primeros modelos son similares en cuanto a sus pesos se podr?a considerar realizar un promedio.

# Una vez ordenados los modelos debemos extraer los datos y par?metros que estos contienen lo cual se realiza mediante la funci?n  get.models()

mejor = MuMIn::get.models(object = sel, 
                          # Extracci?n de un ?nico modelo
                          subset = 1)[[1]]
  #subset = 1: indica que queremos extraer un ?nico modelo
  #[[1]]: indica que queremos extraer el primer modelo 

tidy(mejor) 
glance(mejor)
augment(mejor)

# De las 10 variables independientes se seleccionan 3 en el primer modelo siendo estas aquellas que permiten predecir de mejor manera la variable respuesta.

# La selecci?n de modelos seg?n variable tambien se puede aplicar a glm. Por ejemplo, con modelos cuyos errores presenten una distribuci?n binomial:

select_titanic = dredge(global.model = model_titanic)
select_titanic = subset(x = select_titanic, delta <=20)

# En este caso, el mejor modelo es aquel que contiene todas las variables y, a su vez, presenta un delta sumamente elevado (16.8) con respecto al segundo mejor modelo. Como en este modelo seleccionado tenemos variables cuantitativas y categ?ricas (factores) a estas ?ltimas se les coloca un "+" en caso de ser seleccionadas.

# Dentro de esta selecci?n de variables tambien se pueden incluir comportamientos cuadr?ticos, logaritmicos, exponenciales, etc.

select_nl = dredge(glm(TempMedia ~ mes + I(mes^2) + I(mes^3) + I(mes^4) + I(mes^5), data = Pun)) %>% subset(delta <= 2)

mejor_nl = get.models(select_nl, subset = 1)[[1]]
tidy(mejor_nl)
glance(mejor_nl)
MasDatos = augment(mejor_nl)

MejorGraph = ggplot(MasDatos, aes(x = mes, y = TempMedia)) + 
  geom_point(color = 'blue') + 
  geom_line(aes(y = .fitted), color = 'red')

# Comparaci?n gr?fica de modelos
MasomenosDatos = glm(TempMedia ~ mes + I(mes^2), data = Pun) %>% augment()

MasomenosGraph = ggplot(MasomenosDatos, aes(x = mes, y = TempMedia)) +
  geom_point(color = 'blue') + 
  geom_line(aes(y = .fitted), color = 'red')

gridExtra::grid.arrange(MejorGraph, MasomenosGraph, ncol = 2)

#4. Expandiendo los modelos con paquete caret----

# http://topepo.github.io/caret/index.html
# https://www.youtube.com/watch?v=7Jbb2ItbTC4&t=3s&ab_channel=MaxKuhn

# Existe mucha variedad de paquetes que permiten armar modelos distintos pero con la desventaja de que presentan una sintaxis muy distinta entre s?. caret (Classification and Regression Training) es un paquete desarrollado por Max Kuhn que presenta una funci?n train() que permite el ajuste de 238 modelos distintos bajo una misma sintaxis.

# lm

efi = train(mpg ~ wt, 
            # Selecci?n de 1 de los 238 modelos
            method = 'lm', 
            data = mtcars)
summary(efi)

#'$finalModel' es lo que nos entrega los par?metros estimados de los modelos

efi$finalModel
tidy(efi$finalModel)
glance(efi$finalModel)

# glm

efi2 = train(mpg ~ wt, method = 'glm', data = mtcars)
efi2$finalModel
glance(efi2$finalModel)

# bagEarth

efi3 = train(mpg ~ wt, 
             # M?todo m?s complejo de ML
             method = 'bagEarth', 
             data = mtcars)
efi3$finalModel
tidy(efi3$finalModel)
  #'bagEarth' es un metodo m?s complicado que involucra Machine Learning. broom todav?a no llega a trabajar con bagEarth

esp = train(Species ~ ., method = 'glm', data = iris)
  #error. Species es categorica
  #glm es para VD continuas

# Modelo de clasificaci?n en caret mediante ?rboles de decisi?n.
esp = train(Species ~ ., method = 'rpart', data = iris)
esp$results

rattle::rpart.plot(esp$finalModel)
