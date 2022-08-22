# Packages ----
library(tidyverse)

nba <- data.frame(Player = c ("James", "Durant", "Curry", "Harden", "Paul", "Wade"),
                  Team = c("CLEOH", "GSWOAK", "GSWOAK", "HOUTX", "HOUTX", "CLEOH"),
                  Day1points = c(25, 23, 30, 41, 26, 20),
                  Day2points = c(24, 25, 33, 45, 26, 23)) %>% as_tibble()

# Ejercicios tidyr()----
# gather() & spread() ----
  # gather(): Convertir una tabla de contingencia en un tidy data (una observación por fila con distintas mediciones)
nba_gather <- nba %>% gather(key = Day,value = Points, c(Day1points, Day2points))

  # spread(): Pasar de una tabla tudy a una tabla de contingencia. La función inversa a gather()
nba_gather %>% spread(Day, Points)

# separate() & unite()----
  # separate(): Separar elementos de una columna mediante un separador
nba_separate <- nba %>% separate(col = Team, #Columna a separar
                                 into = c("Team", "State"), #Los resultados estarán separados en estas columnas
                                 sep = 2) #Separador entre columna 

  # unite(): Unir elementos de columna distintas en una. Función inversa de separate()
nba_separate %>% unite(col = Teamstate,
                       Team, State)

# Resumen
nba %>% gather(key = Day,
               value = Points,
               c(Day1points, Day2points)) %>% 
  separate(col = Team,
           into = c("Team", "State"),
           sep = 2)


# Ejercicios dplyr() ----
glimpse(mtcars)

  #1
mtcars %>% select(hp)

  #2 pull()
mtcars %>% pull(hp)

  #3
mtcars %>% select(mpg:hp)

  #4 rename() y rownames_to_column()
mycars <- mtcars %>% select(mpg, hp) %>% 
  # Renombrar
  rename(miles_per_gallon = mpg,
         horse_power = hp) %>% 
  # Convertir los nombres de autos (en esa columna rara) en una columna
  rownames_to_column()

  #5
mycars %>% mutate(km_per_litre = miles_per_gallon*0.425)

  #6 sample_frac()
mycars %>% sample_frac(size = 0.5) # Seleccionar observaciones

  #7 slice()
mycars_s <- mycars %>% slice(10:30)

  #8 distinct()
mycars_s %>% distinct(rowname,
                      .keep_all = T)

  #9
mycars_s %>% filter(miles_per_gallon > 20,
                    horse_power > 100)

  #10
mtcars %>% rownames_to_column() %>% 
  filter(rowname == "Lotus Europa")

# Ejercicios tidyr - 2 ----
data(who)
names(who)
head(who)

m1 <- who %>% gather(key = Types,
                     value = Cases,
                     new_sp_m014:newrel_f65,
                     na.rm = T)

mycount <- m1 %>% count(Cases)
