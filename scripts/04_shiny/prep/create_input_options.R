library(stringr)

############################ VOLCANO GROUP OPTIONS #############################
# get file list
filenames <- list.files("../DEGs")
df <- data.frame(filename = filenames)

# parse groups in comparison
res <- stringr::str_match(filenames, "(.+)_vs_(.+)_FDRq_1.00_LFC_0.00.tsv")
res <- as.data.frame(res)

# rename cols
df$group1 <- res$V2
df$group2 <- res$V3

# save
write.table(df, file = "../input_options.tsv", sep = "\t", row.names = FALSE)

############################ CPM GENE OPTIONS ##################################
counts <- read.table("../counts/CPM_postfiltering.tsv")
genes <- rownames(counts)
saveRDS(genes, "../genes.rds")

############################ GPROFILER2 FILES ##################################
files <- list.files("../gprofilerInput")
saveRDS(files, "../gprofilerInputFiles.rds")


