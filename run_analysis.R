rm(list=ls())
if(!file.exists("./R/getCleaningData")) dir.create("./R/getCleaningData")
setwd("./R/getCleaningData")

fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL,destfile="dataset.zip",mode="wb")
#load data in to memeory
xTrain=read.table("./UCI HAR dataset/train/X_train.txt")
yTrain=read.table("./UCI HAR dataset/train/y_train.txt")
sTrain=read.table("./UCI HAR dataset/train/subject_train.txt")
xTest=read.table("./UCI HAR dataset/test/X_test.txt")
yTest=read.table("./UCI HAR dataset/test/y_test.txt")
sTest=read.table("./UCI HAR dataset/test/subject_test.txt")
xname=read.table("./UCI HAR dataset/features.txt",colClasses=rep("character",2))
activity=read.table("./UCI HAR dataset/activity_labels.txt")
#1 merge training data and test data, x and y into one dataset
data=cbind(rbind(xTrain,xTest),rbind(yTrain,yTest),rbind(sTrain,sTest))
#4 give data columns with descriptive name
yname<-"activity_label"
xname[562:563,]<-c(yname,"subject_label")
colnames(data)<-xname[,2]
#2 select subdata with only mean and std data
library(dplyr)
subdata=select(data,contains("-std|-mean"),activity_label,subject_label)
#3 join the descriptive activity table into the activity_label in dataset
subdata=merge(subdata,activity,by.x="activity_label",by.y="V1")
subdata=select(subdata,-activity_label)
colnames(subdata)[81]<-yname
#5 create dataset for average of each variable and each subject and each activity
result=aggregate(x=subdata[,1:79],by=list(subdata$activity_label,subdata$subject_label),FUN="mean")
write.table(result,"groupmean.txt",row.names=FALSE)

