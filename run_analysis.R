mdir<-"./UCI HAR Dataset"

# 1
# Read and merge data
###########################################################################

#Read activity labels and features from files

activitylabels <- read.table(paste(mdir, "/activity_labels.txt", sep =""))
features <- read.table(paste(mdir, "/features.txt", sep =""))

#Read and merge X_train and X_test (measurements) data from files
xdata <- read.table(paste(mdir, "/train/X_train.txt", sep = ""))
xdata <- rbind(xdata, read.table(paste(mdir, "/test/X_test.txt", sep = "")))

#Read and merge y_train and y_test (activity) data from files 
ydata <- read.table(paste(mdir, "/train/y_train.txt", sep = ""))
ydata <- rbind(ydata, read.table(paste(mdir, "/test/y_test.txt", sep = "")))

#Read and merge subject_train and subject_test (subject) data from files
subject <- read.table(paste(mdir, "/train/subject_train.txt", sep = ""))
subject <- rbind(subject, read.table(paste(mdir, "/test/subject_test.txt", sep = "")))

# 2
# Extract only measurements on the mean and standard deviations for each measurement
#######################################################################################
xdata <- xdata[grepl("mean|std", as.character(features[,2]))]

# 3
# use descriptive activity names to name the activities in the data set
#######################################################################################
data_set<-cbind(ydata, subject, xdata)
l <- nrow(data_set)
for(i in 1:l ){ data_set[i,1] <- as.character(activitylabels[data_set[i,1],2])}

# 4
# Appropriately labels the data set
#######################################################################################
names(data_set) <- c("activity", "subject", as.character(features[grep("mean|std",features[,2]),2]))

# 5
# From the data set in step 4, creates a second, independent tidy data set with the 
# average of each variable for each activity and each subject
######################################################################################
tidy_data <- aggregate(data_set[3:81], by = list(activity = data_set$activity, subject = data_set$subject), mean)

write.table(tidy_data, "./data.txt", row.names = FALSE, sep = "\t")
