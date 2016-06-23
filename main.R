library(randomForest)
source("dognition_functions.R")

##I. Which dog feature(s) best determine dog activity pattern?

tests <- read.csv("test_complete.csv",header=T)

#Preprocessing
tests <- tests[!is.na(tests$neutered),]

tests$time <- as.factor(time_slot(tests$hour,tests$day,tests$month,day_sect=2))

#random forest classification
rf <- randomForest(time~gender+neutered+personality+weight+age+btype+bgroup,data=tests,ntree=100,importance=T)

#show variable importance (decrease in explained variation after permutation)
round(importance(rf,type=1,scale=T),2)

#Only month can be more accurately predicted; combined with before or after noon is also fine.

##II. Which dog features determine initiation timing and completion rate?

dogs <- read.csv("dog_list.csv",header=T)
dogs <- dogs[!is.na(dogs$neutered),]
dogs <- data.frame(time=as.factor(time_slot(0,0,dogs$month,day_sect=2)),dogs[,c(6:15)])

rfinit <- randomForest(time~gender+neutered+personality+age+weight+btype+bgroup,data=dogs,ntree=100,importance=T)
mean(rfinit$err.rate)

rfncomp <- randomForest(ntests~gender+neutered+weight+personality+age+btype+bgroup,data=dogs,ntree=100,importance=T)
rfncomp

lmncomp <- glm(ntests~gender+neutered+weight+personality+age+btype+bgroup,data=dogs)
summary(lmncomp)

#no pattern! initiation and completion rate are random.

##III. How similar in activitiy pattern are two dogs given their features?

#Make frequency tables for each feature (rows: feature levels; columns: month)
tests$age <- as.factor(c("0-1","2-4","5-7","7-10",">10"))[(tests$age>=0)+(tests$age>1)+(tests$age>4)+(tests$age>7)+(tests$age>10)]

tests$weight <- as.factor(c("0-19","20-49","50-89","90-139",">139"))[(tests$weight>=0)+(tests$weight>19)+(tests$weight>49)+(tests$weight>89)+(tests$weight>129)]

rf <- randomForest(as.factor(month)~gender+neutered+personality+weight+age+btype+bgroup,data=tests,ntree=100,importance=T)

feature_wts <- round(importance(rf,type=1,scale=T),2)

ftables <- list()
features <- c("gender","neutered","weight","personality","age","btype","bgroup")
for(i in 1:length(features)){
	ftables[[i]] <- feature_time_table(tests[,names(tests)==features[i]], tests$month)
}
names(ftables) <- features

#calculate the overall time distribution
average <- colSums(ftables[[4]])/dim(ftables[[4]])[1]
average <- average/sum(average)

#Given values for all features, generate a time trend (weighted sum over all features)
vs1 <- c("female","1","0-19","ace","0-1","Pure Breed","Working")
trend1 <- get_trend(vs1,ftables,feature_wts,average)

vs2 <- c("male","0",">139","stargazer","7-10","Cross Breed","Toy")
trend2 <- get_trend(vs2,ftables,feature_wts,average)

vs3 <- c("female","1",">139",NA,"7-10","Pure Breed","Working")
trend3 <- get_trend(vs3,ftables,feature_wts,average)

plot_trend(trend1,average,graph=T,index=1)
plot_trend(trend2,average,graph=F,index=2)
plot_trend(trend3,average,graph=F,index=3)
legend("topright",c(paste("dog",1:3),"average"),lty=c(rep(1,3),2),col=c(1:3,1))

trend_similarity(trend1,trend2,average)
trend_similarity(trend3,trend2,average)
trend_similarity(trend1,trend3,average)
