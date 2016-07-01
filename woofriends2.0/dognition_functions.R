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

map_dogs <- function(dogs,vs,color){
	
}
