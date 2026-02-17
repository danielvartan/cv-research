# Load Packages -----

library(beepr)
library(chromote)
library(cli)
library(here)
library(magrittr)
library(pdftools)
library(purrr)
library(rmarkdown)

# Set Chrome Path for `chromote` -----

Sys.setenv(
  CHROMOTE_CHROME = "/var/lib/flatpak/exports/bin/com.google.Chrome"
)

# Render CV -----

cli_progress_step("Rendering the HTML version of the CV")

html_file <- here("docs", "index.html")

here("index.Rmd") |>
  rmarkdown::render(
    params = list(pdf_mode = FALSE),
    output_file = html_file
  )

cli_process_done()

Sys.sleep(1)
beep(1)

cli_progress_step("Rendering the PDF version of the CV")

html_pdf_file <- here("docs", "pdf", "index_pdf.html")

here("index.Rmd") |>
  rmarkdown::render(
    params = list(pdf_mode = TRUE),
    output_file = html_pdf_file
  )

cli_process_done()

Sys.sleep(1)
beep(1)

cli_progress_step("Creating the CV PDF file")

pdf_file <- here("docs", "pdf", "Daniel Vartanian.pdf")

session <- ChromoteSession$new()

html_pdf_file %>%
  paste0("file://", .) |>
  session$go_to(delay = 5)

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

cli_process_done()

Sys.sleep(1)
beep(1)

# Check the Number of Pages in the PDF File -----

pdf_pages <-
  pdf_file |>
  pdf_info() |>
  pluck("pages")

max_pages <- 4

if (!pdf_pages == max_pages) {
  Sys.sleep(1)
  beep(2)

  cli_abort(
    paste0(
      "The PDF file has {.strong {col_red(pdf_pages)}}, ",
      "pages, but it should have {.strong {col_blue(max_pages)}} pages. ",
      "Please check the rendering process and try again."
    )
  )
}
