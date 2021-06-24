library(ggplot2)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

balti <- subset(NEI, fips=="24510")
aggTotals <- aggregate(Emissions ~ year + type, balti,sum)
aggTotals$type <-as.factor(aggTotals$type)
  
ggplot(aggTotals, aes(year, Emissions, col = type)) +
  geom_line()+
  geom_point()+
  labs( title = "Total Baltimore Emissions", y= "Total Baltimore Emissions", x = "Year") 
  
dev.copy(png,"plot3.png", width=480, height=480)
dev.off()