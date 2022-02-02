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


## Find data that belongs to vehicles then subset for Balitmore City and LA
vehicles <- grepl("vehicle", SCC[ , "SCC.Level.Two"], ignore.case = TRUE)
vehicles_SCC <- SCC[vehicles, ]$SCC
vehicles_nei <- NEI[NEI$SCC %in% vehicles_SCC, ]
summary(vehicles_nei)
baltimore_vehicles <- subset(vehicles_nei, fips == "24510")
la_vehicles <- subset(vehicles_nei, fips == "06037")
baltimore_la <- rbind(baltimore_vehicles, la_vehicles)
baltimore_la_agg <- aggregate(Emissions ~ year + fips, baltimore_la, sum)



png("plot6.png", width = 480, height = 480, bg = NA)


ggplot(data = baltimore_la_agg, aes(x = year, y = Emissions)) +
  geom_bar(aes(fill = fips), stat = "identity") +
  facet_wrap(~fips) +
  labs(title = "Emissions for Vehicles in Baltimore City vs. LA County",
       # subtitle = "By Type",
       x = "Year",
       y = "Total Emissions") +
  scale_fill_discrete(name = "County", labels = c("LA County", "Baltimore City"))


dev.off()
