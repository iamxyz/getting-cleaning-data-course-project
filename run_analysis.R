
#############################################################################################
## R Scripts for analyzing and processing the dataset from Human Activity 
## Recognition Using Smartphones (http://archive.ics.uci.edu/ml/datasets/
## Human+Activity+Recognition+Using+Smartphones).
## Coding by iamxyz for Getting & Cleaning Data course project on Feb,2015
#############################################################################################

#############################################################################################
## (1) Setting up the environment required 
##
## Firstly, You are required to get the dataset from Human Activity Recognition 
## Using Smartphones, which can be downloaded freely from the site: 
## http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
## or directly from the site : https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles
## %2FUCI%20HAR%20Dataset.zip.
## Next, putting the downloaded file in your R working directory and unzipped it, you will 
## get a new sub directory named as "new UCI HAR Dataset". Plz. do not renaming it or changing
## the files including the directory.
## Last, putting this script file "run_analysis.R" in your R working directory.
## Now,the environment for running the scripts is ready! 8)
##
## (2) Running the R scripts and getting the tidy data 
## In the R command line, excuting : source("run_analysis.R")
## And you will see messages " starting to analyze and process the raw data...", 
## then "Plz. waiting...", after the message "Processing ends and a tidydata file "tidydata.txt" 
## is created." You will find a new text file named as "tidydata.txt" in your R working directory.
## The text file is the processing result from the raw data. The description of  the variables 
## and the data for the result file can be found in the file "CodeBook.md".
##
###############################################################################################


###############################################################################################
## The scipts goes here, follwing the five steps of the course project:
###############################################################################################


cat("Starting to analyze and process the raw data...\n")
cat("Plz. waiting...\n")

## STEP 1:  Merges the training and the test sets to create one data set.


# the path1,path2,path3 variables for creating the raw files paths  
# Important Notes: Because of different description of the directory paths
# in Mac(linux/Unix) and Microsoft Windows, For example:
# path "/iamxyz/R Project/UCI HAR Dataset/activity_labels.txt" in Mac(linux/Unix).
# path "c:\\iamxyz\\R Project\\UCI HAR Dataset\\activity_labels.txt" in MS Windows.
# You should modify the variables below (path1, path2 and path3) accordingly
# if your R environment is running on MicroSoft Windows.

path1 <- paste(getwd(), "/UCI HAR Dataset/", sep = "")
path2 <- paste(getwd(), "/UCI HAR Dataset/train/", sep = "")
path3 <- paste(getwd(), "/UCI HAR Dataset/test/", sep = "")

# creating eight raw files paths 

activity_labels_txt_file_path <- paste(path1, "activity_labels.txt", sep = "")
features_txt_file_path <- paste(path1, "features.txt", sep = "")

subject_train_txt_file_path <- paste(path2, "subject_train.txt", sep = "")
subject_test_txt_file_path <- paste(path3, "subject_test.txt", sep = "")
X_train_txt_file_path <- paste(path2, "X_train.txt", sep = "")
X_test_txt_file_path <- paste(path3, "X_test.txt", sep = "")
y_train_txt_file_path <- paste(path2, "y_train.txt", sep = "")
y_test_txt_file_path <- paste(path3, "y_test.txt", sep = "")


# reading the raw files and creating eight data frames 

mytable_subject_test <- read.table(subject_test_txt_file_path)
mytable_subject_train <- read.table(subject_train_txt_file_path)
mytable_x_test <- read.table(X_test_txt_file_path)
mytable_x_train <- read.table(X_train_txt_file_path)
mytable_y_test <- read.table(y_test_txt_file_path)
mytable_y_train <- read.table(y_train_txt_file_path)
mytable_activity_labels <- read.table(activity_labels_txt_file_path, stringsAsFactors = FALSE)
mytable_features <- read.table(features_txt_file_path, stringsAsFactors = FALSE)

# merging the train and test dataset for subject, x and y respectively

mydata_subject <- rbind(mytable_subject_train, mytable_subject_test)
mydata_x <- rbind(mytable_x_train, mytable_x_test)
mydata_y <- rbind(mytable_y_train, mytable_y_test)

#  merging the three datasets: subject, x and y , to one dataset: mydata_all
#  which is a big dataset with 10299 rows and 563 cols. (approx. 44 MBytes in memory)
#  and its col names are V1,V1,V1,V2,V3,...,V561

