## EMISSIONS

## Of the 4 types, which 4 have seen decreases in emissions from 99-08 in  
## Baltimore City? 

## Use ggplot2

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


library(ggplot2)


baltimore <- subset(NEI, fips == "24510")
summary(baltimore)
by_type <- aggregate(Emissions ~ year + type, baltimore, sum)

## Create a Scatterplot to see the change in distribution over the years
png("plot3.png", width = 480, height = 480, bg = NA)
ggplot(data = baltimore, aes(x = year, y = Emissions, color = factor(type))) +
    geom_point(alpha = 1/3) +
    facet_wrap(~type) +
    labs(title = "Emissions in Baltimore City Per Year",
         subtitle = "By Type",
         x = "Year",
         y = "Total Emissions") +
    scale_color_discrete("Type")


dev.off()
