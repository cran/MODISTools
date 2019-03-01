## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

# load the library
library(MODISTools)


## ----eval = TRUE---------------------------------------------------------
products <- mt_products()
head(products)

## ----eval = TRUE---------------------------------------------------------
bands <- mt_bands(product = "MOD13Q1")
head(bands)

## ----eval = TRUE---------------------------------------------------------
dates <- mt_dates(product = "MOD13Q1", lat = 42, lon = -110)
head(dates)

## ----eval = TRUE---------------------------------------------------------
# download data
subset <- mt_subset(product = "MOD13Q1",
                    lat = 42.534171,
                    lon = -72.179003,
                    band = "250m_16_days_NDVI",
                    start = "2004-01-01",
                    end = "2005-12-30",
                    km_lr = 0,
                    km_ab = 0,
                    site_name = "testsite",
                    internal = TRUE,
                    progress = FALSE)
head(subset)


## ----eval = TRUE---------------------------------------------------------
# create data frame with a site_name, lat and lon column
# holding the respective names of sites and their location
df <- data.frame("site_name" = paste("test",1:2), stringsAsFactors = FALSE)
df$lat <- 40
df$lon <- -110

# an example batch download data frame
print(df)

# test batch download
subsets <- mt_batch_subset(df = df,
                     product = "MOD11A2",
                     band = "LST_Day_1km",
                     internal = TRUE,
                     start = "2004-01-01",
                     end = "2004-02-28",
                     out_dir = "~")

head(subsets)

## ----fig.width = 7, fig.height=3-----------------------------------------
# create a plot of the data - accounting for the multiplier (scale) component
date <- as.Date(subset$calendar_date)
temperature <- subset$value * as.double(subset$scale)
temperature[temperature == 0] <- NA

plot(date,
     temperature,
     xlab = "Date",
     ylab = "NDVI",
     ylim = c(0,1),
     type = "l")

## ------------------------------------------------------------------------
# convert the coordinates
lat_lon <- sin_to_ll(subset$xllcorner, subset$yllcorner)

# bind with the original dataframe
subset <- cbind(subset, lat_lon)

head(subset)

## ------------------------------------------------------------------------
# convert to bounding box
bb <- apply(subset, 1, function(x){
  mt_bbox(xllcorner = x['xllcorner'],
          yllcorner = x['yllcorner'],
           cellsize = x['cellsize'],
           nrows = x['nrows'],
           ncols = x['ncols'])
})

# plot one bounding box
plot(bb[[1]])

# add the location of the queried coordinate within the polygon
points(subset$longitude[1],
       subset$latitude[1],
       pch = 20,
       col = "red")


