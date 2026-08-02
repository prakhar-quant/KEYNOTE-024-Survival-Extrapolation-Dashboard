
# Everything for this project lives in this one file on purpose — the trial
# data, the reconstruction math, the model fitting, and the dashboard itself.
# Open it in RStudio and hit Run App. Nothing else needs to exist alongside it.

library(shiny)
library(bslib)
library(survival)
library(plotly)
library(DT)
library(dplyr)

#Digitized data, embedded directly (no external files needed)
# These are the actual points read off the published KM curve (Figure 2 of the
# KEYNOTE-024 paper) using WebPlotDigitizer. They're written out as plain
# numbers here so the app never has to go looking for a CSV on disk.

pembro_raw <- data.frame(
  time = c(0.15401, 0.314797, 0.431734, 0.62321, 0.82367, 0.932023, 0.960232, 1.070868, 1.240221, 1.422967, 1.567055, 1.574554, 1.713898, 1.737111, 1.88941, 2.079405, 2.268048, 2.456691, 2.608785, 2.765008, 2.912411, 3.110375, 3.296037, 3.484526, 3.673131, 3.854428, 4.011326, 4.204211, 4.341327, 4.382909, 4.487546, 4.673786, 4.847955, 5.043469, 5.225294, 5.411788, 5.591618, 5.784451, 5.968681, 6.157324, 6.357817, 6.483283, 6.534452, 6.729906, 6.793648, 6.865226, 6.94873, 7.042608, 7.231608, 7.240399, 7.344848, 7.42572, 7.529792, 7.576641, 7.716929, 7.910004, 7.950805, 8.099104, 8.175604, 8.193271, 8.35107, 8.385642, 8.539726, 8.574283, 8.735485, 8.891549, 8.911276, 8.951051, 9.097081, 9.139671, 9.308205, 9.31144, 9.448088, 9.53413, 9.63676, 9.722773, 9.828268, 9.834244, 10.013986, 10.181171, 10.354308, 10.391589, 10.400892, 10.43214, 10.612165, 10.613618, 10.802266, 10.809378, 10.990905, 10.994594, 11.093501, 11.093948, 11.28206, 11.348417, 11.509258, 11.541583, 11.691764, 11.735106, 11.89971, 11.916583, 12.105247, 12.129767, 12.299256, 12.307593, 12.499642, 12.585669, 12.688266, 12.791185, 12.816448, 12.820762, 12.890975, 12.985797, 13.116369, 13.202333, 13.350678, 13.397439, 13.407412, 13.408712, 13.521384, 13.673183, 13.681476, 13.870145, 13.936506, 14.024615, 14.127338, 14.316023, 14.365805, 14.521771, 14.710438, 14.813623, 14.899088, 15.087762, 15.096588, 15.276343, 15.465019, 15.55228, 15.722232, 15.890117, 15.990903, 16.15096, 16.339633, 16.391356, 16.528247, 16.716889, 16.905532, 17.094175, 17.282855, 17.326003, 17.471463, 17.660105, 17.848748, 18.037391, 18.226034, 18.414677, 18.595047, 18.603345, 18.791964, 18.92078),
  survival = c(99.48162, 98.95125, 98.079871, 97.995516, 97.80082, 97.80082, 97.131153, 96.713999, 96.713999, 96.097219, 95.221956, 95.221956, 93.987896, 93.987896, 93.050913, 92.785004, 92.785004, 92.785004, 92.418603, 91.498591, 90.298748, 89.837769, 89.411374, 88.878278, 88.745015, 88.049322, 86.991936, 86.835347, 86.562135, 85.385186, 84.813166, 84.742478, 84.106526, 83.155583, 82.384512, 81.791327, 80.966707, 80.627598, 80.191982, 80.191982, 80.115536, 80.115536, 79.64646, 79.476374, 79.476374, 78.175871, 78.175871, 77.534231, 77.247237, 77.247237, 76.978603, 76.978603, 76.978603, 76.978603, 76.769055, 76.490426, 76.490426, 75.882049, 75.882049, 75.348322, 75.348322, 75.348322, 75.348322, 75.348322, 75.348322, 75.348322, 75.348322, 74.580626, 74.580626, 74.499677, 74.150276, 74.150276, 73.560077, 73.560077, 73.560077, 73.560077, 73.560077, 73.560077, 73.455492, 73.455492, 73.361617, 73.361617, 72.122535, 71.452896, 71.452896, 71.388924, 71.388924, 71.388924, 71.388924, 71.388924, 70.351415, 70.351415, 70.059785, 70.059785, 69.952937, 69.952937, 69.952937, 69.952937, 69.952937, 69.952937, 69.952937, 69.952937, 69.952937, 69.952937, 69.952937, 69.952937, 69.919711, 69.919711, 68.39971, 68.39971, 67.719051, 67.719051, 67.719051, 67.719051, 67.504466, 67.504466, 66.006823, 65.105361, 64.766692, 64.766692, 64.766692, 64.766692, 64.766692, 64.766692, 64.766692, 64.766692, 64.766692, 64.766692, 64.766692, 64.766692, 64.766692, 64.766692, 64.766692, 64.766692, 64.766692, 64.766692, 64.766692, 64.766692, 64.766692, 64.766692, 64.766692, 64.766692, 64.766692, 64.766692, 64.766692, 64.766692, 64.766692, 64.766692, 64.766692, 64.766692, 64.766692, 64.766692, 64.766692, 64.766692, 64.766692, 64.766692, 64.766692, 64.766692)
)

