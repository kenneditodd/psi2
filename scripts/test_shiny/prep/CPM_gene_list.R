counts <- read.table("../counts/CPM_prefiltering.tsv")
genes <- rownames(counts)
saveRDS(genes, "../genes.rds")
