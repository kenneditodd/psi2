
# generate cutoff combinations
FDRq_values <- c("0.01","0.05","0.10")
LFC_values <- c("0.0","0.5","1.0","1.5","2.0")
combinations <- vector()
for(i in FDRq_values){
  for(j in LFC_values) {
    string <- paste0("FDRq_", i, "_", "LFC_", j)
    combinations <- c(combinations, string)
  }
}
combinations


# color tables based on cutoff combinations
for
for (cutoff in combinations) {
  
  # initialize variables
  color_values <- vector()
  max <- nrow(data)
  num_DEGs <- vector()
  
  # parse cutoff info
  cutoff_values <- str_match(cutoff, "FDRq_(.+)_LFC_(.+)")
  FDRq <- as.numeric(cutoff_values[,2])
  LFC <- as.numeric(cutoff_values[,3])
  
  # loop through every gene
  for(i in 1:max){
    # if FDRq is met
    if (data$adj.P.Val[i] < FDRq){
      
      if (data$logFC[i] > LFC){
        color_values <- c(color_values, 1) # 1 when logFC met and positive and FDRq met
        num_DEGs <- c(num_DEGs,"up")
      }
      else if (data$logFC[i] < -LFC){
        color_values <- c(color_values, 2) # 2 when logFC met and negative and FDRq met
        num_DEGs <- c(num_DEGs, "down")
      }
      else{
        color_values <- c(color_values, 3) # 3 when logFC not met and FDRq met
        num_DEGs <- c(num_DEGs, "neither")
      }
    }
    # if FDRq is not met
    else{
      color_values <- c(color_values, 3) # 3 when FDRq not met
      num_DEGs <- c(num_DEGs, "neither")
    }
  }
  
  # add column to data
  data[cutoff] <- color_values
}







# set variables
req(input$fdrq,input$lfc,input$group1,input$group2)
fdrq <- input$fdrq
lfc <- input$lfc

# read file
path <- paste0("DEGs/",input$group1,"_vs_",input$group2,"_FDRq_1.00.tsv")
data <- readr::read_tsv(file = path)

# assign colors
color_values <- vector()
max <- nrow(data)
for(row in 1:max){
  if (data$adj.P.Val[row] < fdrq){
    if (data$logFC [row] > lfc){
      color_values <- c(color_values, 1) # 1 when logFC > input.lfc and FDRq < input.fdrq
    }
    else if (data$logFC[row] < -lfc){
      color_values <- c(color_values, 2) # 2 when logFC < input.lfc and FDRq < input.fdrq
    }
    else {
      color_values <- c(color_values, 3) # 3 when input.lfc NOT met and FDRq < input.fdrq
    }
  }
  else{
    color_values <- c(color_values, 3) # 3 when input.fdrq NOT met
  }
}
data$color_adjpval <- factor(color_values)