library(tidyverse)

# ----
download.file("https://github.com/OHI-Science/data-science-training/blob/master/data/gapminder_wide.csv",
              "gapminder.csv")

gap_wide <- readr::read_csv('https://raw.githubusercontent.com/OHI-Science/data-science-training/master/data/gapminder_wide.csv')

str(gap_wide)

gap_long <- gap_wide %>% 
  gather(key = obstype_year,
         value = obs_values,
         dplyr::starts_with("pop"),
         dplyr::starts_with("lifeExp"),
         dplyr::starts_with("gdpPercap")) %>% 
  separate(obstype_year,
           into = c("obs_type", "year"),
           sep = "_",
           convert = T)

# ----

relig_income

relig_income %>% gather(key = income,
                        value = count,
                        !religion) %>% arrange(religion)

relig_income %>% pivot_longer(cols = !religion,
                              names_to = "income",
                              values_to = "count")

billboard

billboard %>% 
  pivot_longer(cols = starts_with("wk"),
               names_to = "week",
               names_prefix = "wk",
               values_to = "rank",
               values_drop_na = T)

who %>% 
  pivot_longer(cols = new_sp_f014:newrel_f65,
               names_to = c("diagnosis", "gender", "age"),
               names_pattern = "new_?(.*)_(.)(.*)",
               values_to = "count")

anscombe

anscombe %>% pivot_longer(cols = everything(),
                          names_to = c(".value","set"),
                          names_pattern = "(.)(.)")

# -----
squirrel <- read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-10-29/nyc_squirrels.csv")

squirrel_tidy <- squirrel %>% 
  select(primary_fur_color, approaches, indifferent, runs_from) %>% 
  mutate(primary_fur_color = fct_explicit_na(primary_fur_color, "Unknown")) %>% 
  mutate_if(is_logical, ~as.numeric(.))

friendly <- squirrel_tidy %>% 
  group_by(primary_fur_color) %>% 
  summarize_if(is.numeric, ~mean(.))

friendly_long <- friendly %>% 
  pivot_longer(cols = c("approaches", "indifferent", "runs_from"),
               names_to = "activity",
               values_to = "pct_activity")

friendly_wide <- friendly_long %>% 
  pivot_wider(names_from = "activity",
              values_from = "pct_activity")

# ----
iris

iris_long <- iris %>% 
  pivot_longer(cols = ends_with("th"),
               names_to = "Flower.attr",
               values_to = "Value") %>% 
  separate(col = Flower.attr,
           into = c("Flower_section", "attr"),
           sep = ".")

iris_long %>% 
  pivot_wider(names_from = "Flower.attr",
              values_from = "Value")


























