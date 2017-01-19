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

## Extract just Baltimore City and Los Angeles County data
d0 <- subset(NEI, fips %in% c("24510", "06037"), c("fips", "SCC", 
  "Emissions", "year"))

## Recode fips to location name
d0$fips[d0$fips == "24510"] <- "Baltimore City, MD"
d0$fips[d0$fips == "06037"] <- "Los Angeles County, CA"

## Merge datasets preserving useful information, then arrange
## data into form usable for assignment
d0 <- merge(d0, SCC[, c("SCC", "SCC.Level.Two")], by = "SCC")
d0 <- subset(d0, grepl(".*Vehicle.*", SCC.Level.Two))[, list(total = sum(Emissions)), 
  by = list(year, fips)]

## Plot the data, facet by Data.Category, and set labels.
print(qplot(year, total, data = d0, facets = ~fips, geom = "line", 
  main = "Total PM2.5 emissions in Baltimore City, MD vs. Los Angeles County, CA\nproduced by motor vehicle sources", 
  ylab = "Total emissions (tons)", xlab = "Year"))

## Write the file.
ggsave("plot6.png", width = 8, height = 5)