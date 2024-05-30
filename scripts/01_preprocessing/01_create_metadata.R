# read table
setwd(".")
library(dplyr)
library(stringr)
mouse.meta <- read.delim2("../../refs/joe_metadata.tsv", sep = "\t", header = TRUE)

# rename columns
colNames <- c("animal_id","filename","cage","group_num","treatment","dose",
              "timepoint","assay")
colnames(mouse.meta) <- colNames

# preview
table(mouse.meta$treatment)
table(mouse.meta$dose)
table(mouse.meta$timepoint)

# sex
mouse.meta$sex <- str_match(mouse.meta$filename, 
                            "Psil2_A[0-9]+_[NSK_LowHigh]+_([FmMale]+)")[,2]
table(mouse.meta$sex)

# remove whitespace
mouse.meta$dose <- gsub(" ","",mouse.meta$dose)
mouse.meta$treatment <- gsub(" ","",mouse.meta$treatment)

# group
# saline = sal
# ketanserin = ket
# low dose psilocybin = psilo.low
# high dose psilocybin = psilo.high
# low dose psilocybin + ketanserin = ket.psilo.low
# high dose psilocybin + ketanserin = ket.psilo.high
group <- paste(mouse.meta$treatment,
               mouse.meta$dose,
               mouse.meta$timepoint,
               sep = ".")
group <- gsub("Saline.0.9%","S",group)
group <- gsub("Psilocybin.0.25mg/kg","L",group)
group <- gsub("Psilocybin.1mg/kg","H",group)
group <- gsub("Ketanserin.2mg/kg","K",group)
group <- gsub("Ketanserin\\+Psilocybin.K\\(2mg/kg\\);psilo\\(0.25mg/kg\\)",
              "KL",
              group)
group <- gsub("Ketanserin\\+Psilocybin.K\\(2mg/kg\\);psilo\\(1mg/kg\\)",
              "KH",
              group)
group <- gsub(" hour","h",group)
group <- gsub(" day","d",group)
table(group)
mouse.meta$group <- group

# group with sex
group2 <- paste0(mouse.meta$group, ".", mouse.meta$sex)
group2 <- gsub("Male","M",group2)
group2 <- gsub("Female","F",group2)
mouse.meta$group2 <- group2

# sample
mouse.meta$sample_name <- paste0(mouse.meta$group2, ".", mouse.meta$animal_id)

# rearrange columns
mouse.meta <- mouse.meta[,c(12,5,6,7,9,1,10,11,2,3,4,8)]

# sort rows
mouse.meta$group <- factor(mouse.meta$group,
                           levels = c("S.8h","K.8h","L.8h","H.8h","KL.8h","KH.8h",
                                      "S.24h","K.24h","L.24h","H.24h","KL.24h","KH.24h",
                                      "S.7d","K.7d","L.7d","H.7d","KL.7d","KH.7d"))
mouse.meta <- mouse.meta %>% ungroup() %>% arrange(group,sex)

# animal 90 died
mouse.meta <- mouse.meta[!mouse.meta$animal_id == 90,]

# Joe's group_num column is the same as my group/group2 column
mouse.meta$group_num <- NULL

# expand assay
mouse.meta$assay <- gsub(" ", "", mouse.meta$assay)
table(mouse.meta$assay)
fixed <- gsub("bulk\\+fixed","yes",mouse.meta$assay)
fixed <- gsub("bulk\\+sn","no",fixed)
mouse.meta$fixed <- fixed
bulk <- gsub("bulk\\+fixed","yes",mouse.meta$assay)
bulk <- gsub("bulk\\+sn","yes",bulk)
mouse.meta$bulk <- bulk
sn <- gsub("bulk\\+fixed","no",mouse.meta$assay)
sn <- gsub("bulk\\+sn","yes",sn)
mouse.meta$sn <- sn
mouse.meta$assay <- NULL

# read TGen info
tgen.meta1 <- read.delim2("../../refs/JDF2122_20240517_LH00295_0087_B22HVM7LT3_QC.txt")
tgen.meta2 <- read.delim2("../../refs/JDF2122_20240522_LH00295_0089_A22JGCYLT3_QC.txt")
all.equal(colnames(tgen.meta1),colnames(tgen.meta2))
tgen.meta <- rbind(tgen.meta1,tgen.meta2)
remove(tgen.meta1,tgen.meta2)
colnames(tgen.meta) <- tolower(colnames(tgen.meta))

# join mouse.meta and tgen.meta
tgen.meta$patient_id <- NULL
colnames(tgen.meta)[3] <- "filename"
mouse.meta <- dplyr::left_join(x = mouse.meta,
                               y = tgen.meta,
                               by = "filename")

# Note: animal 210 had to be re-sequenced
mouse.meta <- mouse.meta[!mouse.meta$animal_id == 210,]

# save meta
write.table(x = mouse.meta, file = "../../refs/metadata.tsv", sep = "\t",
            quote = FALSE, row.names = FALSE)
