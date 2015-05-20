#Script assumes that we're in a working directory containing the folder for the training data - UCI_HAR_Dataset
#Load the libraries we're using
library(dplyr)
library(tidyr)

# Store locations of all the files in 2 variables
x_locations <- c(
        "UCI_HAR_Dataset//test//X_test.txt",
        "UCI_HAR_Dataset//train//X_train.txt")

y_locations <- c(
        "UCI_HAR_Dataset//test//y_test.txt",
        "UCI_HAR_Dataset//train//y_train.txt")

subject_locations <- c(
        "UCI_HAR_Dataset//test//subject_test.txt",
        "UCI_HAR_Dataset//train//subject_train.txt")

features <- "UCI_HAR_Dataset//features.txt"

# Read in the X data - X_train.txt and X_test.txt
x_dataset <- read.table(x_locations[1], header=FALSE)
# Read in the subject dataset and column bind it to the x_dataset
subject_test_dataset <- read.table(subject_locations[1], header=FALSE)
colnames(subject_test_dataset) <- "subject"
x_dataset <- cbind(x_dataset, subject_test_dataset)

# Read in the training data along with the subject data & bind the dataframes
temp_x_dataset <- read.table(x_locations[2], header=FALSE)
subject_train_dataset <- read.table(subject_locations[2], header=FALSE)
colnames(subject_train_dataset) <- "subject"
temp_x_dataset <- cbind(temp_x_dataset, subject_train_dataset)

#Bind the two x datasets by combining all rows
x_dataset <- rbind(x_dataset, temp_x_dataset)

# Read in the Y data - y_train.txt and y_test.txt
y_dataset <- read.table(y_locations[1], header=FALSE)
temp_y_dataset <- read.table(y_locations[2], header=FALSE)
# Bind the two y-datasets by combining all rows
y_dataset <- rbind(y_dataset, temp_y_dataset)
colnames(y_dataset) <- "label"


# Get the features from the feature text file and store in vector
feature_list <- read.table(features)
feature_list <- feature_list[2] # First column contained row numbers so we ignore this

#Transpose feature list and make it the column names for the x_dataset
feature_list <- t(feature_list)
feature_list <- feature_list[1, ]
feature_list <- append(feature_list, "subject") # We are missing subject from the feature file so add it in here
colnames(x_dataset) <- make.names(names=feature_list)

#Combine the x and y dataset by columns
combined_dataset <- cbind(x_dataset, y_dataset)

#Change the numbers in the "label" field to represent the appropriate activity
combined_dataset$label[combined_dataset$label == 1] <- "WALKING"
combined_dataset$label[combined_dataset$label == 2] <- "WALKING_UPSTAIRS"
combined_dataset$label[combined_dataset$label == 3] <- "WALKING_DOWNSTAIRS"
combined_dataset$label[combined_dataset$label == 4] <- "SITTING"
combined_dataset$label[combined_dataset$label == 5] <- "STANDING"
combined_dataset$label[combined_dataset$label == 6] <- "LAYING"



# We want to extract the names of the columns that have mean or std in them and then properly
# format it by removing the full stops and replacing with one underscore
cols_to_extract = grep("mean|std|subject|label", tolower(names(combined_dataset)))
combined_dataset <- combined_dataset[, cols_to_extract]
fix_names <- gsub("\\.+", "_", names(combined_dataset))
colnames(combined_dataset) <- fix_names # Assign the new column names to the combined dataset


# Clean up columns into more meaningful names. Store it temporarily in a variable called 'new_names'
# Convert to lower case and replace the following:
#bodyacc -> body_acceleration
#gravityacc -> gravity_acceleration
#The 't' at the beginning to 'time_domain'
#The 'f' at the beginning to 'fft
#mag -> magnitude
new_names <- tolower(names(combined_dataset))
new_names <- gsub("bodyacc", "_body_acceleration_", new_names)
new_names <- gsub("gravityacc", "_gravity_acceleration_", new_names)
new_names <- gsub("__", "_", new_names) # Replace all double underscores with only one underscore
new_names <- gsub("^t", "time_domain_", new_names)
new_names <- gsub("^f", "fft_", new_names)
new_names <- gsub('mag', '_magnitude_', new_names)
new_names <- gsub("--", "_", new_names)

# Assign the new column names to the combined_dataset
colnames(combined_dataset) <- new_names

#Final part of assignment. We're going to gather the subject and the label

# We first convert the subject and label fields into factors so we can use it for classification
combined_dataset$subject <- factor(combined_dataset$subject)
combined_dataset$label <- factor(combined_dataset$label)

# Collapse the dataset into subject, label, variable and value
tidy_dataset <- melt(combined_dataset, id=c("subject", "label"))

# Use dplyr functions to group bt the subject, label and variable and calculate the means of each combination
tidy_dataset<- tidy_dataset %>% group_by(subject, label, variable) %>% summarise_each(funs(mean))

#Rename the 'value' column to mean_vale'
tidy_dataset <- dplyr::rename(tidy_dataset, mean_value = value)

#Output to file for submission
write.table(tidy_dataset, file="tidy_dataset.txt",row.names=FALSE)