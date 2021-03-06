% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/maple_fit_model.R
\name{maple_fit_model}
\alias{maple_fit_model}
\title{Fit a single forecasting model.}
\usage{
maple_fit_model(model, deaths, population, forecast.horizon, num.threads)
}
\arguments{
\item{model}{A forecasting model; see ?maple_models for more details.}

\item{deaths}{Deaths matrix; see ?maple for more details.}

\item{population}{Population matrix; see ?maple for more details.}

\item{forecast.horizon}{The number of years to produce projections for.}

\item{num.threads}{The number of threads passed to INLA; see ?maple for more details.}
}
\value{
If the model is fitted using INLA, an INLA object. See ?INLA::inla for more details.
For Lee Carter models, a list is returned with the following entries
\describe{
  \item{logrates}{The logarithm of the fitted death rates.}
  \item{rates}{The fitted death rates.}
  \item{alphas}{The intercepts.}
  \item{betas}{The age-specific components in the Lee Carter model. This is a matrix whose columns correspond to age groups and rows to principal components.}
  \item{gammas}{The time-varying components in the Lee Carter model. This is a matrix whose columns correspond to years and rows to principal components.}
  \item{gammas.fit}{A list of length equal to the number of principal components. Each item in the list is the random walk fitted as an Arima object; see ?stats::arima for more details.}
  \item{gammas.pred}{The extrapolated values of gammas.fit used for projections.}
  \item{pct.var}{The proportion of variance explained by the principal component decomposition.}
  \item{num.pcs}{The number of principal components used.}
  \item{forecast.horizon}{The number of years forecast ahead.}
}
}
\description{
Fit a single forecasting model.
}
\examples{
maple_fit_model(maple_models()[[1]], deaths = maple.deaths,
                population = maple.population, forecast.horizon = 20)
}

