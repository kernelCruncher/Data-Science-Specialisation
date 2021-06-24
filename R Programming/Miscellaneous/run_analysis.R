#Unpack the zip folder into your working directory. 
#First sort test data into one big table (combining the columns)
library(dplyr)
library(plyr)

featuresRaw <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt")
features <- featuresRaw[,2]

xTest <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
yTest <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")
subjectTest <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")

names(xTest) <- features
names(yTest) <- "ActivityId"
names(subjectTest) <- "SubjectId"

testDataXandY <- cbind(subjectTest, xTest, yTest)

#Now sort training data into one big table (combining the columns).
xTrain  <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
yTrain  <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")
subjectTrain <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")

names(xTrain) <- features
names(yTrain) <- "ActivityId"
names(subjectTrain) <- "SubjectId"

trainDataXandY <- cbind(subjectTrain,xTrain, yTrain)

#Now we merge the train and test tables (stacking up the rows)
testAndTrainData <- rbind(trainDataXandY,testDataXandY)

#We take only the those variables which involve the mean or standard deviation. However, we keep the subject and activity columns for Id.
#The activity column is also needed for a later task.

totalMeanStd <- testAndTrainData[ , grep("Subject|mean|std|Activity", names(testAndTrainData))]

#We now use the descriptive activityLabel to replace the non-descript ActivitiyId.
activityData <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")
names(activityData) <- c("ActivityId", "ActivityLabel")

totalMeanStdActivity <- select(merge(totalMeanStd, activityData, by = "ActivityId"),-1)
totalMeanStdActivity <- select(totalMeanStdActivity, ActivityLabel, everything())

#Appropriately label the variables with descriptive variable names
names(totalMeanStdActivity) <- gsub("Acc", "Acceleration", names(totalMeanStdActivity))
names(totalMeanStdActivity) <- gsub("^t", "TimeOf", names(totalMeanStdActivity))
names(totalMeanStdActivity) <- gsub("^f", "FrequencyOf", names(totalMeanStdActivity))
names(totalMeanStdActivity) <- gsub("Mag", "Magnitude", names(totalMeanStdActivity))
names(totalMeanStdActivity) <- gsub("std", "Std", names(totalMeanStdActivity))
names(totalMeanStdActivity) <- gsub("Freq", "FrequencyOf", names(totalMeanStdActivity))
names(totalMeanStdActivity) <- gsub("BodyBody", "Body", names(totalMeanStdActivity))
names(totalMeanStdActivity) <- gsub("mean", "Mean", names(totalMeanStdActivity))

#We now create a second, independent tidy data set with the average of each variable for each activity and each subject.
averageTotal<-aggregate(. ~SubjectId + ActivityLabel, totalMeanStdActivity, mean)
averageTotal<-averageTotal[order(averageTotal$SubjectId,averageTotal$ActivityLabel),]

write.table(averageTotal, file = "averageTotal.txt",row.name=FALSE)