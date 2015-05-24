---
title: "README"
author: "Sudhir Chowdhary"
date: "Sunday, May 24, 2015"
output: html_document
---

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

Objectives:
Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement.
Uses descriptive activity names to name the activities in the data set
Appropriately labels the data set with descriptive variable names.
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


Load two main labels for the entire data source
fLabels - stores names used to replace the index numbers used in the Test/Train datasets
aLabels - stores name types of activities that were tracked.


```{r}
## Get data from Activity Labels and Feature text files into respective variables.
fLabels <- read.table("features.txt", col.names = c("FeatureNum","FeatureName"))
aLabels <- read.table("activity_labels.txt", col.names=c("Label","ActivityName"))
```

Raw Data set is divided into 2 set (train/Test), and the files are present in separated directory folders.
1. Load data from test/X_test.txt, and apply lables from above step.
2. Load Labels from test/y_test.txt, (row is present in each label for which feature to track)
3. Load Subjects from test/subject_test.txt, (subject row is linked to the raw data to track which subject the data was collected from raw data set

```{r}
## Test sets from respective files.
tRaw <- read.table("test/X_test.txt",col.names = fLabels$FeatureName)
tstLabels <- read.table("test/y_test.txt",col.names = c("Label"))
tstSubject <- read.table("test/subject_test.txt",col.names=c("Subject"))
```
Load Train data the same way into respective variables as above step.

```{r}
## Training the data set
trnRaw <- read.table("train/X_train.txt",col.names = fLabels$FeatureName)
trnLabels <- read.table("train/y_train.txt",col.names = c("Label"))
trnSubject <- read.table("train/subject_train.txt",col.names=c("Subject"))
```

Combine columns in the subject dataset, label records and data into 1 final data set. (1-test, 1-train)
          
```{r}
## Build Data set from Raw data and Labels
tstData <- cbind(tstSubject,tstLabels,tRaw)
trnData <- cbind(trnSubject,trnLabels,trnRaw)
ttlData <- merge(aLabels,rbind(tstData,trnData),by="Label")
```

Combine the data set via combining multiple columns and consolidating it.

```{r}

## Figure out which columns to use and filter them out
ttlCol <- colnames(ttlData)
colsToUse <- ttlCol=="Subject" | ttlCol=="ActivityName" | grepl("mean",ttlCol) | grepl("std",ttlCol)
tidyData <- ttlData[,c(seq_len(length(ttlCol))[colsToUse])]
tidyData$Subject <- as.factor(tidyData$Subject)
tidyData$ActivityName <- as.factor(tidyData$ActivityName)

```
Calculate the avg (complute mean for all columns except the selected columns (Subject/ActivityName ))
and store the final output in a file for upload.

```{r}
## Get averages for the mean and std columns from tidyData
FnlOutput <- aggregate(.~Subject+ActivityName,data=tidyData,mean)
write.table(statData,"FnlOutput.txt", row.name=FALSE)
```
