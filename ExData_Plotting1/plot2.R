#read all data
epc<-read.csv("household_power_consumption.txt",sep=';',na.strings="?",colClasses=c("character","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric"))
#subset to get targetdata
tepc<-epc[epc$Date=='1/2/2007'|epc$Date=='2/2/2007',]
tepc$DateTime<-paste(tepc$Date,tepc$Time)
tepc$DateTime<-strptime(tepc$DateTime, "%d/%m/%Y %H:%M:%S")

png(file="plot2.png",width = 480, height = 480, units = "px", pointsize = 12,bg="white")
plot(tepc$DateTime,tepc$Global_active_power,type="l",xlab=NULL,ylab="Global Active Power (kilowatts)")
dev.off()