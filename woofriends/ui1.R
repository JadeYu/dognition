shinyUI(fluidPage(
  titlePanel("Woofriends: find the best friend for your dog! "),
  #move to main panel
      helpText("This app compares the activity pattern between two dogs and gives a matching score (>50: better than average; < 50: worse than average). Data is obtained from"),a(href="https://www.dognition.com/","Dognition"),   
     h5(helpText("First dog")),
     fluidRow(
      column(2,selectInput("gender1", 
        label = "Gender",
        choices = c("female","male","unknown"),
        selected = "unknown")),
      column(2,selectInput("neutered1", 
        label = "Whether neutered",
        choices = c("Yes"=1,"No"=0,"unknown")),
        selected = "unknown"),
      column(2,selectInput("weight1", 
        label = "Weight (lbs)",
        choices = c("0-19","20-49","50-89","90-139",">139","unknown"),
        selected = "unknown")),
      column(2,selectInput("age1", 
        label = "Age",
        choices = c("0-1","2-4","5-7","7-10",">10","unknown"),
        selected = "unknown")),
       column(2,selectInput("btype1", 
        label = "Breeding type",
        choices = c("Pure Breed","Mixed Breed/ Other","Popular Hybrid","Cross Breed","unknown"),
        selected = "unknown")),
        column(2,selectInput("bgroup1", 
        label = "Breeding group",
        choices = c("Toy","Herding","Non-Sporting Hound","Working","Terrier","Sporting","unknown"),
        selected = "unknown"))      
      ),
      h5(helpText("Second dog")),
      fluidRow(
      column(2,selectInput("gender2", 
        label = "Gender",
        choices = c("female","male","unknown"),
        selected = "unknown")),
      column(2,selectInput("neutered2", 
        label = "Whether neutered",
        choices = c("Yes"=1,"No"=0,"unknown"),
        selected = "unknown")),
      column(2,selectInput("weight2", 
        label = "Weight (lbs)",
        choices = c("0-19","20-49","50-89","90-139",">139","unknown"),
        selected = "unknown")),
      column(2,selectInput("age2", 
        label = "Age",
        choices = c("0-1","2-4","5-7","7-10",">10","unknown"),
        selected = "unknown")),
      column(2,selectInput("btype2", 
        label = "Breeding type",
        choices = c("Pure Breed","Mixed Breed/ Other","Popular Hybrid","Cross Breed","unknown"),
        selected = "unknown")),
      column(2,selectInput("bgroup2", 
        label = "Breeding group",
        choices = c("Toy","Herding","Non-Sporting Hound","Working","Terrier","Sporting","unknown"),
        selected = "unknown"))
      ),
      fluidRow(
      column(4,
      fluidRow(
      checkboxInput("plot", "Show activity pattern")
      ),
      fluidRow(
      column(1,""),
      h5("Matching score ="),
      h3(textOutput("score")),
      actionButton("calculate","Calculate")
      )),
      column(8,
      conditionalPanel(
      condition = "input.plot == 0",
      imageOutput("wait",width=600,height=500)
      ),
      conditionalPanel(
      condition = "input.plot > 0",
      plotOutput("comparison",width=700,height=600)
      ))
      ),
      
      fluidRow(   
      column(4,
      helpText("Data and codes for analysis can be found in:"),
      a(href="https://github.com/adamkalman/CDIPS_2015.git","https://github.com/adamkalman/CDIPS_2015.git"),offset=2
      )
    )
))
