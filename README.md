# GettingCleaningDataProject
Course Project for the Getting and Cleaning Data Course

This repository contains the run_analysis.R script, the project code book, the tidy data output and this readme file.
The raw data was obtained from:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

The run_analysis.R script expects that the unzipped raw data be in the same working directory.

The raw data set contains two sets of data: train and test.
In the first step, the scripts combines the two data sets to create a single data set. 
It is also at this point that descriptive variable names are added to the table.

In the second step, the measurements pertaining to mean and std deviation are retained while all others are dropped.

The third step changes the integer values in the activity column into user readable descriptions.

The final step creates a tidy data set by taking the average of each variable grouped by subject and activity.