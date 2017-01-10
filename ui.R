library(shiny)

# Define UI for dataset viewer application
shinyUI(pageWithSidebar(
      
      # Application title
      headerPanel("Jaguar EPC Part Lookup"),
      
      # Sidebar with controls to select a dataset and specify the number
      # of observations to view
      sidebarPanel(
            textInput("text", "Enter the part number")
      ),
      
      # Show a summary of the dataset and an HTML table with the requested
      # number of observations
      mainPanel(
            tableOutput("view")
      )
))