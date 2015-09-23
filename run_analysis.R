## carltronic
## 23 September 2015
## V1.1
## runanalysis.R

library(dplyr)
################################################################################
## 1. Merges the training and the test sets to create one data set.           ##
################################################################################

## read test data files into R tables
x.test <- read.table("./UCI HAR Dataset/test/X_test.txt")
x.test <- tbl_df(x.test)

y.test <- read.table("./UCI HAR Dataset/test/y_test.txt")
y.test <- tbl_df(y.test)

subject.test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subject.test <- tbl_df(subject.test)

## read train data files into R tables
x.train <- read.table("./UCI HAR Dataset/train/X_train.txt")
x.train <- tbl_df(x.train)

y.train <- read.table("./UCI HAR Dataset/train/y_train.txt")
y.train <- tbl_df(y.train)

subject.train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subject.train <- tbl_df(subject.train)

## Read activity labels from file
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
## Read features labels from file
features_labels <- read.table("./UCI HAR Dataset/features.txt")

## Merge tables. add train data after test
x.all <- rbind(x.test, x.train)
y.all <- rbind(y.test, y.train)
subject.all <- rbind(subject.test, subject.train)

## Clean up
rm(x.test, x.train)
rm(y.test, y.train)
rm(subject.test, subject.train)

## Add descriptive variable names to tables
colnames(x.all) <- features_labels[,2]
colnames(y.all) <- c("activity")
colnames(subject.all) <- c("subject")

## Merge all three tables into a master table
master <- cbind(subject.all, y.all, x.all)
master <- tbl_df(master)


################################################################################
## 2. Extracts only the measurements on the mean and standard deviation for   ##
##    each measurement.                                                       ##
################################################################################
## Subset the master table for columns with mean and std using the grepl 
## function. Note that subject and activity columns are also kept.

master.reduced <- master[,grepl("subject|activity|mean|std",colnames(master))]

## Clean up
rm(master)

################################################################################
## 3. Uses descriptive activity names to name the activities in the data set  ##
################################################################################
## merge activity labels with the main data set to get text-based descriptions
master.labeled <- merge(master.reduced, activity_labels, by.x="activity", by.y="V1", sort = FALSE)
master.labeled <- mutate(master.labeled, activity = V2)
master.labeled$V2 <- NULL ## drop the temporary column

## Clean up
rm(master.reduced)

################################################################################
## 4. Appropriately labels the data set with descriptive variable names.      ##
##    Labeling the data set with the feature variable names was performed     ##
##    in Step 1. This was done prior to creating the master table.            ##
################################################################################


################################################################################
## 5. From the data set in step 4, creates a second, independent tidy data set 
##    with the average of each variable for each activity and each subject.
################################################################################
## Create data set of the average of each variable for each activity and each subject

master.grouped <- group_by(master.labeled, subject, activity)
master.summarized <- summarise_each(master.grouped, funs(mean))

## Clean up
rm(master.labeled, master.grouped)

## Output the summarized data to a file
write.table(master.summarized, file="./tidy_data.txt", row.names = FALSE)