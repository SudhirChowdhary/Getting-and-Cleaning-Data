
##Merges the training and the test sets to create one data set.
##Extracts only the measurements on the mean and standard deviation for each measurement.
##Uses descriptive activity names to name the activities in the data set
##Appropriately labels the data set with descriptive variable names.
##From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

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
FnlOutput <- aggregate(.~Subject+ActivityName,data=tidyData,mean)
write.table(FnlOutput,"OutPut.txt", row.name=FALSE)
