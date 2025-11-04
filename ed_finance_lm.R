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

fields <- list(enroll, effort, state_gap, exp_q1, year, fair)


df_list <- function(fields) {
        df_list <- list()
          for (el in fields) {
              df_list[[el]] <- NULL
          }
        return(df_list)
      }

build_df(c('enroll', 'year', 'gap'))


df_read <- function(csv) {
        df <- read_csv(csv)
          return(df)
      }


df_select <- function(df, fields, start, stop, drop=TRUE) {
        ret_df <- NULL
        field_list <- df_list(fields) 

        while (start <= stop) {
          df %>% 
            select(all_of(fields)) %>% 
            filter(year == year) %>% 
            if (drop == True) {
              drop_na()
            }

          # store the dataframe (optional)
          ret_df[[as.character(start)]] <- df

          temp_fair <- df[['fairness_curexpp']]
          temp_enroll <- df[['necm_enroll_q1']]
          temp_effort <- df[['effort']]
          temp_exp_q1 <- df[['necm_ppcstot_q1']]
          temp_gap <- df[['necm_fundinggap_state']]
          temp_year <- df[['year']]

          field_list[['fairness_curexpp']] <- temp_fair
          field_list[['necm_enroll_q1']] <- temp_enroll
          field_list[['effort']] <- temp_effort
          field_list[['necm_ppcstot_q1']] <- temp_exp_q1
          field_list[['necm_fundinggap_state']] <- temp_gap
          field_list[['year']] <- temp_year

          start <- start + 1
        }
       
        return(field_list)
      }


df_build <- function(df, fields, start, stop, bool=TRUE) {
      fields_list <- df_select(df, fields, start, stop, drop=bool)

      year <- fields_list[['year']]
      enroll <- fields_list[['necm_enroll_q1']]
      effort <- fields_list[['effort']]
      state_gap <- fields_list[['necm_fundinggap_state']]
      exp_q1 <- fields_list[['necm_ppcstot_q1']]
      fair <- fields_list[['fairness_curexpp']]

      df <- data.frame(year = year, enroll_q1 = enroll, effort = effort, state_gap = state_gap, exp_q1 = exp_q1, fair = fair)
      return(df)
}


lm_build <- function(a, b, c=NULL, d=NULL, data) {
      lm <- NULL

      # Check if either c or d is NULL
      if (any(sapply(list(c, d), is.null))) {
        # no d value if c is null
        if (is.null(c)) {
          lm <- lm(a ~ b, data = data)
        }
        # c not null, d null
        else {
          temp_c <- data[[c]]
          lm <- lm(a ~ b + c, data = data)
        }
      }  
      # all values not null
      else {
        temp_c <- data[[c]]
        temp_d <- data[[d]]
        lm <- lm(a ~ b + c + d, data = data)
      }

      sum_lm <- summary(lm)
      return(sum_lm)
}


plot_build <- function(data, x, y, title) {
    df_plot <- ggplot(data, aes(x = x, y = y)) +
      geom_point(alpha = 0.9) +
      geom_smooth(method = "lm", col = "blue") +
      labs(title = title) + 
      theme(
        axis.text.x = element_text(size = 12, face = "bold", color = "black"),
        axis.text.y = element_text(size = 12, face = "bold", color = "black"),
        plot.title = element_text(size = 20, face = "bold", color = "darkblue"),
        axis.title = element_text(size = 16, color = "gray30"),
        panel.background = element_rect(fill = "lightgreen", color = NA),
        panel.grid.major = element_line(color = "white", linetype = "dashed")
      )
    return(df_plot)
}



df <- df_read("CSV/ed_finance.csv")
df_final <- df_build(df, list('fairness_curexpp', 'necm_enroll_q1', 'effort', 'necm_ppcstot_q1', 'necm_fundinggap_state', 'year'), 2009, 2022)
# state_gap ~ exp_q1 + enroll + fair
lm <- lm_build('necm_fundinggap_state' ~ 'necm_ppcstot_q1' + 'necm_enroll_q1' + 'fairness_curexpp', data = df)
#print(lm)



