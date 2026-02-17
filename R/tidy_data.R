library(checkmate)
library(dplyr)
library(glue)
library(here)
library(magrittr)
library(stringr)
library(purrr)

#' Tidy data from `get_data()`
#'
#' @description
#'
#' `tidy_data()` takes the [`list`][base::list()] returned by `get_data()` and
#' performs various transformations to tidy the data.
#'
#' @param data A [`list`][base::list()] with CV data, as returned by
#'   `get_data()`.
#'
#' @return A [`list`][base::list()] with the same structure as the input `data`,
#'   but with the values transformed and tidied for use in the CV rendering
#'   process.
#'
#' @noRd
tidy_data <- function(data) {
  section_methods <- c(
    introduction = "filter",
    education = "entries",
    research_experience = "entries",
    teaching_experience = "entries",
    funding = "entries",
    outreach = "entries",
    talks = "entries",
    publications = "entries",
    software_development = "entries",
    additional_training = "entries",
    events = "entries",
    contact = "filter",
    references = "filter",
    affiliations = "affiliations",
    languages = "filter",
    programming_languages = "filter",
    technical_skills = "filter"
  )

  assert_list(data, min.len = 1)

  for (i in seq_along(section_methods)) {
    section <- names(section_methods)[i]
    method <- section_methods[i]

    if (is.null(data[[section]])) {
      next
    }

    i_data <-
      data |>
      pluck(section) |>
      filter(include == "TRUE")

    if (nrow(i_data) == 0) {
      data <-
        data |>
        inset2(section, i_data)

      next
    }

    data <-
      do.call(
        glue("tidy_data.{method}"),
        list(data, section)
      ) %>%
      inset2(data, section, .)
  }

  data
}

library(checkmate)
library(dplyr)
library(lubridate)
library(purrr)
library(stringr)
library(tidyr)

tidy_data.entries <- function(data, section) {
  assert_list(data, min.len = 1)
  assert_subset(section, names(data))

  data |>
    pluck(section) |>
    filter(include == "TRUE") |>
    unite(
      col = "description_bullets",
      starts_with("description"),
      sep = "\n- ",
      na.rm = TRUE
    ) |>
    mutate(
      description_bullets = case_when(
        bullets == "FALSE" |
          str_detect(description_bullets, "^\\[-\\]") ~
          description_bullets,
        description_bullets != "" ~ paste0("- ", description_bullets),
        TRUE ~ "" # Do not change to `NA`
      ),
      description_bullets = if_else(
        str_detect(description_bullets, "^\\[-\\]"),
        description_bullets |>
          str_remove("^\\[-\\]") |>
          str_trim(),
        description_bullets
      ),
      start = if_else(
        str_detect(start, "^[0-9]{4}$"),
        start,
        NA
      ),
      start_end = case_when(
        is.na(start) & is.na(end) ~ NA_character_,
        !is.na(start) & is.na(end) ~ start,
        is.na(start) & !is.na(end) ~ end,
        TRUE ~ paste(end, "-", start)
      ),
      across(
        .cols = where(is.character),
        .fns = \(x) replace_na(x, "N/A")
      )
    ) |>
    arrange(
      end |>
        parse_date_time(c("ymd", "dmy", "mdy", "y")) |>
        ymd() |>
        replace_na(Sys.Date() |> ymd()) |>
        desc() |>
        suppressWarnings()
    )
}

library(checkmate)
library(dplyr)
library(lubridate)
library(purrr)
library(stringr)
library(tidyr)

tidy_data.affiliations <- function(data, section = "affiliations") {
  assert_list(data, min.len = 1)
  assert_subset(section, names(data))

  data |>
    pluck(section) |>
    filter(include == "TRUE") |>
    mutate(
      start = if_else(
        str_detect(start, "^[0-9]{4}$"),
        start,
        NA
      ),
      start_end = case_when(
        is.na(start) & is.na(end) ~ NA,
        !is.na(start) & is.na(end) ~ start,
        is.na(start) & !is.na(end) ~ end,
        TRUE ~ paste0(start, "-", end)
      ),
      across(
        .cols = where(is.character),
        .fns = \(x) replace_na(x, "N/A")
      )
    ) |>
    arrange(
      end |>
        parse_date_time(c("ymd", "dmy", "mdy", "y")) |>
        ymd() |>
        replace_na(Sys.Date() |> ymd()) |>
        desc() |>
        suppressWarnings()
    )
}

library(checkmate)
library(dplyr)
library(purrr)

tidy_data.filter <- function(data, section) {
  assert_list(data, min.len = 1)
  assert_subset(section, names(data))

  data |>
    pluck(section) |>
    filter(include == "TRUE")
}
