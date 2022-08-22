#Exercises https://garthtarr.github.io/meatR/dplyr_ex1.html----
library(dplyr)
?mtcars
glimpse(mtcars)
names(mtcars)

#1. Print out the hp column
mtcars %>% select(hp)

#2. Print out all BUT the hp column
mtcars %>% select(-hp)
  #Puedo colocar un símbolo '-' que indica no-selección

#3. Print out the mpg, hp, vs, am, gear columns
mtcars %>% select(1,4,8:10) %>% names()
  #en select() puedo indicar las columnas con número

#4. Change the name of the columns 1 and 4 plus add the rownames (cars) into a column
mycars = mtcars %>% select(miles_per_gallon=1, horse_power=4) %>%
  tibble::rownames_to_column(var = 'model')
  
#5. Create a new variable in the mycars data frame km_per_litre
mycars = mycars %>% mutate(km_per_litre=miles_per_gallon*0.425)
  #mutate() agrega una nueva columna, no elimina la original

#6. Randomly select and print half the observations of mycars
mycars %>% slice_sample(n = 16)
mycars %>% sample_frac(size = 0.5)

#7.
mycars_s = mycars %>% slice(10:20)

#8. Print out the mycars_s object without any duplicates
mycars %>% distinct()

#9. Print out from mycars_s object all the observations which have mpg>20 and hp>100
mycars %>% filter(miles_per_gallon>20 & horse_power>100)

#10. Print out the row corresponding to the Lotus Europa car
mycars %>% rename(modelos = model) %>% filter(model == 'Lotus Europa')

#Exercises https://www.r-exercises.com/2017/10/19/dplyr-basic-functions-exercises/?__cf_chl_managed_tk__=f4bbacc7a5f982679a1dd16a73d1d2107e2421cf-1623118187-0-Ad8ct9Jl3H8y_8E-BKIUtTifIUEKciGgjBr3Vb6yMC0e7DAmjlplrXJXfxi5BgbY5UPuXETxiso401wC9bgtOHY6XLgFWS_F_RGSEjxYfQOnjqN1NZm7AUKZNg-VUF2WrB4MMTxmnZr53e9YBA43wzHhLI6-NBrZMVewa4asUAEzEIVSnZBuiv57d-PVAwtPP3R9CKbq5dxGVn1rLaK-rW_7zl50r2W3JV9jyq5LXtBIj4KFQCPx9TQAMTjb8GtyzM8dqNSF2QrA94Xq80I21DM-EBQKhnZTbvPuETvtI9b4rSjiE02okPtd6eApoFpDTRywurQL6i5_U_lGyj5LPT7xjmf3yEclm9_2NDyd5BmrWdyBppSVw4im9r0nNUdon4yw2et5gA4inF2_da9aClr2OWKIgNEwVgib8BuqJQayVXPmfbzOWS4GZoAgaxBfKI1oFI7EjD4pZrBQJfIJS1tTLWxdWiWzkU8UIWUgLcY9IvaueWtRyoY_UQm8UmDuLqL-MSpxfHb0VwqpyaifJ-_82RzI92jLfMXAelx8hYQDHkkRxZRJnfucTg1T9WowtkekONNpepoa0ongMysHgTxoSGfGQhXDT8byERtcc00jfB_KrVSqTyo_EX0zvyH2D0149QkddfKWvm3vzAJkunF6DchRzm_cIfDVc4jWvl4K----
#1. Select the first three columns of the iris dataset using their column names
iris %>% select("Sepal.Length","Sepal.Width","Petal.Length") %>% glimpse()

#2. Select all the columns of the iris dataset except "Petal Width"
iris %>% select(-'Petal.Width') %>% head()

#3. Select all columns of the iris dataset that start with the character string "P"
iris %>% select(starts_with('S')) %>% glimpse()

#4. Filter the rows of the iris dataset for Sepal.Length >= 4.6 and Petal.Width >= 0.5
iris %>% filter(Sepal.Length >=4.6 & Petal.Width >= 0.5) %>% head()

#5.Pipe the iris data frame to the function that will select two columns 
iris %>% select("Sepal.Width", "Sepal.Length") %>% head()
  #incluso se cambia el orden de las columnas

#6. Arrange rows by a particular column, such as the Sepal.Width
iris %>% arrange(Sepal.Width)

#7. Select three columns from iris, arrange the rows by Sepal.Length, then arrange the rows by Sepal.Width
iris %>% select(Species, Sepal.Length, Sepal.Width) %>% 
  arrange(Sepal.Length, Sepal.Width) %>% head()
  #arrange() te permite ordenar según distintas columnas en el orden de los argumentos

#8.Create a new column called proportion, which is the ratio of Sepal.Length to Sepal.Width
iris %>% mutate(proportion = Sepal.Length/Sepal.Width) %>% head()

#9. Compute the average number of Sepal.Length, apply the mean() function to the column Sepal.Length, and call the summary value "avg_slength"
iris %>% summarise(avg_slength = mean(Sepal.Length))

#10. Split the iris data frame by the Sepal.Length, then ask for the same summary statistics as above
iris %>% group_by(Sepal.Length) %>% summarise(avg_slength = mean(Sepal.Length))

iris$Species %>% unique()
iris$Species %>% levels()
