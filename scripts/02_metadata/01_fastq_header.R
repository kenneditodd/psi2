# read files
meta <- read.delim2("../../refs/metadata.tsv")
seq.info <- read.delim2("../../refs/fastq_headers.tsv", header = FALSE)

# reformat seq.info
colnames(seq.info) <- c("filename","fastq_header")
seq.info$fastq_header <- gsub("@","",seq.info$fastq_header)
seq.info <- tidyr::separate_wider_delim(seq.info, 
                                        cols = fastq_header, 
                                        delim = " ", 
                                        names = c("header1","header2"))
seq.info <- tidyr::separate_wider_delim(seq.info, 
                                        cols = header1, 
                                        delim = ":", 
                                        names = c("instrument","run","flow_cell","lane",
                                                  "xpos","ypos","tile"))

# remove unnecessary info
seq.info$header2 <- NULL
seq.info$xpos <- NULL
seq.info$ypos <- NULL
seq.info$tile <- NULL

# remove R2 files
keep <- is.na(stringr::str_match(seq.info$filename, ".+_R2"))
seq.info <- seq.info[keep,]

# check instrument, run, flow cell, lane
table(seq.info$instrument) # all the same
table(seq.info$run)
table(seq.info$flow_cell)
table(seq.info$lane)
seq.info$run_flowcell_lane <- paste(seq.info$run,
                                    seq.info$flow_cell,
                                    seq.info$lane,
                                    sep = "_")
table(seq.info$run_flowcell_lane)
seq.info <- seq.info[,c(1,6)]

# check how the lane varies with group
seq.info$filename <- stringr::str_match(seq.info$filename,
                   "(Psil2_A[0-9]+_[HighLowNSK_]+_[FemMale]+)_L[0-9]+_R1_001.fastq.gz")[,2]

# merge
df <- dplyr::left_join(meta, seq.info, by = "filename")
df$lane <- NULL

# save meta
write.table(x = df, file = "../../refs/metadata.tsv", sep = "\t",
            quote = FALSE)


