## Load library to process data
require(dtplyr)
require(ggplot2)

## Set local filename for dataset
filename <- "PM25.zip"

## Download and unzip the dataset
if (!file.exists(filename)) {
  fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(fileURL, filename)
}
if (!file.exists("summarySCC_PM25.rds") | !file.exists("Source_Classification_Code.rds")) {
  unzip(filename)
}

## Read in data
if (!exists("NEI")) NEI <- tbl_dt(readRDS("summarySCC_PM25.rds"))
if (!exists("SCC")) SCC <- tbl_dt(readRDS("Source_Classification_Code.rds"))

## Extract just Baltimore City data
BaltCity <- subset(NEI, fips == "24510", c("SCC", "Emissions", 
  "year"))

## Merge datasets preserving useful information, then arrange
## data into form usable for assignment
d0 <- merge(BaltCity, SCC[, c("SCC", "SCC.Level.Two")], by = "SCC")
d0 <- subset(d0, grepl(".*Vehicle.*", SCC.Level.Two))[, list(total = sum(Emissions)), 
  by = list(year, SCC.Level.Two)]

## Plot the data grouped only by year, and set labels.
print(qplot(year, total, data = d0[, list(total = sum(total)), 
  by = year], geom = "line", main = "Total PM2.5 emissions in Baltimore City, Maryland produced by motor vehicle sources", 
  ylab = "Total emissions (tons)", xlab = "Year"))

## Write the file.
ggsave("plot5-1.png", width = 8, height = 5)


## Plot the data, facet by Data.Category, and set labels.
print(qplot(year, total, data = d0, col = SCC.Level.Two, geom = "line", 
  main = "Total PM2.5 emissions in Baltimore City, Maryland\nproduced by motor vehicle sources, subsetted by source", 
  ylab = "Total emissions (tons)", xlab = "Year"))

## Write the file.
ggsave("plot5-2.png", width = 8, height = 5)