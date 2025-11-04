library(tidyverse)
library(reticulate)
library(readr)
library(here)
library(ggplot2)
library(caTools)

df_19 <- read_csv("CSV/ed_finance.csv",
                  show_col_types = FALSE) %>% 
  select(year, stabbr, effort, region4, necm_fundinggap_state, necm_fundinggap_q1, necm_fundinggap_q3) %>% 
  filter(year == 2019)

df_drop_19 <- drop_na(df_19)
# view(df_drop)

df_south_19 <- df_drop_19 %>% 
  filter(region4=="South")
# view(df_south)

df_northeast_19 <- df_drop_19 %>% 
  filter(region4=="Northeast")
# view(df_northeast)

df_west_19 <- df_drop_19 %>% 
  filter(region4=="West")
# view(df_west)

df_midwest_19 <- df_drop_19 %>% 
  filter(region4=="Midwest")
# view(df_midwest)

highest_effort_state_19 <- df_drop_19 %>% slice_max(effort, n = 1) %>% pull(stabbr, effort)
lowest_effort_state_19  <- df_drop_19 %>% slice_min(effort, n = 1) %>% pull(stabbr, effort)

mean_effort_national_19 <- mean(df_drop_19$effort, na.rm = TRUE)
# view(mean_effort_national)

df_regions_19 = list(df_south_19, df_northeast_19, df_west_19, df_midwest_19)
df_regions_mean_effort_19 = c()

for (region in df_regions_19) {
  temp <- mean(region$effort, na.rm = TRUE)  # skip NA values
  df_regions_mean_effort_19 <- append(df_regions_mean_effort_19, temp)
}
# view(df_regions_mean_effort_19)

                                      # ----------------------------------------------- #

df_18 <- read_csv("CSV/ed_finance.csv") %>% 
  select(year, stabbr, effort, region4, necm_fundinggap_state, necm_fundinggap_q1, necm_fundinggap_q3) %>% 
  filter(year == 2018)

df_drop_18 <- drop_na(df_18)
# view(df_drop)

df_south_18 <- df_drop_18 %>% 
  filter(region4=="South")
# view(df_south)

df_northeast_18 <- df_drop_18 %>% 
  filter(region4=="Northeast")
# view(df_northeast)

df_west_18 <- df_drop_18 %>% 
  filter(region4=="West")
# view(df_west)

df_midwest_18 <- df_drop_18 %>% 
  filter(region4=="Midwest")
# view(df_midwest)

highest_effort_state_18 <- df_drop_18 %>% slice_max(effort, n = 1) %>% pull(stabbr, effort)
lowest_effort_state_18  <- df_drop_18 %>% slice_min(effort, n = 1) %>% pull(stabbr, effort)

mean_effort_national_18 <- mean(df_drop_18$effort, na.rm = TRUE)
# view(mean_effort_national)

df_regions_18 = list(df_south_18, df_northeast_18, df_west_18, df_midwest_18)
df_regions_mean_effort_18 = c()

for (region in df_regions_18) {
  temp <- mean(region$effort, na.rm = TRUE)  # skip NA values
  df_regions_mean_effort_18 <- append(df_regions_mean_effort_18, temp)
}

# view(df_regions_mean_effort_18)

                                                                      # ---------------------------------------------- #

df_17 <- read_csv("CSV/ed_finance.csv") %>% 
  select(year, stabbr, effort, region4, necm_fundinggap_state, necm_fundinggap_q1, necm_fundinggap_q3) %>% 
  filter(year == 2017)

df_drop_17 <- drop_na(df_17)
# view(df_drop)

df_south_17 <- df_drop_17 %>% 
  filter(region4=="South")
# view(df_south)

df_northeast_17 <- df_drop_17 %>% 
  filter(region4=="Northeast")
# view(df_northeast)

df_west_17 <- df_drop_17 %>% 
  filter(region4=="West")
# view(df_west)

df_midwest_17 <- df_drop_17 %>% 
  filter(region4=="Midwest")
# view(df_midwest)

highest_effort_state_17 <- df_drop_17 %>% slice_max(effort, n = 1) %>% pull(stabbr, effort)
lowest_effort_state_17  <- df_drop_17 %>% slice_min(effort, n = 1) %>% pull(stabbr, effort)

mean_effort_national_17 <- mean(df_drop_17$effort, na.rm = TRUE)
# view(mean_effort_national)

df_regions_17 = list(df_south_17, df_northeast_17, df_west_17, df_midwest_17)
df_regions_mean_effort_17 = c()

for (region in df_regions_17) {
  temp <- mean(region$effort, na.rm = TRUE)  # skip NA values
  df_regions_mean_effort_17 <- append(df_regions_mean_effort_17, temp)
}

# view(df_regions_mean_effort_17)

                                                                            # ------------------------------------------- #

df_16 <- read_csv("CSV/ed_finance.csv") %>% 
  select(year, stabbr, effort, region4, necm_fundinggap_state, necm_fundinggap_q1, necm_fundinggap_q3) %>% 
  filter(year == 2016)

