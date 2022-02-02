## EMISSIONS

## Across the US, how have emissions from coal combustion-related sources 
## changed from 1999 to 2008?

## fips: 5 digit number indicating county
## SCC: name of source as indicated by digit string in source code class table
## Pollutant: string indicating pollutant
## Emission: Amt of PM2.5 emitted, in tons
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


library(ggplot2)


## Find coal related data
coal_scc <- grepl("[Cc]oal", SCC$EI.Sector)
coal_scc <- SCC[coal_scc, ]
coal_nei <- NEI[(NEI$SCC %in% coal_scc$SCC), ]
coal_agg <- aggregate(Emissions ~ year, coal_nei, sum)


png("plot4.png", width = 480, height = 480, bg = NA)


ggplot(data = coal_agg, aes(x = year, y = Emissions)) +
  geom_bar(stat = "identity", fill = "midnightblue") +
  labs(title = "Total US Emissions for Coal Combustions",
       # subtitle = "By Type",
       x = "Year",
       y = "Total Emissions")


dev.off()
