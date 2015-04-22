## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

if (!require("data.table")) {
  install.packages("data.table")}

if (!require("reshape2")) {
  install.packages("reshape2")}

require("data.table")
require("reshape2")

##Download the file and put the file in the data folder
if(!file.exists("./data")){dir.create("./data")}
url <-"http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile="./data/Dataset.zip")

##Unzip the file
unzip(zipfile="./data/Dataset.zip",exdir="./data")

path_rf <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)
files

# 0. load test and training sets and the activities

testData_act  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
testData <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
trainData <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)
trainData_act <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)
trainData_sub<- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
testData_sub <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)


features <- read.table(file.path(path_rf,"features.txt"),header=FALSE,colClasses="character")

# 1. merge test and training sets into one data set, including the activities
testData<-cbind(testData,testData_act)
testData<-cbind(testData,testData_sub)
trainData<-cbind(trainData,trainData_act)
trainData<-cbind(trainData,trainData_sub)
BigData<-rbind(testData,trainData)

# 4. Appropriately labels the data set with descriptive activity names
names(BigData) <- c("Subject.id","Activity.id",features[,2])
#ordering the data by subject id then by activity id
BigData <- BigData[order(BigData$Subject.id,BigData$Activity.id),]

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
mean_string <- "mean"
std_string <- "std"

# Removes all columns with name containing neither "mean" nor "std"
# grepl return TRUE if there is a match
for (i in seq_along(features$Variable.Name)) {
        if (!grepl(mean_string,features$Variable.Name[i]) & !grepl(std_string,features$Variable.Name[i])) {
               BigData[,features$Variable.Name[i]] <- NULL
        }
}

# As stated in the code book of the data provided (README.txt) the table linking activity names to thier ids is in activity_labels.txt
##3. Uses descriptive activity names to name the activities in the data set

activity <-read.table(file.path(path_rf,"activity_labels.txt"),header = FALSE,colClasses = c("numeric","character"), 
col.names = c("Activity.id","Activity.Name"),comment.char = "")

if (!require("plyr")) {
  install.packages("plyr")}
require(plyr)

BigData <- join(BigData, activity, by = "Activity.id")

# Removes not required anymore column Activity.id
BigData$Activity.id <- NULL

# 4. Appropriately labels the data set with descriptive variable names.
labels <- names(BigData)
labels <- labels[complete.cases(labels)]

#cleaning variable names
for (i in seq_along(labels)) {
        labels[i] <- gsub("mean","Mean",labels[i])
        labels[i] <- gsub("std","Std",labels[i])
        labels[i] <- gsub("\\()","",labels[i]) # '(' is a special character in regex so we need to escape it
        labels[i] <- gsub("-","",labels[i])
}

names(BigData) <- labels

# 5. From the data set in step 4, creates a second, independent tidy data set
# with the average of each variable for each activity and each subject. Please
# upload the tidy data set created in step 5 of the instructions. Please upload
# your data set as a txt file created with write.table() using row.name=FALSE
# (do not cut and paste a dataset directly into the text box, as this may cause
# errors saving your submission).

tidy <- ddply(BigData, .(Subject.id, Activity.Name), numcolwise(mean))
# Tidy a bit more by prefixing Mean. to the variable names
#cleaning variable names
labels  <- names(tidy)
for (i in 3:length(labels)) { #skips the 2 first
        labels[i] <- paste0("Mean.",labels[i])
}
names(tidy) <- labels

write.table(tidy,"my_tidy_data_set.txt",row.name=FALSE)
