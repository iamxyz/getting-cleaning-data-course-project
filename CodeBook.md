##Code Book

###PART I  Introduction to the raw data

The raw data comes from Human Activity Recognition Using Smartphones DataSet[1].

####DataSet Downloaded URL: 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
or https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


####DataSet Information:
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

####DataSet Attribute Information:

For each record in the dataset it is provided:

* Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.

* Triaxial Angular velocity from the gyroscope.

* A 561-feature vector with time and frequency domain variables.

* Its activity label.

* An identifier of the subject who carried out the experiment.


###PART II  The contents of the raw data

After you unzip the raw dataset file downloaded, you will get a folder "UCI HAR Dataset", which contains files for data and related infomation.
There will be four text files ( activity_labels.txt, features_info.txt, features.txt and README.txt )  as well as two
subfolders ( test and train ). In the test folder, there are three text files ( subject_test.txt, X_test.txt, y_test.txt ) and a subfolder ( Inertial Signals ). The other train folder has the same structure as the test folder but changes the string "test" in the files' name with string "train", just as subject_train.txt, X_train.txt and y_train.txt. Besides, two important files ( README.txt and features_intro.txt ) provide us more information for setting up our processing work.

The rules of the processing tasks go below: ( Note: All processing rules are based on my personal understanding )

1. In the course project, we will omit the subforders "test/Inertial Signals" and "train/Inertial Signals", because the
data files which contained are useless in our processing task. 

2. All of processing tasks are based on these raw data files: 

* 'features.txt': List of all features.

* 'activity_labels.txt': Links the class labels with their activity name.

* 'train/subject_train.txt': Subjects in Training set.

* 'train/X_train.txt': Training set.

* 'train/y_train.txt': Training labels.

* 'test/subject_test.txt': Subjects in Test set.

* 'test/X_test.txt': Test set.

* 'test/y_test.txt': Test labels. 

3. There are 10299 instances with 561 features in our processing task, which has been randomly partitioned into two sets ( Train and Test ). In the first step of the project, we will combine all of the 30 subjects ,the 6 kinds of activities and all of the 561 measurement of features into a large dataset. During the next extraction processing work, in my view, only the features which contains "mean()" or "std()" in the name string are eligible for extraction. For example, tBodyAcc-mean()-X, tBodyAcc-std()-Z and tBodyAccMag-std(), all of them meet the rules, but fBodyAcc-meanFreq()-X or angle(X,gravityMean) are not eligible, though they both have the word "mean" in their names. Using grep function, we will find only 66 of the features are required to be extracted in the processing task.


###PART III  The description of datasets and the transformations steps 
 
####STEP1: Merges the training and the test sets to create one data set.
The subjects, the activities and the measurements of the features are combined together to create a large dataset.

* ( subject_train.txt, X_train.txt, y_train.txt, subject_test.txt, X_test.txt, y_test.txt ) -> mydata_all dataset
* mydata_all dataset: 10299 rows and 563 cols. ( approx. 44 MBytes in memory ).
* mydata_all dataset's col names: V1,V1,V1,V2,V3,...,V561
* V1: int, subject id, 1 ~ 30
* V1: int, activity lables, 1 ~ 6
* V1 ~ V561: num,  measurement of features (normalized and bounded within [-1,1]), such as -0.0203, 0.278,... etc.

####STEP2: Extracts only the measurements on the mean and standard deviation for each measurement.
As dicussed before, only 66 of all variables whose name include "mean()" or "std()" are extraced and formed a smaller dataset mydata_all_selected.

* ( mydata_all dataset ) -> extraction -> ( mydata_all_selected dataset )
* mydata_all_selected dataset: 10299 rows and 68 cols ( approx. 5 MBytes in memory )
* mydata_all_selected dataset's col names: V1,V1.1,V1.2,V2,V3,...V6,V41,...V46,V81,...,V542,V543 ( NOTE: the numbers "x" in the names "Vx" are discontinuous )
* V1: int, subject id, 1 ~ 30
* V1.1: int, activity lables, 1 ~ 6
* V1.2 ~ V543: num,  measurement of features ( normalized and bounded within [-1,1] ), such as -0.0203, 0.278,...etc.

####STEP3: Uses descriptive activity names to name the activities in the data set
We can obtain the activity lables from the "activity_labels.txt" as "WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING" and "LAYING", which refer to 1 to 6 in mydata_all_selected$V1.1. Simply replacing them using the descriptive names.

* ( mydata_all_selected dataset, activity_labels.txt ) -> renaming all the items in activity variable ( Col V1.1  ) -> ( mydata_all_selected dataset )

####STEP4: Appropriately labels the data set with descriptive variable names.
We can obtain the descriptive names for measurement of features from the features.txt. Creating a new col names variable and replacing the old one.

* ( mydata_all_selected dataset, features.txt ) -> renaming the cols of the dataset -> ( mydata_all_selected dataset )
* mydata_all_selected dataset's descriptive col names: "subject", "activity", "tBodyAcc-mean()-X", "tBodyAcc-mean()-Y",...,"fBodyBodyGyroJerkMag-mean()","fBodyBodyGyroJerkMag-std()"

####STEP5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
To get the tidy dataset with the average of each variable for each activity and each subject, the split-apply-combine method is used. We use the sapply function in two layers for-loop structure to work out the average values and combine them to create a data frame for measurement values, which is used to create the wide form tidy dataset with the subjects and activities variabls. The tidy dataset will be saved as a text file at the end of the R scripts. In addition, for making the dataset more tidy, the text variables in the tidydata have been replaced with more descriptive names, for example, one of the names is : "tBodyAccJerk.mean...X"  is replaced with the new name: "tBodyAccJerkMeanX", the dots in the old name are removed as well as all of the first letters in the name strings are capitalized for more readable.   

* ( mydata_all_selected dataset ) -> ( split-apply-combine for average ) -> ( editing text variables ) -> ( tidydata )
* tidydata: 180 rows and 68 cols  ( approx. 0.1 MBytes in memory )
* tidydata's col names: Subject, Activity, tBodyAccMeanX, tBodyAccMeanY, ..., fBodyBodyGyroJerkMagStd
* Subject: Factor, 30 levels, subject id, "1" ~ "30"
* Activity: Factor, 6 levels, activity lables, "LAYING”, ”SITTING”, “STANDING”, ”WALKING”, ”WALKING_DOWNSTAIRS”, “WALKING_UPSTAIRS"  
* tBodyAccMeanX: num,  average of mean value of the measurement of feature ( tBodyAccMean in X ) , 0.222, 0.261, ...
* tBodyAccMeanY: num, average of mean value of the measurement of feature ( tBodyAccMean in Y ) , -0.04051 -0.00131, ...
* tBodyAccMeanZ: num,  average of mean value of the measurement of feature ( tBodyAccMean in Z ) , -0.113 -0.105, ... 
* tBodyAccStdX: num,  average of standard deviation of the measurement of feature ( tBodyAccStd in X ) , -0.928 -0.977, ...
* ......
* fBodyBodyGyroJerkMagStd: num,  average of mean value of the measurement of feature ( fBodyBodyGyroJerkMagStd ) , -0.933 -0.987, ...







###Reference:

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

***
Feb, 2015. By iamxyz for Getting & Cleaning Data course project