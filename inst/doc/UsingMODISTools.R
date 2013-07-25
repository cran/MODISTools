### R code from vignette source 'UsingMODISTools.Rnw'
### Encoding: UTF-8

###################################################
### code chunk number 1: UsingMODISTools.Rnw:25-36
###################################################
library(MODISTools)

# Makes copy-paste much less painful
options(continue = ' ')
options(width = 90)
options(prompt = '> ')

options(SweaveHooks = list(fig=function() par(mgp=c(2.5,1,0), 
                                              mar=c(4,4,2,1),
                                              oma=c(0,0,1,0),
                                              cex.main=0.8)))


###################################################
### code chunk number 2: UsingMODISTools.Rnw:46-48
###################################################
data(ConvertExample)
ConvertExample


###################################################
### code chunk number 3: UsingMODISTools.Rnw:51-55
###################################################
modis.subset <- 
  ConvertToDD(XY = ConvertExample, LatColName = "lat", LongColName = "long")
modis.subset <- data.frame(lat = modis.subset[ ,1], long = modis.subset[ ,2])
modis.subset


###################################################
### code chunk number 4: UsingMODISTools.Rnw:58-60
###################################################
modis.subset$start.date <- rep(2003, nrow(modis.subset))
modis.subset$end.date <- rep(2006, nrow(modis.subset))


###################################################
### code chunk number 5: UsingMODISTools.Rnw:67-69
###################################################
GetProducts()
GetBands(Product = "MOD13Q1")


###################################################
### code chunk number 6: UsingMODISTools.Rnw:74-78
###################################################
dates <- 
  GetDates(Product = "MOD13Q1", Lat = modis.subset$lat[1], Long = modis.subset$long[1])
min(dates)
max(dates)


###################################################
### code chunk number 7: UsingMODISTools.Rnw:84-87 (eval = FALSE)
###################################################
## MODISSubsets(LoadDat = modis.subset, Product = "MOD13Q1", 
##              Bands = c("250m_16_days_EVI", "250m_16_days_pixel_reliability"), 
##              Size = c(1,1))


###################################################
### code chunk number 8: UsingMODISTools.Rnw:92-95 (eval = FALSE)
###################################################
## subset.string <- read.csv(paste(list.files(pattern=".asc")[1], 
##                                 header=FALSE, as.is=TRUE))
## subset.string[1, ]


###################################################
### code chunk number 9: UsingMODISTools.Rnw:97-101
###################################################
subset.string <- read.csv(paste("./MODISSubsetsMOD13Q1/", 
                                list.files(path = "./MODISSubsetsMOD13Q1", pattern = ".asc")[1]
                                , sep = ""), header = FALSE, as.is = TRUE)
subset.string[1, ]


###################################################
### code chunk number 10: UsingMODISTools.Rnw:107-116 (eval = FALSE)
###################################################
## names(modis.subset) <- c("start.lat", "start.long", "start.date", "end.date")
## EndCoordinates(LoadDat = modis.subset, Distance = 1000, Angle = 60, 
##                AngleUnits = "degrees")
## 
## modis.transect <- read.csv(list.files(pattern = "Transect Coordinates"))
## 
## MODISTransects(LoadData = modis.transect, Product = "MOD13Q1",     
##     Bands = c("250m_16_days_EVI", "250m_16_days_pixel_reliability"), 
##     Size = c(0,0), StartDate = TRUE)


###################################################
### code chunk number 11: UsingMODISTools.Rnw:122-126 (eval = FALSE)
###################################################
## MODISSummaries(LoadDat = modis.subset, Product = "MOD13Q1", Band = "250m_16_days_EVI", 
##                ValidRange = c(-2000,10000), NoDataFill = -3000, ScaleFactor = 0.0001, 
##                QualityScreen = TRUE, QualityBand = "250m_16_days_pixel_reliability", 
##                QualityThreshold = 0)


###################################################
### code chunk number 12: UsingMODISTools.Rnw:132-134 (eval = FALSE)
###################################################
## TileExample <- read.csv(list.files(pattern = "MODIS Data"))
## TileExample <- TileExample[ ,which(grepl("band.pixels", names(TileExample)))]


###################################################
### code chunk number 13: UsingMODISTools.Rnw:136-140
###################################################
TileExample <- read.csv(paste("./MODISSummaries/", 
                              list.files(path = "./MODISSummaries/", 
                                         pattern = "Data"), sep = ""))
TileExample <- TileExample[ ,which(grepl("band.pixels", names(TileExample)))]


###################################################
### code chunk number 14: UsingMODISTools.Rnw:143-147
###################################################
dim(TileExample)
dim(ExtractTile(Data = TileExample, Rows = c(9,2), Cols = c(9,2), Grid = FALSE))
head(ExtractTile(Data = TileExample, Rows = c(9,2), Cols = c(9,2), Grid = FALSE), 
     n = 2)


###################################################
### code chunk number 15: UsingMODISTools.Rnw:150-152
###################################################
matrix(TileExample[1, ], nrow = 9, ncol = 9, byrow = TRUE)
ExtractTile(Data = TileExample, Rows = c(9,2), Cols = c(9,2), Grid = TRUE)[ , ,1]


###################################################
### code chunk number 16: UsingMODISTools.Rnw:158-160 (eval = FALSE)
###################################################
## MODISSubsets(LoadDat = modis.subset, Product = "MCD12Q1", Bands = "Land_Cover_Type_1", 
##              Size = c(1,1))


###################################################
### code chunk number 17: UsingMODISTools.Rnw:163-167 (eval = FALSE)
###################################################
## LandCover(Band = "Land_Cover_Type_1")
## 
## land.summary <- read.csv(list.files(pattern = "MODIS Land Cover Summary"))
## head(land.summary)


###################################################
### code chunk number 18: UsingMODISTools.Rnw:169-174
###################################################
land.summary <- read.csv(paste("./LandCover/",
                               list.files(path = "./LandCover/",
                                          pattern = "LandCoverSummary"),
                               sep = ""))
head(land.summary)


