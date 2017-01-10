library(shiny)

load("up.RData")

# Define server logic required to summarize and view the selected dataset
shinyServer(function(input, output) {
      
      # Return the requested dataset
      listing <- reactive({
            input$text
      })
      
      # Show the first "n" observations
      output$view <- renderTable({
            subset(up, up[,2] == toupper(input$text))
      })
})