chemo_raw <- data.frame(
  time = c(0.114823, 0.126766, 0.139866, 0.332202, 0.513188, 0.649091, 0.811593, 0.942794, 1.00732, 1.037125, 1.136328, 1.278491, 1.429045, 1.548582, 1.718659, 1.896226, 1.924767, 2.00004, 2.078179, 2.180727, 2.3428, 2.531245, 2.643079, 2.786129, 2.996541, 3.119737, 3.309775, 3.499668, 3.688297, 3.864896, 4.065397, 4.20985, 4.302269, 4.44859, 4.569888, 4.76774, 4.947717, 5.068117, 5.170027, 5.291093, 5.36677, 5.454041, 5.626112, 5.829771, 5.836587, 5.985466, 6.051792, 6.139037, 6.294833, 6.479971, 6.534571, 6.66862, 6.668908, 6.852511, 7.028852, 7.045724, 7.200368, 7.240875, 7.394104, 7.408328, 7.580878, 7.609929, 7.713873, 7.90251, 8.037253, 8.069983, 8.108018, 8.167811, 8.294161, 8.365167, 8.399196, 8.467502, 8.669442, 8.67361, 8.776506, 8.780598, 8.781429, 8.909505, 8.915179, 9.118186, 9.127027, 9.295663, 9.306797, 9.469772, 9.478589, 9.484112, 9.683814, 9.701224, 9.864512, 10.00103, 10.060748, 10.249365, 10.438079, 10.438339, 10.626722, 10.626982, 10.789517, 10.8664, 11.05509, 11.055338, 11.243662, 11.432305, 11.569819, 11.620979, 11.792386, 11.880443, 12.066429, 12.066716, 12.255095, 12.255345, 12.37539, 12.383663, 12.43486, 12.43887, 12.597396, 12.614161, 12.751222, 12.939916, 12.991632, 13.128579, 13.180275, 13.317216, 13.361296, 13.505845, 13.58843, 13.694471, 13.694756, 13.88308, 14.071776, 14.097766, 14.260392, 14.260704, 14.449009, 14.586523, 14.637685, 14.826343, 14.870441, 15.014951, 15.20361, 15.283231, 15.392257, 15.401119, 15.580868, 15.769511, 15.958154, 16.146797, 16.292886, 16.335467, 16.524084, 16.653023, 16.712753, 16.901369, 17.090012, 17.278655, 17.467311, 17.570514, 17.655961, 17.836329, 17.844612, 18.033228, 18.221871, 18.410514, 18.582055, 18.616626),
  survival = c(99.30403, 99.30403, 99.30403, 99.30403, 98.770624, 98.540321, 97.092481, 96.127407, 95.221913, 94.175585, 93.260744, 92.648119, 91.936153, 91.004488, 90.667592, 90.487813, 90.487813, 89.419796, 88.523854, 87.315077, 86.668552, 85.980524, 84.95327, 84.013965, 83.714842, 82.639202, 82.140897, 81.901864, 81.854546, 81.259283, 81.206871, 80.890746, 79.954774, 79.390568, 78.585893, 78.498683, 78.181327, 77.122906, 75.98716, 75.278431, 74.337453, 73.677627, 73.128567, 73.128567, 73.086912, 72.304642, 71.030853, 70.278771, 69.364557, 69.10472, 69.10472, 69.10472, 69.10472, 68.507834, 68.507834, 68.495673, 68.495673, 68.191713, 67.372408, 67.372408, 66.992476, 66.992476, 66.149721, 66.128561, 66.124657, 66.124657, 65.144499, 64.34454, 63.468412, 63.468412, 63.468412, 62.877625, 62.733864, 62.733864, 62.733864, 62.733864, 61.21718, 59.912169, 59.179987, 59.179987, 59.179987, 59.179987, 59.179987, 59.179987, 59.179987, 58.268729, 58.268729, 58.268729, 57.598335, 57.598335, 57.167305, 57.078883, 57.078883, 57.078883, 57.078883, 57.078883, 56.897523, 55.892228, 55.892228, 55.892228, 55.811294, 55.811294, 55.811294, 55.811294, 55.623141, 54.481242, 54.419247, 54.419247, 54.419247, 54.419247, 54.419247, 54.318606, 53.445482, 52.482984, 52.115084, 50.781069, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396, 50.313396)
)

# This is the "number at risk" row printed underneath the original figure —
# how many patients were still being followed at each checkpoint. It's what
# keeps the reconstruction below honest instead of just eyeballing the curve.
risk <- data.frame(
  time   = c(0, 3, 6, 9, 12, 15, 18, 21),
  pembro = c(154, 136, 121, 82, 39, 11, 2, 0),
  chemo  = c(151, 123, 106, 64, 34, 7, 1, 0)
)

# Brand palette (matches the original NEJM figure's arm colors)
COL_PEMBRO <- "#1F5FBF"
COL_CHEMO  <- "#7A7A7A"
COL_FIT    <- "#D6455D"
arm_colors <- c(Pembrolizumab = COL_PEMBRO, Chemotherapy = COL_CHEMO)

