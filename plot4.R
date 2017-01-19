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
NEI <- data.table(readRDS('summarySCC_PM25.rds'))
SCC <- data.table(readRDS('Source_Classification_Code.rds'))

## Merge datasets preserving useful information, then arrange data into form usable for assignment
d0 <- merge(NEI[, c('SCC', 'Emissions', 'year')], SCC[, c('SCC', 'EI.Sector')], by='SCC')
d0 <- subset(d0, grepl(".*Coal", EI.Sector))[, list(total=sum(Emissions)), by=year]

## Plot the data, facet by Data.Category, and set labels.
print(qplot(year, total, data=d0, geom='line',
            main='Total PM2.5 emissions Country-wide\nproduced by coal combustion-related sources', ylab='Total emissions (tons)', xlab='Year'))

## Write the file.
ggsave('plot4.png')