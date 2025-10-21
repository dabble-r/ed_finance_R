import pandas as pd
import numpy as np
import plotly.express as px
from sklearn.preprocessing import MinMaxScaler

# Step 1: Read CSVs
finance_data = pd.read_csv("ed_finance.csv", usecols=["state_name", "year", "effort", "necm_fundinggap_q1", "necm_fundinggap_q3"])
reading_data = pd.read_csv("ed_report_dis.csv", usecols=["region", "year", "status", "at_basic", "at_proficient", "at_advanced"])

# Step 2: Filter for year 2022 and regions of interest
finance_2022 = finance_data[finance_data["year"] == 2022].copy()
reading_2022 = reading_data[(reading_data["year"] == 2022) &
                            (reading_data["region"].isin(["Louisiana", "Mississippi", "Kentucky", "National"]))].copy()

# Step 3: Calculate National averages across all states
national_effort = finance_2022["effort"].mean(skipna=True)
national_q1_gap = finance_2022["necm_fundinggap_q1"].mean(skipna=True)
national_q3_gap = finance_2022["necm_fundinggap_q3"].mean(skipna=True)

# Step 4: Prepare state data (Louisiana, Mississippi, Kentucky)
state_data = reading_2022[reading_2022["region"] != "National"].merge(
    finance_2022.rename(columns={"state_name": "region"}), on=["region", "year"], how="left"
)

# Step 5: Prepare National row
national_data = reading_2022[reading_2022["region"] == "National"].copy()
national_data["effort"] = national_effort
national_data["necm_fundinggap_q1"] = national_q1_gap
national_data["necm_fundinggap_q3"] = national_q3_gap

# Step 6: Combine state and national data
combined_data = pd.concat([state_data, national_data], ignore_index=True)

# Step 7: Calculate at_basic_or_higher
combined_data["at_basic_or_higher"] = (
    combined_data["at_basic"] +
    combined_data["at_proficient"] +
    combined_data["at_advanced"]
)

# Step 8: Assign funding gap based on economic status
combined_data["funding_gap_for_bubble"] = np.where(
    combined_data["status"] == "Economically disadvantaged",
    combined_data["necm_fundinggap_q1"],
    combined_data["necm_fundinggap_q3"]
)

# Step 9: Bubble size logic (shortfall = bigger bubble)
combined_data["bubble_size"] = np.where(
    combined_data["funding_gap_for_bubble"] < 0,
    abs(combined_data["funding_gap_for_bubble"]),
    1
)

# Step 10: Rescale bubble size (3–12 range)
scaler = MinMaxScaler(feature_range=(3, 12))
combined_data["bubble_size_scaled"] = scaler.fit_transform(combined_data[["bubble_size"]])

# Step 11: Define fill color for economic status
combined_data["fill_color"] = combined_data["status"].map({
    "Economically disadvantaged": "black",
    "Not economically disadvantaged": "lightgray"
})

# Step 12: Create bubble chart
fig = px.scatter(
    combined_data,
    x="effort",
    y="at_basic_or_higher",
    size="bubble_size_scaled",
    color="region",
    hover_name="region",
    hover_data={
        "status": True,
        "funding_gap_for_bubble": True,
        "bubble_size_scaled": False,
        "effort": True,
        "at_basic_or_higher": True
    },
    color_discrete_sequence=px.colors.qualitative.Set1,
    title="Effort, Funding Gap, and Reading Achievement (2022)<br><sup>Bubble size reflects funding gap by economic status; National = averages of all states</sup>"
)

# Customize marker outline & fill shade
for i, d in enumerate(fig.data):
    status_mask = combined_data["region"] == d.name
    colors = combined_data.loc[status_mask, "fill_color"]
    d.marker.line = dict(width=1, color="gray")
    d.marker.color = colors

# Axis labels
fig.update_layout(
    xaxis_title="Funding Effort (State/Local Expenditure / GSP)",
    yaxis_title="% of Students At Basic or Higher",
    legend_title_text="Region",
    template="simple_white"
)

fig.show()
