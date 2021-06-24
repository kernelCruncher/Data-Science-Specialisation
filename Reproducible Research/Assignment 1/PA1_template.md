---
output: 
  html_document:
    keep_md: TRUE

---


# Week 2 Assignment


### Loading and preprocessing the data

We load and process the data by the following:

```r
df<-read.csv("activity.csv")
df$date<-as.Date(df$date)
```

### What is mean total number of steps taken per day?
We calculate the total number of steps taken per day and represent it as a histogram:

```r
agg<-aggregate(steps~date, data = df, sum, na.rm = TRUE)
hist(agg$steps, xlab = "Total Number of Steps Taken Each Day", ylab = "Frequency", main = "")
```

![](PA1_template_files/figure-html/unnamed-chunk-2-1.png)<!-- -->

The mean and median number of steps per day are:

```r
mean(agg$steps)
```

```
## [1] 10766.19
```

```r
median(agg$steps)
```

```
## [1] 10765
```

### What is the average daily activity pattern?

Consider the following time series plot of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)


```r
meanagg<- tapply(df$steps, df$interval, mean, na.rm = TRUE)
plot(meanagg~names(meanagg), type = "l", xlab= "5 minute interval", ylab = "Average number of steps taken")
```

![](PA1_template_files/figure-html/unnamed-chunk-4-1.png)<!-- -->

The 5-minute interval, on average across all the days in the dataset, that contains the maximum number of steps is

```r
names(which.max(meanagg))
```

```
## [1] "835"
```
### Imputing missing values

The total number of missing values in the dataset is

```r
sum(!complete.cases(df))
```

```
## [1] 2304
```

Consider this strategy for filling in all of the missing values in the dataset and creating a new dataset with this in:

```r
MedianSteps <- aggregate(steps ~ interval, data = df, median)
NaGone <- numeric()
for (i in 1:nrow(df)) {
  dfRow <- df[i, ]
  if (is.na(dfRow$steps)) {
    steps <- subset(MedianSteps, interval == dfRow$interval)$steps
  } else {
    steps <- dfRow$steps
  }
  NaGone <- c(NaGone, steps)
}

activity2 <- df
activity2$steps <- NaGone
```
We now make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day.

```r
agg2<-aggregate(steps~date, data = activity2, sum)
hist(agg2$steps, xlab = "Total Number of Steps Taken Each day (NA Filled in)", ylab = "Frequency", main = "")
```

![](PA1_template_files/figure-html/unnamed-chunk-8-1.png)<!-- -->

```r
mean(agg2$steps)
```

```
## [1] 9503.869
```

```r
median(agg2$steps)
```

```
## [1] 10395
```
Clearly the mean and median are affected. They are now both lower.

### Are there differences in activity patterns between weekdays and weekends?
We create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.

```r
weekend <- c("Saturday", "Sunday")
daytype <- weekdays(activity2$date)
wdaytype<-vector(mode = "character")
for (i in 1:length(daytype)){
  if (daytype[i] %in% weekend){
    wdaytype <-c(wdaytype, "weekend")}
  else {wdaytype <- c(wdaytype, "weekday")}}
activity2$wdayType <- as.factor(wdaytype)
```

We make a panel plot containing a time series plot of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis)

```r
library(ggplot2)
```

```
## Warning: package 'ggplot2' was built under R version 3.5.1
```

```r
activity2agg <- aggregate(steps~interval+wdaytype, data = activity2, FUN = mean)
qplot(x = interval, y = steps, geom = "line", data = activity2agg, facets=.~ wdaytype, xlab = "5 Minute Interval", ylab = "Average Number of Steps")
```

![](PA1_template_files/figure-html/unnamed-chunk-10-1.png)<!-- -->
