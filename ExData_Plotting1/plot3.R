library("reshape2")
#read all data
epc<-read.csv("household_power_consumption.txt",sep=';',na.strings="?",colClasses=c("character","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric"))
#subset to get targetdata
tepc<-epc[epc$Date=='1/2/2007'|epc$Date=='2/2/2007',]
tepc$DateTime<-paste(tepc$Date,tepc$Time)
tepc$DateTime<-strptime(tepc$DateTime, "%d/%m/%Y %H:%M:%S")

getGroupData<-function(name){
  group<-cbind(tepc$DateTime, tepc[name])
  group$group<-name
  names(group)<-c("DateTime","energy","submetering")
  group
}

#TODO: try lapply?
group1<-getGroupData("Sub_metering_1")
group2<-getGroupData("Sub_metering_2")
group3<-getGroupData("Sub_metering_3")

group<-rbind(group1,group2,group3)

png(file="plot3.png",width = 480, height = 480, units = "px", pointsize = 12,bg="white")
plot(group$DateTime,group$energy,xlab="",ylab="Energy sub metering",type="n")
points(tepc$DateTime,tepc$Sub_metering_1,type='l')
points(tepc$DateTime,tepc$Sub_metering_2,type='l',col="red")
points(tepc$DateTime,tepc$Sub_metering_3,type='l',col="blue")
legend("topright",  lty=1, col = c("black", "red","blue"), legend = c("Sub metering 1","Sub metering 2","Sub metering 3"))

dev.off()