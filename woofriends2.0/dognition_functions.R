#make a distinct code for each month-day of the week-hour of the day combination
time_slot <- function(time,division="day",sect){
	if(division=="day"){
		whole <- 24
	}else if(division=="year"){
		whole <- 12
	}else{
		print("no such division")
		return()
	}
	slot <- rep(1,length(time))
	for(i in 1:(sect-1)){
		slot <- slot + (time > whole/sect*i)
	}
	slot
}

dog_distr <- function(time,slots){
	unlist(lapply(slots,function(s){sum(time==s)}))
}

dist_distr <- function(PC1,PC2){
	dist <- matrix(nrow=length(PC1),ncol=length(PC1))
	for(i in 1:(length(PC1)-1)){
		for(j in (i+1):length(PC1)){
			dist[i,j] <- dist[j,i] <- sqrt((PC1[i]-PC1[j])^2+(PC2[i]-PC2[j])^2)
		}
	}
	diag(dist) <- 0
	dist
}

map_dogs <- function(X,Y,style,color){
	points(X,Y,pch=style,col=color)
}

distance_pvalue <- function(dist,ID1,ID2,IDs){
	index1 <- match(ID1,IDs)
	index2 <- match(ID2,IDs)
	m <- mean(as.matrix(dist[index1,index2]))
	list(m=m,p=sum(as.matrix(dist)<m)/length(as.matrix(dist)))
}

dog_selection <- function(dogs,vs,features){
	features <- features[vs != "all"]
	vs <- vs[vs != "all"]
	#When no feature is selected, length(features)==0
	for(i in 1:length(features)){
		dogs <- dogs[dogs[,match(features[i],names(dogs))]==vs[i],]
	}
	list(ID=dogs$dog_guid,X=dogs$PC1,Y=dogs$PC2)
}
