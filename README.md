
<!-- README.md is generated from README.Rmd. Please edit that file -->

``` r
# make readme
rmarkdown::render("README.Rmd", output_format = "github_document", output_file = "README.md") 
```

# madrid-santiago-2019

<!-- badges: start -->

<!-- badges: end -->

This repo hosts a photobook. Some of the stages of the development of
the book are documented here.

The first stage was to create a template repository. I did this using
RStudio’s GUI, and selecting the bookdown template when creating a new
project (I’m not sure how to do that from the command line).

Next, the index file was generated as follows:

``` r
index = photomapr::photobook_index(
  photobook_name = "From Madrid to Santiago de Compostela, 2019",
  photobook_author = "Robin and Katy",
  photobook_repo = "katyrobin/madrid-santiago-2019",
  photobook_description = "Photobook of our trip from Madrid to Santiago via Salamanca, Ourense and the Camino de Compostela."
)
writeLines(index, "index.Rmd")
```
