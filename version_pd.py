import pandas as pd 

# read file (csv)
file = pd.read_csv("CSV/ed_finance.csv") 
#print(file)

# create df
df = pd.DataFrame(file)
#print(df)

# drop row/col no data
df.dropna()
#print(df)

# fitler for [year, stabbr, state_name, region4, effort, necm_fundinggap_q1, necm_fundinggap_q3, necm_fundinggap_state]
df_filtered_all_fields = df.filter(items=['year', 'stabbr', 'region4', 'effort', 'necm_fundinggap_q1', 'necm_fundinggap_q3', 'necm_fundinggap_state'])
#print(df_filtered)

df_filtered_year_2019 = df_filtered_all_fields[df['year'] == 2019]
#print(df_filtered_year_2019)

df_filtered_region4 = df_filtered_year_2019[df['region4'] == 'South']
#print(df_filtered_region4)

df_sorted = df_filtered_region4.sort_values('effort', axis=0, ascending=False, inplace=False, kind='quicksort', na_position='last', ignore_index=False, key=None)
print(df_sorted)