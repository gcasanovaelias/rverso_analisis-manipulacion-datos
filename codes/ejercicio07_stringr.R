# Packages ----
library(stringr)
library(gapminder)

# EXERCISES 1 ----
addresses <- c("14 Pine Street, Los Angeles", 
               "152 Redwood Street, Seattle", 
               "8 Washington Boulevard, New York")

products <- c("TV ", 
              " laptop", 
              "portable charger", 
              "Wireless  Keybord", 
              " HeadPhones ")

field_names <- c("order_number",
                 "order_date",
                 "customer_email",
                 "product_title",
                 "amount")

employee_skills <- c("John Bale (Beginner)",
                     "Rita Murphy (Pro)",
                     "Chris White (Pro)",
                     "Sarah Reid (Medium)")

# Generar strings
stringr::sentences[1:10]

stringr::fruit[1:3]

stringr::words[1:2]

long_sentences <- stringr::sentences[1:10]

# 1:Normalize the addresses vector by replacing capitalized letters with lower-case ones.
addresses %>% str_to_lower()

# 2:Pull only the numeric part of the addresses vector.
addresses %>% str_extract(pattern = "[:digit:]+")

addresses %>% parse_number() %>% as.character()

# 3:Split the addresses vector into two parts: address and city. The result should be a matrix.
addresses %>% str_split_fixed(pattern = ", ", 
                              n = 2)

addresses %>% str_split(pattern = ", ",
                        simplify = T) #Se simplifica a una matriz en vez de entregar los resultados en forma de lista

# 4:Now try to split the addresses vector into three parts: house number, street and city. The result should be a matrix. Hint: use a regex lookbehind assertion
addresses %>% str_split(pattern = "(?<=[:digit:]) |, ",
                        simplify = T)

# 5:In the long_sentences vector, for sentences that start with the letter "T" or end with the letter "s", show the first or last word respectively. If the sentence both starts with a "T" and ends with an "s", show both the first and the last words. Remember that the actual last character of a sentence is usually a period.
long_sentences %>% str_extract_all(pattern = "^T[A-z]+|[A-z]+s\\.$")

# 6:Show only the first 20 characters of all sentences in the long_sentences vector. To indicate that you removed some characters, use two consecutive periods at the end of each sentence.
long_sentences %>% str_trunc(width = 20,
                             side = "left", #Desde donde el string empieza a ser cortado
                             ellipsis = "...")

# 7: Normalize the products vector by removing all unnecessary whitespaces (both from the start, the end and the middle), and by capitalizing all letters.
products %>% 
  # Remueve espacios al principio y al final del string
  str_trim() %>% 
  # Remueve doble espacios
  str_squish() %>% 
  # Capitalizing all letters
  str_to_upper()

# 8:Prepare the field_names for display, by replacing all of the underscore symbols with spaces, and by converting it to the title-case.
field_names %>% 
  str_replace(pattern = "_",
              replacement = " ") %>% 
  # Turn string to title case
  str_to_title()

# 9:Align all of the field_names to be with equal length, by adding whitespaces to the beginning of the relevant strings.
field_names %>% str_pad(width = max(str_length(field_names)), 
                        side = "left")

# 10:In the employee_skills vector, look for employees that are defined as "Pro" or "Medium". Your output should be a matrix that have the employee name in the first column, and the skill level (without parenthesis) in the second column. Employees that are not qualified should get missing values in both columns.
str_match(string = employee_skills, pattern = "([A-z ]*) \\((Pro|Medium)\\)")[, 2:3]

# EXERCISES 2 ----
# 1:Load (and install) the stringr and gapminder package. For a warm up, make a new data.frame based on the gapminder data with one row per country and two columns. Name the country and the continent it is classified to.  Name it simply df.
df <- gapminder %>% group_by(country) %>% 
  summarize(gdpPercap.mean = mean(gdpPercap),
            lifeExp.mean = mean(lifeExp),
            continent = unique(continent)) %>% 
  relocate(continent, .after = country)

# 2:Use a stringr function to find out what the average length of the country names are, as they appear in the data-set.
df %>% 
  pull(country) %>% 
  str_length() %>% 
  mean()

