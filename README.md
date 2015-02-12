

##Read Me 

###About the R script

The R script "run_analysis.R" is used to analyze and process the raw dataset from Human 
Activity Recognition Using Smartphones. It will create a tidy dataset which includes the averages 
of values on the mean and standard deviation extraced from the raw dataset for each features, each 
activity and each subject. The tidy dataset is outputed as a text file "tidydata.txt". More 
Information about the raw dataset can be found on the web site:
(http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)


###Setting up the script running environment

In order to excute the R script, you should set up the R running environment firstly
and make sure R scripts can be excuted in the command line. Next, you should unzip
the raw dataset downloaded from the web site and put the folder "UCI HAR Dataset" in
your R working directory. Please remember: Do not modify the names or contents of the 
folder (includind its subfolders).

###Making the R script running

You should put the R script file "run_analysis.R" in your R working directory. One 
important thing you need to notice is: The R script is based on R environment running
on Unix-like OS (Mac, linux) or Unix. If your R environment is running on the Microsoft
Windows, you are required to modify the path variables in the run_alalysis.R (path1, 
path2 and path3) accordingly, or the R script will give out errors on running.
To make the R script running, in the R command line, excuting : source("run_analysis.R")
. And you will see messages "Starting to analyze and process the raw data...", next, 
"Plz. waiting...", then the message "Processing ends and a tidydata file 'tidydata.txt' 
is created." You will find a new text file named as "tidydata.txt" in your R working directory.
The text file is the processing result from the raw data. The detail description of the variables 
and the data for the result file can be found in the file "CodeBook.md".

###How the R script works on the raw data and outputs the tidy data 

The R script will complete all of the tasks, following the five steps given in the requirement of 
the course project.

####STEP 1:  Merges the training and the test sets to create one data set.

1. Reading the raw files and creating eight data frames.

2. Merging the train and test dataset for subject, X and y respectively

3. Merging the three datasets: subject, X and y to one dataset: "mydata_all", which is a big dataset
with 10299 rows and 563 cols. 

####STEP 2: Extracts only the measurements on the mean and standard deviation for each measurement.

1. Here supposed that only variables whose name includes "mean()" or "std()" meet the requirements
and will be extracted.

2. A new dataset "mydata_all_selected" is created as the subset of mydata_all, which is smaller than 
mydata_all, with 10299 rows and 68 cols.

####STEP 3: Uses descriptive activity names to name the activities in the data set.

All of the values of the activity variable are replaced by descriptive names: "WALKING", "WALKING_UPSTAIRS", 
"WALKING_DOWNSTAIRS", "SITTING", "STANDING" and "LAYING".

####STEP 4: Appropriately labels the data set with descriptive variable names. 

The mydata_all_selected's col names will be replaced with more descriptive names, just as :
"subject", "activity", "tBodyAcc-mean()-X", "tBodyAcc-mean()-Y", ... , "fBodyBodyGyroJerkMag-mean()",
"fBodyBodyGyroJerkMag-std()".


####STEP 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

1. Using the split-apply-combine method,  the averages of each measurement variables are workd out and
a new wide form tidy dataset "tidydata" is created, which becomes more smaller, with 180 rows and 68 cols.

2. The text variables in the tidydata will be replaced with the more descriptive names based on the tidy rules.

3. A text file "tidydata.txt" is created and saved in your working directory as the processing result of the scripts.

###Trouble Shooting
1.

Q: The R script give the error message : can not open files ... or No such files or directory.

A: Firstly, be sure your R environment is running on unix-like operation system, or you should modify the path variables
in the R script accordingly. Second, be sure you put the unzipped folder "UCI HAR Dataset" in your R working directory,
which must be the same directory where the R script file "run_analysis.R" is executed.

2.

Q: The R script is running and gives out a message" Plz. waiting...", but it seemed that the program is halted.

A: Because functions to operate the data frame more fastly are not used in the R script. It may be slow and needs more
time to complete all the processing tasks. Just keep waiting for the result. 8)

***
Feb, 2015. By iamxyz for Getting & Cleaning Data course project