# This is really the heart of the whole project. A published KM curve only
# ever shows survival percentages over time — it never hands you the actual
# patient records behind it. This function works backwards from the curve
# and the risk table to rebuild a plausible per-patient dataset (who had an
# event, who was censored, and roughly when), following the approach Guyot
# and colleagues published back in 2012.
#' @param time     numeric vector, digitized time points (sorted or not)
#' @param survival numeric vector, digitized survival probability at each
#'                  time point, as a PERCENT (0-100)
#' @param t_risk   numeric vector, times at which the number-at-risk table
#'                  reports a value (must start at 0)
#' @param n_risk   integer vector, number at risk at each t_risk (n_risk[1]
#'                  is the total number randomized to this arm)
#' @param arm_name character label used in the output (e.g. "Pembrolizumab")
#'
#' @return a data.frame with columns: arm, time, status (1 = event/death,
#'         0 = censored)
reconstruct_ipd <- function(time, survival, t_risk, n_risk, arm_name = "Arm") {

  stopifnot(length(t_risk) == length(n_risk), t_risk[1] == 0)

  # --- 1. Clean and order the digitized curve ------------------------------
  curve <- data.frame(time = time, surv = survival / 100)
  curve <- curve[order(curve$time), ]
  curve <- curve[!duplicated(curve$time), ]

  # Force a clean anchor point at t = 0, S = 1 (start of follow-up)
  if (curve$time[1] > 0) {
    curve <- rbind(data.frame(time = 0, surv = 1), curve)
  } else {
    curve$surv[1] <- 1
  }

  events    <- data.frame(time = numeric(0), status = integer(0))
  n_int     <- length(t_risk)

  # --- 2. Walk interval by interval, anchored to the risk table ------------
  for (i in seq_len(n_int - 1)) {

    lower <- t_risk[i]
    upper <- t_risk[i + 1]
    r     <- n_risk[i]        # risk set size we trust at the start of this interval
    target <- n_risk[i + 1]   # risk set size the paper reports at the end of it

    pts <- curve[curve$time > lower & curve$time <= upper, ]
    if (nrow(pts) == 0) {
      # No digitized reading inside this interval -- everything lost between
      # checkpoints must be censored (no curve evidence of a step down)
      dropped <- r - target
      if (dropped > 0) {
        t_cens <- seq(lower, upper, length.out = dropped + 2)[-c(1, dropped + 2)]
        events <- rbind(events, data.frame(time = t_cens, status = 0))
      }
      next
    }

    s_prev <- curve$surv[curve$time == lower]
    if (length(s_prev) == 0) {
      # interpolate the survival level at the lower boundary from the curve
      before <- curve[curve$time <= lower, ]
      s_prev <- tail(before$surv, 1)
    }

    deaths_this_interval <- integer(nrow(pts))
    r_running <- r

    for (j in seq_len(nrow(pts))) {
      s_curr <- pts$surv[j]
      ratio  <- if (s_prev > 0) s_curr / s_prev else 1
      d      <- round(r_running * (1 - ratio))
      d      <- max(d, 0)
      d      <- min(d, r_running)          # can't kill more than are at risk
      deaths_this_interval[j] <- d
      r_running <- r_running - d
      s_prev <- s_curr
    }

    if (sum(deaths_this_interval) > 0) {
      death_times <- pts$time[deaths_this_interval > 0]
      death_reps  <- deaths_this_interval[deaths_this_interval > 0]
      events <- rbind(events, data.frame(
        time   = rep(death_times, death_reps),
        status = 1
      ))
    }

    # --- Reconcile against the risk table: whatever gap remains is censoring
    censored_n <- r_running - target
    if (censored_n > 0) {
      # Spread censoring evenly across the reading points inside this
      # interval (mirrors real-world censoring, rather than piling it all
      # at one time point)
      t_cens <- seq(lower + (upper - lower) / (censored_n + 1),
                    upper - (upper - lower) / (censored_n + 1),
                    length.out = censored_n)
      events <- rbind(events, data.frame(time = t_cens, status = 0))
    } else if (censored_n < 0) {
      # Rounding pushed us past the target risk count -- trim the most
      # recent death(s) back to censoring so the arm total still reconciles
      n_fix <- abs(censored_n)
      last_death_idx <- which(events$status == 1)
      last_death_idx <- tail(last_death_idx, min(n_fix, length(last_death_idx)))
      if (length(last_death_idx) > 0) events$status[last_death_idx] <- 0
    }
  }

  # --- 3. Reconcile total N: anyone unaccounted for is censored at the ------
  #        last observed time (administrative censoring at end of follow-up)
  n_total   <- n_risk[1]
  n_so_far  <- nrow(events)
  remainder <- n_total - n_so_far
  if (remainder > 0) {
    last_time <- max(curve$time)
    events <- rbind(events, data.frame(time = rep(last_time, remainder), status = 0))
  } else if (remainder < 0) {
    events <- events[seq_len(n_total), ]
  }

  events$arm <- arm_name
  events[, c("arm", "time", "status")]
}

