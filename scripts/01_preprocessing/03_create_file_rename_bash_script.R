# setup
setwd(".")
library('stringr')

# read fastq names
file <- read.delim2("../../refs/original_fastq_names.txt",
                    header = FALSE)
colnames(file) <- "original_names"

# read meta
meta <- read.delim2("../../refs/metadata.tsv")

# parse TGen sample name
# MAYO_0135_1_BR_Whole_C1_KBMRS_L99704_22JGCYLT3_TAGATCTACA_L006_R2_001.fastq.gz
file$tgen_sample_name <- str_match(file$original_names,
                                   "(MAYO_[0-9]+)_.+")[,2]
file$lane <- str_match(file$original_names,
                       "MAYO_[0-9]+_.+_(L00[0-9])")[,2]
file$read <- str_match(file$original_names,
                       "MAYO_[0-9]+_.+_L00[0-9]_(R[12])")[,2]

# join tables
file <- dplyr::left_join(x = file,
                         y = meta,
                         by = "tgen_sample_name")

# create new filename
new.names <- paste0(file$filename,
                    "_",
                   file$lane.x,
                   "_",
                   file$read,
                   "_",
                   "001.fastq.gz")
file$new_filename <- new.names

# check all names are unique
table(duplicated(file$new_filename))

# create bash script
header <- c("#!/bin/bash","cd /research/labs/neurology/fryer/projects/psilocybin/psi2")
path <- "/research/labs/neurology/fryer/m214960/psi2/rawReads/"
bsh <- paste0("cp ", file$original_names, " ", path, file$new_filename)
script <- as.data.frame(c(header,bsh))

# save script
write.table(x = script,
            file = "04_rename_fastq_files.sh",
            quote = FALSE,
            row.names = FALSE,
            col.names = FALSE)

