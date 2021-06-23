NLP Prediciton Algortihm
========================================================
author: Peter P.
date: 25/01/2019
autosize: true
transition:rotate

Capstone Project Final Assignment

Description
========================================================

The app requires the user to input an incomplete sentence, or phrase, and produces
a ranked table of predictions for what the missing word could be. The input can include
punctuation and letters of any case - these are all accounted for in the algorithm.

See the app at 
https://kernelcruncher.shinyapps.io/NLPAssessment/

Algorithm: Idea
========================================================
The algorithm involves taking the sentence and running it against a set of 
3-, 2- and 1-grams that are stored with their frequencies in separate rmd files (which are loaded into the
shiny app at start up). Specifically, the final one or two words of the input are
searched against the initial entries in the stored n-grams and if an entry exists with these elements
then the missing word is correlated from the final n-grams component.


Algorithm: Extract
========================================================

```r
predictNextWord3Gram<-function(sentence){
  cleanlc<-cleaner(sentence)
  words<-unlist(strsplit(cleanlc, " "))
  wordLength<-length(words)
  finalTwo<- words[(wordLength-1):wordLength]
  pattern <- paste0(paste(paste0("^",finalTwo[1]),
                          finalTwo[2])," ")
  valid <- grepl(pattern, trigramBlog$word)
  if (sum(valid)>0){reduced<-trigramBlog[valid,]
    selectedWords<-na.omit(reduced$word[1:15])
    words2<-sapply(sapply(selectedWords, function(x) toString(x)),strsplit, " ", USE.NAMES = FALSE)
    sapply(words2, function(x) x[3]) }
  else {predictNextWord2Gram(sentence)}
}
```

Next Iteration Suggestions
==============================
- Due to limited processing power, I could only use a fraction of the original corpus data. With better
resources I would employ more of the data and therefore have a greater lexicon of n-grams to check against.

- To improve efficiency, I would parse the rmd files of n-grams so that of all those 3-grams with the same first two elements, only the most popular were kept. This would reduce the search time. Similarly, with 2-grams.

- I would extend to 4-grams, 5-grams, 6-grams . . . .
