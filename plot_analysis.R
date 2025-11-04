library(tidyverse)
library(reticulate)
library(readr)
library(here)

df <- read_csv("CSV/ed_finance.csv") %>% 
  select(year, stabbr, effort, region4, necm_fundinggap_state, necm_fundinggap_q1, necm_fundinggap_q3) %>% 
  filter(year == 2019)

df_drop <- drop_na(df)
# view(df_drop)

df_south <- df %>% 
  filter(region4=="South")
# view(df_south)

df_northeast <- df %>% 
  filter(region4=="Northeast")
# view(df_northeast)

df_west <- df %>% 
  filter(region4=="West")
# view(df_west)

df_midwest <- df %>% 
  filter(region4=="Midwest")
# view(df_midwest)

highest_effort_state <- df %>% slice_max(effort, n = 1) %>% pull(stabbr, effort)
lowest_effort_state  <- df %>% slice_min(effort, n = 1) %>% pull(stabbr, effort)

mean_effort_national <- mean(df$effort, na.rm = TRUE)
#view(mean_effort_national)

df_regions = list(df_south, df_northeast, df_west, df_midwest)
df_regions_mean_effort = c()

for (region in df_regions) {
  temp <- mean(region$effort, na.rm = TRUE)  # skip NA values
  df_regions_mean_effort <- append(df_regions_mean_effort, temp)
}

view(df_regions_mean_effort)

# view(highest_effort_state)
# view(lowest_effort_state)










