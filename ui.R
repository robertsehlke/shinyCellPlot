library(shiny)
library(shinyBS)
library(shinyWidgets)

shinyUI(
  navbarPage("",inverse = T,
    tabPanel("CellPlot",
             sidebarLayout(
               
               
               sidebarPanel(
                 HTML(
'This is a small-scale demonstration of <b>cell.plot</b>, a segmented bar chart function to visualise functional biological terms (e.g. GO, gene ontology), 
as well as the relative changes of their annotated genes or proteins.
</br></br>cell.plot is part of the <a href="https://github.com/dieterich-lab/CellPlot">CellPlot R package</a> (<a href="http://robertdoes.science" target="_blank">Robert Sehlke</a> [aut], Sven Templer [ctb]).</br></br>'),
                 bsButton("bt_plot","Update CellPlot"),
                 downloadButton("downloadPlot","Download as .png"),
                 textAreaInput("input_values","",rows = 25, value = ""),
                 
                 div(style="display: inline-block", prettySwitch("plot_sym", "make key range symmetric", value = T) ),
                 HTML("</br>"),
                 div(style="display: inline-block", textInput("plot_lxaxis", "X-axis label",value = "GO Term enrichment") ),
                 div(style="display: inline-block", textInput("plot_lcell", "Key label",value = "log(fold-change)") ),
                 HTML("</br>"),
                 div(style="display: inline-block", numericInput("plot_width", "Width", 800, min=200, max=3000) ),
                 div(style="display: inline-block", numericInput("plot_height", "Height", 400, min=200, max=3000) ),
                 div(style="display: inline-block", numericInput("plot_lwd", "Line weight", 4, min=1, max=100) ),
                 div(style="display: inline-block", numericInput("plot_txt", "Text scale", 1.5, min=1, max=5, step = 0.5) ),
                 HTML("</br>"),
                 div(style="display: inline-block", numericInput("plot_mary", "Margin (y)", 0.1, min=0, max=0.5, step = 0.05) ),
                 div(style="display: inline-block", numericInput("plot_marx", "Margin (x)", 0.1, min=0, max=0.5, step = 0.05) )
                 
                 
                 # div(style="display: inline-block;vertical-align:top", numericInput("plot_cellwd", "Cell line width", 2, min=1, max=10) ),
                 # div(style="display: inline-block;vertical-align:top", numericInput("plot_cellouter", "Cell outer border", 2, min=1, max=10) )
               ),
               
               mainPanel(plotOutput("cellplot"))
             )
             )
)
)
