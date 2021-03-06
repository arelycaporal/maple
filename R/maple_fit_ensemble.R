#' Fit an ensemble of models.
#' @param deaths Deaths matrix; see ?maple for more details.
#' @param population Population matrix; see ?maple for more details.
#' @param forecast.horizon The number of years to produce projections for.
#' @param models The individual models to be run; see ?maple_models for more details.
#' @param num.draws The number of posterior draws to sample and use for calculating statistical summaries.
#' @param ax The number of years lived on average by those who die in their current age group. See ?maple_plt for more details. 
#' @param num.threads The number of threads passed to INLA; see ?maple for more details.
#' @param verbose If TRUE (the default), print some information on progress fitting models, etc.
#' @return A list with the following entries
#' \describe{
#'   \item{sample.summaries}{A data frame holding statistical summary information for age-specific death rates, life expectancy and probability of dying, calculated from the posterior draws.}
#'   \item{samples}{A list of life table draws, calculated using posterior samples of death rates.}
#'   \item{model.fits}{The fitted model objects, which can be used for futher analysis.}
#' }
#' @examples
#' fits <- maple_fit_ensemble(deaths = maple.deaths, population = maple.population,
#'                            forecast.horizon = 20, models = maple_models()[c(1, 20)])
#' @export
maple_fit_ensemble <- function(deaths, population, forecast.horizon, models = maple_models(),
                          num.draws = 1000, ax = NULL, num.threads = inla.getOption("num.threads"),
                          verbose = TRUE) {
    
    check_maple_data_format(deaths, population, ax)
    
    if (is.null(rownames(deaths))) {
        message("Death rates matrix row names are missing; assuming they match age groups 0-4, 5-9, ..., 80-84, 85+.")
        rownames(deaths) <- seq(0, 85, 5)
    }
    if (is.null(rownames(population))) {
        message("Population matrix row names are missing; assuming they match age groups 0-4, 5-9, ..., 80-84, 85+.")
        rownames(population) <- seq(0, 85, 5)
    }
    if (!is.null(ax) && is.null(rownames(ax))) {
        message("ax values matrix row names are missing; assuming they match age groups 0-4, 5-9, ..., 80-84, 85+.")
        rownames(ax) <- seq(0, 85, 5)
    }
    
    model.fits <- structure(lapply(seq_along(models), function(m) {
            if (verbose) message("Fitting model ", models[[m]]$name, "...")
            tryCatch(maple_fit_model(model = models[[m]],
                                     deaths = deaths,
                                     population = population,
                                     forecast.horizon = forecast.horizon,
                                     num.threads = num.threads),
                     error = function(e) {
                            message("Error:", e$message)
                            return(e)
                         }
            )
        }), 
        names = names(models)
    )

    samples <- summaries <- NULL
    if (num.draws > 0) {
        samples <- structure(lapply(seq_along(models), function(m) {
                if (verbose) message("Sampling draws for model ", models[[m]]$name, "...")
                tryCatch(
                    maple_sample(model.fit = model.fits[[m]],
                                 num.draws = num.draws,
                                 ax = ax),
                    error = function(e) {
                            message("Error:", e$message)
                            return(e)
                        }
                )
            }),
            names = names(models)
        )

        sample.summaries <- lapply(seq_along(models), function(m) {
            if (verbose) message("Calculating summary statistics for model ",
                                 models[[m]]$name, "...")
            tryCatch(
                data.frame(model = names(models)[m], 
                           maple_sample_summaries(samples[[m]])),
                error = function(e) {
                        message("Error:", e$message)
                        return(e)
                    }
            )
        })
        sample.summaries <- do.call(rbind, sample.summaries)
    }
    list(
        sample.summaries = sample.summaries,
        samples = samples,
        model.fits = model.fits
    )
}
