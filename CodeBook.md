# CodeBook

This document describes the data, the variables, and the modifications that were performed in order to obtain a tidy dataset for the assignment.

Data were collected from accelerometers from the Samsung Galaxy S smartphone.

The following link contains a full decription of data: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

And the following information comes from the features_info.txt file:

**Feature Selection**

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation
mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean

The complete list of variables of each feature vector is available in 'features.txt'

Finally, the following information is related to the performed changes in order to clean up the data:

## 1. Merge the training and the test sets to create one dataset

### Clean up workspace

```{r}
rm(list = ls())
```

### Set working directory

```{r}
setwd("/Users/Henry/Dropbox/Education/JHU/Data Sience Specialization/3. Getting and Cleaning Data/wd_for_g_and_c_data")
```

### Import data

```{r}
features = read.table("/Users/Henry/Dropbox/Education/JHU/Data Sience Specialization/3. Getting and Cleaning Data/wd_for_g_and_c_data/features.txt", header = FALSE)

activity_labels = read.table("/Users/Henry/Dropbox/Education/JHU/Data Sience Specialization/3. Getting and Cleaning Data/wd_for_g_and_c_data/activity_labels.txt", header = FALSE)

subject_test = read.table("/Users/Henry/Dropbox/Education/JHU/Data Sience Specialization/3. Getting and Cleaning Data/wd_for_g_and_c_data/subject_test.txt", header = FALSE)

X_test = read.table("/Users/Henry/Dropbox/Education/JHU/Data Sience Specialization/3. Getting and Cleaning Data/wd_for_g_and_c_data/X_test.txt", header = FALSE)

y_test = read.table("/Users/Henry/Dropbox/Education/JHU/Data Sience Specialization/3. Getting and Cleaning Data/wd_for_g_and_c_data/y_test.txt", header = FALSE)

subject_train = read.table("/Users/Henry/Dropbox/Education/JHU/Data Sience Specialization/3. Getting and Cleaning Data/wd_for_g_and_c_data/subject_train.txt", header = FALSE)

X_train = read.table("/Users/Henry/Dropbox/Education/JHU/Data Sience Specialization/3. Getting and Cleaning Data/wd_for_g_and_c_data/X_train.txt", header = FALSE)

y_train = read.table("/Users/Henry/Dropbox/Education/JHU/Data Sience Specialization/3. Getting and Cleaning Data/wd_for_g_and_c_data/y_train.txt", header = FALSE)
```

### Get familiar with imported data

```{r}
str(features)

str(activity_labels)

str(subject_test)

str(X_test)

str(y_test)

str(subject_train)

str(X_train)

str(y_train)
```

### Assign names to columns

```{r}
colnames(activity_labels) = c("activityID", "activityType")

colnames(subject_test) = "subjectID"

colnames(X_test) = features[, 2]

colnames(y_test) = "activityID"

colnames(subject_train) = "subjectID"

colnames(X_train) = features[, 2]

colnames(y_train) = "activityID"
```

### Check labels

```{r}
head(activity_labels)

head(subject_test)

head(X_test)

head(y_test)

head(subject_train)

head(X_train)

head(y_train)
```

### Merge data

```{r}
testData = cbind(subject_test, X_test, y_test)

trainingData = cbind(subject_train, X_train, y_train)

finalData = rbind(testData, trainingData)
```


### Check final dataset

```{r}
str(finalData)

head(finalData)
```

## 2. Extract only the measurements on the mean and standard deviation for each measurement

### Create a vector for the column names

```{r}
colNames = colnames(finalData)
```

### Create a logical vector that contains the TRUE values for ID, mean, and standard deviation columns

```{r}
logical = (grepl("activity..", colNames) | grepl("subject..", colNames) | grepl("-mean..", colNames) & !grepl("-meanFreq..", colNames) & !grepl("mean..-", colNames) | grepl("-std..", colNames) & !grepl("-std()..-", colNames))
```

```{r}
finalData = finalData[logical == TRUE]
```

## 3. Use descriptive activity names to name the activities of the data set

```{r}
finalData = merge(finalData, activity_labels, by = 'activityID', all.x = TRUE)
```

```{r}
str(finalData)

head(finalData)
```

## 4. Label the dataset appropriately with descriptive variable names

### Update column names
```{r}
colNames = colnames(finalData)
```

### Change the names

```{r}
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
```

### Assign the descriptive names to the dataset
```{r}
colnames(finalData) = colNames
```

### Check the changes

```{r}
head(finalData)
```

## 5. Create a second independent tidy dataset, from the data in step 4, with the average of each variable for each activity and each subject

### Create a new dataset without the activityType column

```{r}
newData <- finalData[, names(finalData) != 'activityType']
```

### Aggregate newData by activityID & subjectID

```{r}
tidydata = aggregate(newData[, names(newData) != c('activityID', 'subjectID')], by = list(activityID = newData$activityID, subjectID = newData$subjectID), mean)
```

### Merge

```{r}
tidydata = merge(tidydata, activity_labels, by = 'activityID', all.x = TRUE)
```

```{r}
head(tidydata)
```

### Export dataset

```{r}
write.table(tidydata, "/Users/Henry/Dropbox/Education/JHU/Data Sience Specialization/3. Getting and Cleaning Data/wd_for_g_and_c_data/tidydata.txt", row.names = FALSE)
```
