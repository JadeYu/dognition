
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
        choices = c("female","male","all"),
        selected = "all"),
      selectInput("neutered1", 
        label = "Neutered",
        choices = c("Yes"=1,"No"=0,"all"),
        selected = "all"),
      selectInput("weight1", 
        label = "Weight (lbs)",
        choices = c("0-19","20-49","50-89","90-139",">139","all"),
        selected = "all"),
      selectInput("age1", 
        label = "Age",
        choices = c("0-1","2-4","5-7","7-10",">10","all"),
        selected = "all"),
      #selectInput("btype1", 
        #label = "Breeding type",
        #choices = c("Pure Breed","Mixed Breed/ Other","Popular Hybrid","Cross Breed","all"),
       # selected = "all"),
      selectInput("bgroup1", 
        label = "Breeding group",
        choices = c("Toy","Herding","Non-Sporting Hound","Working","Terrier","Sporting","all"),
        selected = "all")
      ),
      column(5,
     h4(helpText("Dog 2")),
      selectInput("gender2", 
        label = "Gender",
        choices = c("female","male","all"),
        selected = "all"),
      selectInput("neutered2", 
        label = "Neutered",
        choices = c("Yes"=1,"No"=0,"all"),
        selected = "all"),
      selectInput("weight2", 
        label = "Weight (lbs)",
        choices = c("0-19","20-49","50-89","90-139",">139","all"),
        selected = "all"),
      selectInput("age2", 
        label = "Age",
        choices = c("0-1","2-4","5-7","7-10",">10","all"),
        selected = "all"),
      #selectInput("btype2", 
        #label = "Breeding type",
       # choices = c("Pure Breed","Mixed Breed/ Other","Popular Hybrid","Cross Breed","all"),
       # selected = "all"),
      selectInput("bgroup2", 
        label = "Breeding group",
        choices = c("Toy","Herding","Non-Sporting Hound","Working","Terrier","Sporting","all"),
        selected = "all")
      )),
      checkboxInput("month", "Show monthly activeness"),
      fluidRow(
      column(3,helpText("Matching score = ")),
      column(3,h3(textOutput("day.score"))),
      column(3,actionButton("calculate","Calculate"))
      ),
      h5(textOutput("comment")),
      helpText("(See below the graphs for how the score is calculated.)")   
     ),
    mainPanel(
     fluidRow(
     column(2,imageOutput("dog",width = 80,
         height = 50)),
     column(9,helpText("This app compares the activeness pattern (across different months throughout the year) between two dogs and gives a matching score. Data is obtained from",a(href="https://www.dognition.com/","Dognition",target="_blank")))),
      conditionalPanel(
      condition = "input.calculate == 0",
      imageOutput("wait",width=600,height=500)
      ),
      conditionalPanel(
      condition = "input.month > 0",
      plotOutput("year",width=600,height=200),
      helpText("(Activeness level - the Y axis - is the proportion of ", a(href="https://www.dognition.com/","Dognition",target="_blank")," games completed in the given month averaged across all dogs with the given features).")
      ),
      conditionalPanel(
      condition = "input.calculate > 0",
      plotOutput("PCA",width=600,height=400),
      helpText("(Principal component analysis for when games are accomplished for each dog gives two principal components strongly correlated with morning hours and late hours, respectively)"),
      plotOutput("day.comp",width=600,height=200),
      helpText("(Above shows the distribution of distances between any two dogs on the PCA map. Distance between the given two dogs is highlighted by the red line. The matching score is 100 * (1- p), where p is the one-tailed p value, or the proportion of distances smaller than the distance between the given two dogs.)")
      ),
      helpText("Codes and data can be found in:",
      a(href="https://github.com/JadeYu/dognition.git","GitHub",target="_blank"))
    )
  )
))
