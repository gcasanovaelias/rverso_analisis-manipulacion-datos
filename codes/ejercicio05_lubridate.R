# Packages ----
library(tidyverse)
library(lubridate)

# EXERCISES 1 ----
# https://www.r-exercises.com/2016/08/15/dates-and-times-simple-and-easy-with-lubridate-part-1/

# 1:Populate a variable called "start_date" with a date representation of string "23012017"
start_date <- dmy("23012017")

# 2:Use the lubridate function today to print the current date
today()

# 3:Extract the year part from the "start_date" variable created on exercise 1
year(start_date)

# 4:Extract the month part from the "start_date" variable created on exercise 1
month(start_date)

# 5:Extract the day part from the "start_date" variable created on exercise 1
day(start_date)

# 6:Set the month in variable "start_date" to February
month(start_date) <- month(2)

# 7:Add 6 days to variable "start_date". Did you notice what happened to the month value?
day(start_date) <- day(start_date) + 6

day(start_date) <- start_date + days(6) #days(): Crea un periodo de tiempo a partir de un valor numérico

# 8:Substract 3 months from variable "start_date"
month(start_date) <- start_date - months(3)

month(start_date) <- month(start_date) - 3

# 9:Populate a field called concatenated_dates with a vector of dates containing the following values:"31.12.2015", "01.01.2016", "15.02.2016"
concatenated_dates <- dmy(c("31.12.2015", "01.01.2016", "15.02.2016"))

# 10:Calculate in a short and simple way the addition of 1 thru 10 days to "start_date" variable
start_date + c(1:10)*days(1)

# EXERCISES 2 ----
# https://www.r-exercises.com/2016/08/29/dates-and-times-simple-and-easy-with-lubridate-exercises-part-2/

# 1:Populate two variables called "start_date" and "end_date" with date representation of string "01/12/2015 15:40:32" and "01/10/2016 16:01:10"
start_date <- dmy_hms("01/12/2015 15:40:32")
end_date <- dmy_hms("01/10/2016 16:01:10")

# 2:Create an interval variable called my_interval based on variables "start_date" and "end_date"
my_interval <- interval(start = start_date, end = end_date)

# 3:Show the class of the new object in order to make sure it's an "interval"
class(my_interval)

    # Setting/Extracting date/time parts ----

day(start_date) <- 4
month()
year()

hour(start_date)
minute(start_date)
second(end_date)

  # Día del mes
mday(start_date)

  # Día de la semana
wday(start_date,
     label = T, #Nombre del día en vez de un número
     abbr = F) #Nombre completo y no una abreviación

  # Día del cuatrimestre
qday(start_date)

  # Día del año
yday(end_date)

# 4:Extract the "week day" part from the "start_date" variable created on exercise 1. Display the name of the day in a long format.
wday(start_date, label = T, abbr = F)

# 5:Check if the "day of the year" in the "end_date" variable is greater than 230
yday(end_date) > 230

    # Time zones ----
# Time zones represent the same "instant" across different geographic locations
# For example "2016-08-21 11:53:24" in UCT time zone is identical "2016-08-21 19:53:24" in CST TZ
# lubridate provides two functions that help dealing with time zones

# with_tz(): only changes the representation of the specific instant but not the actual value
# force_tz(): changes the actual value of a specific instant

# olsonNames(): list of time zones
OlsonNames()

# Find a specific time zone
grep(pattern = "Chile", x = OlsonNames(), value = T)

# 6:Find the time zone representation for the city of "Buenos_Aires"
grep(pattern = "Buenos_Aires", x = OlsonNames(), value = T)

# 7:Display the value of "end_date" variable according to "Buenos Aires" time zone
with_tz(time = end_date, 
        tzone = "America/Argentina/Buenos_Aires")

# 8:Populate a variable called "NY_TZ" with the time zone value of "New_York" city
NY_TZ <- grep(pattern = "New_York", x = OlsonNames(), value = T)

# 9:Set the time zone of "end_date" so it matches the time zone of New York. Populate a variable called "end_date_ny" with the result
end_date_ny <- force_tz(time = end_date, tzone = NY_TZ)

# 10:Display the time difference between end_date_ny and end_date
end_date_ny - end_date


