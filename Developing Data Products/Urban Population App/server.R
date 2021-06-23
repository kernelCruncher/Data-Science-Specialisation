library(shiny)
data("USArrests")
shinyServer(function(input, output) {

  model1<-lm(Murder~UrbanPop, data = USArrests)
  model2<-lm(Rape~UrbanPop, data = USArrests)
  model3<-lm(Assault~UrbanPop, data = USArrests)
  
  
  model1pred<- reactive({
    urbanInput<-input$sliderUrb
    predict(model1, newdata = data.frame(UrbanPop=urbanInput))
  })
  model2pred<- reactive({
    urbanInput<-input$sliderUrb
    predict(model2, newdata = data.frame(UrbanPop=urbanInput))
  })
  model3pred<- reactive({
    urbanInput<-input$sliderUrb
    predict(model3, newdata = data.frame(UrbanPop=urbanInput))
  })

  output$plot1 <- renderPlot({
    urbInput<-input$sliderUrb
    switch(input$dependent,"1"={
    plot(USArrests$UrbanPop, USArrests$Murder, xlab = "Urban Population Percentage", 
         ylab = "Murders", bty = "n", pch = 16, ylim = c(0,25))
    abline(model1, col= "red",lwd = 2)
        points(urbInput, model1pred(), col = "red",pch = 16, cex =2)},
    "2"={plot(USArrests$UrbanPop, USArrests$Rape, xlab = "Urban Population Percentage", 
              ylab = "Rapes", bty = "n", pch = 16)
      abline(model2, col= "red",lwd = 2)
      points(urbInput, model2pred(), col = "red",pch = 16, cex =2)},
    "3"={ plot(USArrests$UrbanPop, USArrests$Assaults, xlab = "Urban Population Percentage", 
                 ylab = "Assaults", bty = "n", pch = 16, ylim=c(45,190), xlim=c(32,91))
    abline(model3, col= "red",lwd = 2)
    points(urbInput, model3pred(), col = "red",pch = 16, cex =2)})
  })
  
  output$predType <- renderText({switch(input$dependent,"1"= "Murders",
                             "2"="Rapes",
                             "3"="Assaults")})
  output$predValue <- renderText({
    switch(input$dependent,"1"= model1pred(),
           "2"=model2pred(),
           "3"=model3pred())
  })
})
