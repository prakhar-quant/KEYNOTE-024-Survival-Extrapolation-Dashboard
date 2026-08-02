# KEYNOTE-024 Survival Extrapolation Dashboard

An interactive **Health Economics and Outcomes Research (HEOR)** dashboard that reconstructs individual patient-level survival data (pseudo-IPD) from a published Kaplan–Meier curve and performs **parametric survival modeling**, **survival extrapolation**, and **restricted mean survival time (RMST)** analysis.

🌐 **Live Dashboard:**  
https://prakhargupta.shinyapps.io/survivalextrapolationdashboard/

---

# Project Overview

Published oncology clinical trials generally provide Kaplan–Meier survival curves, hazard ratios, and summary statistics but do not release the underlying patient-level survival data.

However, patient-level data are essential for:

- Health Technology Assessment (HTA)
- Cost-Effectiveness Analysis (CEA)
- Budget Impact Analysis (BIA)
- Long-term survival extrapolation
- Decision-analytic modeling
- Health Economics and Outcomes Research (HEOR)

This project demonstrates an end-to-end survival reconstruction and extrapolation workflow using the **KEYNOTE-024** clinical trial, which established **Pembrolizumab** as first-line therapy for advanced non-small-cell lung cancer (NSCLC) with high PD-L1 expression.

---

# Objectives

The dashboard was developed to:

- Reconstruct pseudo individual patient-level data (pseudo-IPD)
- Validate reconstructed survival data
- Fit multiple parametric survival distributions
- Compare statistical goodness-of-fit
- Extrapolate survival beyond observed follow-up
- Calculate Restricted Mean Survival Time (RMST)
- Present the complete workflow through an interactive R Shiny dashboard

---

# Workflow

```text
Published Kaplan–Meier Curve
            │
            ▼
 Digitization (WebPlotDigitizer)
            │
            ▼
 Number-at-Risk Table
            │
            ▼
 Guyot Algorithm
 (Pseudo-IPD Reconstruction)
            │
            ▼
 Kaplan–Meier Validation
            │
            ▼
 Parametric Survival Models
            │
            ▼
 Survival Extrapolation
            │
            ▼
 RMST Calculation
            │
            ▼
 Interactive R Shiny Dashboard
```

---

# Dashboard Features

## Overview

- Total reconstructed patients
- Number of events
- Hazard ratio comparison
- Trial summary

---

## Kaplan–Meier Curves & Validation

- Original KM curve
- Reconstructed KM curve
- Overlay comparison
- Survival validation

---

## Parametric Survival Modeling

The dashboard fits six commonly used parametric survival distributions:

- Exponential
- Weibull
- Gompertz
- Gamma
- Log-normal
- Log-logistic

Each model is evaluated using:

- Log-likelihood
- AIC
- BIC

Users can compare model performance interactively.

---

## Survival Extrapolation

Generate long-term survival projections by:

- Selecting the preferred parametric distribution
- Choosing an extrapolation horizon
- Comparing projected survival curves

---

## Restricted Mean Survival Time (RMST)

Automatically calculates:

- RMST
- Incremental survival benefit
- Treatment comparison

---

# Validation

The reconstructed pseudo-IPD was validated against the published KEYNOTE-024 trial results before performing any survival extrapolation. The close agreement between the reconstructed and published estimates demonstrates that the reconstruction accurately reproduces the original trial outcomes.

| Metric | Reconstructed | Published |
|--------|---------------|-----------|
| Hazard Ratio (95% CI) | **0.61 (0.41–0.90)** | **0.60 (0.41–0.89)** |
| P-value | **0.013** | **0.005** |
| Pembrolizumab Median Overall Survival | **Not Reached** | **Not Reached** |
| Chemotherapy Median Overall Survival | **12.6 months** | **Consistent with published curve** |

**Conclusion:** The reconstructed survival data closely replicate the published KEYNOTE-024 results, providing confidence that the subsequent parametric modeling and long-term survival extrapolation are based on a reliable pseudo-IPD reconstruction.

---

# Repository Structure

```text
KEYNOTE-024-Survival-Extrapolation-Dashboard
│
├── app.R
├── README.md
├── LICENSE
├── .gitignore
│
├── data
│   ├── chemotherapy_os_cleaned.csv
│   ├── pembrolizumab_os_cleaned.csv
│   └── risk_table.csv
│
├── images
│   ├── dashboard_overview.png
│   ├── km_validation.png
│   ├── parametric_modeling.png
│   ├── extrapolation.png
│   └── methodology.png
│
├── docs
│   ├── methodology.pdf
│   └── KEYNOTE024_reference.pdf
│
└── www
    ├── logo.png
    └── style.css
```

---

# Technologies Used

## Programming

- R

## Framework

- Shiny

## Statistical Packages

- survival
- flexsurv
- survRM2

## Visualization

- ggplot2
- plotly
- DT

## Data Manipulation

- dplyr
- tidyr
- readr

## User Interface

- bslib
- shinyWidgets

## Digitization

- WebPlotDigitizer

---

# Clinical Trial Reference

**KEYNOTE-024**

Reck M, Rodríguez-Abreu D, Robinson AG, Hui R, et al.

**Pembrolizumab versus Chemotherapy for PD-L1–Positive Non–Small-Cell Lung Cancer**

*New England Journal of Medicine.*

2016;375:1823–1833.

---

# Future Improvements

Planned enhancements include:

- Bayesian survival models
- Generalized Gamma distribution
- Flexible spline models
- Mixture cure models
- External validation datasets
- Cost-effectiveness analysis module
- Partitioned survival model
- Markov model integration
- Downloadable analysis reports

---

# Author

## Prakhar Gupta

**M.Sc. Statistics & Computing**  
Banaras Hindu University (BHU)

### Connect

- LinkedIn: https://www.linkedin.com/in/prakhar-quant/
- GitHub: https://github.com/prakhar-quant

---

# License

This project is licensed under the **MIT License**.

---

## Acknowledgements

This dashboard was developed for educational and research purposes to demonstrate a complete HEOR survival analysis workflow using publicly available clinical trial results. The original clinical trial data and publication belong to the respective study investigators and publishers.
