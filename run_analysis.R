#install 'data.table' and 'reshape2' package if it is not installed.
library("data.table")
library("reshape2")

# Read the activity labels
activity.labels <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")[,2]

# Read the data column names
features <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt")[,2]

# Read X_test & Y_test data.
X_test <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")

# Read X_train & Y_train data.
X_train <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")

subject.test <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")
subject.train <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")

names(X_test) = features

# Finds only the measurements on the mean and standard deviation for each measurement.
extract.features <- grepl("mean|std", features)

X_test = X_test[,extract.features]

# Load activity labels
Y_test[,2] = activity.labels[Y_test[,1]]
names(Y_test) = c("Activity.ID", "Activity.Label")
names(subject.test) = "subject"

# Binding test data
test.data <- cbind(as.data.table(subject.test), Y_test, X_test)

names(X_train) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
X_train = X_train[,extract.features]

# Load activity data
y_train[,2] = activity.labels[y_train[,1]]
names(y_train) = c("Activity.ID", "Activity.Label")
names(subject.train) = "subject"

# Binding training data
train.data <- cbind(as.data.table(subject.train), y_train, X_train)

# Merge test and train data
data.bind = rbind(test.data, train.data)

ids   = c("subject", "Activity.ID", "Activity.Label")
data.labels = setdiff(colnames(data.bind), ids)
melt.data   = melt(data.bind, id = ids, measure.vars = data.labels)

# Calculating mean to dataset using dcast function
tidy.data   = dcast(melt.data, subject + Activity.Label ~ variable, mean)

write.table(tidy.data, file = "./tidy_data.txt")
