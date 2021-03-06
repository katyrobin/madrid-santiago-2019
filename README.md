
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

To select photos to use, we looked over the photos and copy-pasted the paths into R code as follows:

``` r
library(photomapr)
f = read.csv(header = FALSE, stringsAsFactors = FALSE, text = 
"/home/robin/Pictures/2019/05/18/IMG_20190518_064058.jpg
/home/robin/Pictures/2019/05/18/IMG_20190518_152257.jpg
/home/robin/Pictures/2019/05/19/IMG_20190519_212131.jpg
/home/robin/Pictures/2019/05/20/IMG_20190520_195619.jpg
/home/robin/Pictures/2019/05/20/PANO_20190520_195852.jpg
/home/robin/Pictures/2019/05/20/IMG_20190520_201047.jpg
/home/robin/Pictures/2019/05/20/IMG_20190520_201518.jpg
/home/robin/Pictures/2019/05/21/IMG_20190521_143559.jpg
/home/robin/Pictures/2019/05/21/IMG_20190521_143559.jpg
/home/robin/Pictures/2019/05/21/IMG_20190521_153335.jpg
/home/robin/Pictures/2019/05/22/IMG_20190522_161635.jpg
/home/robin/Pictures/2019/05/22/IMG_20190522_161735.jpg
/home/robin/Pictures/2019/05/22/IMG_20190522_194521.jpg
/home/robin/Pictures/2019/05/22/IMG_20190522_203034.jpg
/home/robin/Pictures/2019/05/22/IMG_20190522_210759.jpg
/home/robin/Pictures/2019/05/23/IMG_20190523_094920.jpg
/home/robin/Pictures/2019/05/23/IMG_20190523_095634.jpg
/home/robin/Pictures/2019/05/23/IMG_20190523_102100.jpg
/home/robin/Pictures/2019/05/23/IMG_20190523_102113.jpg
/home/robin/Pictures/2019/05/23/IMG_20190523_102128.jpg
/home/robin/Pictures/2019/05/23/IMG_20190523_123302.jpg
/home/robin/Pictures/2019/05/23/IMG_20190523_130101.jpg
/home/robin/Pictures/2019/05/23/IMG_20190523_133759.jpg
/home/robin/Pictures/2019/05/23/IMG_20190523_134136.jpg
/home/robin/Pictures/2019/05/23/IMG_20190523_140106.jpg
/home/robin/Pictures/2019/05/23/IMG_20190523_141202.jpg
/home/robin/Pictures/2019/05/23/PANO_20190523_130455.jpg
/home/robin/Pictures/2019/05/23/IMG_20190523_142043.jpg
/home/robin/Pictures/2019/05/23/IMG_20190523_142359.jpg
/home/robin/Pictures/2019/05/23/IMG_20190523_175552.jpg
/home/robin/Pictures/2019/05/24/IMG_20190524_073324.jpg
/home/robin/Pictures/2019/05/24/IMG_20190524_084154.jpg
/home/robin/Pictures/2019/05/24/IMG_20190524_105818.jpg
/home/robin/Pictures/2019/05/24/IMG_20190524_111615.jpg
/home/robin/Pictures/2019/05/24/IMG_20190524_134012.jpg
/home/robin/Pictures/2019/05/24/IMG_20190524_140724.jpg
/home/robin/Pictures/2019/05/24/IMG_20190524_151938.jpg
/home/robin/Pictures/2019/05/24/IMG_20190524_185535.jpg
/home/robin/Pictures/2019/05/24/IMG_20190524_185841.jpg
/home/robin/Pictures/2019/05/24/IMG_20190524_191302.jpg
/home/robin/Pictures/2019/05/24/IMG_20190524_200740.jpg
/home/robin/Pictures/2019/05/24/IMG_20190524_200945.jpg
/home/robin/Pictures/2019/05/24/IMG_20190524_215211.jpg
/home/robin/Pictures/2019/05/25/IMG_20190525_163802.jpg")
slideshow(f$V1)
```

## Set-up

The next task was to create a template repository. The was done using
RStudio’s GUI, and selecting the bookdown template when creating a new
project (I’m not sure how to do that from the command line).

Next, the index file was generated as follows:

``` r
index = photobook_index(
  photobook_name = "From Madrid to Santiago de Compostela, 2019",
  photobook_author = "Robin and Katy",
  photobook_repo = "katyrobin/madrid-santiago-2019",
  photobook_description = "Photobook of our trip from Madrid to Santiago via Salamanca, Ourense and the Camino de Compostela."
)
writeLines(index, "index.Rmd")
```

To check that the photos made sense, they were converted into an `sf` data frame and plotted as follows:

``` r
photos_geo = photos_sf(f$V1)
plot(photos_geo)
```

## Grouping photos

Chapters are the building blocks of books.
To divide the photos into chapters, the following code was used:

``` r
photos_geo$group = photo_group(photos_geo, 5)
# test grouping function
mapview::mapview(photos_geo, zcol = "group")
```

## Adding captions

To help automate the process of adding captions, used the function `photo_add_caption()`.

``` r
photos_geo$caption = photomapr::photo_add_captions(photos_geo$SourceFile)
```

## Creating the photomap

The photobook was created with this command:

``` r
photomapr::photobook(
  photo = photos_geo,
  index = index,
  groups = photos_geo$group,
  captions = photos_geo$caption,
  dir_out = "."
  )
```

## Compressing giant photos

The photos were rather large initially (smartphones now save photos with 1000+ pixels, in one dimension!), so they were shrunk with the following code:

``` r
f = list.files(".", ".jpg")
i = f[length(f)]
for(i in f) {
  im = magick::image_read(i)
  i_smaller = magick::image_scale(image = im, geometry = magick::geometry_size_pixels(width = 800))
  magick::image_write(i_smaller, i)
}
```

That subsequently became the function `photo_compress_width()`.

## Using photos in the root directory

In hindsight, it makes sense to do image pre-processing before creating the photobook.
Imagining that we had started with all the nicely compressed photos in the root directory, we could have started (again) as follows:

``` r
f = list.files(".", ".jpg")
p = photos_sf(f)
p$group = photo_group(p, 5)
sf::write_sf(p, "p.geojson")
```
## Building the books

After editing the `index.Rmd` and chapter `.Rmd` files, the book was ready to compile.
To create the pdf version, the following command was used:

``` r
rmarkdown::render_site(output_format = 'bookdown::pdf_book', encoding = 'UTF-8')
browseURL("_book/madrid-santiago-2019.pdf")
```

