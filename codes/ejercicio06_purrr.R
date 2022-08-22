# Packages ----
library(tidyverse)

# EXERCISES 1----
# https://www.r-exercises.com/2018/01/12/functional-programming-with-purrr-exercises-part-1/

# 1:For each column in the mtcars data set, calculate the mean. Results should be a list.
mtcars
mtcars %>% names()

purrr::map(.x = mtcars,.f = mean) #Entrega una lista

# 2:Do the same thing as above, but returning  the named vector as a result.
mtcars %>% 
  # Entrega un vector
  map_dbl(.f = mean)

# 3:Calculate the mean once again, but with max/min 10% values trimmed.
mtcars %>% map_dbl(.f = mean,
                   # .1 = 10% de loa valores másximos y minimos eliminados
                   trim = .1)

# 4:Split mtcars by cyl into a list and calculate the number of rows for each element of the list.
mtcars %>% 
  # split(): genera listas que se diferencian de acuerdo a los valores de la columna cyl. Todas las obs dentro de una misma lista presentan igual valor de cyl
  split(f = .$cyl) %>% 
  map_int(.f = nrow)

# 5:For each element of lists from Exercise 4, calculate the mean of each column. Return results as a data.frame with one record for each input element (3 rows in total).
mtcars %>% split(f = .$cyl) %>% 
  # Resultado: tibble. Señañamos con "~" lo que queremos que se le aplique a los elementos de la lista
  map_df(~map(.x = .,
              .f = mean))

mtcars %>% split(f = .$cyl) %>% map(~map(.x = .,.f = mean))

# 6:For each element of the list from Exercise 4, fit a linear model between 1/4 mile time and gross horsepower.
model_mtcars <- mtcars %>% 
  split(f = .$cyl) %>% 
  map(~lm(qsec ~ hp, 
          # Indicar los datos
          data = .))

# 7:For each model from the previous exercise, extract the co-efficient table.
model_mtcars %>% map(summary) %>% map(coefficients)

# 8:Fit each of the models to all mtcars.
prediction_mtcars <- model_mtcars %>% 
  map2(.y = list(mtcars),
       ~predict(.x, newdata = .y))

# 9:For each model, plot separate histograms of the predicted value with the model indicated in the title.
prediction_mtcars %>% 
  iwalk(~hist(.x, 
              main = paste("Histogram for", .y, "cilinders"),
              xlab = "Predicted qsec"))

# 10:For each car, calculate the average prediction of the models.
prediction_mtcars %>% pmap_dbl(sum)/3

# EXERCISES 2 ----
# 1: Compute the mean of every column in mtcars
mtcars %>% map_dbl(.f = mean)

# 2:Determine the type of each column in nycflights13::flights.
iris %>% map_chr(.f = typeof)

# 3:Compute the number of unique values in each column of iris.
# n_distinct(): calculates the number of unique values in a vector
iris %>% map_int(.f = n_distinct)

# 4:Generate 10 random normals for each of  -10, 0, 10 and 100
c(-10, 0, 10, 100) %>% map(.f = ~rnorm(n = 10, mean = .))




