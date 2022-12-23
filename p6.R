
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

input <- readLines('i6.txt')
input <- strsplit(input, '')[[1]]

getn <- function (n,s) {
  for (i in n:length(s)){
    if(length(unique(s[(i-n+1):i]))>n-1) {
      return(i)
    }
  }
} 

message("part 1:", getn(4,input))
message("part 2:", getn(14,input))
