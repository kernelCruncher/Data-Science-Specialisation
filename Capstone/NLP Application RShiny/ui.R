library(shiny)

shinyUI(fluidPage(
  
  titlePanel(tags$b("Natural Language Processing Prediction Algorithm")),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       textInput("textId",
                   "Write your words here",
                  ""),
       actionButton("button", "Submit")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      h3(tags$u("Prediction (in descending likelihood):")),
      tableOutput("table")
    )
  )
))
