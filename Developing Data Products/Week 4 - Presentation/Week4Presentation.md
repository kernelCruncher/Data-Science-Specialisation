Shiny Application
========================================================
author: Peter P.
date: 
autosize: true
transition:rotate

Introduction
========================================================

I created a Shiny application that used the USArrests data set.


```r
data("USArrests")
str(USArrests)
```

```
'data.frame':	50 obs. of  4 variables:
 $ Murder  : num  13.2 10 8.1 8.8 9 7.9 3.3 5.9 15.4 17.4 ...
 $ Assault : int  236 263 294 190 276 204 110 238 335 211 ...
 $ UrbanPop: int  58 48 80 50 91 78 77 72 80 60 ...
 $ Rape    : num  21.2 44.5 31 19.5 40.6 38.7 11.1 15.8 31.9 25.8 ...
```

Overview
========================================================

The user was asked to input an Urban Popualtion Percentage and specify 
(using a radio button) whether they wished to predict the number of Murders,
Rapes or Assaults. A plot would then appear along with a prediction for what
the Murder/Rape/Assault value would be for that Urban Population Percentage.


A linear model was fitted using the `lm` function to obtain the result. The validity of such a model was not explored. Also, `switch` statements were instrumental in getting this code to perform as expected.

Server Calculations
============================================================

Here is an extract of the server code

```r
model1<-lm(Murder~UrbanPop, data = USArrests)
  model2<-lm(Rape~UrbanPop, data = USArrests)
  model3<-lm(Assault~UrbanPop, data = USArrests)
  model1pred<- reactive({
    urbanInput<-input$sliderUrb
    predict(model1, newdata = data.frame(UrbanPop=urbanInput))})
```

Link
============================================================
See the application for yourself at:

https://kernelcruncher.shinyapps.io/USArrestsApp/