mydata_all <- cbind(mydata_subject, mydata_y)
mydata_all <- cbind(mydata_all, mydata_x)


## STEP 2: Extracts only the measurements on the mean and standard deviation for each measurement.

# here supposed that only variables whose name includes "mean()" or "std()" meet the requirements.
# such as "tBodyAcc-mean()-X", "tBodyAcc-std()-X" 


# n is the index of the measurement items extracted 
n <- grep("mean\\(\\)|std\\(\\)", mytable_features$V2)

# measured_values_names vector which including names of all extraced items, will be used later.
measured_values_names <- mytable_features$V2[n]

# mydata_all_selected is the subset of mydata_all, which is smaller than mydata_all, with
# 10299 rows and 68 cols (approx. 5 MBytes in memory)
# and its col names are V1,V1.1,V1.2,V2,V3,...V6,V41,...V46,V81,...,V542,V543
mydata_all_selected <- mydata_all[, c(1, 2, n+2)]


## STEP 3: Uses descriptive activity names to name the activities in the data set.


# mydata_all_selected$V1.1 is the activities variable, whose value is 1 to 6. Here they
# are used as index to get the matched activity names in mytable_activity_labels$V2, as
# "WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING" and "LAYING" 
# As result, all of the values of the activity variable are replaced by descriptive names. 
temp <- mytable_activity_labels$V2[mydata_all_selected$V1.1]

mydata_all_selected$V1.1 <- temp


## STEP 4: Appropriately labels the data set with descriptive variable names. 

# creating vector new_col_names which used to rename the col names of the dataset: 
# mydata_all_selected
# ,now the mydata_all_selected's col names become descriptive ,just as :
# "subject", "activity", "tBodyAcc-mean()-X", "tBodyAcc-mean()-Y",...,
# "fBodyBodyGyroJerkMag-mean()","fBodyBodyGyroJerkMag-std()"

new_col_names <- c("subject", "activity", measured_values_names)

colnames(mydata_all_selected) <- new_col_names


## STEP 5: From the data set in step 4, creates a second, independent tidy data set with 
## the average of each variable for each activity and each subject.


# the main idea to get the tidy dataset is: spliting the dataset: mydata_all_selected by subjects,
# to get 30 smaller subsets, then continuing to split these subsets one by one by activities, to get 
# 180 more smaller subsets, next, using sapply to work out the average of each measurement variables.
# finally,combining all the average of each measurement variables to create average_result_matrix, 
# converting it to a dataframe, meanwhile, creating two vectors: subjects and activities. Now all the
# thins come to the end. the dataset: tidydata is created and saved as a text file tidydata.txt.  
# Note: tidydata becomes more smaller, with 180 rows and 68 cols  (approx. 0.1 MBytes in memory)


# spliting the dataset by subjects and activities and combining all the average to average_result_table
subdata_as_subject <- split(mydata_all_selected, mydata_all_selected$subject)


average_result_matrix <- NULL

for(i in 1:30){
    subdata_as_subject_as_activity <- split(subdata_as_subject[[i]], subdata_as_subject[[i]]$activity); 
               for(j in 1:6){  
                             average_result_matrix <- rbind(average_result_matrix, sapply(subdata_as_subject_as_activity[[j]][,3:68], mean))
               }
}

average_result_table <- data.frame(average_result_matrix)

# created the subject and activity vector, join them with the average_result_table to create the tidydata 

subject <- NULL
for(i in 1:30){subject <-c(subject, rep(i,6))}  

activity_set <- sort(mytable_activity_labels$V2)

activity <- rep(activity_set, 30)

tidydata <- NULL

tidydata <- cbind(subject, activity)

colnames(tidydata) <- c("Subject","Activity")

tidydata <- cbind(tidydata, average_result_table)

# editing text variables( such as: removing dots in the col names of the tidydata, etc.) to make 
# the col names more descriptive. The description of the variables can be found in the file "CodeBook.md".

colnames(tidydata) <- gsub("\\.","",gsub("s","S",gsub("m","M",names(tidydata))))


# saving the tidydata as text file "tidydata.txt"

write.table(tidydata, file = "tidydata.txt", row.names = FALSE)

cat(paste("Processing ends and a tidydata file"," \'","tidydata.txt","\' ","is created.", sep=""))

