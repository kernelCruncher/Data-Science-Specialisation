NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

balti <- subset(NEI, fips=="24510")
aggTotals <- aggregate(Emissions ~ year, balti,sum)
aggTotals$year<- as.factor(aggTotals$year)

with(aggTotals, plot(
  year,
  Emissions,
  xlab="Year",
  ylab="PM2.5 Emissions",
  main="Total PM2.5 Emissions For Balitmore City"
))

dev.copy(png,"plot2.png", width=480, height=480)
dev.off()