## Load library to process data
require(dtplyr)
require(ggplot2)

## Set local filename for dataset
filename <- 'PM25.zip'

## Download and unzip the dataset
if (!file.exists(filename)){
  fileURL <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip'
  download.file(fileURL, filename)
}  
if (!file.exists('summarySCC_PM25.rds') | !file.exists('Source_Classification_Code.rds')) { 
  unzip(filename) 
}

## Read in data
if(!exists('NEI')) NEI <- tbl_dt(readRDS('summarySCC_PM25.rds'))
if(!exists('SCC')) SCC <- tbl_dt(readRDS('Source_Classification_Code.rds'))

## Extract just Baltimore City data
d0 <- subset(NEI, fips %in% c('24510', '06037'), c('fips', 'SCC', 'Emissions', 'year'))
d0$fips <- factor(d0$fips, labels=c('Los Angeles County, CA', 'Baltimore City, MD'))

## Merge datasets preserving useful information, then arrange data into form usable for assignment
d0 <- merge(d0, SCC[, c('SCC', 'SCC.Level.Two')], by='SCC')
d0 <- subset(d0, grepl(".*Vehicle.*", SCC.Level.Two))[, list(total=sum(Emissions)), by=list(year, fips)]

## Plot the data, facet by Data.Category, and set labels.
print(qplot(year, total, data=d0, facets=~fips, geom='line',
            main='Total PM2.5 emissions in Los Angeles County, CA vs. Baltimore City, MD\nproduced by motor vehicle sources',
            ylab='Total emissions (tons)', xlab='Year'))

## Write the file.
ggsave('plot6.png', width = 8, height = 5)