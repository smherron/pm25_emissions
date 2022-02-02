## EMISSIONS

## Have total emissions from PM2.5 decreased in the United States from 
## 1999 to 2008? 

## Using the base plotting system, make a plot showing the total PM2.5 emission 
## from all sources for each of the years 1999, 2002, 2005, and 2008.

## fips: 5 digit number indicating county
## SCC: name of source as indicated by digit string in source code class table
## Pollutant: string indicating pollutant
## Emission: Amt of PM2.5 emitited, in tons
## type: type of source (point, non-point, on-road, non-road)
## year: year emissions recorded

file_name <- "emissions.zip"
if(!file.exists(file_name)) {
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(url, file_name, method = "curl")
}

if (!file.exists("summarySCC_PM25.rds")) {
  unzip(file_name)
}

if (!file.exists("Source_Classification_Code.rds")) {
  unzip(file_name)
}

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")



by_year <- aggregate(Emissions ~ year, NEI, sum)


png("plot1.png", width = 480, height = 480, bg = NA)
par(mar = c(5, 5, 3, 1))
with(by_year,
     barplot(height = (Emissions/10^6), names.arg = year,
             xlab = "Year",
             ylab = "Total PM2.5 Emissions (by 10^6 tons)",
             main = "Annual PM2.5 Totals",
             col = c("red", "orange", "yellow", "green")
     )
)
dev.off()
