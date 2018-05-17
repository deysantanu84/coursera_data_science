library(plyr)

# Download Dataset.zip
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="./data/Dataset.zip")

# Unzip DataSet.zip into /data directory
unzip(zipfile="./data/Dataset.zip", exdir="./data")

# Step 1
# Merging the training and the test sets to create one data set
# Read training sets X_train.txt, y_train.txt and subject_train.txt
x_trng <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_trng <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_trng <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# Read testing sets X_test.txt, y_test.txt and subject_test.txt
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# create 'x' data set
x_data <- rbind(x_trng, x_test)

# create 'y' data set
y_data <- rbind(y_trng, y_test)

# create 'subject' data set
subject_data <- rbind(subject_trng, subject_test)

# Step 2
# Extract only the measurements on the mean and standard deviation for each measurement
features <- read.table('./data/UCI HAR Dataset/features.txt')

# get only columns with mean() or std() in their names
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

# subset the desired columns
x_data <- x_data[, mean_and_std_features]

# Step 3
# Use descriptive activity names to name the activities in the data set
activity_labels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

# update values with correct activity names
y_data[, 1] <- activity_labels[y_data[, 1], 2]

# Step 4
# Appropriately label the data set with descriptive variable names
names(x_data) <- features[mean_and_std_features, 2]
names(y_data) <- "activity"
names(subject_data) <- "subject"

# Merging into a single data set
all_data <- cbind(x_data, y_data, subject_data)

# Step 5
# Create a second, independent tidy data set with the average of each variable
# for each activity and each subject
# 66 <- 68 columns but last two (activity & subject)
tidyDataSet <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(tidyDataSet, "tidyDataSet.txt", row.name=FALSE)
