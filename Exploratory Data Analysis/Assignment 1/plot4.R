library(dplyr)
data<-read.table("household_power_consumption.txt", header = TRUE, sep = ";", colClasses = c('character','character','numeric','numeric','numeric','numeric','numeric','numeric','numeric'), na.strings = "?")
data<-mutate(data, DateTime = paste(Date, Time))
data <- select(data, -(1:2))

data$DateTime <- strptime(data$DateTime, "%d/%m/%Y %H:%M:%S")
data$DateTime <-as.POSIXct(data$DateTime)
data <- filter(data, DateTime >= as.POSIXct("2007-2-1") & DateTime < as.POSIXct("2007-2-3"))

par(mfrow=c(2,2),mar=c(4,4,2,1))
plot(Global_active_power~ DateTime, type="l", 
       ylab="Global Active Power (kilowatts)", xlab="", data = data)
  
  plot(Voltage~ DateTime, type="l", 
       ylab="Voltage (volt)", xlab="", data = data)
  
  plot(Sub_metering_1~ DateTime, type="l", 
       ylab="Global Active Power (kilowatts)", xlab="", data = data)
  lines(Sub_metering_2~ DateTime,col='Red', data = data)
  lines(Sub_metering_3~ DateTime,col='Blue', data = data)
  legend("topright", col=c("black", "red", "blue"), lty="solid",bty = "n", y.intersp=0.2, cex = 0.5, ncol =1,
         legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
  
  plot(Global_reactive_power~DateTime, type="l", 
       ylab="Global Rective Power (kilowatts)",xlab="", data = data)

dev.copy(png,"plot4.png", width=480, height=480)
dev.off()