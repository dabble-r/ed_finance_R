import pandas as pd 

# READ
# read file (csv)
file = pd.read_csv("CSV/ed_finance.csv") 
#print(file)

# create df
df = pd.DataFrame(file)
#print(df)

# CLEAN
# drop row/col no data
df.dropna()
#print(df)

# FILTER & SORT
# filter for [year, stabbr, state_name, region4, effort, necm_fundinggap_q1, necm_fundinggap_q3, necm_fundinggap_state]
df_filtered_all_fields = df.filter(items=['year', 'stabbr', 'region4', 'effort', 'necm_fundinggap_state', 'necm_fundinggap_q1', 'necm_fundinggap_q3', ])
#print(df_filtered)

df_filtered_year_2019 = df_filtered_all_fields[df['year'] == 2019]
#print(df_filtered_year_2019)

df_filtered_region4 = df_filtered_year_2019[df['region4'] == 'South']
#print(df_filtered_region4)

df_sorted = df_filtered_region4.sort_values(by='effort', axis=0, ascending=False, inplace=False, kind='quicksort', na_position='last', ignore_index=False, key=None)
#print(df_sorted)

# CALCULATE
mean_vals_south = df_sorted.mean(numeric_only=True)
#print(mean_vals_south)

# MAX VALS - Lowest effort - Biggest funding gaps
min_vals_south = df_sorted.min(numeric_only=True)
print(min_vals_south)

max_gap_state = min_vals_south['necm_fundinggap_state']
print(max_gap_state)

max_gap_q1 = min_vals_south['necm_fundinggap_q1']
print(max_gap_q1)

max_gap_q3 = min_vals_south['necm_fundinggap_q3']
print(max_gap_q3)

min_effort_south = min_vals_south['effort']
print(min_effort_south)