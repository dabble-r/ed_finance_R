# Step 1: Import libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.preprocessing import MinMaxScaler

# Step 2: Read CSVs
finance_data = pd.read_csv("CSV/ed_finance.csv", usecols=["state_name", "year", "effort", "necm_fundinggap_q1", "necm_fundinggap_q3"])
reading_data = pd.read_csv("CSV/ed_report_dis.csv", usecols=["region", "year", "status", "at_basic", "at_proficient", "at_advanced"])

# Step 3: Filter for 2022 and regions of interest
finance_2022 = finance_data.query("year == 2022")
reading_2022 = reading_data.query("year == 2022 and region in ['Louisiana', 'Mississippi', 'Kentucky', 'National']")

# Step 4: Calculate National averages across all states
national_effort = finance_2022["effort"].mean(skipna=True)
national_q1_gap = finance_2022["necm_fundinggap_q1"].mean(skipna=True)
national_q3_gap = finance_2022["necm_fundinggap_q3"].mean(skipna=True)

# Step 5: Prepare state data (Louisiana, Mississippi, Kentucky)
state_data = (
    reading_2022.query("region != 'National'")
    .merge(finance_2022.rename(columns={"state_name": "region"}), on=["region", "year"], how="left")
)

# Step 6: Prepare National row
national_data = (
    reading_2022.query("region == 'National'")
    .assign(
        effort=national_effort,
        necm_fundinggap_q1=national_q1_gap,
        necm_fundinggap_q3=national_q3_gap
    )
)

# Step 7: Combine datasets
combined_data = pd.concat([state_data, national_data], ignore_index=True)

# Step 8: Calculate % at or above basic
combined_data["at_basic_or_higher"] = (
    combined_data["at_basic"] + combined_data["at_proficient"] + combined_data["at_advanced"]
)

# Step 9: Assign funding gap by economic status
combined_data["funding_gap_for_bubble"] = np.where(
    combined_data["status"] == "Economically disadvantaged",
    combined_data["necm_fundinggap_q1"],
    combined_data["necm_fundinggap_q3"]
)

# Step 10: Compute bubble size (negative = larger bubble)
combined_data["bubble_size"] = np.where(
    combined_data["funding_gap_for_bubble"] < 0,
    abs(combined_data["funding_gap_for_bubble"]),
    1
)

# Step 11: Scale bubble sizes for visibility
scaler = MinMaxScaler(feature_range=(100, 1200))
combined_data["bubble_size_scaled"] = scaler.fit_transform(
    combined_data[["bubble_size"]]
)

# Step 12: Define fill colors by economic status
fill_colors = {
    "Not economically disadvantaged": "lightgray",
    "Economically disadvantaged": "black"
}

# Step 13: Create the bubble chart
plt.figure(figsize=(10, 7))
sns.scatterplot(
    data=combined_data,
    x="effort",
    y="at_basic_or_higher",
    size="bubble_size_scaled",
    hue="region",
    style="status",
    palette="Set2",
    alpha=0.8,
    sizes=(100, 1200),
    edgecolor="k",
    linewidth=1
)

# Overlay fill color by status
for _, row in combined_data.iterrows():
    plt.scatter(
        row["effort"],
        row["at_basic_or_higher"],
        s=row["bubble_size_scaled"],
        c=fill_colors.get(row["status"], "gray"),
        alpha=0.8,
        edgecolors="k",
        linewidths=1
    )

# Labels and titles
plt.title("Effort, Funding Gap, and Reading Achievement (2022)", fontsize=14, fontweight="bold")
plt.suptitle("Bubble size reflects funding gap by economic status; National = averages of all states", fontsize=10)
plt.xlabel("Funding Effort (State/Local Expenditure / GSP)")
plt.ylabel("% of Students At Basic or Higher")

# Step 14: Custom legend formatting
# Format funding gap legend values rounded to two decimals
handles, labels = plt.gca().get_legend_handles_labels()

# Build a legend for bubble sizes
size_labels = np.linspace(combined_data["funding_gap_for_bubble"].min(),
                          combined_data["funding_gap_for_bubble"].max(), 4)
size_labels = [f"{x:.2f}" for x in size_labels]  # Round to nearest hundredth

print("rounded gaps: ", size_labels)

# Create the main legend
plt.legend(
    title="Region & Economic Status",
    bbox_to_anchor=(1.25, 1),
    loc="upper left",
    borderaxespad=0.,
    fontsize=9,
    title_fontsize=10,
    frameon=True,
    labelspacing=1.3,
    handletextpad=0.8,
    borderpad=1.2
)

# Step 15: Adjust layout to prevent overlap
plt.subplots_adjust(right=0.75)
plt.tight_layout()
plt.savefig("bubble_chart.png", dpi=300)
print("Chart saved as bubble_chart.png")