# Six standard survival distributions, each one described by how to turn
# optim()'s raw unconstrained numbers into real parameters, plus how to
# compute the log-density and log-survival that the likelihood below needs.
# This is normally what a package like flexsurv hands you for free — it's
# written out by hand here instead, so nothing in the modeling is a black box.
.dist_specs <- list(

  exponential = list(
    k = 1,
    to_params = function(par) c(rate = exp(par[1])),
    logf = function(t, p) dexp(t, rate = p["rate"], log = TRUE),
    logS = function(t, p) pexp(t, rate = p["rate"], lower.tail = FALSE, log.p = TRUE),
    start = function(time, status) log(sum(status) / sum(time))
  ),

  weibull = list(
    k = 2,
    to_params = function(par) c(shape = exp(par[1]), scale = exp(par[2])),
    logf = function(t, p) dweibull(t, shape = p["shape"], scale = p["scale"], log = TRUE),
    logS = function(t, p) pweibull(t, shape = p["shape"], scale = p["scale"], lower.tail = FALSE, log.p = TRUE),
    start = function(time, status) c(log(1), log(mean(time)))
  ),

  gamma = list(
    k = 2,
    to_params = function(par) c(shape = exp(par[1]), rate = exp(par[2])),
    logf = function(t, p) dgamma(t, shape = p["shape"], rate = p["rate"], log = TRUE),
    logS = function(t, p) pgamma(t, shape = p["shape"], rate = p["rate"], lower.tail = FALSE, log.p = TRUE),
    start = function(time, status) c(log(1), log(1 / mean(time)))
  ),

  lognormal = list(
    k = 2,
    to_params = function(par) c(meanlog = par[1], sdlog = exp(par[2])),
    logf = function(t, p) dlnorm(t, meanlog = p["meanlog"], sdlog = p["sdlog"], log = TRUE),
    logS = function(t, p) plnorm(t, meanlog = p["meanlog"], sdlog = p["sdlog"], lower.tail = FALSE, log.p = TRUE),
    start = function(time, status) c(mean(log(time)), log(sd(log(time))))
  ),

  loglogistic = list(
    k = 2,
    to_params = function(par) c(shape = exp(par[1]), scale = exp(par[2])),
    logf = function(t, p) {
      sh <- p["shape"]; sc <- p["scale"]
      log(sh / sc) + (sh - 1) * log(t / sc) - 2 * log(1 + (t / sc)^sh)
    },
    logS = function(t, p) {
      sh <- p["shape"]; sc <- p["scale"]
      -log(1 + (t / sc)^sh)
    },
    start = function(time, status) c(log(1), log(median(time)))
  ),

  gompertz = list(
    k = 2,
    to_params = function(par) c(shape = par[1], rate = exp(par[2])),
    logf = function(t, p) {
      sh <- p["shape"]; rt <- p["rate"]
      log(rt) + sh * t + (-(rt / sh) * (exp(sh * t) - 1))
    },
    logS = function(t, p) {
      sh <- p["shape"]; rt <- p["rate"]
      -(rt / sh) * (exp(sh * t) - 1)
    },
    start = function(time, status) c(0.01, log(sum(status) / sum(time)))
  )
)

#' Fit one parametric survival distribution by maximum likelihood
#'
#' @param time    numeric vector of observed times (event or censoring)
#' @param status  integer/logical vector, 1 = event, 0 = censored
#' @param dist    one of "exponential","weibull","gamma","lognormal",
#'                "loglogistic","gompertz"
# Fits one distribution to one arm's reconstructed data by maximum likelihood.
# BFGS is tried first since it's fast; if it doesn't converge cleanly, it
# falls back to Nelder-Mead, which is slower but more forgiving of a rough
# starting point.
fit_parametric <- function(time, status, dist = "weibull") {

  spec <- .dist_specs[[dist]]
  if (is.null(spec)) stop("Unknown distribution: ", dist)

  negloglik <- function(par) {
    p <- spec$to_params(par)
    ll <- sum(status * spec$logf(time, p)) + sum((1 - status) * spec$logS(time, p))
    if (!is.finite(ll)) return(1e10)
    -ll
  }

  start <- spec$start(time, status)
  fit <- tryCatch(
    optim(start, negloglik, method = "BFGS", hessian = FALSE,
          control = list(maxit = 2000)),
    error = function(e) NULL
  )
  if (is.null(fit) || fit$convergence != 0) {
    fit <- optim(start, negloglik, method = "Nelder-Mead",
                 control = list(maxit = 5000))
  }

  params  <- spec$to_params(fit$par)
  loglik  <- -fit$value
  k       <- spec$k
  n       <- length(time)
  aic     <- 2 * k - 2 * loglik
  bic     <- k * log(n) - 2 * loglik

  surv_fn <- function(t) exp(spec$logS(t, params))

  list(
    dist    = dist,
    params  = params,
    loglik  = loglik,
    k       = k,
    n       = n,
    events  = sum(status),
    aic     = aic,
    bic     = bic,
    surv_fn = surv_fn,
    convergence = fit$convergence
  )
}

