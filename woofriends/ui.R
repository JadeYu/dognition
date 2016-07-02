
shinyUI(fluidPage(
  titlePanel("Woofriends: find the best friend for your dog!"),
  #move to main panel
  sidebarLayout(
    sidebarPanel(
     fluidRow(
     column(5,
     h4(helpText("Dog 1")),
      selectInput("gender1", 
        label = "Gender",
        choices = c("female","male","unknown"),
        selected = "unknown"),
      selectInput("neutered1", 
        label = "Neutered",
        choices = c("Yes"=1,"No"=0,"unknown"),
        selected = "unknown"),
      selectInput("weight1", 
        label = "Weight (lbs)",
        choices = c("0-19","20-49","50-89","90-139",">139","unknown"),
        selected = "unknown"),
      selectInput("age1", 
        label = "Age",
        choices = c("0-1","2-4","5-7","7-10",">10","unknown"),
        selected = "unknown"),
      #selectInput("btype1", 
        #label = "Breeding type",
        #choices = c("Pure Breed","Mixed Breed/ Other","Popular Hybrid","Cross Breed","unknown"),
       # selected = "unknown"),
      selectInput("bgroup1", 
        label = "Breeding group",
        choices = c("Toy","Herding","Non-Sporting Hound","Working","Terrier","Sporting","unknown"),
        selected = "unknown")
      ),
      column(5,
     h4(helpText("Dog 2")),
      selectInput("gender2", 
        label = "Gender",
        choices = c("female","male","unknown"),
        selected = "unknown"),
      selectInput("neutered2", 
        label = "Neutered",
        choices = c("Yes"=1,"No"=0,"unknown"),
        selected = "unknown"),
      selectInput("weight2", 
        label = "Weight (lbs)",
        choices = c("0-19","20-49","50-89","90-139",">139","unknown"),
        selected = "unknown"),
      selectInput("age2", 
        label = "Age",
        choices = c("0-1","2-4","5-7","7-10",">10","unknown"),
        selected = "unknown"),
      #selectInput("btype2", 
        #label = "Breeding type",
       # choices = c("Pure Breed","Mixed Breed/ Other","Popular Hybrid","Cross Breed","unknown"),
       # selected = "unknown"),
      selectInput("bgroup2", 
        label = "Breeding group",
        choices = c("Toy","Herding","Non-Sporting Hound","Working","Terrier","Sporting","unknown"),
        selected = "unknown")
      )),
      checkboxInput("plot", "Show monthly activeness"),
      fluidRow(
      column(3,helpText("Matching score = ")),
      column(3,h3(textOutput("score"))),
      column(3,actionButton("calculate","Calculate"))
      ),
      h5(textOutput("comment")),
      helpText("(100: perfect match; 50: average across all dogs in the database)")   
     ),
    mainPanel(
     fluidRow(
     column(2,imageOutput("dog",width = 80,
         height = 50)),
     column(9,helpText("This app compares the activeness pattern (across different months throughout the year) between two dogs and gives a matching score. Data is obtained from",a(href="https://www.dognition.com/","Dognition",target="_blank")))),
      conditionalPanel(
      condition = "input.plot == 0",
      imageOutput("wait",width=600,height=500)
      ),
      conditionalPanel(
      condition = "input.plot > 0",
      plotOutput("comparison",width=600,height=500),
      helpText("(Activeness level - the Y axis - is the proportion of ", a(href="https://www.dognition.com/","Dognition",target="_blank")," games completed in the given month averaged across all dogs with the given features).")
      ),
      helpText("Codes and data can be found in:",
      a(href="https://github.com/JadeYu/dognition.git","GitHub",target="_blank"))
    )
  )
))
