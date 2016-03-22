#read all data
epc<-read.csv("household_power_consumption.txt",sep=';',na.strings="?",colClasses=c("character","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric"))
#subset to get targetdata
tepc<-epc[epc$Date=='1/2/2007'|epc$Date=='2/2/2007',]

png(file="plot1.png",width = 480, height = 480, units = "px", pointsize = 12,bg="white")
hist(tepc$Global_active_power,xlab="Global Active Power (kilowatts)",main="Global Active Power",col="red")
dev.off()