# library(beepr)
# library(chromote)
# library(cli))
# library(here)
library(magrittr)
# library(rmarkdown)

cli::cli_progress_step("Rendering the HTML version of the CV")

html_file <- here::here("docs", "index.html")

rmarkdown::render(
  here::here("index.Rmd"),
  params = list(pdf_mode = FALSE),
  output_file = html_file
)

cli::cli_progress_step("Rendering the PDF version of the CV")

html_pdf_file <- here::here("docs", "pdf", "index_pdf.html")

rmarkdown::render(
  here::here("index.Rmd"),
  params = list(pdf_mode = TRUE),
  output_file = html_pdf_file
)

cli::cli_progress_step("Creating the PDF file from the HTML version")

pdf_file <- here::here("docs", "pdf", "Daniel Vartanian.pdf")

session <- chromote::ChromoteSession$new()

html_pdf_file %>%
  paste0("file://", .) |>
  session$go_to(delay = 5)

# Sys.sleep(5)

pdf_file |>
  session$screenshot_pdf(
    pagesize = "a4",
    margins = 0,
    units = "cm",
    landscape = FALSE,
    display_header_footer = TRUE,
    print_background = TRUE,
    scale = 1,
    wait_ = TRUE
  )

cli::cli_process_done()

beepr::beep(1)

pdf_pages <-
  pdf_file |>
  pdftools::pdf_info() |>
  magrittr::extract2("pages")

if (!pdf_pages == 4) {
  beepr::beep(9)

  cli::cli_abort(
    paste0(
      "The PDF file has {.strong {cli::col_red(pdf_pages)}}, ",
      "pages, but it should have {.strong {cli::col_blue('4')}} pages. ",
      "Please check the rendering process and try again."
    )
  )
}
