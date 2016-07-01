source("dognition_functions.R")

features <- c("gender","neutered","personality","weight","age","btype","bgroup")

dogs <- read.csv("dog_list.csv",header=T)



shinyServer(function(input, output) {
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
     	vs1 = c(input$gender1,input$neutered1,"unknown",input$weight1,input$age1,input$btype1,input$bgroup1)
  	 	vs2 = c(input$gender2,input$neutered2,"unknown",input$weight2,input$age2,input$btype2,input$bgroup2)
  	 	trend1 <- as.numeric(get_trend(vs1,ftables,feature_wts,average))
  	 	trend2 <- as.numeric(get_trend(vs2,ftables,feature_wts,average))
     	output$score <- renderText({as.character(round(trend_similarity(trend1,trend2,average)*100,2))})
     observeEvent(input$plot,{
       	output$comparison <- renderPlot({
  	 		ulim <- max(trend1^2,trend2^2)
     		plot_trend(trend1,average,ulim,graph=T,index=1)
			plot_trend(trend2,average,ulim,graph=F,index=2)
			legend("topleft",c(paste("Dog",1:2),"average"),lty=c(rep(1,2),2),lwd=2,col=c(1:2,1),cex=1.5)
     })  
     })
     })
  }
)
