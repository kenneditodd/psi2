library(stringr)

# read file list
df <- read.table("DEG_files.txt")
colnames(df) <- "file_name"

# parse groups in comparison
res <- stringr::str_match(df$file_name, "(.+)_vs_(.+)_FDRq_1.00.tsv")
res <- as.data.frame(res)

# rename cols
df$group1 <- res$V2
df$group2 <- res$V3

# save
write.table(df, file = "../input_options.tsv", sep = "\t", row.names = FALSE)
