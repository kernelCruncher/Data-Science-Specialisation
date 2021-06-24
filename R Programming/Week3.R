## Put comments here that give an overall description of what your
## functions do

## This function (makeCacheMatrix) outputs a list of useful functions (get, set, setMatrixInverse, getMatrixInverse) to be invoked 
## by a subsequent function (cacheSolve). Within makeCacheMatrix the inverse of the inputted matrix (x) is stored as the variable 'm' 
## when it is externally calculated.

makeCacheMatrix <- function(x = matrix()) {
  m <- NULL
  
  set <- function(y) {
    x <<- y
    m <<- NULL
  }
  get <- function() x
  setMatrixInverse <- function(solved) m <<- solved
  getMatrixInverse <- function() m
  
  list(set = set, get = get,
       setMatrixInverse = setMatrixInverse,
       getMatrixInverse = getMatrixInverse)
  
}


## Here the real work is done. If the makeCacheInverse is inputted as a  parameter
## in the cacheSolve function then cacheSolve looks to see if the variable m is set in
## makeCacheMatrix which corresponds to the inverse. If it is, the function returns
##this value. If not, the inverse is calculated in the cacheSolve function and stored
#in the makeCacheMatrix function

cacheSolve <- function(x, ...) {
  m <- x$getMatrixInverse()
  
  if(!is.null(m)) {
    
    message("getting cached data")
    
    return(m)
  }
  
  data <- x$get()
  m <- solve(data, ...)
  x$setMatrixInverse(m)
  
  m
}