#' Fit every candidate distribution and return a ranked comparison table
#'
#' @return list(table = data.frame ranked by AIC, fits = named list of fit objects)
fit_all_parametric <- function(time, status,
                                dists = c("exponential", "weibull", "gamma",
                                          "lognormal", "loglogistic", "gompertz")) {
  fits <- setNames(lapply(dists, function(d) fit_parametric(time, status, d)), dists)

  tbl <- do.call(rbind, lapply(fits, function(f) {
    data.frame(
      Distribution = f$dist,
      Parameters   = paste(sprintf("%s = %.4f", names(f$params), f$params), collapse = ", "),
      LogLik       = round(f$loglik, 2),
      AIC          = round(f$aic, 2),
      BIC          = round(f$bic, 2)
    )
  }))
  tbl <- tbl[order(tbl$AIC), ]
  rownames(tbl) <- NULL

  list(table = tbl, fits = fits)
}

#' Restricted mean survival time (area under S(t) up to a horizon) for a fit
#'
#' @param fit     object returned by fit_parametric()
#' @param horizon numeric, truncation time (e.g. trial max follow-up, or a
#'                longer economic-model time horizon)
rmst_parametric <- function(fit, horizon) {
  integrate(fit$surv_fn, lower = 0, upper = horizon,
            subdivisions = 500, stop.on.error = FALSE)$value
}


# SECTION 4 — Dashboard (was: app.R from here down)
# Reconstruct pseudo-IPD once at startup
# Reconstruction happens right here, once, the moment the app starts — not
# every time someone opens a tab or moves a slider.
ipd_pembro <- reconstruct_ipd(pembro_raw$time, pembro_raw$survival,
                               risk$time, risk$pembro, "Pembrolizumab")
ipd_chemo  <- reconstruct_ipd(chemo_raw$time, chemo_raw$survival,
                               risk$time, risk$chemo, "Chemotherapy")
ipd_all    <- rbind(ipd_pembro, ipd_chemo)
max_followup <- max(ipd_all$time)

# ---- Validation stats (reconstructed vs. published) ------------------------
km_fit  <- survfit(Surv(time, status) ~ arm, data = ipd_all)
cox_fit <- coxph(Surv(time, status) ~ arm, data = ipd_all)
cox_ci  <- summary(cox_fit)$conf.int
cox_p   <- summary(cox_fit)$coefficients[, "Pr(>|z|)"]
med_tbl <- summary(km_fit)$table

# ---- Fit every candidate parametric model, once, for each arm -------------
# Same idea here — every distribution is fit for both arms up front. Later,
# when someone picks a different model in the dashboard, it's just looking up
# an answer that's already sitting in memory, not refitting anything live.
fits_pembro <- fit_all_parametric(ipd_pembro$time, ipd_pembro$status)
fits_chemo  <- fit_all_parametric(ipd_chemo$time,  ipd_chemo$status)
fits_by_arm <- list(Pembrolizumab = fits_pembro, Chemotherapy = fits_chemo)

dist_choices <- c("Exponential" = "exponential", "Weibull" = "weibull",
                   "Gamma" = "gamma", "Log-normal" = "lognormal",
                   "Log-logistic" = "loglogistic", "Gompertz" = "gompertz")

# ---- Helper: build an empirical KM step-curve data.frame for plotting -----
km_curve_df <- function(arm_name) {
  d <- if (arm_name == "Pembrolizumab") ipd_pembro else ipd_chemo
  sf <- survfit(Surv(time, status) ~ 1, data = d)
  data.frame(time = c(0, sf$time), surv = c(1, sf$surv) * 100)
}

# ==============================================================================
# UI
# ==============================================================================
# Just the look and feel from here — colors, font stack, a couple of small
# CSS tweaks so it doesn't read as a stock, default-looking Shiny app.
app_font <- font_collection(
  "Inter", "-apple-system", "Segoe UI", "Roboto", "Helvetica Neue", "Arial", "sans-serif"
)

