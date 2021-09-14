options(stringsAsFactors = F)

library(tidyverse)

args <- commandArgs(T)

infile <- args[1]
outfile <- args[2]

# infile <- "work/cellranger_multi/outs/multi/multiplexing_analysis/assignment_confidence_table.csv"

assignments <- read.csv(infile, header = T)
assigned_bcs <- assignments %>% 
  # filter(grepl("^CMO", Assignment)) %>% 
  pull(Barcodes)

write.table(assigned_bcs, outfile, quote = F, col.names = F, row.names = F)