df_drop_16 <- drop_na(df_16)
# view(df_drop)

df_south_16 <- df_drop_16 %>% 
  filter(region4=="South")
# view(df_south)

df_northeast_16 <- df_drop_16 %>% 
  filter(region4=="Northeast")
# view(df_northeast)

df_west_16 <- df_drop_16 %>% 
  filter(region4=="West")
# view(df_west)

df_midwest_16 <- df_drop_16 %>% 
  filter(region4=="Midwest")
# view(df_midwest)

highest_effort_state_16 <- df_drop_16 %>% slice_max(effort, n = 1) %>% pull(stabbr, effort)
lowest_effort_state_16  <- df_drop_16 %>% slice_min(effort, n = 1) %>% pull(stabbr, effort)

mean_effort_national_16 <- mean(df_drop_16$effort, na.rm = TRUE)
# view(mean_effort_national)

df_regions_16 = list(df_south_16, df_northeast_16, df_west_16, df_midwest_16)
df_regions_mean_effort_16 = c()

for (region in df_regions_16) {
  temp <- mean(region$effort, na.rm = TRUE)  # skip NA values
  df_regions_mean_effort_16 <- append(df_regions_mean_effort_16, temp)
}

# view(df_regions_mean_effort_16)


                                                      # -------------------------------------------------------------------- #
# dynamic df creation 
start <- 2009
stop <- 2022

df_all <- list()
enroll <- c()
effort <- c()
state_gap <- c()
exp_q1 <- c()
year = c()
fair <- c()

while (start <= stop) {
  #print(start)
  temp_df <- read_csv("CSV/ed_finance.csv") %>% 
    select(year, stabbr, effort, region4, necm_enroll_q1, necm_fundinggap_state, necm_ppcstot_q1, fairness_curexpp) %>% 
    filter(year == start) %>% 
    drop_na()
  
  if (is.null(temp_df[['necm_enroll_q1']])) {
    start <- start + 1
    
  }
  else {
    # store the dataframe (optional)
    df_all[[as.character(start)]] <- temp_df

    temp_fair <- temp_df[['fairness_curexpp']]
    temp_enroll <- temp_df[['necm_enroll_q1']]
    temp_effort <- temp_df[['effort']]
    temp_exp_q1 <- temp_df[['necm_ppcstot_q1']]
    temp_gap <- temp_df[['necm_fundinggap_state']]
    temp_year <- temp_df[['year']]

    fair <- append(fair, temp_fair)
    enroll <- append(enroll, temp_enroll)
    effort <- append(effort, temp_effort)
    exp_q1 <- append(exp_q1, temp_exp_q1)
    state_gap <- append(state_gap, temp_gap)
    year <- append(year, temp_year)

    start <- start + 1
  }
  
}

# Optional: convert to a data frame for plotting
df_means <- data.frame(year = year, enroll_q1 = enroll, effort = effort, state_gap = state_gap, exp_q1 = exp_q1, fair = fair)
# print(df_means)
# view(df_means)
# plot(df_means)

# not currently in use
# split = sample.split(df_means$state_gap, SplitRatio = 0.7)
# trainingset = subset(df_means, split == TRUE)
# testset = subset(df_means, split == FALSE)

# Regression 1: Predict exp_q1 using enrollment
lm_exp <- lm(exp_q1 ~ enroll, data = df_means)
sum_exp <- summary(lm_exp)
# print(sum_exp)

# Regression 2: Predict state_gap using enrollment
lm_gap <- lm(state_gap ~ enroll, data = df_means)
sum_gap <- summary(lm_gap)
# print(sum_gap)

# Regression 3: Predict state_gap using enrollment, q1 spending, and statewide effort
# Multiple linear regression
lm_multi <- lm(state_gap ~ enroll + exp_q1 + effort, data = df_means)
# View summary of the model
sum_multi <- summary(lm_multi)
# print(sum_multi)

# Regression 4: Predict state_gap using enrollment, actual spending in q1, statewide effort, and measure of progressive spending
# lm multi -- improved variable selection
lm_improved <- lm(state_gap ~ exp_q1 + enroll + fair, data = df_means)
sum_improved <- summary(lm_improved)
#print(sum_improved)

df_plot <- ggplot(df_means, aes(x = exp_q1, y = state_gap)) +
    geom_point(alpha = 0.9) +
    geom_smooth(method = "lm", col = "blue") +
    labs(title = "State Funding Gap vs Q1 Expenditure") + 
    theme(
      axis.text.x = element_text(size = 12, face = "bold", color = "black"),
      axis.text.y = element_text(size = 12, face = "bold", color = "black"),
      plot.title = element_text(size = 20, face = "bold", color = "darkblue"),
      axis.title = element_text(size = 16, color = "gray30"),
      panel.background = element_rect(fill = "lightgreen", color = NA),
      panel.grid.major = element_line(color = "white", linetype = "dashed")
    )

plot(df_plot)