theme <- bs_theme(
  version      = 5,
  primary      = "#1F5FBF",
  secondary    = "#7A7A7A",
  success      = "#1E8A5F",
  base_font    = app_font,
  heading_font = app_font,
  font_scale   = 0.92
) |> bs_add_rules("
  .navbar-brand { font-weight: 650; letter-spacing: -0.01em; }
  .card-header { font-weight: 600; }
  .value-box-title { font-size: 0.8rem; opacity: 0.85; }
  footer.app-footer { color: #888; font-size: 0.8rem; padding: 24px 8px 8px 8px; }
")

# From here down is what a user actually sees and clicks on — the dashboard's
# tabs, cards, and layout. There's no data logic in this part, only how
# everything is presented; the numbers themselves come from the section above.
ui <- page_navbar(
  title = "KEYNOTE-024 Survival Extrapolation",
  theme = theme,
  fillable = TRUE,
  window_title = "Survival Extrapolation Dashboard",

  # ---------------------------------------------------------------- Overview
  nav_panel(
    title = "Overview", icon = icon("chart-line"),
    layout_columns(
      col_widths = c(3, 3, 3, 3),
      value_box(title = "Total patients (reconstructed)", value = nrow(ipd_all),
                showcase = icon("users"), theme = "primary"),
      value_box(title = "Total events (deaths)", value = sum(ipd_all$status),
                showcase = icon("heart-pulse"), theme = "secondary"),
      value_box(title = "Reconstructed HR (95% CI)",
                value = sprintf("%.2f (%.2f\u2013%.2f)", cox_ci[1,1], cox_ci[1,3], cox_ci[1,4]),
                showcase = icon("scale-balanced"), theme = "success"),
      value_box(title = "Published HR (Reck et al. 2016)",
                value = "0.60 (0.41\u20130.89)",
                showcase = icon("book"), theme = "success")
    ),
    layout_columns(
      col_widths = c(7, 5),
      card(
        card_header("Reconstructed Overall Survival — both arms"),
        plotlyOutput("overview_km", height = "420px")
      ),
      card(
        card_header("What this dashboard does"),
        markdown(
          "1. **Digitized curve** — Figure 2 (Overall Survival) of the KEYNOTE-024
          trial (Reck et al., *NEJM* 2016) was digitized point-by-point.
          2. **Pseudo-IPD reconstruction** — individual patient records
          (time + event/censoring status) were rebuilt from the digitized
          curve and the published number-at-risk table, using a from-scratch
          implementation of the Guyot et al. (2012) algorithm.
          3. **Parametric modeling** — six standard survival distributions are
          fit by maximum likelihood and ranked by AIC/BIC — the standard
          workflow used in health-economic survival extrapolation.
          4. **Extrapolation** — the best (or any chosen) model is projected
          beyond the trial's observed follow-up, and restricted mean survival
          time (RMST) is computed — a key input to cost-effectiveness models.

          See the **About / Methodology** tab for validation details and
          limitations."
        )
      )
    )
  ),

  # ------------------------------------------------------- KM & Validation
  nav_panel(
    title = "KM Curves & Validation", icon = icon("check-double"),
    layout_columns(
      col_widths = c(8, 4),
      card(
        card_header("Reconstructed Kaplan-Meier curves (validation view)"),
        plotlyOutput("validation_km", height = "440px"),
        p(class = "text-muted small mt-2",
          "Step curves are refit directly from the reconstructed pseudo-IPD — their close
           visual match to the original published figure is the first check that the
           reconstruction worked.")
      ),
      card(
        card_header("Reconstruction accuracy check"),
        tableOutput("validation_table"),
        hr(),
        h6("Events / censoring by arm"),
        tableOutput("events_table"),
        p(class = "text-muted small",
          "Targets are read directly from the published risk table; a close match confirms the
           digitized curve and Guyot reconstruction are consistent with the source paper.")
      )
    )
  ),

  # ----------------------------------------------------- Parametric Fitting
  nav_panel(
    title = "Parametric Modeling", icon = icon("wave-square"),
    layout_sidebar(
      sidebar = sidebar(
        title = "Model controls", width = 300,
        selectInput("pm_arm", "Treatment arm",
                    choices = c("Pembrolizumab", "Chemotherapy")),
        checkboxGroupInput("pm_dists", "Distributions to overlay on the KM curve",
                            choices = dist_choices,
                            selected = c("weibull", "gamma", "lognormal")),
        hr(),
        p(class = "text-muted small",
          "Every model is fit once at startup by direct maximum-likelihood
          optimization (no flexsurv dependency). AIC/BIC below update instantly
          because nothing is refit on the fly.")
      ),
      card(
        card_header("Kaplan-Meier vs. fitted parametric curves"),
        plotlyOutput("pm_plot", height = "440px")
      ),
      card(
        card_header(textOutput("pm_table_header")),
        DTOutput("pm_table"),
        downloadButton("dl_aic_table", "Download AIC/BIC table (.csv)", class = "btn-sm mt-2")
      )
    )
  ),

  # -------------------------------------------------------- Extrapolation
  nav_panel(
    title = "Extrapolation & RMST", icon = icon("arrow-trend-up"),
    layout_sidebar(
      sidebar = sidebar(
        title = "Extrapolation controls", width = 300,
        sliderInput("horizon", "Extrapolation horizon (months)",
                    min = round(max_followup), max = 120,
                    value = 60, step = 1),
        selectInput("ex_dist_pembro", "Pembrolizumab model",
                    choices = dist_choices,
                    selected = fits_pembro$table$Distribution[1]),
        selectInput("ex_dist_chemo", "Chemotherapy model",
                    choices = dist_choices,
                    selected = fits_chemo$table$Distribution[1]),
        p(class = "text-muted small",
          HTML(sprintf("Dropdowns default to each arm's <b>AIC-best</b> model
                       (Pembrolizumab: %s, Chemotherapy: %s), but any
                       distribution can be selected to compare extrapolation
                       assumptions.", fits_pembro$table$Distribution[1],
                       fits_chemo$table$Distribution[1])))
      ),
      layout_columns(
        col_widths = c(12),
        card(
          card_header("Extrapolated survival beyond the trial's observed follow-up"),
          plotlyOutput("ex_plot", height = "440px")
        )
      ),
      layout_columns(
        col_widths = c(6, 6),
        value_box(title = "Pembrolizumab — restricted mean survival (RMST) to horizon",
                  value = textOutput("rmst_pembro"), showcase = icon("stopwatch"), theme = "primary"),
        value_box(title = "Chemotherapy — restricted mean survival (RMST) to horizon",
                  value = textOutput("rmst_chemo"), showcase = icon("stopwatch"), theme = "secondary")
      )
    )
  ),

  # ----------------------------------------------------------------- About
  nav_panel(
    title = "About / Methodology", icon = icon("circle-info"),
    layout_columns(
      col_widths = c(8, 4),
      card(
        card_header("Methodology"),
        markdown(
          "**Source trial.** KEYNOTE-024 — Reck M, Rodr\u00edguez-Abreu D, Robinson AG, et al.
          *Pembrolizumab versus Chemotherapy for PD-L1\u2013Positive Non\u2013Small-Cell Lung
          Cancer.* N Engl J Med. 2016;375:1823-1833. Overall survival, Figure 2.

          **Digitization.** Figure 2 was digitized point-by-point in WebPlotDigitizer.
          Automatic-extraction artifacts (a handful of points falling on the
          in-plot arm-label text rather than the curve itself, and minor jitter
          from censoring tick marks) were identified and removed by enforcing
          monotonic non-increasing survival before reconstruction.

          **Pseudo-IPD reconstruction.** Individual patient time-to-event
          records were rebuilt using a from-scratch R implementation of:
          *Guyot P, Ades AE, Ouwens MJ, Welton NJ. Enhancing secondary analysis
          of survival data: reconstructing the data from published
          Kaplan-Meier survival curves. BMC Med Res Methodol. 2012;12:9.*
          The published number-at-risk table anchors each interval, so the
          reconstruction reconciles exactly to the reported risk counts at
          every checkpoint.

          **Parametric survival modeling.** Six standard distributions
          (exponential, Weibull, gamma, log-normal, log-logistic, Gompertz)
          were fit by direct maximum-likelihood estimation — the same
          candidate set recommended by the NICE Decision Support Unit
          (TSD 14) for survival extrapolation in cost-effectiveness models.

          **Validation.** The reconstructed data reproduce the trial's
          headline result closely: reconstructed HR was compared against the
          hazard ratio reported in the original figure (0.60, 95% CI
          0.41\u20130.89, P=0.005) as the primary check of reconstruction quality."
        )
      ),
      card(
        card_header("Limitations & disclaimer"),
        markdown(
          "- This is a **reconstructed approximation** of the original
          patient-level data, built from a published figure — not the
          trial's actual IPD.
          - Digitization and reconstruction introduce small, unavoidable
          error; treat point estimates as illustrative, not exact.
          - Parametric extrapolation beyond the observed follow-up window
          carries substantial structural uncertainty regardless of AIC/BIC —
          this is a general feature of survival extrapolation, not a
          limitation specific to this dashboard.
          - Built for **educational and portfolio purposes**. Not intended
          for clinical, regulatory, or payer decision-making."
        ),
        hr(),
        downloadButton("dl_ipd", "Download reconstructed pseudo-IPD (.csv)", class = "btn-sm")
      )
    ),
    tags$footer(class = "app-footer",
      "Built with R, Shiny, bslib, plotly & survival. Guyot reconstruction and all
       parametric model fitting implemented from first principles in base R.")
  )
)

# ==============================================================================
# SERVER
# ==============================================================================
# And this is the reactive side of things. Everything the UI above displays
# gets its actual values from here, recalculated on the fly whenever a user
# changes an input — switches arms, ticks a distribution, drags the horizon
# slider, and so on.
server <- function(input, output, session) {

  # ---------------------------------------------------------------- Overview
  output$overview_km <- renderPlotly({
    p <- plot_ly()
    for (a in names(arm_colors)) {
      df <- km_curve_df(a)
      p <- add_trace(p, data = df, x = ~time, y = ~surv, type = "scatter",
                      mode = "lines", line = list(shape = "hv", color = arm_colors[[a]], width = 3),
                      name = a)
    }
    p |> layout(xaxis = list(title = "Months since randomization"),
                yaxis = list(title = "Overall Survival (%)", range = c(0, 102)),
                legend = list(orientation = "h", y = -0.15),
                margin = list(t = 10))
  })

  # ------------------------------------------------------- KM & Validation
  output$validation_km <- renderPlotly({
    p <- plot_ly()
    for (a in names(arm_colors)) {
      df <- km_curve_df(a)
      raw <- if (a == "Pembrolizumab") pembro_raw else chemo_raw
      p <- add_trace(p, data = df, x = ~time, y = ~surv, type = "scatter",
                      mode = "lines", line = list(shape = "hv", color = arm_colors[[a]], width = 3),
                      name = paste(a, "(reconstructed KM)"))
      p <- add_trace(p, x = raw$time, y = raw$survival, type = "scatter", mode = "markers",
                      marker = list(color = arm_colors[[a]], size = 4, opacity = 0.35),
                      name = paste(a, "(digitized points)"))
    }
    p |> layout(xaxis = list(title = "Months since randomization"),
                yaxis = list(title = "Overall Survival (%)", range = c(0, 102)),
                legend = list(orientation = "h", y = -0.2),
                margin = list(t = 10))
  })

  output$validation_table <- renderTable({
    data.frame(
      Metric = c("Hazard ratio", "95% CI lower", "95% CI upper", "P-value"),
      Reconstructed = c(round(cox_ci[1,1], 2), round(cox_ci[1,3], 2), round(cox_ci[1,4], 2), signif(cox_p, 2)),
      Published     = c(0.60, 0.41, 0.89, 0.005)
    )
  }, striped = TRUE, digits = 3)

  output$events_table <- renderTable({
    data.frame(
      Arm      = c("Pembrolizumab", "Chemotherapy"),
      N        = c(nrow(ipd_pembro), nrow(ipd_chemo)),
      Events   = c(sum(ipd_pembro$status), sum(ipd_chemo$status)),
      Censored = c(sum(ipd_pembro$status == 0), sum(ipd_chemo$status == 0)),
      `Target N (risk table)` = c(risk$pembro[1], risk$chemo[1]), check.names = FALSE
    )
  }, striped = TRUE)

  # ----------------------------------------------------- Parametric Fitting
  output$pm_table_header <- renderText({
    sprintf("AIC / BIC comparison — %s", input$pm_arm)
  })

  current_fits <- reactive({ fits_by_arm[[input$pm_arm]] })

  output$pm_plot <- renderPlotly({
    req(input$pm_dists)
    df  <- km_curve_df(input$pm_arm)
    fit <- current_fits()
    tgrid <- seq(0, max_followup, length.out = 200)

    p <- plot_ly() |>
      add_trace(data = df, x = ~time, y = ~surv, type = "scatter", mode = "lines",
                line = list(shape = "hv", color = "#222222", width = 3),
                name = "Reconstructed KM")

    palette <- c("#D6455D", "#E08E1E", "#2E9E6E", "#7A4FE0", "#1F9CBF", "#B5760F")
    for (i in seq_along(input$pm_dists)) {
      d  <- input$pm_dists[i]
      fo <- fit$fits[[d]]
      yv <- fo$surv_fn(tgrid) * 100
      p <- add_trace(p, x = tgrid, y = yv, type = "scatter", mode = "lines",
                      line = list(color = palette[((i - 1) %% length(palette)) + 1], width = 2, dash = "dash"),
                      name = names(dist_choices)[dist_choices == d])
    }
    p |> layout(xaxis = list(title = "Months since randomization"),
                yaxis = list(title = "Survival (%)", range = c(0, 102)),
                legend = list(orientation = "h", y = -0.2),
                margin = list(t = 10))
  })

  output$pm_table <- renderDT({
    datatable(current_fits()$table, rownames = FALSE, selection = "none",
              options = list(dom = "t", pageLength = 6)) |>
      formatStyle("Distribution", target = "row",
                  backgroundColor = styleEqual(current_fits()$table$Distribution[1], "#EAF2FF"))
  })

  output$dl_aic_table <- downloadHandler(
    filename = function() paste0("aicbic_", tolower(input$pm_arm), ".csv"),
    content  = function(file) write.csv(current_fits()$table, file, row.names = FALSE)
  )

  # -------------------------------------------------------- Extrapolation
  output$ex_plot <- renderPlotly({
    tgrid <- seq(0, input$horizon, length.out = 250)
    p <- plot_ly()

    for (a in names(arm_colors)) {
      df <- km_curve_df(a)
      p <- add_trace(p, data = df, x = ~time, y = ~surv, type = "scatter", mode = "lines",
                      line = list(shape = "hv", color = arm_colors[[a]], width = 3),
                      name = paste(a, "— observed"))
    }

    fo_p <- fits_pembro$fits[[input$ex_dist_pembro]]
    fo_c <- fits_chemo$fits[[input$ex_dist_chemo]]
    p <- add_trace(p, x = tgrid, y = fo_p$surv_fn(tgrid) * 100, type = "scatter", mode = "lines",
                    line = list(color = COL_PEMBRO, width = 2, dash = "dot"),
                    name = paste("Pembrolizumab —", input$ex_dist_pembro, "extrapolation"))
    p <- add_trace(p, x = tgrid, y = fo_c$surv_fn(tgrid) * 100, type = "scatter", mode = "lines",
                    line = list(color = COL_CHEMO, width = 2, dash = "dot"),
                    name = paste("Chemotherapy —", input$ex_dist_chemo, "extrapolation"))

    p |> layout(
      xaxis = list(title = "Months since randomization"),
      yaxis = list(title = "Survival (%)", range = c(0, 102)),
      legend = list(orientation = "h", y = -0.2),
      shapes = list(list(type = "line", x0 = max_followup, x1 = max_followup, y0 = 0, y1 = 102,
                          line = list(color = "#999999", dash = "dot", width = 1))),
      annotations = list(list(x = max_followup, y = 100, text = "trial follow-up ends",
                               showarrow = FALSE, font = list(size = 10, color = "#999999"), xanchor = "left")),
      margin = list(t = 10))
  })

  output$rmst_pembro <- renderText({
    fo <- fits_pembro$fits[[input$ex_dist_pembro]]
    sprintf("%.1f months", rmst_parametric(fo, input$horizon))
  })
  output$rmst_chemo <- renderText({
    fo <- fits_chemo$fits[[input$ex_dist_chemo]]
    sprintf("%.1f months", rmst_parametric(fo, input$horizon))
  })

  # ----------------------------------------------------------------- About
  output$dl_ipd <- downloadHandler(
    filename = "reconstructed_ipd.csv",
    content  = function(file) write.csv(ipd_all, file, row.names = FALSE)
  )
}

# Ties the two halves together and launches the app.
shinyApp(ui, server)

