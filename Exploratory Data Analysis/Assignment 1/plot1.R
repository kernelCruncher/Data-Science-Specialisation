library(dplyr)
data<-read.table("household_power_consumption.txt", header = TRUE, sep = ";", colClasses = c('character','character','numeric','numeric','numeric','numeric','numeric','numeric','numeric'), na.strings = "?")
data<-mutate(data, DateTime = paste(Date, Time))
data <- select(data, -(1:2))

data$DateTime <- strptime(data$DateTime, "%d/%m/%Y %H:%M:%S")
data$DateTime <-as.POSIXct(data$DateTime)
data <- filter(data, DateTime >= as.POSIXct("2007-2-1") & DateTime < as.POSIXct("2007-2-3"))

hist(data$Global_active_power,main="Global Active Power", xlab = "Global Active Power (kilowatts)", col="red")

dev.copy(png,"plot1.png", width=480, height=480)
dev.off()