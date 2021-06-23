---
output: 
  html_document:
    keep_md: TRUE

---

Practical Machine Learning Assignment
============================================

###Data processing and Cross-Validation
We load the data and relevant libraries. First we remove those variables that are either mostly NA or are just for naming. We divide the data into two sets since we intend to use a random forest algorithm, and this does not require k-fold validation.

```r
library(caret)
library(e1071)
traindata<-read.csv("pml-training.csv",na.strings=c("NA","#DIV/0!", ""))
traindata<-traindata[,-(1:5)]
naMost<- sapply(traindata, function(x) mean(is.na(x))) > 0.95
traindata<-traindata[,naMost==FALSE]
```

We divide the data into two sets since we intend to use a random forest algorithm, and this does not require k-fold validation.

```r
train<-createDataPartition(y=traindata$classe, p=0.60, list=FALSE)
training<-traindata[train,]
testing<-traindata[-train,]
```

###Machine Learning Models
As we are trying to predict a factor variable we will use a Random Forest approach - it is also flexible, easy to use and produces very powerful results. We now this algorithm against the test portion of our training set.

```r
fit <- train(classe~.,method = "rf", data = training, ntree = 120)
prediction<-predict(fit, testing)
```
We now see that the accuracy is 99.68%.

```r
confusionMatrix(testing$classe, prediction)
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction    A    B    C    D    E
##          A 2231    0    0    0    1
##          B    2 1515    1    0    0
##          C    0    3 1364    1    0
##          D    0    0   12 1273    1
##          E    0    0    0    1 1441
## 
## Overall Statistics
##                                           
##                Accuracy : 0.9972          
##                  95% CI : (0.9958, 0.9982)
##     No Information Rate : 0.2846          
##     P-Value [Acc > NIR] : < 2.2e-16       
##                                           
##                   Kappa : 0.9965          
##  Mcnemar's Test P-Value : NA              
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity            0.9991   0.9980   0.9906   0.9984   0.9986
## Specificity            0.9998   0.9995   0.9994   0.9980   0.9998
## Pos Pred Value         0.9996   0.9980   0.9971   0.9899   0.9993
## Neg Pred Value         0.9996   0.9995   0.9980   0.9997   0.9997
## Prevalence             0.2846   0.1935   0.1755   0.1625   0.1839
## Detection Rate         0.2843   0.1931   0.1738   0.1622   0.1837
## Detection Prevalence   0.2845   0.1935   0.1744   0.1639   0.1838
## Balanced Accuracy      0.9995   0.9988   0.9950   0.9982   0.9992
```

###Conclusion
We load the data from the actual test set and get our predictions.

```r
testdata<-read.csv("pml-testing.csv",na.strings=c("NA","#DIV/0!", ""))
predict(fit, testdata)
```

```
##  [1] B A B A A E D B A A B C B A E E A B B B
## Levels: A B C D E
```
