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
  hospital <- split(data[,outcome], data$State)
  stateValue <- sort(hospital[[state]])
  
  if (num == "best"){
    num <- 1
  }
  else if(num == "worst") {
    num <- length(stateValue)
  }
  else if(is.numeric(x=num)) {
    if(num < 1 || num > length(stateValue)) {
      return(NA)
    }
  }
 
  numValue <- stateValue[num]
  possibleRows <- data[data$State == state & data[,outcome]== numValue & !is.na(data[,outcome]),]
  possibleHospitals <- sort(possibleRows$Hospital.Name)
  
  possibleHospitals[1]
  
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
  hospital <- split(data[,outcome], data$State)
  
  hospitalList <- sapply(uniqueStateList, function (state) {
    
    stateValue <- sort(hospital[[state]])
    
    if (num == "best"){
      num <- 1
    }
    else if(num == "worst") {
      num <- length(stateValue)
    }
    
    numValue <- stateValue[num]
    possibleRows <- data[data$State == state & data[,outcome]== numValue & !is.na(data[,outcome]),]
    possibleHospitals <- sort(possibleRows$Hospital.Name)
    
    possibleHospitals[1]
    
  })
  
  frame <- cbind(hospitalList, uniqueStateList)
  dataframe <- data.frame(frame)
  colnames(dataframe)<- c("Hospital","State")
  
  return(dataframe)
  
}