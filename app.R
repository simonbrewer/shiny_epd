# this is a shiny web app. Save as app.r

library(shiny)
library(shinyWidgets)
library(leaflet)
library(dplyr)
library(sf)

# Define UI for application that draws a map
data <- readRDS("./data/sites_654_Quercus.rds") 
# ice <- st_read("icefiles/icee_15000/icee_15000.shp", quiet = TRUE)
ice <- readRDS("./icefiles/ice_all.rds")

ui <- bootstrapPage(
    tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
    leafletOutput("map", width = "100%", height = "100%"),
    absolutePanel(top = 10, right = 10,
                  sliderTextInput("animation", 
                                  label = "Years BP:",
                                  choices = seq(from = 15000, to = 0, by = -500),
                                  selected = 15000,
                                  grid = TRUE,
                                  animate =
                                      animationOptions(interval = 600, loop = TRUE))
                  # absolutePanel(top = 10, right = 10,
                  #               sliderInput("animation", 
                  #                           label = "Years BP:",
                  #                           min = 0,
                  #                           max = 15000,
                  #                           value = 15000,
                  #                           step = 500,
                  #                           animate =
                  #                               animationOptions(interval = 600, loop = TRUE))
    )
    
)


# Define server logic required
server <- function(input, output) {
    #stuff in server
    filteredData <- reactive({
        #add rollified thing
        data %>% filter(agebp == input$animation)
    })
    
    filteredIce <- reactive({
        #add rollified thing
        if (input$animation >= 10000) {
            ice %>% filter(time == input$animation)
        } 
    })
    
    qpal <- colorBin("YlOrRd", data$freq, bins = 7, pretty = TRUE)
    
    output$map<-renderLeaflet({
        leaflet(data) %>%
            addTiles() %>%
            fitBounds(~min(lon), ~min(lat), ~max(lon), ~max(lat))
        
    })
    
    observe({
        if (input$animation >= 10000) {
            leafletProxy("map", data = filteredData()) %>%
                clearMarkers() %>%
                clearShapes() %>%
                addCircleMarkers(lng = ~lon, lat = ~lat, 
                                 fillColor = ~qpal(freq), fillOpacity = 0.75,
                                 radius = ~sqrt(freq) * 15, weight = 2,
                                 popup = ~ent, 
                                 color = "black", stroke = TRUE) %>%
                addPolygons(data = filteredIce(), fill=TRUE, 
                            stroke = TRUE, weight = 4, color = "#2E86C1")
        } else {
            leafletProxy("map", data = filteredData()) %>%
                clearMarkers() %>%
                clearShapes() %>%
                addCircleMarkers(lng = ~lon, lat = ~lat, 
                                 fillColor = ~qpal(freq), fillOpacity = 0.75,
                                 radius = ~sqrt(freq) * 15, weight = 2,
                                 popup = ~ent, 
                                 color = "black", stroke = TRUE)
        }
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)