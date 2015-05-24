
## Get data from Activity Labels and Feature text files into respective variables.
fLabels <- read.table("features.txt", col.names = c("FeatureNum","FeatureName"))
aLabels <- read.table("activity_labels.txt", col.names=c("Label","ActivityName"))

## Test sets from respective files.
tRaw <- read.table("test/X_test.txt",col.names = fLabels$FeatureName)
tstLabels <- read.table("test/y_test.txt",col.names = c("Label"))
tstSubject <- read.table("test/subject_test.txt",col.names=c("Subject"))

## Training the data set
trnRaw <- read.table("train/X_train.txt",col.names = fLabels$FeatureName)
trnLabels <- read.table("train/y_train.txt",col.names = c("Label"))
trnSubject <- read.table("train/subject_train.txt",col.names=c("Subject"))

## Build Data set from Raw data and Labels
tstData <- cbind(tstSubject,tstLabels,tRaw)
trnData <- cbind(trnSubject,trnLabels,trnRaw)
ttlData <- merge(aLabels,rbind(tstData,trnData),by="Label")

## Figure out which columns to use and filter them out
ttlCol <- colnames(ttlData)
colsToUse <- ttlCol=="Subject" | ttlCol=="ActivityName" | grepl("mean",ttlCol) | grepl("std",ttlCol)
tidyData <- ttlData[,c(seq_len(length(ttlCol))[colsToUse])]
tidyData$Subject <- as.factor(tidyData$Subject)
tidyData$ActivityName <- as.factor(tidyData$ActivityName)

## Get averages for the mean and std columns from tidyData
statData <- aggregate(.~Subject+ActivityName,data=tidyData,mean)
