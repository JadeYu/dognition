##functions for PCA analysis of within-day activeness

time_div <- function(time,division="day",sect){#divide a time unit into subunits (e.g. year to seasons) and return numeric codes (1,2,3,...)
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

##functions for trend (across months) similarity analysis 
time_slot <- function(hour,day,month,day_sect=2){#make a distinct code for each month-day of the week-hour of the day combination
	time <- month*10 + day 
	for(i in 1:(day_sect-1)){
		time <- time + 1/day_sect*(hour > 24/day_sect*i)
	}
	time
}

#for a given feature, generate a table each row of which is the frequency distribution among time slots at the corresponding level of the feature
feature_time_table <- function(feature, time){
	values <- sort(unique(feature))
	result <- t(matrix(unlist(lapply(values,time_profile,feature=feature,time=time)),ncol=length(values)))
	colnames(result) <- sort(unique(time))
	rownames(result) <- values
	result
}

#for a given level of a feature, returns the frequency distribution among time slots
time_profile <- function(v,feature,time){
	nt <- sort(unique(time))
	profile <- numeric(length(nt))
	for(i in 1:length(nt)){
		profile[i] <- sum((feature==v)*(time==nt[i]))
	}
	profile
}

#for given values of all features, returns the frequency distribution among time slots (weight-averaged over all features)
get_trend <- function(vs,ftables,wts,average){
	wts <- wts/sum(wts)
	trend <- numeric(dim(ftables[[1]])[2])
	for(i in 1:length(vs)){
		rftable <- ftables[[i]]/rowSums(ftables[[i]])
		index <- match(vs[i],rownames(rftable))
		if(!is.na(index)){
			trend <- trend+wts[i]*rftable[index,]
		}else{
			trend <- trend+wts[i]*average
		}
	}
	trend
}

#plot the time distribution
plot_trend <- function(trend,average,ulim,graph,index){
	time <- 1:12
	if(graph){
		par(bg="floralwhite")
		plot(trend^2~time,xlab="Month",ylab="Activeness",ylim=c(0,ulim),yaxt='n',col=0,cex.lab=1.5,cex.axis=1.5)
		lines(time,average^2,lty=2,col=2,lwd=2)
	}
	lines(time,trend^2,lty=1,col=index+2,lwd=2)
}

#calculate similarity between two time distributions
trend_similarity <- function(trend1,trend2,average){
	simi <- cor(trend1,trend2)
	#compare to average; similarity should be 0.5 when compared to average
	contra <- min(cor(trend2,average),cor(trend1,average))
	0.5*(simi-contra)/(1-contra)+0.5
}

comment <- function(score){
	c("The two dogs are not compatible;b","Their compatibility is average - Meh","Their activeness pattern match pretty well~","They match perfectly!")[(score>-100)+(score>0.3)+(score>0.7)+(score>0.9)]
}