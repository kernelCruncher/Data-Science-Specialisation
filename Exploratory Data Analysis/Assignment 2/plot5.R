library(ggplot2)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

bMotor <- subset(NEI, NEI$fips == "24510" & NEI$type == "ON-ROAD")
bMotorAGG <- aggregate(Emissions ~ year, bMotor, sum)

ggplot(bMotorAGG, aes(year, Emissions)) +
  geom_line() +
  geom_point() +
 labs(title ="Baltimore Motor Vehicle Emissions by Year", x="Year", y="Motor Vehicle Emissions")

dev.copy(png,"plot5.png", width=480, height=480)
dev.off()