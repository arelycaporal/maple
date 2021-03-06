% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plt_qx.R
\name{plt_qx}
\alias{plt_qx}
\title{Extract the probability of dying by a given age from a life table.}
\usage{
plt_qx(plt, x = 70)
}
\arguments{
\item{plt}{A life table calculated by maple_plt().}

\item{x}{The age group for which to calculate probability of dying by.}
}
\value{
A named vector containing the probability of dying between 0 and age x in each year.
}
\description{
Extract the probability of dying by a given age from a life table.
}

