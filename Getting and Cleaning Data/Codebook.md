# CodeBook 

The original data must already be saved to the working directory and can be collected from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip. 
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. 

Here we describe how to tidy up the data so that it the various smaller tables (features, X_train, y_train, subject_train, X_test, y_test, subject_test, activity_labels) are combined into one large table with specific variables relating to means and standard deviations.

First we sort the Test (x, y, subject) data into one big table (combining the columns). We also extract the features headings
so that we can give the rows in the Test table appropriate headings.

*library(dplyr)<br/>
featuresRaw <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt")<br/>
features <- featuresRaw[,2]<br/>
xTest <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")<br/>
yTest <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")<br/>
subjectTest <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")<br/>
names(xTest) <- features<br/>
names(yTest) <- "ActivityId"<br/>
names(subjectTest) <- "SubjectId"<br/>
testDataXandY <- cbind(subjectTest, xTest, yTest)*<br/>

We now sort the Training data into one big table (combining the columns). The process is similar to that used for the Test data i.e. x,y,subjects tables.
Note that we have already extracted the features headings and therefore do not need to do this again.

*xTrain  <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")<br/>
yTrain  <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")<br/>
subjectTrain <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")<br/>
names(xTrain) <- features<br/>
names(yTrain) <- "ActivityId"<br/>
names(subjectTrain) <- "SubjectId"<br/>
trainDataXandY <- cbind(subjectTrain,xTrain, yTrain)*<br/>

We now merge the Training and Test tables (stacking up the rows) into one large table. 
*testAndTrainData <- rbind(trainDataXandY,testDataXandY)*<br/>

We take only the those variables which involve the mean or standard deviation. However, we keep the subject and activity columns as ids.
The activity column is also needed for a later task.

*totalMeanStd <- testAndTrainData[ , grep("Subject|mean|std|Activity", names(testAndTrainData))]*<br/>

We now use the descriptive activityLabel to replace the non-descript ActivitiyId.

*activityData <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")<br/>
names(activityData) <- c("ActivityId", "ActivityLabel")<br/>
totalMeanStdActivity <- select(merge(totalMeanStd, activityData, by = "ActivityId"),-1)<br/>
totalMeanStdActivity <- select(totalMeanStdActivity, ActivityLabel, everything())*<br/>

We label the variables with appropriate descriptive variable names.

*names(totalMeanStdActivity) <- gsub("Acc", "Acceleration", names(totalMeanStdActivity))<br/>
names(totalMeanStdActivity) <- gsub("^t", "TimeOf", names(totalMeanStdActivity))<br/>
names(totalMeanStdActivity) <- gsub("^f", "FrequencyOf", names(totalMeanStdActivity))<br/>
names(totalMeanStdActivity) <- gsub("Mag", "Magnitude", names(totalMeanStdActivity))<br/>
names(totalMeanStdActivity) <- gsub("std", "Std", names(totalMeanStdActivity))<br/>
names(totalMeanStdActivity) <- gsub("Freq", "FrequencyOf", names(totalMeanStdActivity))<br/>
names(totalMeanStdActivity) <- gsub("BodyBody", "Body", names(totalMeanStdActivity))<br/>
names(totalMeanStdActivity) <- gsub("mean", "Mean", names(totalMeanStdActivity))*<br/>

We now create a second, independent tidy data set with the average of each variable for each activity and each subject, writing the table to the working directory
with name "averageTotal.txt".

*averageTotal<-aggregate(. ~SubjectId + ActivityLabel, totalMeanStdActivity, mean)<br/>
averageTotal<-arrange(averageTotal, SubjectId, ActivityLabel)<br/>
write.table(averageTotal, file = "averageTotal.txt",row.name=FALSE)*<br/>

The new tidy data (named 'averageTotal') has the following variables
[1] "SubjectId"                                                        
 [2] "ActivityLabel"                                                    
 [3] "TimeOfBodyAcceleration-Mean()-X"                                  
 [4] "TimeOfBodyAcceleration-Mean()-Y"                                  
 [5] "TimeOfBodyAcceleration-Mean()-Z"                                  
 [6] "TimeOfBodyAcceleration-Std()-X"                                   
 [7] "TimeOfBodyAcceleration-Std()-Y"                                   
 [8] "TimeOfBodyAcceleration-Std()-Z"                                   
 [9] "TimeOfGravityAcceleration-Mean()-X"                               
