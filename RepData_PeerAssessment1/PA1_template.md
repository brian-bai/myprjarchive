# Reproducible Research: Peer Assessment 1


## Loading and preprocessing the data

*Load the data*

```r
rawdata<-read.csv("activity.csv")
```


*Process the data*

```r
rawdata$date<-as.Date(rawdata$date)
```


## What is mean total number of steps taken per day?


```r
library(reshape2)
meltdata <- melt(rawdata, id.vars=c("date"), measure.vars=c("steps"))
steps <- dcast(meltdata, date ~ variable, sum, na.rm=TRUE)
hist(steps$steps,breaks=10,xlab="Steps per day", main="Histogram of steps per day")
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3.png) 

The mean of total namer of steps taken per day:

```r
mean(steps$steps,na.rm=TRUE)
```

```
## [1] 9354
```

The median of total namer of steps taken per day:

```r
median(steps$steps,na.rm=TRUE)
```

```
## [1] 10395
```


## What is the average daily activity pattern?
Time series of average steps on 5 minutes interval:

```r
meltdata <- melt(rawdata, id.vars=c("interval"), measure.vars=c("steps"))
steps <- dcast(meltdata, interval ~ variable, mean, na.rm=TRUE)
plot(steps$interval,steps$steps,type="l", xlab="5 minutes Interval",ylab="average steps")
```

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6.png) 

Maximum steps and it's interval:

```r
steps[steps$steps==max(steps$steps),]
```

```
##     interval steps
## 104      835 206.2
```

## Imputing missing values

*Total number of missing values*

```r
nrow(rawdata[is.na(rawdata$steps),])
```

```
## [1] 2304
```

*Filling in all of th emissing values by the mean for that interval*

```r
mdata<-merge(rawdata,steps,by="interval")
mdataNA<-mdata[is.na(mdata$steps.x),]
mdataNA$steps.x<-mdataNA$steps.y
newmdata<-rbind(mdataNA,mdata[!is.na(mdata$steps.x),])
```

*Create a new dataset that is equal to the original dataset but with the missing data filed in*

```r
newmdata<-newmdata[,1:3]
names(newmdata)<-c("interval","steps","date")
```

*Make a histogram of the total number of steps taken each day*

```r
meltdata <- melt(newmdata, id.vars=c("date"), measure.vars=c("steps"))
newsteps <- dcast(meltdata, date ~ variable, sum)
hist(newsteps$steps,breaks=10,xlab="Steps per day", main="Histogram of steps per day(Filled missing value)")
```

![plot of chunk unnamed-chunk-11](figure/unnamed-chunk-11.png) 

**mean**

```r
mean(newsteps$steps)
```

```
## [1] 10766
```

**median**

```r
median(newsteps$steps)
```

```
## [1] 10766
```

*Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?*

Both the mean and median are increased by imputting the missing data.


## Are there differences in activity patterns between weekdays and weekends?

```r
newmdata$weekday<-weekdays(newmdata$date)
myfun<-function(x){
  if(x=="Sunday" | x=="Saturday" ){
    x<-"weekend"
  }else{
    x<-"weekday"
  }
  x
}
wl<-lapply(newmdata$weekday,myfun)
newmdata$weekday<-wl
newmdata$weekday<-factor(newmdata$weekday,levels=c("weekday","weekend"))

weekdaydata<-newmdata[newmdata$weekday=="weekday",]
weekenddata<-newmdata[newmdata$weekday=="weekend",]
meltdata <- melt(weekdaydata, id.vars=c("interval","weekday"), measure.vars=c("steps"))
weekdaysteps <- dcast(meltdata, interval+weekday ~ variable, mean)
meltdata <- melt(weekenddata, id.vars=c("interval","weekday"), measure.vars=c("steps"))
weekendsteps <- dcast(meltdata, interval+weekday ~ variable, mean)
alldata<-rbind(weekdaysteps,weekendsteps)
library(lattice)
xyplot(alldata$steps ~ alldata$interval | alldata$weekday,type="l",xlab="interval",ylab="steps",layout = c(1, 2))
```

![plot of chunk unnamed-chunk-14](figure/unnamed-chunk-14.png) 


