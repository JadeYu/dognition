source("dognition_functions.R")
dogs <- read.csv("dog_list.csv",header=T)

dist <- read.csv("distance_matrix.csv",header=T,row.names=1)

features <- c("gender","neutered","personality","weight","age","btype","bgroup")

ftables <- list()
for(i in 1:length(features)){
	ftables[[i]] <- read.csv(paste("features/",features[i],".csv",sep=""),header=T,row.names=1)
}
names(ftables) <- features

feature_wts <-  read.csv("features/feature_weights.csv",header=T,row.names=1)
feature_wts <- feature_wts[,1]
average <- colSums(ftables[[4]])/dim(ftables[[4]])[1]
average <- average/sum(average)


shinyServer(function(input, output) {
	 output$dog <- renderImage({
        list(src = "dog_running.gif",
         contentType = 'image/gif',
         width = 80,
         height = 50,
         alt = "The cute pictures are stolen!Xb")
  }, deleteFile = F)
	 output$wait <- renderImage({
	 	num = sample(1:6,1)
       	filename = paste("wait",num,".png",sep="")
        list(src = filename,
         contentType = 'image/png',
         width = 600,
         height = 350,
         alt = "The cute pictures are stolen!Xb")
  }, deleteFile = F)
      
     observeEvent(input$calculate,{
     	vs1 = c(input$gender1,input$neutered1,"all",input$weight1,input$age1,"all",input$bgroup1)
  	 	vs2 = c(input$gender2,input$neutered2,"all",input$weight2,input$age2,"all",input$bgroup2)
  	 	selected_dogs1 <- dog_selection(dogs,vs1,features)
  	 	selected_dogs2 <- dog_selection(dogs,vs2,features)
  	 	     	
     output$PCA <- renderPlot({
     		par(bg="ghostwhite")
  	 		plot(dogs$PC2~dogs$PC1,,ylab="Night howler",xlab="Early riser",pch=16,col="yellow",xaxt='n',yaxt='n')
			map_dogs(selected_dogs1$X,selected_dogs1$Y,2,2)
			map_dogs(selected_dogs2$X,selected_dogs2$Y,3,4)
			legend("bottomright",paste("dog",1:2),pch=2:3,col=c(2,4))
     }) 
     
     distance <- distance_pvalue(dist,selected_dogs1$ID,selected_dogs2$ID,dogs$dog_guid)
     
     output$day.comp <- renderPlot({
     		par(bg="floralwhite")
  	 		hist(as.matrix(dist),xlab="distance",main="")
			abline(v=distance$m,col=2)
     }) 
     
     output$day.score <- renderText({as.character(round((1-distance$p)*100,2))})
     
     output$comment <- renderText({comment(1-distance$p)})
     
     observeEvent(input$month,{
       	output$year <- renderPlot({
       		trend1 <- as.numeric(get_trend(vs1,ftables,feature_wts,average))
  	 		trend2 <- as.numeric(get_trend(vs2,ftables,feature_wts,average))
  	 		similarity <- trend_similarity(trend1,trend2,average)
     		output$year.score <- renderText({as.character(round(similarity2)*2)})

  	 		ulim <- max(trend1^2,trend2^2)
     		plot_trend(trend1,average,ulim,graph=T,index=1)
			plot_trend(trend2,average,ulim,graph=F,index=2)
			legend("topleft",c(paste("Dog",1:2),"average"),lty=c(rep(1,2),2),lwd=2,col=c(3:4,2),cex=1.5)
     })  
     })
     })
  }
)
