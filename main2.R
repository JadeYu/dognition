source("woofriends2.0/dognition_functions.R")
dogs <- read.csv("dog_list.csv",header=T)

plot(dogs$PC1~dogs$PC2,,xlab="PC2",ylab="PC1",pch=16,col="yellow")
