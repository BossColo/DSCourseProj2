## Load library to process data
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
NEI <- readRDS('summarySCC_PM25.rds')

## Extract just Baltimore City data
BaltCity <- subset(NEI, fips == '24510', c('Emissions', 'year', 'type'))

## Merge datasets preserving useful information, then arrange data into form usable for assignment
d0 <- aggregate(Emissions ~ year + type, BaltCity, sum)

## Plot the data, facet by Data.Category, and set labels.
print(qplot(year, Emissions, data=d0, col=type, geom='line',
      main='Total PM2.5 emissions in Baltimore City, Maryland\nby year and data category', ylab='Total emissions (tons)', xlab='Year'))

## Close the graphics device and write the file.
ggsave('plot3.png')