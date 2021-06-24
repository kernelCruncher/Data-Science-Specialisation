library(ggplot2)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

blMotors <- subset(NEI, fips %in% c("24510","06037") & type == "ON-ROAD")
blMotorsAGG <- aggregate(Emissions ~ year + fips, blMotors, sum)

ggplot(blMotorsAGG, aes(year, Emissions, col = fips)) +
  geom_line() +
  geom_point() +
  labs(title = "Baltimore and Los Angeles Motor Vehicle Emissions by Year", x = "Year", y = "Motor Vehicle Emissions")+
  scale_colour_discrete(name = "City", labels = c("Los Angeles", "Baltimore"))
  
dev.copy(png,"plot6.png", width=480, height=480)
dev.off()