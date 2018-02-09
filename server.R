
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(CellPlot)

shinyServer(function(input, output, session) {
  
  parseTextInput = function(x) {
    x = strsplit(x, "\n")[[1]]
    x = x[ sapply(x, function(x) substr(x,1,1)!="#") ]
    
    if (length(x) > 0) {
      x = strsplit(x, ";")
      bars = setNames(as.numeric(sapply(x,function(x) x[1])),
                      sapply(x,function(x) x[2]))
      cells = strsplit( sapply(x,function(x) x[3]), "," )
      cells = lapply(cells, as.numeric)
      
      include = which(!is.na(bars) &
                        sapply(cells,function(x) length(x) > 0) )
      if (length(include) > 0) {
        bars = setNames( pmax(0,bars), names(bars))
        return(list("bars"=bars[include], "cells"=cells[include]))
      }
      
    } else {
      return(NULL)
    }
  }
  
  instructions =
"# Input your data in the following format:
# Length of bar; Title; comma-separated list of values
# 3.2;lipid metabolism;-1,-0.8,-0.76,0.3,0.9,2"
  
  # reactive variable to store last parsed plot data and params
  PD = reactiveValues("plotdata"=NULL)
  
  
  example = "\n2.6;GO Term 1;0.27, -4.4, -0.52, -1.8, 4.4, 0.97, -0.17, -0.46, -2.7, 4.3, 4.1, 4.3, -4.2, -3.2, 4.8, 0.076, -0.9, 4.4, 0.35\n\n2.4;GO Term 2;-0.24, -0.77, -0.48, -2.7, -2.5, -1.2, -1.8, 0.2\n\n2.4;GO Term 3;4.8, 1.4, 0.93, 1, -0.65, 0.011, -2.7, 1.4, 4.9, -1.6, -2.7, -4.9, 1.7, -0.36, 1.6, -4.1, 3.1, 3, -1.1, 1.9, -3.5, 3.7, -4.5, -1.9, 3.5, 1.9, 0.57\n\n2.3;GO Term 4;3.2, 0.76, -0.54, -3.4, 0.07, -2.4, 1.7, 4.4, -1.9, 2, -4, 4.4, -2.8, 0.39, -3.4, -1.1, 0.35, 1.4, -1.4, 0.81\n\n1.9;GO Term 5;-4.5, -2.9, 2.3, 2.4, 2.2, 3.5, 3.1, -2.2, 2.7, 2.5, -4.7, -0.28, 3.7, -0.19, -4.3, -4.8, -1.8, -2.9, -0.82, -2.5, -0.59, -0.82, 4.1, -1.1, 0.35\n\n1.9;GO Term 6;2.7, -2.2, -4.6, -4, -1.1, -3.2, -3.8, -1.3, -3.7, 0.51, 2.8, -5, 4.6, 4, 2, -1.3\n\n1.4;GO Term 7;-3, 3.4, -3.5, 0.35, 1.3, 2.8, -4.9, 0.026, 0.071, -1.5, 3.3, -0.43, 4.4, 2.8, -4.5, 3.9, -1.3, 2.3, 0.063, -4, 4.9, -4.7, 1.3, 4.4\n\n"
  updateTextAreaInput(session, "input_values", value=paste0(instructions,"\n",example)  )
  
  PD$plotdata = parseTextInput(paste0(instructions,"\n",example))
 
  
  # plot the cellplot
  observeEvent(input$bt_plot, { PD$plotdata = parseTextInput(input$input_values)
  print(PD$plotdata$bars)} )
  
  cellfun = function(){
    if (length(PD$plotdata) > 0) {
      cell.plot( PD$plotdata$bars, PD$plotdata$cells, 
                 main="", xlab=input$plot_lxaxis, key.lab = input$plot_lcell,
                 cell.lwd = input$plot_lwd, cell.outer = input$plot_lwd, 
                 xdes.cex = input$plot_txt, xlab.cex = input$plot_txt, lab.cex = input$plot_txt, 
                 y.mar = c(0.08,input$plot_mary), sym = input$plot_sym )
    } else { return(NULL) }
  }
  
  observeEvent({
    input$plot_width
    input$plot_height
  },
  {
    output$cellplot = renderPlot(cellfun(), width = input$plot_width, height=input$plot_height)
  })

  output$downloadPlot <- downloadHandler(
        filename = function() { paste0( "cellplot_", format(Sys.time(), "%Y%b%d_%Hh%Mm%Ss"), ".png" ) },
        content = function(file) {
          png(file, width = input$plot_width, height=input$plot_height)
          cellfun()
          dev.off()
        },
        contentType = 'image/png')
  
})
