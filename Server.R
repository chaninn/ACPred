library(shiny)
library(seqinr)
library(protr)
library(caret)

# Parameters from ELM model
index = c(1,4,6,8,12,11,13,3,15,7,2,16,17,20,18)
parameter = c(2.6851399,-2.0436876,-2.4310987,-1.7418030,-0.5260239,0.7438176,-2.4197328,-2.6906637,-2.3572390,-1.9399534,-2.8536440,-2.1697011,-0.6695258,-1.3601942,-1.0319769,-1.2260244)
cutoff = 1.461278
#

shinyServer(function(input, output, session) {
  observe({
    FASTADATA <- ''
    fastaexample <- '>ACP
GLWSKIKEVGKEAAKAAAKAAGKAALGAVSEAV
>NonACP
NNQEVIDAISQAISQTPGCVL
'
    if(input$addlink>0) {
      isolate({
        FASTADATA <- fastaexample
      })
    }
    updateTextInput(session, inputId = "Sequence", value = FASTADATA)
  })
  
  datasetInput <- reactive({
    
    inFile <- input$file1 
    inTextbox <- input$Sequence
    
    if (inTextbox == "") {
      return("Please insert/upload sequence in FASTA format")
    } 
    else {
      if (is.null(inFile)) {
        x <- inTextbox
        write.fasta(sequence = x, names = names(x),
                    nbchar = 80, , file.out = "text.fasta")
        x <- readFASTA("text.fasta")
        x <- x[(sapply(x, protcheck))]
        AAC <- t(sapply(x, extractAAC))
        test <- data.frame(AAC)
        dataset = test[index]
        Prediction <- as.matrix(dataset)%*% as.numeric( parameter[-1])+ as.numeric( parameter[1])
        #Prediction <- as.data.frame(Prediction)
        Prediction <- ifelse(Prediction > cutoff, 2 , 1)
        Prediction <- ifelse(as.numeric(Prediction) > 1, 'anticancer peptide' , 'non-anticancer peptide')
        Prediction <- as.data.frame(Prediction)
        Protein <- cbind(Name = rownames(dataset, Prediction))
        results <- cbind(Protein, Prediction)
        results <- data.frame(results, row.names=NULL)
        print(results)
      } 
      else {     
        x <- readFASTA(inFile$datapath)
        x <- x[(sapply(x, protcheck))]
        AAC <- t(sapply(x, extractAAC))
        test <- data.frame(AAC)
        dataset = test[index]
        Prediction <- as.matrix(dataset)%*% as.numeric( parameter[-1])+ as.numeric( parameter[1])
        Prediction <- as.data.frame(Prediction)
        Prediction <- ifelse(Prediction > cutoff, 2 , 1)
        Prediction <- ifelse(as.numeric(Prediction) > 1, 'anticancer peptide' , 'non-anticancer peptide')
        Protein <- cbind(Name = rownames(dataset, Prediction))
        results <- cbind(Protein, Prediction)
        results <- data.frame(results, row.names=NULL)
        print(results)
      }
    }
    
  })
  
  
  
  output$contents <- renderPrint({
    input$submitbutton
    isolate(datasetInput())
  })
  
  output$downloadData <- downloadHandler(
    filename = function() { paste('Predicted_Results', '.csv', sep='') },
    content = function(file) {
      write.csv(datasetInput(), file, row.names=FALSE)
    })
  
})
