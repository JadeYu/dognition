library(randomForest)
source("dognition_functions.R")

tests <- read.csv("test_complete.csv",header=T)

dogs <- read.csv("dog_list.csv",header=T)

##I. Which dog feature(s) best determine dog activity pattern?

#combine month, day and hour into one variable

dog_tests <- data.frame(time=as.factor(time_slot(0,0,tests$month,day_sect=2)),tests[,c(6:13)])

#to see initiation time
test_dogs <- data.frame(time=as.factor(time_slot(0,0,dogs$month,day_sect=2)),dogs[,c(6:13)])

#Only month can be more accurately predicted; combined with before or after noon is also fine.

#random forest classification
rf <- randomForest(time~gender+weight+personality+age+weight+btype+bgroup,data=dog_tests,ntree=100,importance=T)
mean(rf$err.rate)

#no pattern! initiation is random.
rfd <- randomForest(time~gender+weight+personality+age+weight+btype+bgroup,data=test_dogs,ntree=100,importance=T)
mean(rfd$err.rate)

#show variable importance (decrease in explained variation after permutation)
round(importance(rf,type=1,scale=T),2)

##II. How similar in activitiy pattern are two dogs given their features?

#For each dog feature, create a pmi table (row: feature classes, column: time chunks) and calculate pmi among classes