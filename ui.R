library(shiny)
library(shinythemes)
library(protr)
library(markdown)

shinyUI(fluidPage(title="ACPred: A Sequence-Based Tool for Predicting Anticancer Peptides", theme=shinytheme("united"),
                  navbarPage(strong("ACPred"),
                             tabPanel("Submit Job", titlePanel("ACPred: A Sequence-Based Tool for Predicting Anticancer Peptides"),
                                      sidebarLayout(
                                        wellPanel(
                                          tags$label("Enter your input sequence(s) in FASTA format:",style="float: none; width: 100%;"),
                                          actionLink("addlink", "Insert example data"),
                                          tags$textarea(id="Sequence", rows=8, cols=100, style="float: none; width:100%;", ""),
                                          fileInput('file1', '',accept=c('text/FASTA','FASTA','.fasta','.txt')),
                                          actionButton("submitbutton", "Submit", class = "btn btn-primary")
                                        ), #wellPanel
                                        
                                        mainPanel(
                                          verbatimTextOutput('contents'),
                                          downloadButton('downloadData', 'Download CSV')
                                        )  
                                      ) #sidebarLayout
                             ), #tabPanel Submit Job
                             
                             tabPanel("About", titlePanel("Anticancer Peptide"), div(includeMarkdown("about.md"), align="justify")),
                             tabPanel("Data", titlePanel("Data"), includeMarkdown("data.md")),
                             tabPanel("Citation", titlePanel("Citation"), includeMarkdown("citation.md")),
                             tabPanel("Contact", titlePanel("Contact"), includeMarkdown("contact.md"))	
                             
                  ) #navbarPage
) #fluidPage	
) #shinyUI
