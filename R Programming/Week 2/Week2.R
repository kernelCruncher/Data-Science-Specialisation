pollutantmean <- function(directory, pollutant, id = 1:332){
  
  filesDirect <- list.files(directory)
  totalSum <- 0
  totalRow <- 0
  
  for(i in id){
    
    table <- read.csv(paste(directory, filesDirect[i], sep = "/"))
    totalSum<- totalSum + sum(table[,pollutant], na.rm = TRUE)
    reducedTable<- table[, pollutant]
    totalRow <- totalRow + sum(!is.na(reducedTable))
    
  }
  
  totalSum/totalRow
}

  complete <- function(directory, id = 1: 332){
    
    filesDirect <- list.files(directory)
    monitors <- numeric()
    count <- numeric()
    
     for( i in id){
       
       table <- read.csv(paste(directory, filesDirect[i], sep = "/"))
       countNumber <- nrow(na.omit(table))
       
       monitors <- c(monitors, i)
       count <- c(count, countNumber)
       
     }
    
    frame <- cbind(monitors, count)
    dataframe <- data.frame(frame)
    colnames(dataframe)<- c("id", "nobs")
    
    return(dataframe)
  }
  
  corr <- function(directory, threshold = 0){
    
    filesDirect <- list.files(directory)
    corrVector <- numeric()
    
    for( i in 1:length(filesDirect)){
      
      table <- read.csv(paste(directory, filesDirect[i], sep = "/"))
      omittedTable <- na.omit(table)
      
      if (nrow(omittedTable) > threshold)
      {
        corrValue <- cor(omittedTable[,"sulfate"], omittedTable[,"nitrate"])
          corrVector <- c(corrVector, corrValue)
      }
      
        }
    
    return (corrVector)

  }