NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

aggTotals <- aggregate(Emissions ~ year, data=NEI, sum)
aggTotals$year<- as.factor(aggTotals$year)

with(aggTotals, plot(
  year,
  Emissions,
  xlab="Year",
  ylab="PM2.5 Emissions",
  main="Total Emissions For All US")
)

dev.copy(png,"plot1.png", width=480, height=480)
dev.off()