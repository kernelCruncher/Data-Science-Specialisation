df<-read.csv("activity.csv")

df$date<-as.Date(df$date)
agg<-aggregate(steps~date, data = df, sum, na.rm = TRUE)
hist(agg$steps, xlab = "Total Number of Steps Taken Each day", ylab = "Frequency")

mean(agg$steps)
median(agg$steps)

meanagg<- tapply(df$steps, df$interval, mean, na.rm = TRUE)
plot(meanagg~names(meanagg), type = "l", xlab= "5 minute interval", ylab = "Average number of steps taken")

names(which.max(meanagg))

sum(!complete.cases(df))

MedianSteps <- aggregate(steps ~ interval, data = df, median)
NaGone <- numeric()
for (i in 1:nrow(df)) {
  obs <- df[i, ]
  if (is.na(obs$steps)) {
    steps <- subset(MedianSteps, interval == obs$interval)$steps
  } else {
    steps <- obs$steps
  }
  NaGone <- c(NaGone, steps)
}

activity2 <- df
activity2$steps <- NaGone

activity2$date<-as.Date(df$date)
agg2<-aggregate(steps~date, data = activity2, sum)
hist(agg2$steps, xlab = "Total Number of Steps Taken Each day (NA Filled in)", ylab = "Frequency")

mean(agg2$steps)
median(agg2$steps)

#Mean and median affected.

weekend <- c("Saturday", "Sunday")
daytype <- weekdays(activity2$date)
wdaytype<-vector(mode = "character")
for (i in 1:length(daytype)){
  if (daytype[i] %in% weekend){
    wdaytype <-c(wdaytype, "weekend")}
  else {wdaytype <- c(wdaytype, "weekday")}}
activity2$wdayType <- as.factor(wdaytype)

library(ggplot2)
activity2agg <- aggregate(steps~interval+wdaytype, data = activity2, FUN = mean)
qplot(x = interval, y = steps, geom = "line", data = activity2agg, facets=.~ wdaytype, xlab = "5 Minute Interval", ylab = "Average Number of Steps")

