library(dplyr)
data<-read.table("household_power_consumption.txt", header = TRUE, sep = ";", colClasses = c('character','character','numeric','numeric','numeric','numeric','numeric','numeric','numeric'), na.strings = "?")
data<-mutate(data, DateTime = paste(Date, Time))
data <- select(data, -(1:2))

data$DateTime <- strptime(data$DateTime, "%d/%m/%Y %H:%M:%S")
data$DateTime <-as.POSIXct(data$DateTime)
data <- filter(data, DateTime >= as.POSIXct("2007-2-1") & DateTime < as.POSIXct("2007-2-3"))

plot(data$DateTime, data$Sub_metering_1, type="l", col="black", xlab="", ylab="Energy sub metering")
lines(data$DateTime, data$Sub_metering_2, col="red")
lines(data$DateTime, data$Sub_metering_3, col="blue")
legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col=c("black", "red", "blue"), lty="solid", y.intersp=0.2, cex = 0.7, ncol =1)

dev.copy(png,"plot3.png", width=480, height=480)
dev.off()