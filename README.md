# Practical-Machine-Learning_Course-Project
Prediction Assignment - Classifying Manner of Exercises

### Executive Summary
The goal of the project is to predict the manner in which individuals did a certain exercise. In this project, the goal is to use data from accelerometers on the belt, forearm, arm, and dumbell of 6 participants.
### Target Variable
The outcome variable is classe, a factor variable with 5 levels. For this data set, “participants were asked to perform one set of 10 repetitions of the Unilateral Dumbbell Biceps Curl in 5 different fashions:

- exactly according to the specification (Class A)
- throwing the elbows to the front (Class B)
- lifting the dumbbell only halfway (Class C)
- lowering the dumbbell only halfway (Class D)
- throwing the hips to the front (Class E)

Class A corresponds to the specified execution of the exercise, while the other 4 classes correspond to common mistakes." 

Prediction evaluations will be based on maximizing the accuracy and minimizing the out-of-sample error. All other available variables after cleaning will be used for prediction.
# Findings
## Basic Steps to Build the Model: 
0. "Set the seed." Ensure reproducibility for the model.
1. Read in the dataset
2A. Preserve only the variables that included data in at least 98% of records. This removed 100 variables. (160 to 60)
2B. Remove 7 additional variables that did not appear to have any predictive value. This included things like name and times of the records.
3. Partition the dataset. The original data came in two CSV files, one labeled 'training' and one labeled 'testing.' The test dataset included the final 20 questions for the final evaluation. In order to build the model without overfitting, I split the training set randomly in a 70/30 split into a training subset and validation set. This validation is used to test the accuracy of the models. 
4. Build & train the models! By attempting to predict the classe, the proper algorithm to use for the model needed to work with factor variables. (i.e. a classification problem) With this in mind, I built two models and compared the prediction accuracy of each to decide the best fit.
4A. Attempt 1 - Random Forest. Out-of-the-box random forest model from the randomForest R package produced the greatest accuracy. 
4B. Attempt 2 - Generalized Boosted Model. Despite using custom tuning parameters (3-fold cross validation), this model did not perform as well as the random forest model. This model's accuracy was 96.18%.
5. Test each model against the validation set and examine the accuracy.
6. Predict using the best model (Random Forest) against the test set.

## Prediction Results using a Random Forest model: 
Accuracy: 99.42%
Out of Sample Error Rate: .58%

### Problem Background
Using devices such as Jawbone Up, Nike FuelBand, and Fitbit it is now possible to collect a large amount of data about personal activity relatively inexpensively. These type of devices are part of the quantified self movement - a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks. One thing that people regularly do is quantify how much of a particular activity they do, but they rarely quantify how well they do it. In this project, your goal will be to use data from accelerometers on the belt, forearm, arm, and dumbell of 6 participants. They were asked to perform barbell lifts correctly and incorrectly in 5 different ways. 

More information is available from the website here: http://web.archive.org/web/20161224072740/http:/groupware.les.inf.puc-rio.br/har (see the section on the Weight Lifting Exercise Dataset).
