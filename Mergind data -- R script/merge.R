trainTemp <- read.csv("C://Users//romai//OneDrive//PC portable//Projet large scale data processing//data//train.csv")
features <- read.csv("C://Users//romai//OneDrive//PC portable//Projet large scale data processing//data//features.csv")
stores <- read.csv("C://Users//romai//OneDrive//PC portable//Projet large scale data processing//data//stores.csv")

stores$Type <- as.numeric(stores$Type)

#Concatenate features with store and date
trainTemp2 <- merge(trainTemp, features[-12], by.x=c("Date", "Store"), by.y=c("Date", "Store"))

#Add store size
allData <- merge(trainTemp2, stores, by.x="Store", by.y="Store")
allData[is.na(allData)] <- 0
allData[,5] <- as.numeric(allData[,5])

first_date <- as.Date(as.character(allData[1,2]), format="%Y-%m-%d")
allData$Date <- as.Date(as.character(allData$Date), format="%Y-%m-%d") - first_date

#Re order column so that weekly_sales is first column
ordered_data = allData[c(4,1,2,3,5,6,7,8,9,10,11,12,13,14,15,16)]

write.csv(ordered_data, "C://Users//romai//OneDrive//PC portable//Projet large scale data processing//data//aggregated.csv", row.names=FALSE)