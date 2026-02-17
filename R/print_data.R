library(checkmate)
library(dplyr)
library(glue)
library(purrr)

#' Print a CV section
#'
#' @description
#'
#' `print_data()` is a generic function that call methods for printing
#' different sections of curriculum vitae
#' ([CV](https://en.wikipedia.org/wiki/Curriculum_vitae)) data.
#'
#' @param data A [`list`][base::list()] with CV data, as returned by
#'   `tidy_data()`.
#' @param section A [`character`][base::character()] string with the section of
#'   the CV data to be printed.
#'
#' @noRd
print_data <- function(data, section) {
  assert_list(data, min.len = 1)
  assert_subset(section, names(data))

  section_methods <- c(
    introduction = "text_block",
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
    contact = "contact",
    references = "references",
    affiliations = "affiliations",
    languages = "languages",
    programming_languages = "programming_languages",
    technical_skills = "technical_skills"
  )

  i_data <-
    data |>
    pluck(section) |>
    filter(include == "TRUE")

  if (!nrow(i_data) == 0) {
    if (section %in% names(section_methods)) {
      method <- section_methods[[section]]

      do.call(
        glue("print_data.{method}"),
        args = list(data, section)
      )
    } else {
      print_data.text_block(data, section)
    }
  } else {
    ""
  }
}

library(checkmate)
library(dplyr)
library(glue)
library(purrr)

print_data.entries <- function(data, section) {
  assert_list(data, min.len = 1)
  assert_subset(section, names(data))

  data |>
    pluck(section) |>
    filter(include == "TRUE") |>
    glue_data(
      "### {title}",
      "\n\n",
      "{institution}",
      "\n\n",
      "{location}",
      "\n\n",
      "{start_end}",
      "\n\n",
      "{description_bullets}",
      "\n\n"
    )
}

library(checkmate)
library(dplyr)
library(glue)
library(purrr)

print_data.contact <- function(data, section = "contact") {
  assert_list(data, min.len = 1)
  assert_subset(section, names(data))

  data |>
    pluck(section) |>
    filter(include == "TRUE") |>
    glue_data(
      "<i class=\"{icon}\"></i>&nbsp;&nbsp; {contact}",
      "\n\n"
    )
}

library(checkmate)
library(dplyr)
library(glue)
library(purrr)
library(stringr)

print_data.references <- function(data, section = "references") {
  assert_list(data, min.len = 1)
  assert_subset(section, names(data))

  data |>
    pluck(section) |>
    filter(include == "TRUE") |>
    mutate(
      affiliation = affiliation |>
        str_replace_all("\n", "<br>")
    ) |>
    glue_data(
      "<h3 style=\"padding-top: 0px\">{name}</h3>",
      "\n\n",
      "<p>{affiliation}</p>",
      "\n\n",
    )
}

library(checkmate)
library(dplyr)
library(glue)
library(purrr)
library(stringr)

print_data.affiliations <- function(data, section = "affiliations") {
  assert_list(data, min.len = 1)
  assert_subset(section, names(data))

  data |>
    pluck(section) |>
    filter(include == "TRUE") |>
    glue_data(
      "<h3 style=\"padding-bottom: 5px\">{affiliation}</h3>",
      "\n\n",
      "<p style=\"margin-block-start: 0em;\">{role} ({start_end})</p>",
      "\n\n",
    )
}

library(checkmate)
library(dplyr)
library(glue)
library(purrr)

print_data.languages <- function(data, section = "languages") {
  assert_list(data, min.len = 1)
  assert_subset(section, names(data))

  data |>
    pluck(section) |>
    filter(include == "TRUE") |>
    glue_data(
      "<h3 style=\"padding-top: 10px\">{language}</h3>",
      "\n\n",
      "<i class=\"fa-solid fa-ear-listen\"></i>&nbsp;&nbsp; {listening}",
      "\n\n",
      "<i class=\"fas fa-book-reader\"></i>&nbsp;&nbsp; {reading}",
      "\n\n",
      "<i class=\"fa fa-comments-o\" aria-hidden=\"true\"></i>&nbsp;&nbsp; ",
      "{speaking}",
      "\n\n",
      "<i class=\"fas fa-pencil-alt\" aria-hidden=\"true\"></i>&nbsp;&nbsp; ",
      "{writing}",
      "\n\n"
    )
}

library(checkmate)
library(dplyr)
library(glue)
library(purrr)

print_data.programming_languages <- function(
  data,
  section = "programming_languages"
) {
  assert_list(data, min.len = 1)
  assert_subset(section, names(data))

  data <-
    data |>
    pluck(section) |>
    filter(include == "TRUE")

  levels <-
    data |>
    pull(level) |>
    unique()

  out <- character()

  for (i in levels) {
    i_data <-
      data |>
      filter(level == i)

    out <-
      c(
        out,
        glue(
          "<h3 style=\"padding-top: 10px\">{i}</h3>",
          "\n\n\n"
        ),
        i_data |>
          glue_data(
            "<i class=\"{icon}\"></i>&nbsp;&nbsp; {language}",
            "\n\n\n"
          )
      )
  }

  out |> cat()
}

library(checkmate)
library(dplyr)
library(glue)
library(purrr)

print_data.technical_skills <- function(data, section = "technical_skills") {
  assert_list(data, min.len = 1)
  assert_subset(section, names(data))

  data |>
    pluck(section) |>
    filter(include == "TRUE") |>
    glue_data(
      "<p style=\"margin-block-start: 0em;\">• {skill}</p>",
      "\n\n",
    )
}

library(checkmate)
library(dplyr)
library(glue)
library(magrittr)
library(purrr)

print_data.text_block <- function(data, section) {
  assert_list(data, min.len = 1)
  assert_choice(section, names(data))

  data |>
    pluck(section) |>
    filter(include == "TRUE") |>
    pull(1) |>
    cat()
}
