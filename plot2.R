## Load library to process data
require(dtplyr)

## Set local filename for dataset
filename <- "PM25.zip"

## Download and unzip the dataset
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(fileURL, filename)
}  
if (!file.exists("summarySCC_PM25.rds") | !file.exists("Source_Classification_Code.rds")) { 
  unzip(filename) 
}

## Read in data
if(!exists('NEI')) NEI <- tbl_dt(readRDS('summarySCC_PM25.rds'))

## Extract just Baltimore City data
BaltCity <- subset(NEI, fips == "24510", c("Emissions", "year"))

## Open png device
png(filename='plot2.png')

## Group the data by year, and calculate the totals. In the same line, plot the data, and set labels.
plot(aggregate(Emissions ~ year, BaltCity, sum), type='l', pch=20, main='Total PM2.5 emissions in Baltimore City, Maryland by year',
     ylab='Total emissions (tons)', xlab='Year')

## Close the graphics device and write the file.
dev.off()