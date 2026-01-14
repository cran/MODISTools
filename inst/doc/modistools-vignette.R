## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  error = TRUE,
  collapse = TRUE,
  comment = "#>"
)

# load the library
library(MODISTools)
library(terra)
library(ggplot2)
library(dplyr)
library(sf)

# pre-load data
data("arcachon_lai")
data("arcachon_lc")


## ----eval = TRUE--------------------------------------------------------------
products <- mt_products()
head(products)

## ----eval = TRUE--------------------------------------------------------------
bands <- mt_bands(product = "MOD13Q1")
head(bands)

## ----eval = TRUE--------------------------------------------------------------
dates <- mt_dates(product = "MOD13Q1", lat = 42, lon = -110)
head(dates)

## ----eval = FALSE-------------------------------------------------------------
# # download the MODIS land cover (IGBP) and NDVI data
# # for a region around the French city and basin of Arcachon
# arcachon_lai <- mt_subset(product = "MOD15A2H",
#                     lat = 44.656286,
#                     lon =  -1.174748,
#                     band = "Lai_500m",
#                     start = "2004-01-01",
#                     end = "2004-12-30",
#                     km_lr = 20,
#                     km_ab = 20,
#                     site_name = "arcachon",
#                     internal = TRUE,
#                     progress = FALSE
#                     )
# 
# arcachon_lc <- mt_subset(
#   product = "MCD12Q1",
#   lat = 44.656286,
#   lon =  -1.174748,
#   band = "LC_Type1",
#   start = "2004-01-01",
#   end = "2004-3-20",
#   km_lr = 20,
#   km_ab = 20,
#   site_name = "arcachon",
#   internal = TRUE,
#   progress = FALSE
#   )

## -----------------------------------------------------------------------------
head(arcachon_lai)
head(arcachon_lc)

## ----eval = TRUE--------------------------------------------------------------
# create data frame with a site_name, lat and lon column
# holding the respective names of sites and their location
df <- data.frame("site_name" = paste("test",1:2), stringsAsFactors = FALSE)
df$lat <- 40
df$lon <- -110

# an example batch download data frame
head(df)

## ----eval = FALSE-------------------------------------------------------------
# # test batch download
# subsets <- mt_batch_subset(df = df,
#                      product = "MOD13Q1",
#                      band = "250m_16_days_NDVI",
#                      km_lr = 1,
#                      km_ab = 1,
#                      start = "2004-01-01",
#                      end = "2004-12-30",
#                      internal = TRUE)

## -----------------------------------------------------------------------------
# merge land cover and lai data
arcachon <- arcachon_lc %>%
  rename("lc" = "value") %>%
  select("lc","pixel") %>%
  right_join(arcachon_lai, by = "pixel")

## -----------------------------------------------------------------------------
# create a plot of the data - accounting for the multiplier (scale) component
arcachon <- arcachon %>%
  filter(value <= 100,
         lc %in% c("1","5")) %>% # retain everything but fill values
  mutate(lc = ifelse(lc == 1, "ENF","DBF")) %>%
  group_by(lc, calendar_date) %>% # group by lc and date
  summarize(doy = as.numeric(format(as.Date(calendar_date)[1],"%j")),
            lai_mean = median(value * as.double(scale)))

## ----fig.width = 7, fig.height=3----------------------------------------------
# plot LAI by date and per land cover class
ggplot(arcachon, aes(x = doy, y = lai_mean)) +
  geom_point() +
  geom_smooth(span = 0.3, method = "loess") +
  labs(x = "day of year (DOY)",
       y = "leaf area index (LAI)") +
  theme_minimal() +
  facet_wrap(~ lc)

## -----------------------------------------------------------------------------
# convert the coordinates
lat_lon <- sin_to_ll(arcachon_lc$xllcorner, arcachon_lc$yllcorner)

# bind with the original dataframe
subset <- cbind(arcachon_lc, lat_lon)

head(subset)

## ----fig.width = 5, fig.height=5----------------------------------------------
# convert to bounding box
bb <- apply(arcachon_lc, 1, function(x){
  mt_bbox(xllcorner = x['xllcorner'],
          yllcorner = x['yllcorner'],
           cellsize = x['cellsize'],
           nrows = x['nrows'],
           ncols = x['ncols'])
})

# plot one bounding box
plot(bb[[1]])

# add the location of the queried coordinate within the polygon
points(arcachon_lc$longitude[1],
       arcachon_lc$latitude[1],
       pch = 20,
       col = "red")

## ----fig.width = 5, fig.height=5----------------------------------------------
# convert to raster, when reproject is TRUE
# the data is reprojected to lat / lon if FALSE
# the data is shown in its original sinuidal projection
LC_r <- mt_to_terra(df = arcachon_lc, reproject = TRUE)

# plot the raster data as a map
plot(LC_r)

