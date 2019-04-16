# Define UI for application that draws a map
ui <- fluidPage(
   
   # Application title
   titlePanel("Rental housing in Minneapolis"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("range", "Year built:",
                                min = 1890, max = 2018,
                                value = c(2009,2018),
                     sep = "")
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
        leafletOutput("mymap",height = "88vh")
      )
   )
)
