
#set working directory
setwd("S:/Documents/R")

#load R packages
library(data.table) # for quick file reading
library(caret) # for model building - ideal for classification & regression problems
library(randomForest) # for efficient random forest model building

set.seed(16) # for reproducibility

#download train/test datasets for evaluation
training <- fread("https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv", na.strings=c("NA","#DIV/0!",""))

#test dataset to be used for final evaluation only & will be ignored for all model building
testing <- fread("https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv", na.strings=c("NA","#DIV/0!",""))

#evaluate datasets
dim(training)
dim(testing) 
#as expected, test dataset contains 20 records for final evaluation

#convert to DF's
training <- as.data.frame(training)
testing <- as.data.frame(testing)

#Remove columns with >= 98% of NA or "" values
relevant_Columns <- !apply(training, 2, function(x) sum(is.na(x)) > .98  || sum(x=="") > .98)
training <- training[, relevant_Columns]
testing <- testing[,relevant_Columns]

#convert target variable to factor
training$classe <- as.factor(training$classe)
#include classe in testing set as NA
testing$classe <- as.factor(NA)

#review training and test sets again to remove additional unneeded columns
names(testing) # first seven variables can be removed based on our goal (times, username, etc.)
names(training)
testing[,1:7] <- NULL 
training[,1:7] <- NULL

#prep for cross validation in prediction mode
#since we already have the final test set, we'll create a validation set within the training dataset
inValidation <- createDataPartition(y = training$classe, p = .7, list = FALSE)
TrainingSet <- training[inValidation,]
ValidationSet <- training[-inValidation,]

dim(TrainingSet)
dim(ValidationSet)

# data exploration
#show breakdown of the classe variable (e.g. A = exercised performed as intended)
histogram(TrainingSet$classe, col = "blue", xlab = "Classe ~ Target Variable")
summary(TrainingSet$classe)

#Algorithm 1: Random Forest
#build the model
modFit_RF <- randomForest(classe ~ ., data = TrainingSet, ntree = 100, mtry = 16)
# modFit_RF_CV <- rfcv(TrainingSet, TrainingSet$classe, cv.fold = 3)

#predict using decision tree model against validation set
prediction_RF <-  predict(modFit_RF, ValidationSet)

#review accuracy against the validation set
confusionMatrix(prediction_RF, ValidationSet$classe)
---
        
#Algorithm 2: Generalized Boosted Model
#Tune the model: 
# utilize 3-fold cross validation to further break apart the training set and determine best model settings
# with GBM, the 3 tuning parameters checked will be trees, shrinkage, and interaction depth.
objControl <- trainControl(method='cv', number=3, returnResamp='none', classProbs = TRUE)

#train the model 
modFit_GBM <- train(classe ~.,
                  data = TrainingSet,
                  method='gbm', 
                  trControl=objControl,  
                  metric = "Accuracy",
                  preProc = c("center", "scale"))

#predict using GBM on the validation set
prediction_GBM <- predict(modFit_GBM, ValidationSet)

#review accuracy against the validation set
confusionMatrix(prediction_GBM, ValidationSet$classe)

#compare models
modelComp <- data.frame(rbind(confusionMatrix(prediction_RF, ValidationSet$classe)$overall, confusionMatrix(prediction_GBM, ValidationSet$classe)$overall))
rownames(modelComp) <- c("RF", "GBM")
print(modelComp) # across the board, the random forest model outperforms the generalized boosted model

#visualizations
plot(modFit_GBM) #displays model accuracy increases across cross validation sets as boosting iterations rise
plot(modFit_RF) # displays decreasing model error rate as # of trees expands
legend("topright", colnames(modFit_RF$err.rate), col = 1:5, cex=.8, fill = 1:5)

#display top 10 most important variables based on predictions for each model
varImp_GBM <- varImp(modFit_GBM, useModel = FALSE)
plot(varImp_GBM, top = 10)

#predictions against quiz questions
predict(modFit_RF, testing)