options(stringsAsFactors = F)

library(tidyverse)

args <- commandArgs(T)

infile <- args[1]
outhandle <- args[2]  # path/to/handle
n <- as.numeric(args[3])

# infile <- "work/demuxlet/input/barcodes.tsv"
# n <- 2000

barcodes <- read.table(infile)
barcodes$batch <- (1:nrow(barcodes) %/% n) + 1
max_batch <- max(barcodes$batch)

barcodes$V1 <- sample(barcodes$V1)  # in case there's any underlying structure


barcodes %>% 
  split(.$batch) %>% 
  lapply(function(i) {
    current_batch <- unique(i$batch)
    suffix <- paste(current_batch, max_batch, sep = "_")
    outfile <- paste(outhandle, suffix, "txt", sep = ".")
    write.table(i$V1, outfile, quote = F, col.names = F, row.names = F)
  })
