# KEYNOTE-024 Survival Extrapolation Dashboard

An end-to-end HEOR / biostatistics pipeline: **digitized published Kaplan-Meier curve → reconstructed pseudo-IPD → parametric survival modeling → interactive extrapolation dashboard.** Built entirely on base R — no `flexsurv` or `IPDfromKM` dependency, so every statistical step (the Guyot reconstruction algorithm and all six parametric model fits) is implemented from first principles and fully auditable in `app.R`.

**Live demo:** _add your shinyapps.io link here after running `deploy.R`_

![Reconstructed overall survival](assets/fig1_km_validation.png)

## What this does

1. **Reconstructs pseudo-IPD** from a digitized KM curve using the Guyot et al. (2012) algorithm, anchored to the trial's published number-at-risk table
2. **Fits six parametric survival distributions** (exponential, Weibull, gamma, log-normal, log-logistic, Gompertz) by direct maximum-likelihood estimation, ranked by AIC/BIC — the standard candidate set recommended by NICE DSU TSD 14
3. **Extrapolates survival** beyond the trial's observed follow-up and computes restricted mean survival time (RMST) — a key input to cost-effectiveness models
4. Wraps all of it in an interactive **R Shiny dashboard** (`bslib` + `plotly`)

## Data source

KEYNOTE-024 — Reck M, Rodríguez-Abreu D, Robinson AG, et al. *Pembrolizumab versus Chemotherapy for PD-L1–Positive Non–Small-Cell Lung Cancer.* N Engl J Med. 2016;375:1823-1833. Overall Survival, Figure 2, digitized with WebPlotDigitizer.

## Validation

| Metric | Reconstructed | Published |
|---|---|---|
| Hazard ratio | 0.61 (0.41–0.90) | 0.60 (0.41–0.89) |
| P-value | 0.013 | 0.005 |
| Pembrolizumab median OS | not reached | not reached |
| Chemotherapy median OS | 12.6 months | consistent with published curve |

![Parametric model fit](assets/fig2_parametric_fit.png)
![Extrapolation to 60 months](assets/fig3_extrapolation.png)

## Run it locally

```r
install.packages(c("shiny","bslib","survival","plotly","DT","dplyr"))
shiny::runApp("app.R")
```

Everything — data, the Guyot reconstruction function, all model-fitting code, and the dashboard — lives in the single `app.R` file. No other files or folders are required to run it.

## Deploy it live

```r
# one-time setup: install.packages("rsconnect"), then add your shinyapps.io
# credentials into deploy.R (see comments in that file)
source("deploy.R")
```

## Project structure

```
.
├── app.R          # everything: data, Guyot reconstruction, model fitting, dashboard
├── deploy.R        # shinyapps.io deployment (kept separate from app.R on purpose)
├── assets/         # figures used in this README
├── LICENSE
└── README.md
```

## Methodology summary

- **Digitization** — Figure 2 (OS) digitized point-by-point in WebPlotDigitizer
- **Reconstruction** — the published risk table anchors each interval; the digitized curve's step ratios estimate deaths; any reconciliation gap against the next risk-table checkpoint is attributed to censoring and spread across the interval (Guyot et al., 2012)
- **Parametric modeling** — six distributions fit by direct MLE via `optim()`, ranked by AIC/BIC
- **Extrapolation & RMST** — best (or any user-selected) model projected beyond observed follow-up; RMST computed by numerical integration

## Limitations

This is a reconstructed *approximation* of the trial's actual patient-level data, built from a published figure — not the real IPD. Treat all outputs as illustrative. Not intended for clinical, regulatory, or payer decision-making.

## License

MIT — see [LICENSE](LICENSE).

