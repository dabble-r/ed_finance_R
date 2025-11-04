library(dplyr)
library(readr)
library(ggplot2)

#---------------------
# Helper functions
#---------------------
df_read <- function(csv) {
  read_csv(csv)
}

df_list <- function(fields) {
  out <- list()
  for (el in fields) {
    out[[el]] <- NULL
  }
  out
}

df_select <- function(df, fields, start, stop, drop=TRUE) {
  field_list <- df_list(fields)
  
  for (yr in start:stop) {
    df_year <- df %>%
      select(all_of(fields)) %>%
      filter(year == yr)
    
    if (drop) {
      df_year <- tidyr::drop_na(df_year)
    }
    
    for (field in fields) {
      field_list[[field]] <- c(field_list[[field]], df_year[[field]])
    }
  }
  field_list
}

df_build <- function(df, fields, start, stop, bool=TRUE) {
  fields_list <- df_select(df, fields, start, stop, drop=bool)
  
  df_final <- data.frame(
    year   = fields_list[['year']],
    enroll = fields_list[['necm_enroll_q1']],
    effort = fields_list[['effort']],
    state_gap = fields_list[['necm_fundinggap_state']],
    exp_q1 = fields_list[['necm_ppcstot_q1']],
    fair = fields_list[['fairness_curexpp']]
  )
  df_final
}

lm_build <- function(response, predictors, data) {
  # predictors can be one or more column names
  non_null_preds <- predictors[!sapply(predictors, is.null)]
  formula <- reformulate(termlabels = non_null_preds, response = response)
  
  model <- lm(formula, data = data)
  summary(model)
}

plot_build <- function(data, x, y, title) {
  plot <- ggplot(data, aes({{ x }}, {{ y }})) +
    geom_point(alpha = 0.9) +
    geom_smooth(method = "lm", color = "blue") +
    labs(title = title) +
    theme(
      axis.text.x = element_text(size = 12, face = "bold", color = "black"),
      axis.text.y = element_text(size = 12, face = "bold", color = "black"),
      plot.title  = element_text(size = 20, face = "bold", color = "darkblue"),
      axis.title  = element_text(size = 16, color = "gray30"),
      panel.background = element_rect(fill = "lightgreen", color = NA),
      panel.grid.major = element_line(color = "white", linetype = "dashed")
    )
  plot
}

# Call like this (no quotes)
plot_build(df_final, exp_q1, state_gap, "State Funding Gap vs Q1 Expenditure")


#---------------------
# Execution
#---------------------

df <- df_read("CSV/ed_finance.csv")

fields <- c('fairness_curexpp', 'necm_enroll_q1', 'effort',
            'necm_ppcstot_q1', 'necm_fundinggap_state', 'year')

df_final <- df_build(df, fields, 2009, 2022)

names(df_final)

lm_result <- lm_build(
  response = 'state_gap',
  predictors = c('exp_q1', 'enroll', 'fair'),
  data = df_final
)

#print(lm_result)

plot <- plot_build(df_final, exp_q1, state_gap, "State Funding Gap vs Q1 Expenditure")
print(plot)


