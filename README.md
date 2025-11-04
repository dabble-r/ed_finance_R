# Education Finance Analysis (R)

This R script provides a simple workflow for **building datasets**, **running linear regression models**, and **visualizing relationships** between education finance variables across years.

---

## 📦 Requirements

Before running the script, install the following R packages:

```r
install.packages(c("dplyr", "readr", "ggplot2", "tidyr"))
```

---

## 📊 Output

* **Regression Summary:** Printed model coefficients and diagnostics.
* **Visualization:** A scatterplot of state funding gaps vs. Q1 expenditure with a fitted regression line.

---

## 🧠 Notes

* Adjust the `fields` vector and year range (`start`, `stop`) as needed.
* Ensure the CSV file includes the expected column names before running.
* The plotting function uses tidy evaluation, so variable names are passed **without quotes**.
