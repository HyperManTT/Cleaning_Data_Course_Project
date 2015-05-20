run_analysis.R

The script assumes that it’s in a directory containing the UCI_HAR_Dataset folder which contains the training and test data we are working with.

Algorithm
Reading in Data
- Store the x, y and subject file locations in three variables.
- Read in the x dataset from the test directory and the subject data from the subject_test file.
- Merge these two data frames into one by assigning the subject as a column to the test x_dataset
- Read in the x dataset from the train directory and the subject from the subject_train file
- Merge these two data frames into one by assigning the subject as a column to the train x_dataset
- Combine the two x datasets (train and test) into one large data frame by binding the rows
- Read in the y dataset from the two y files - test and train, into two data frames . 
- Combine the two data frames by binding the rows of the two data frames
- Read in the feature list from ‘features.txt’. 
- Convert this single column data frame into a single row data frame and assign it to the names of the x_dataset from above
- Merge the x and y datasets to form a combined_dataset.

Cleaning the Data
- Rename the label column in the combined_dataset from a number to text describing the activity
- Extract the mean and standard deviation columns from the combined_dataset
- Clean up the names by replacing full stops with underscores
- Rename column names to be more meaningful

Shaping Data
- Change the subject and label columns into factors
- Melt the data by the subject and label factor variables.
- Use dplyr’s group_by and summarise_each function to calculate the mean for each subject-label-variable.
- Output data to file.


Code Book
x_locations - The locations of the x training and test data files
y_locations - The locations of the y training and test data files
subject_locations - The locations of the subject training and test data files
features - The location of the feature file
x_dataset - Data frame containing the data from the x training dataset
subject_test_dataset - Data frame containing the subject data from the subject test dataset
temp_x_dataset - Temporary variable to store the x test dataset
subject_train_dataset - Data frame containing the subject data from the subject training dataset
feature_list - Single row vector that contains all the features
combined_dataset - Combination of all the above datasets into one large data frame
fix_names - Variable holding modified column names for the combined_dataset data frame
new_names - Variable to hold modified column names for the combined_dataset data frame
tidy_dataset - Dataset containing the mean for each subject and activity for each feature