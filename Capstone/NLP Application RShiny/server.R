library(shiny)
cleaner<- function(lines){
  badwords<-"(shit|fuck|prick|cunt)( |[^ ]*)"
  lines<-gsub("\\&", " and ", lines)
  lines<-gsub("'", "'", lines)
  lines<-gsub("[^[:alnum:][:space:]']", " ", lines)
  lines<-gsub(badwords, "", lines, ignore.case = TRUE)
  lines<-gsub("[0-9]", " ", lines)
  lines<-gsub(" +", " ", lines)
}

unigramBlog<-readRDS(file='sample_en_US.unigram.RDS')
bigramBlog<- readRDS(file='sample_en_US.bigram.RDS')
trigramBlog <- readRDS(file='sample_en_USReduced.trigram.RDS')

predictNextWord1Gram<-function(){
  unigramBlog$word[1:15]
}

predictNextWord2Gram<-function(sentence){
  words<-unlist(strsplit(sentence, " "))
  wordLength<-length(words)
  finalWord<- words[wordLength]
  pattern <- paste0("^",finalWord, " ")
  valid <- grepl(pattern, bigramBlog$word)
  if (sum(valid)>0){
    reduced<-bigramBlog[valid,]
    selectedWords<-na.omit(reduced$word[1:15])
    words2<-sapply(sapply(selectedWords, function(x) toString(x)),strsplit, " ", USE.NAMES = FALSE)
    sapply(words2, function(x) x[2]) }
  
  else {predictNextWord1Gram()}
}

predictNextWord3Gram<-function(sentence){
  clean<-cleaner(sentence)
  cleanlc<- tolower(clean)
  words<-unlist(strsplit(cleanlc, " "))
  wordLength<-length(words)
  finalTwo<- words[(wordLength-1):wordLength]
  pattern <- paste0(paste(paste0("^",finalTwo[1]),finalTwo[2])," ")
  valid <- grepl(pattern, trigramBlog$word)
  if (sum(valid)>0){
    reduced<-trigramBlog[valid,]
    selectedWords<-na.omit(reduced$word[1:15])
    words2<-sapply(sapply(selectedWords, function(x) toString(x)),strsplit, " ", USE.NAMES = FALSE)
    sapply(words2, function(x) x[3]) }
  
  else {predictNextWord2Gram(sentence)}
}

shinyServer(function(input, output) {
  word<-eventReactive(input$button, {input$textId})
  output$table<-renderTable({
       words<- predictNextWord3Gram(word())
       wordsTab<-data.frame(Rank=1:length(words), Word = words)
       wordsTab
       })
  })
  

