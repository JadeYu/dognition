#make a distinct code for each month-day of the week-hour of the day combination
time_slot <- function(hour,day,month,day_sect=2){
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
		plot(trend^2~time,xlab="month",ylab="activity",ylim=c(0,ulim),yaxt='n',col=0,cex.lab=1.5,cex.axis=1.5)
		lines(time,average^2,lty=2,col=1,lwd=2)
	}
	lines(time,trend^2,lty=1,col=index,lwd=2)
}

#calculate similarity between two time distributions
trend_similarity <- function(trend1,trend2,average){
	simi <- cor(trend1,trend2)
	#compare to average; similarity should be 0.5 when compared to average
	contra <- min(cor(trend2,average),cor(trend1,average))
	0.5*(simi-contra)/(1-contra)+0.5
}