# 3:Extract the first and last letter of each country's name. Make a frequency plot for both. Here you can use base-R function table.
df %>% str_sub(start = 1, end = 1)
df %>% str_sub(start = -1, end = -1)

# 4:What countries have the word "and" as part of their name?
df %>% pull(country) %>% 
  str_subset(pattern = " and ")

# 5:Delete all instances of "," and "." from the country names.
df %>% pull(country) %>% 
  str_remove_all(pattern = fixed(",")) %>% 
  str_remove(pattern = fixed("."))

# 6:Use str_dup and str_c to generate the vector c("mouse likes cat very much", "mouse likes cat very very much", "mouse likes cat very very very much").
"mouse likes cat" %>% str_c(str_dup("very ", times = 1:3), "much", sep = " ") %>% 
  str_squish()

# 7:Imagine you are creating an app to explore the Gapminder data; the tool you are using can only accommodate country names of 12 characters. Therefore, you decide to shorten the names from the right, such that if the country name is longer than 12 characters, you trim it to 11 and add a full stop. Example: "United States" becomes "United Stat.". Use str_trunc(), then find a way to reach the same result without it.
df %>% pull(country) %>% 
  str_trunc(width = 12, side = "right", ellipsis = ".")

# 8:sentences is a character vector of 720 sentences that loads to your environment when you load the stringr package. Extract all two-character words from it and plot their frequency.
sentences %>% 
  str_c(collapse = " ") %>% 
  str_replace_all(fixed("'"), "") %>% 
  str_replace_all(fixed("."), "") %>% 
  str_replace_all(fixed(","), "") %>% 
  str_to_lower() %>% 
  str_split(" ", simplify = T)

# 9:Convert the names to lower case and count what characters are the most common in the country names overall.
df %>% pull(country) %>% str_to_lower() %>% 
  str_c(collapse = T) %>% str_split("") %>% table()

# 10:Only one country has "x" in its name, congrats Mexico! "A" is the most used character. What is the country that takes this the furthest and has the most "a"s in its name?
df %>% pull(country) %>% str_count("a") %>% max()

df %>% pull(country) %>% str_count("a") %>% table()

df %>% pull(country) %>% str_count("a") %>% which.max()

df %>% slice(77)

# EXERCISES 3 ----

# 1:use a stringr function to merge this 3 strings .
x <- "I AM SAM. I AM SAM. SAM I AM"
y <- "THAT SAM-I-AM! THAT SAM-I-AM! I DO NOT LIKE THAT SAM-I-AM!"
z <- "DO WOULD YOU LIKE GREEN EGGS AND HAM?"

x %>% str_c(y, z, sep = " ") %>% str_squish()

# 2:Now use a vector which contains x,y,z and NA and make it a single sentence using paste ,do the same by the same function you used for exercise1 .Can you spot the difference .
x %>% str_c(y, z, NA, sep = " ") %>% str_squish()

# 3:Now use a vector which contains x,y,z and NA and make it a single sentence using paste ,do the same by the same function you used for exercise1 .Can you spot the difference .
fruit[1:50] %>% str_length()

# 4:We often use substr to get part of the string ,in stringr world there exist a much powerful function which does almost the same thing . Create a string name with your name .Use str_sub to get the last character and the last 5 characters .
"Giancarlo Casanova" %>% str_sub(start = -5, end = -1)

# 5:In mtcars dataset rownames, find all cars of the brand Merc .
mtcars %>% rownames_to_column() %>% 
  rename(brand = rowname) %>% pull(brand) %>% 
  str_subset(pattern = "Merc")

# 6:Use the same mtcars rownames ,find the total number of times "e" appears in that .
mtcars %>% rownames_to_column() %>% 
  pull(rowname) %>% 
  str_to_lower() %>% 
  str_c(collapse = T) %>% 
  str_split("") %>% 
  table()

# 7:Suppose you have a string like this
j <- "The_quick_brown_fox_jumps_over_the_lazy_dog"

j %>% str_split(pattern = "_")

# 8:On the same string I need the first word splitted but the rest intact ,help me to achieve that
j %>% str_split(pattern = "_", n = 2)

# 9: 

# 10:How can you turn the NA into a character string .
na_string_vec <- c("The_quick_brown_fox_jumps_over_the_lazy_dog",NA)

na_string_vec %>% str_replace_na(replacement = "NA")












