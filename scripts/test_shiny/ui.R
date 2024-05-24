# load libraries
library(dplyr)
library(ggrepel)
library(plotly)
library(shiny)
library(stringr)

# load input options
comparisons <- readr::read_tsv("input_options.tsv")
genes <- readRDS("genes.rds")
group1_options <- comparisons$group1

# user interface
ui <- fluidPage(
  
  # application title
  titlePanel("Psilocybin Mice Bulk RNA-Sequencing"),
  
  tabsetPanel(
    
    # volcano tab
    tabPanel(
      title = "volcano",
      # Sidebar with two select input options 
      sidebarLayout(
        sidebarPanel(
          selectInput(inputId = "group1",
                      label = "Select group 1",
                      choices = group1_options,
                      selected = "psilo.low.7d"),
          selectInput(inputId = "group2",
                      label = "Select group 2",
                      choices = c(),
                      selected = NULL),
          numericInput(inputId = "fdrq",
                       label = "Select FDRq cutoff",
                       value = 0.05,
                       min = 0,
                       max = 1,
                       step = 0.01),
          numericInput(inputId = "lfc",
                       label = "Select log2(FC) cutoff",
                       value = 0,
                       step = 0.1)
        ),
        
        # plot
        mainPanel(
          h5("Samples: removed if Hbb-bs > 10 CPM"),
          h5("Filtering: keep genes with a group average CPM of 1 in at least 1 group"),
          h5("Model: group + sex + Hbb-bs"),
          plotlyOutput("volcano")
        )
        
      ) # end sidebarLayout
    ), # end tabPanel - volcano
      
    # CPM tab
    tabPanel(
      title = "CPM",
      # Sidebar with a slider input for number of bins 
      sidebarLayout(
        sidebarPanel(
          # Populate gene options based on selected tissue
          selectizeInput(inputId = "goi",
                         label = "Select a gene",
                         choices = genes,
                         selected = "Hbb-bs",
                         options = list(maxOptions = 5))
        ), # end sidebarPanel
        
        # Show a plot of the generated distribution
        mainPanel(
          plotOutput("boxplot"),
          br(),
          plotOutput("bar")
        )
      ) # end SidebarLayout
    ) # end tabPanel - CPM
  ) # end of tabsetPanel
  

) # end of fluidPage
