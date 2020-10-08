#this is the code to getting and cleanning data, also is the assignment 4 of the
#Data science course

#import the library data.table to use the function read.table
library(data.table)

#for train and test files
#import subject file that contents the number of the subject who is performing the probes
#import y file that contents the number of the activity
#import x file that contents the values 

subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "subjectID")
ytest<-read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "activity")
xtest<-read.table("./UCI HAR Dataset/test/X_test.txt")


subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "subjectID")
ytrain<-read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "activity")
xtrain<-read.table("./UCI HAR Dataset/train/X_train.txt")

#import the features that have the names of the features, that allow us recognize to where
#belongs each x value

features<-read.table("./UCI HAR Dataset/features.txt",col.names = c("num","var"))

#then assign the previous names to each column in the x data 

names(xtest)<-features$var
names(xtrain)<-features$var

#now that each column hava a name, the columns of test and train could be combined

testset<-cbind(subject_test, ytest, xtest)
trainset<-cbind(subject_train, ytrain, xtrain)

#how both data have the same name in columns and same order, its possiblecombine rows

joined<-rbind(testset,trainset)

#Now, the columns with mean() and std() are extracted by logical operation, 
#also the first two columns are extracted so change them to true 

TFcol<-grepl("mean\\(\\)", names(joined)) | grepl("std\\(\\)", names(joined)) 
TFcol[1:2]<-TRUE

#extracting the columns
meanstd<-joined[,TFcol]

#import the activity names
activitynames<-read.table("./UCI HAR Dataset/activity_labels.txt")
activitynames$V2<-tolower(activitynames$V2)

#become the activity column of the data to factors and relate them with the activity names
meanstd$activity<- factor(meanstd$activity, labels = activitynames$V2)

#import reshape to use melt
library(reshape2)

#conserve subjectid and activity and melt the rest ofcolumns
melted<- melt(meanstd, id=c("subjectID","activity"))

#now, extract the mean for each feature accordingly to each activity and subject id
organizeddata<-dcast(melted, subjectID+activity~variable, mean)

#checking the rownames
rownames(organizeddata)

#write the organized data
write.csv(organizeddata,"organized.csv", row.names = FALSE)
