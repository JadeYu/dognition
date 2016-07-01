source("woofriends2.0/dognition_functions.R")
dogs <- read.csv("dog_list.csv",header=T)

dist <- read.csv("distance_matrix.csv",header=T,row.names=1)

features <- c("gender","neutered","weight","age","bgroup")

plot(dogs$PC2~dogs$PC1,,ylab="Night howler",xlab="Early riser",pch=16,col="yellow",xaxt='n',yaxt='n')

vs = c("male",0,"all","all","Hound")

selected_dogs1 <- dog_selection(dogs,vs,features)

map_dogs(selected_dogs1$X,selected_dogs1$Y,2,2)

vs2 = c("female",1,"all","all","Sporting")

selected_dogs2 <- dog_selection(dogs,vs2,features)

map_dogs(selected_dogs2$X,selected_dogs2$Y,3,4)

legend("bottomright",paste("dog",1:2),pch=2:3,col=c(2,4))

distance <- distance_pvalue(dist,selected_dogs1$ID,selected_dogs2$ID,dogs$dog_guid)

compatibility <- 1- distance$p
compatibility

hist(as.matrix(dist),xlab="distance",main="")
abline(v=distance$m,col=2)

#classify weight and age!
#make a reminder for overconstrained selection!

