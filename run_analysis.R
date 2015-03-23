## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#install 'data.table' and 'reshape2' package if it is not installed.
library("data.table")
library("reshape2")

# Load the activity labels
activity.labels <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")[,2]

# Load the data column names
features <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt")[,2]

# Load and process X_test & Y_test data.
X_test <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")

# Load and process X_train & Y_train data.
X_train <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")

subject_test <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")
subject.train <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")

names(X_test) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
extract.features <- grepl("mean|std", features)
# Extract only the measurements on the mean and standard deviation for each measurement.
X_test = X_test[,extract.features]

# Load activity labels
Y_test[,2] = activity.labels[Y_test[,1]]
names(Y_test) = c("Activity.ID", "Activity.Label")
names(subject_test) = "subject"

# Bind data
test_data <- cbind(as.data.table(subject_test), y_test, X_test)


names(X_train) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
X_train = X_train[,extract_features]

# Load activity data
y_train[,2] = activity_labels[Y_train[,1]]
names(Y_train) = c("Activity.ID", "Activity.Label")
names(subject_train) = "subject"

# Bind data
train.data <- cbind(as.data.table(subject.train), Y_train, X_train)

# Merge test and train data
data = rbind(test.data, train.data)

id.labels   = c("subject", "Activity.ID", "Activity.Label")
data.labels = setdiff(colnames(data), id.labels)
melt.data   = melt(data, id = id.labels, measure.vars = data.labels)

# Apply mean function to dataset using dcast function
tidy.data   = dcast(melt.data, subject + Activity.Label ~ variable, mean)

write.table(tidy.data, file = "./tidy_data.txt")
