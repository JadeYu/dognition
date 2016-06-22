time_slot <- function(hour,day,month,day_sect=2){#make a distinct code for each month-day of the week-hour of the day combination
	time <- month*10 + day 
	for(i in 1:(day_sect-1)){
		time <- time + 1/day_sect*(hour > 24/day_sect*i)
	}
	time
}