[10] "TimeOfGravityAcceleration-Mean()-Y"                               
[11] "TimeOfGravityAcceleration-Mean()-Z"                               
[12] "TimeOfGravityAcceleration-Std()-X"                                
[13] "TimeOfGravityAcceleration-Std()-Y"                                
[14] "TimeOfGravityAcceleration-Std()-Z"                                
[15] "TimeOfBodyAccelerationJerk-Mean()-X"                              
[16] "TimeOfBodyAccelerationJerk-Mean()-Y"                              
[17] "TimeOfBodyAccelerationJerk-Mean()-Z"                              
[18] "TimeOfBodyAccelerationJerk-Std()-X"                               
[19] "TimeOfBodyAccelerationJerk-Std()-Y"                               
[20] "TimeOfBodyAccelerationJerk-Std()-Z"                               
[21] "TimeOfBodyGyro-Mean()-X"                                          
[22] "TimeOfBodyGyro-Mean()-Y"                                          
[23] "TimeOfBodyGyro-Mean()-Z"                                          
[24] "TimeOfBodyGyro-Std()-X"                                           
[25] "TimeOfBodyGyro-Std()-Y"                                           
[26] "TimeOfBodyGyro-Std()-Z"                                           
[27] "TimeOfBodyGyroJerk-Mean()-X"                                      
[28] "TimeOfBodyGyroJerk-Mean()-Y"                                      
[29] "TimeOfBodyGyroJerk-Mean()-Z"                                      
[30] "TimeOfBodyGyroJerk-Std()-X"                                       
[31] "TimeOfBodyGyroJerk-Std()-Y"                                       
[32] "TimeOfBodyGyroJerk-Std()-Z"                                       
[33] "TimeOfBodyAccelerationMagnitude-Mean()"                           
[34] "TimeOfBodyAccelerationMagnitude-Std()"                            
[35] "TimeOfGravityAccelerationMagnitude-Mean()"                        
[36] "TimeOfGravityAccelerationMagnitude-Std()"                         
[37] "TimeOfBodyAccelerationJerkMagnitude-Mean()"                       
[38] "TimeOfBodyAccelerationJerkMagnitude-Std()"                        
[39] "TimeOfBodyGyroMagnitude-Mean()"                                   
[40] "TimeOfBodyGyroMagnitude-Std()"                                    
[41] "TimeOfBodyGyroJerkMagnitude-Mean()"                               
[42] "TimeOfBodyGyroJerkMagnitude-Std()"                                
[43] "FrequencyOfuencyOfBodyAcceleration-Mean()-X"                      
[44] "FrequencyOfuencyOfBodyAcceleration-Mean()-Y"                      
[45] "FrequencyOfuencyOfBodyAcceleration-Mean()-Z"                      
[46] "FrequencyOfuencyOfBodyAcceleration-Std()-X"                       
[47] "FrequencyOfuencyOfBodyAcceleration-Std()-Y"                       
[48] "FrequencyOfuencyOfBodyAcceleration-Std()-Z"                       
[49] "FrequencyOfuencyOfBodyAcceleration-MeanFrequencyOf()-X"           
[50] "FrequencyOfuencyOfBodyAcceleration-MeanFrequencyOf()-Y"           
[51] "FrequencyOfuencyOfBodyAcceleration-MeanFrequencyOf()-Z"           
[52] "FrequencyOfuencyOfBodyAccelerationJerk-Mean()-X"                  
[53] "FrequencyOfuencyOfBodyAccelerationJerk-Mean()-Y"                  
[54] "FrequencyOfuencyOfBodyAccelerationJerk-Mean()-Z"                  
[55] "FrequencyOfuencyOfBodyAccelerationJerk-Std()-X"                   
[56] "FrequencyOfuencyOfBodyAccelerationJerk-Std()-Y"                   
[57] "FrequencyOfuencyOfBodyAccelerationJerk-Std()-Z"                   
[58] "FrequencyOfuencyOfBodyAccelerationJerk-MeanFrequencyOf()-X"       
[59] "FrequencyOfuencyOfBodyAccelerationJerk-MeanFrequencyOf()-Y"       
[60] "FrequencyOfuencyOfBodyAccelerationJerk-MeanFrequencyOf()-Z"       
[61] "FrequencyOfuencyOfBodyGyro-Mean()-X"                              
[62] "FrequencyOfuencyOfBodyGyro-Mean()-Y"                              
[63] "FrequencyOfuencyOfBodyGyro-Mean()-Z"                              
[64] "FrequencyOfuencyOfBodyGyro-Std()-X"                               
[65] "FrequencyOfuencyOfBodyGyro-Std()-Y"                               
[66] "FrequencyOfuencyOfBodyGyro-Std()-Z"                               
[67] "FrequencyOfuencyOfBodyGyro-MeanFrequencyOf()-X"                   
[68] "FrequencyOfuencyOfBodyGyro-MeanFrequencyOf()-Y"                   
[69] "FrequencyOfuencyOfBodyGyro-MeanFrequencyOf()-Z"                   
[70] "FrequencyOfuencyOfBodyAccelerationMagnitude-Mean()"               
[71] "FrequencyOfuencyOfBodyAccelerationMagnitude-Std()"                
[72] "FrequencyOfuencyOfBodyAccelerationMagnitude-MeanFrequencyOf()"    
[73] "FrequencyOfuencyOfBodyAccelerationJerkMagnitude-Mean()"           
[74] "FrequencyOfuencyOfBodyAccelerationJerkMagnitude-Std()"            
[75] "FrequencyOfuencyOfBodyAccelerationJerkMagnitude-MeanFrequencyOf()"
[76] "FrequencyOfuencyOfBodyGyroMagnitude-Mean()"                       
[77] "FrequencyOfuencyOfBodyGyroMagnitude-Std()"                        
[78] "FrequencyOfuencyOfBodyGyroMagnitude-MeanFrequencyOf()"            
[79] "FrequencyOfuencyOfBodyGyroJerkMagnitude-Mean()"                   
[80] "FrequencyOfuencyOfBodyGyroJerkMagnitude-Std()"                    
[81] "FrequencyOfuencyOfBodyGyroJerkMagnitude-MeanFrequencyOf()" 