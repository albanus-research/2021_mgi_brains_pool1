options(stringsAsFactors = F)
seed <- 87532163

suppressPackageStartupMessages({
  library(knitr)
  library(ggplot2)
  library(RColorBrewer)
  library(dplyr)
  library(tidyr)
  library(scales)
  library(glue)
  library(Matrix)  
})

options(dplyr.summarise.inform = FALSE)  # Disable "`summarise()` has grouped output by 'foo'" message

theme_set(theme_bw(base_size = 12))

args <- commandArgs(T)
sample_name <- args[1]
maindir <- args[2]
outdir <- args[3]


read_raw_counts <- function(sample_name) {
  message(glue("Processing {sample_name}"))
  indir <- file.path(maindir, sample_name, "outs/raw_feature_bc_matrix")
  bc <- read.table(file.path(indir, "barcodes.tsv.gz"))[,1]
  bc <- gsub("1$", sample_name, bc)
  features <- read.table(file.path(indir, "features.tsv.gz"))[,2]
  mat <- readMM(file.path(indir, "matrix.mtx.gz"))
  colnames(mat) <- bc
  rownames(mat) <- features
  return(mat)
}


get_qc <- function(mat, id) {
  message(glue("Processing QC for {id}"))
  depths <- colSums(mat)
  mt <- mat[grep("^MT-", rownames(mat)), ]
  mt <- colSums(mt)
  mt <- mt / depths
  mt[is.na(mt)] <- 0
  
  if(all(names(mt) == names(depths))) {
    out_df <- data.frame(barcode = names(mt),
                         nUMI = unname(depths),
                         pctMT = unname(mt),
                         sample = id)
    return(out_df)
  } else {
    stop("Names do not match!")
  }
}

mat <- read_raw_counts(sample_name)
qc <-  get_qc(mat, sample_name)

message("Generating output")
outfile <- file.path(outdir, paste0(sample_name, ".barcode_metrics.tsv.gz"))
write.table(qc, gzfile(outfile), col.names = T, row.names = F, quote = F, sep = "\t")

plt <- qc %>% 
  ggplot(aes(x = nUMI + 1, y = pctMT)) +
  geom_point(alpha = .01, size = .5) +
  geom_hline(yintercept = 0.2, lty = "dashed", color = "red") +
  facet_wrap(~ sample) +
  scale_x_log10(labels = comma) +
  labs(x = "Number of UMIs per barcode", y = "Fraction MT")
outfile <- file.path(outdir, paste0(sample_name, ".all_barcodes.png"))
ggsave(outfile, plt, width = 4, height = 4, units = "in", dpi = 150)

plt <- qc %>% 
  filter(nUMI > 1000) %>% 
  ggplot(aes(x = nUMI + 1, y = pctMT)) +
  geom_point(alpha = .01, size = .5) +
  geom_hline(yintercept = 0.2, lty = "dashed", color = "red") +
  facet_wrap(~ sample) +
  scale_x_log10(labels = comma) +
  labs(x = "Number of UMIs per barcode", y = "Fraction MT")
outfile <-file.path(outdir, paste0(sample_name, ".gt1000umis.png"))
ggsave(outfile, plt, width = 4, height = 4, units = "in", dpi = 150)