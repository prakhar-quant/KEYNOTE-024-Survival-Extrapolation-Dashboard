# KEYNOTE-024 Survival Extrapolation Dashboard

An interactive **Health Economics and Outcomes Research (HEOR)** tool that reconstructs patient-level survival data from a published clinical trial figure and extrapolates it into decision-ready projections.

**Live dashboard:**  
https://prakhargupta.shinyapps.io/survivalextrapolationdashboard/

---

## About

Published clinical trials typically report survival outcomes as a Kaplan–Meier curve and a handful of summary statistics—never the underlying patient-level data. Yet health economic evaluations depend on exactly that kind of data to model survival beyond a trial's observed follow-up. This project closes that gap for a single, real, and clinically significant example: **KEYNOTE-024**, the pivotal trial that established **pembrolizumab** as a first-line treatment for advanced non-small-cell lung cancer with high PD-L1 expression.

---

## What it does

- Reconstructs individual patient-level survival records directly from the trial's published Overall Survival curve and its number-at-risk table.
- Fits six standard parametric survival distributions and ranks them by statistical fit, following the modeling approach recommended for economic survival extrapolation.
- Projects survival beyond the trial's observed follow-up window and calculates **Restricted Mean Survival Time (RMST)**, a core input to cost-effectiveness modeling.
- Presents the entire pipeline as an interactive dashboard, allowing every step—from the reconstructed curve to the extrapolated projection—to be explored rather than simply reported.

---

## Validation

The reconstructed dataset was validated against the published **KEYNOTE-024** trial results before being used for downstream survival modeling. The reconstructed hazard ratio, confidence interval, and median overall survival closely matched the values reported in the original publication, demonstrating that the pseudo-IPD accurately reproduces the observed clinical trial outcomes.

| Metric | Reconstructed | Published |
|--------|---------------|-----------|
| Hazard Ratio (95% CI) | **0.61 (0.41–0.90)** | **0.60 (0.41–0.89)** |
| P-value | **0.013** | **0.005** |
| Pembrolizumab Median Overall Survival | **Not Reached** | **Not Reached** |
| Chemotherapy Median Overall Survival | **12.6 months** | **Consistent with published curve** |

The close agreement between the reconstructed and published survival estimates provides confidence that the extrapolated projections are based on a reliable reconstruction of the original clinical trial data rather than artifacts introduced during the reconstruction process.

---

## Conclusion

This project demonstrates a complete, decision-analytic-ready survival analysis pipeline built entirely around a single published figure—showing that meaningful HEOR-style extrapolation is possible even when a trial's patient-level data were never made public. Applied to **KEYNOTE-024**, it reproduces the trial's core findings and extends them into the kind of long-term projections that real-world health economic evaluations depend on.

---

## Made by

**Prakhar Gupta**  
**M.Sc. Statistics & Computing**  
Banaras Hindu University (BHU)
