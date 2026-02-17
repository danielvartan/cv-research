# cv-research

<!-- badges: start -->
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![DOI Badge](https://img.shields.io/badge/doi-10.5281/zenodo.18666383-1284C5.svg)](https://doi.org/10.5281/zenodo.18666383)
[![FAIR checklist badge](https://img.shields.io/badge/fairsoftwarechecklist.net--00a7d9.png)](https://fairsoftwarechecklist.net/v0.2?f=21&a=32113&i=32300&r=123)
[![fair-software.eu](https://img.shields.io/badge/fair--software.eu-%E2%97%8F%20%E2%97%8F%20%E2%97%8F%20%E2%97%8F%20%E2%97%8B-yellow)](https://fair-software.eu)
[![License: GPLv3](https://img.shields.io/badge/license-GPLv3-bd0000.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![License: CC BY-NC-SA 4.0](https://img.shields.io/badge/license-CC_BY--NC--SA_4.0-lightgrey.svg)](https:/n/creativecommons.org/licenses/by-nc-sa/4.0/)
<!-- badges: end -->

## Overview

This repository provides the source files for generating my curriculum vitae ([CV](https://en.wikipedia.org/wiki/Curriculum_vitae)) for research positions.

The CV is available [here](https://danielvartan.github.io/cv-research/).

## Usage

This CV was developed using the [R](https://www.r-project.org/) programming language, along with the [`rmarkdown`](https://rmarkdown.rstudio.com/), [`pagedown`](https://github.com/rstudio/pagedown), and [`datadrivencv`](https://github.com/nstrayer/datadrivencv) packages. To ensure reproducibility, the [`renv`](https://rstudio.github.io/renv/) package was used to manage and restore the R environment.

After installing all the dependencies mentioned above, follow these steps to reproduce the results:

1. **Clone** this repository to your local machine.
2. **Open** the project in your preferred [IDE](https://en.wikipedia.org/wiki/Integrated_development_environment).
3. **Restore the R environment** by running [`renv::restore()`](https://rstudio.github.io/renv/reference/restore.html) in the R console. This will install all required software dependencies.
4. **Open** [`index.Rmd`](index.Rmd) and run the code as described in the document.

## Rendering

The rendering process uses [`rmarkdown`](https://rmarkdown.rstudio.com/) along with scripts that can be found at [`render.R`](R/render.R). Make sure you meet all the requirements listed in the [Usage](#usage) section before moving on.

By running the [`render.R`](R/render.R) script, you will initiate the rendering process for both the HTML and PDF versions of the CV. Once completed, the rendered files will be available in the [`docs`](docs) folder.

## Data

The data used to populate this CV are stored in a public [Google Sheet](https://docs.google.com/spreadsheets/) and can be accessed [here](https://docs.google.com/spreadsheets/d/1Cp-ebP86AXGIIpuGiFnTpquweFzMsH9M8QDIUQfZQEU/edit?usp=sharing).

## License

[![License: GPLv3](https://img.shields.io/badge/license-GPLv3-bd0000.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![License: CC BY-NC-SA 4.0](https://img.shields.io/badge/license-CC_BY--NC--SA_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-sa/4.0/)

The code in this repository is licensed under the [GNU General Public License Version 3](https://www.gnu.org/licenses/gpl-3.0), while the document is available under the [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International](https://creativecommons.org/licenses/by-nc-sa/4.0/) license.

```
Copyright (C) 2026 Daniel Vartanian

The code in this repository is free software: you can redistribute it and/or
modify it under the terms of the GNU General Public License as published by the
Free Software Foundation, either version 3 of the License, or (at your option)
any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program. If not, see <https://www.gnu.org/licenses/>.
```
