# 1. Merge the training and the test sets to create one dataset

# Clean up workspace

rm(list = ls())

# Set working directory

setwd("/Users/Henry/Dropbox/Education/JHU/Data Sience Specialization/3. Getting and Cleaning Data/wd_for_g_and_c_data")

# Import data

features = read.table("/Users/Henry/Dropbox/Education/JHU/Data Sience Specialization/3. Getting and Cleaning Data/wd_for_g_and_c_data/features.txt", header = FALSE)

activity_labels = read.table("/Users/Henry/Dropbox/Education/JHU/Data Sience Specialization/3. Getting and Cleaning Data/wd_for_g_and_c_data/activity_labels.txt", header = FALSE)

subject_test = read.table("/Users/Henry/Dropbox/Education/JHU/Data Sience Specialization/3. Getting and Cleaning Data/wd_for_g_and_c_data/subject_test.txt", header = FALSE)

X_test = read.table("/Users/Henry/Dropbox/Education/JHU/Data Sience Specialization/3. Getting and Cleaning Data/wd_for_g_and_c_data/X_test.txt", header = FALSE)

y_test = read.table("/Users/Henry/Dropbox/Education/JHU/Data Sience Specialization/3. Getting and Cleaning Data/wd_for_g_and_c_data/y_test.txt", header = FALSE)

subject_train = read.table("/Users/Henry/Dropbox/Education/JHU/Data Sience Specialization/3. Getting and Cleaning Data/wd_for_g_and_c_data/subject_train.txt", header = FALSE)

X_train = read.table("/Users/Henry/Dropbox/Education/JHU/Data Sience Specialization/3. Getting and Cleaning Data/wd_for_g_and_c_data/X_train.txt", header = FALSE)

y_train = read.table("/Users/Henry/Dropbox/Education/JHU/Data Sience Specialization/3. Getting and Cleaning Data/wd_for_g_and_c_data/y_train.txt", header = FALSE)

# Get familiar with imported data

str(features)

str(activity_labels)

str(subject_test)

str(X_test)

str(y_test)

str(subject_train)

str(X_train)

str(y_train)

# Assign names to columns

colnames(activity_labels) = c("activityID", "activityType")

colnames(subject_test) = "subjectID"

colnames(X_test) = features[, 2]

colnames(y_test) = "activityID"

colnames(subject_train) = "subjectID"

colnames(X_train) = features[, 2]

colnames(y_train) = "activityID"

# Check labels

head(activity_labels)

head(subject_test)

head(X_test)

head(y_test)

head(subject_train)

head(X_train)

head(y_train)

# Merge data

testData = cbind(subject_test, X_test, y_test)

trainingData = cbind(subject_train, X_train, y_train)

finalData = rbind(testData, trainingData)

# Check final dataset

str(finalData)

head(finalData)

# 2. Extract only the measurements on the mean and standard deviation for each measurement

# Create a vector for the column names

colNames = colnames(finalData)

# Create a logical vector that contains the TRUE values for ID, mean, and standard deviation columns

logical = (grepl("activity..", colNames) | grepl("subject..", colNames) | grepl("-mean..", colNames) & !grepl("-meanFreq..", colNames) & !grepl("mean..-", colNames) | grepl("-std..", colNames) & !grepl("-std()..-", colNames))

finalData = finalData[logical == TRUE]

# 3. Use descriptive activity names to name the activities of the data set

finalData = merge(finalData, activity_labels, by = 'activityID', all.x = TRUE)

# 4. Label the dataset appropriately with descriptive variable names

# Update column names

colNames = colnames(finalData)

# Change the names

for (i in 1:length(colNames)) {
	colNames[i] = gsub("\\()", "", colNames[i])
	colNames[i] = gsub("-std$", "Std_Dev", colNames[i])
	colNames[i] = gsub("-mean", "Mean", colNames[i])
	colNames[i] = gsub("^(t)", "time", colNames[i])
	colNames[i] = gsub("^(f)", "freq", colNames[i])
	colNames[i] = gsub("([Gg]ravity)", "Gravity", colNames[i])
	colNames[i] = gsub("([Bb]ody[Bb]ody | [Bb]ody)", "Body", colNames[i])
	colNames[i] = gsub("([Gg]yro)", "Gyro", colNames[i])
	colNames[i] = gsub("AccMag", "Acc_Magnitude", colNames[i])
	colNames[i] = gsub("([Bb]odyaccjerkmag)", "Body_Acc_Jerk_Magnitude", colNames[i])
	colNames[i] = gsub("JerkMag", "Jerk_Magnitude", colNames[i])
	colNames[i] = gsub("GyroMag", "Gyro_Magnitude", colNames[i])
}

# Assign the descriptive names to the dataset

colnames(finalData) = colNames

# Check the changes

head(finalData)

# 5. Create a second independent tidy dataset, from the data in step 4, with the average of each variable for each activity and each subject

# Create a new dataset without the activityType column
newData <- finalData[, names(finalData) != 'activityType']

# Aggregate newData by activityID & subjectID

tidydata = aggregate(newData[, names(newData) != c('activityID', 'subjectID')], by = list(activityID = newData$activityID, subjectID = newData$subjectID), mean)

# Merge

tidydata = merge(tidydata, activity_labels, by = 'activityID', all.x = TRUE)

# Export dataset

write.table(tidydata, "/Users/Henry/Dropbox/Education/JHU/Data Sience Specialization/3. Getting and Cleaning Data/wd_for_g_and_c_data/tidydata.txt", row.names = FALSE)