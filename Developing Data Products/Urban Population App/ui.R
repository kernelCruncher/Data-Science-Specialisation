library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Predict the number of Murders/Assaults/Rapes from Urban Population "),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
    sliderInput("sliderUrb",
                  "What is the Urban Population Percentage?",
                  min = 32,
                  max = 91,
                  value = 50),
      radioButtons("dependent", "What are you predicting?", choices=list("Murders"=1,"Rapes" =2, "Assaults"=3))
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("plot1"),
      h3("Prediction"),
      textOutput("predType"), textOutput("predValue")
    )
  )
))
