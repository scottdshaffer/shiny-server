server <- function(input,output, session){
  output$mymap <- renderLeaflet({
    mpls_sp <- mpls_sp[mpls_sp@data$YEARBUILT >=input$range[1] & mpls_sp@data$YEARBUILT<=input$range[2],]
         
leaflet(mpls_sp) %>%
  addProviderTiles(providers$Esri.WorldGrayCanvas) %>% 
  addCircleMarkers(radius = ~ sqrt(UNITS),
                   col = ~pal(INCOME),
                   stroke = FALSE, 
                   fillOpacity = 0.5,
                   popup = paste("<strong>", mpls_sp@data$FORMATTED_ADDRESS, "</strong> <br>",
                                        mpls_sp@data$UNITS, "units built in ", mpls_sp@data$YEARBUILT)
                   )%>%
  addLegend(
    position = "bottomright",
    pal = pal,
    values = ~INCOME,
    title = "Multifamily buildings",
    opacity = 1
    ) 
   })
}
