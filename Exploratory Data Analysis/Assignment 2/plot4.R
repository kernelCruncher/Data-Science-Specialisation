library(ggplot2)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

Scoal <- subset(SCC, grepl("coal", Short.Name, ignore.case = T))
Ncoal <- subset(NEI, SCC %in% Scoal$SCC)
totalCoal <- aggregate(Emissions ~ year + type, Ncoal, sum)

ggplot(totalCoal, aes(year, Emissions, col = type)) +
  geom_line() +
  geom_point() +
  labs(title = "Total US Coal Emission", x = "Year", y ="US Coal Emission") 

dev.copy(png,"plot4.png", width=480, height=480)
dev.off()