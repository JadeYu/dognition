source("dognition_functions.R")

features <- c("gender","neutered","personality","weight","age","btype","bgroup")
ftables <- list()
for(i in 1:length(features)){
	ftables[[i]] <- read.csv(paste(features[i],".csv",sep=""),header=T,row.names=1)
}
names(ftables) <- features

feature_wts <-  read.csv("feature_weights.csv",header=T,row.names=1)
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
     	vs1 = c(input$gender1,input$neutered1,"unknown",input$weight1,input$age1,"unknown",input$bgroup1)
  	 	vs2 = c(input$gender2,input$neutered2,"unknown",input$weight2,input$age2,"unknown",input$bgroup2)
  	 	trend1 <- as.numeric(get_trend(vs1,ftables,feature_wts,average))
  	 	trend2 <- as.numeric(get_trend(vs2,ftables,feature_wts,average))
  	 	similarity <- trend_similarity(trend1,trend2,average)
     	output$score <- renderText({as.character(round(similarity$score*100,2))})
     	output$comment <- renderText({similarity$comment})
     observeEvent(input$plot,{
       	output$comparison <- renderPlot({
  	 		ulim <- max(trend1^2,trend2^2)
     		plot_trend(trend1,average,ulim,graph=T,index=1)
			plot_trend(trend2,average,ulim,graph=F,index=2)
			legend("topleft",c(paste("Dog",1:2),"average"),lty=c(rep(1,2),2),lwd=2,col=c(3:4,2),cex=1.5)
     })  
     })
     })
  }
)
