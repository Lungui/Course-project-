Code Book for Course Project

Overview

Source of the original data:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Full Description at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
Process

The script run_analysis.R performs the following process to clean up the data and create tiny data sets:

Merge the training and test sets to create one data set.

Reads features.txt and uses only the measurements on the mean and standard deviation for each measurement.

Reads activity_labels.txt and applies human readable activity names to name the activities in the data set.

Labels the data set with descriptive names. 

Merges the features with activity labels and subject IDs. The result is saved as tidy.csv

Variables
testData_act - table contents of test/Y_test.txt 
testData - table contents of test/X_test.txt 
testData_sub - table contents of test/subject_test.txt 
testData - Combined data set of the above variables 
trainData - table contents of train/X_train.txt 
trainData_act - table contents of train/Y_train.txt 
trainData_sub - table contents of train/subject_train.txt 
trainData- Combined data set of the above variables 
activities - table contents of activity_labels.txt
features - table contents of features.txt
bigData -Combined data set of testData and trainData
features$V2 - Names of for data columns derived from features



