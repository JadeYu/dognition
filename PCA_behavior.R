source("woofriends2.0/dognition_functions.R")
tests <- read.csv("test_complete.csv",header=T)
dogs <- read.csv("dog_list.csv",header=T)
dogs <- dogs[!is.na(dogs$neutered)&!is.na(dogs$mid),]
IDs <- dogs$dog_guid

#at first season information is also included but since it does not vary much across dog features, in the app I only use time of the day

#year_sect <- 4
#tests$season <- as.factor(time_slot(tests$month,"year",year_sect))
day_sect <- 4
tests$time <- as.factor(time_slot(tests$hour,"day",day_sect))
#season_distr <- matrix(nrow=length(IDs),ncol=year_sect)
day_distr <- matrix(nrow=length(IDs),ncol=day_sect)
for(i in 1:length(IDs)){
	data <- tests[tests$dog_guid==IDs[i],]
	#season_distr[i,] <- dog_distr(data$season,1:year_sect)
	day_distr[i,] <- dog_distr(data$time,1:day_sect)
}

#behaviors <- data.frame(season_distr,day_distr)
behaviors <- data.frame(day_distr)

#Principal component analysis
pca <- prcomp(behaviors,scale=T,center=T)
plot(pca,type="l")
summary(pca)
predictions <- predict(pca)
dogs$PC1 <- predictions[,1]
dogs$PC2 <- predictions[,2]

#Write down results
write.csv(dogs,"dog_list.csv")

