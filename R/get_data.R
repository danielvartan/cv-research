library(checkmate)
library(cli)
library(dplyr)
library(googlesheets4)
library(magrittr)
library(purrr)
library(tibble)

#' Download and import CV data from a Google Sheet
#'
#' @description
#'
#' `get_data()` reads and imports curriculum vitae
#' ([CV](https://en.wikipedia.org/wiki/Curriculum_vitae)) data from a
#' [Google Sheet](https://docs.google.com/spreadsheets/), organizing it into a
#' [`list`][base::list()] for further processing.
#'
#' @details
#'
#' If your data is not publicly available, you will need to set up
#' authentication credentials to allow the function to read the data from the
#' Google Sheet. You can do this by running:
#'
#' ```r
#' library(gargle)
#' library(googlesheets4)
#' ```
#'
#' ```r
#' options(gargle_oauth_cache = ".secrets")
#' ```
#'
#' ```r
#' gs4_auth()
#' gargle_oauth_cache()
#' ```
#'
#' This will prompt you to authenticate with your Google account and create a
#' local cache of your credentials in a `.secrets` folder. Make sure that the
#' Google account you use has access to the sheet containing your CV data.
#'
#' @param ss A [`character`][base::character()] string with the URL or ID of a
#'   Google Sheet containing the CV data.
#' @param public (optional) A [`logical`][logical()] flag indicating whether the
#'   Google Sheet is publicly available. If `FALSE`, the function will look for
#'   authorization credentials in a local `.secrets` folder. See the *Details*
#'   section for instructions on how to set up authentication credentials if
#'   your data is not publicly available (default: `TRUE`).
#'
#' @return A [`list`][base::list()] with the CV data read from the Google Sheet.
#'
#' @noRd
get_data <- function(ss, public = TRUE) {
  assert_string(ss)
  assert_flag(public)

  if (isTRUE(public)) {
    gs4_deauth()
  } else {
    options(gargle_oauth_cache = ".secrets")
  }

  meta_sheets <- c(
    "Documentation",
    "Codebook",
    "Validation",
    "Template"
  )

  sheets <-
    ss |>
    gs4_get() |>
    pluck("sheets") |>
    filter(!name %in% meta_sheets) |>
    pull(name)

  data <- list()

  for (i in sheets) {
    data <-
      ss |>
      read_sheet(
        sheet = i,
        skip = 0,
        col_types = "c"
      ) |>
      list() |>
      set_names(i) |>
      append(data, values = _)
  }

  data
}
