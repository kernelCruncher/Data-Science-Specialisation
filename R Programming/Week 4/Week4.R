## Method 1
best <- function(state, condition){
  
  data<-read.csv("outcome-of-care-measures.csv", colClasses = "character")
  
    list<- c("heart attack" = "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack",
           "heart failure" = "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure",
           "pneumonia" = "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"             
)
    if (! condition %in% names(list)){
      stop("Invalid outcome")
    }
    
    if (!state%in% data$State){
      stop("Invalid state")
    }
    
    outcome <- list[[condition]]
    data[,outcome] <- as.numeric(data[,outcome])
  hospital <- split(data[,outcome], data$State)
  bestStateValue <- min(hospital[[state]], na.rm = TRUE)
  possibleRows <- data[data$State == state & data[,outcome]== bestStateValue & !is.na(data[,outcome]),]
  possibleHospitals <- sort(possibleRows$Hospital.Name)
  
  possibleHospitals[1]

}


##Method 2
rankHospital <- function(state, condition, num){
  
  data<-read.csv("outcome-of-care-measures.csv", colClasses = "character")
  
  list<- c("heart attack" = "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack",
           "heart failure" = "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure",
           "pneumonia" = "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"             
  )
  if (! condition %in% names(list)){
    stop("Invalid outcome")
  }
  
  if (!state %in% data$State){
    stop("Invalid state")
  }
  
  outcome <- list[[condition]]
  data[,outcome] <- as.numeric(data[,outcome])
 newTable <- data[data$State == state, c(outcome, "Hospital.Name")]
orderedTable <- newTable[order(newTable[,outcome], newTable$"Hospital.Name", na.last = NA),]  

  if (num == "best"){
    num <- 1
  }
  else if(num == "worst") {
    num <- nrow(orderedTable)
  }
  else if(is.numeric(x=num)) {
    if(num < 1 || num > nrow(orderedTable)) {
      return(NA)
    }
  }
  
  orderedTable[num, "Hospital.Name"]
  
}

## Method 3

rankall <- function(condition, num){
  
  data<-read.csv("outcome-of-care-measures.csv", colClasses = "character")
  
  list<- c("heart attack" = "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack",
           "heart failure" = "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure",
           "pneumonia" = "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia")
  outcome <- list[[condition]]
  
  if (!condition%in%names(list)){
    stop("Invalid outcome")
  }
  
  uniqueStateList <- unique(data$State)
  data[,outcome] <- as.numeric(data[,outcome])
  
  hospitalList <- sapply(uniqueStateList, function (state) {
    
    newTable <- data[data$State == state, c(outcome, "Hospital.Name")]
    orderedTable <- newTable[order(newTable[,outcome], newTable$"Hospital.Name", na.last = NA),]  
    
    if (num == "best"){
      num <- 1
    }
    else if(num == "worst") {
      num <- nrow(orderedTable)
    }
    
    orderedTable[num, "Hospital.Name"]
  })
  
  frame <- cbind(hospitalList, uniqueStateList)
  dataframe <- data.frame(frame)
  colnames(dataframe)<- c("hospital","state")
  
  return(dataframe)
  
}
