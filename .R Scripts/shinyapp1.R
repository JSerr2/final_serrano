library(shiny)
library(leaflet)
library(dplyr)
library(sf)

setwd("C:\\Users\\joses\\OneDrive\\Documents\\GitHub\\final_serrano")

# shapefile directory
shapefile_dir <- "Data/EDGE_SCHOOLDISTRICT_TL19_SY1819/"

# Does shp file exist
if (!dir.exists(shapefile_dir) || 
    !file.exists(paste0(shapefile_dir, "schooldistrict_sy1819_tl19.shp"))) {
  stop(paste0(
    "The shapefiles are missing! Please download them from the following link https://drive.google.com/drive/u/0/folders/1bIdtloiKcNgHsFiSLyvIJvu7MZpLHGNw",
    "and place them in the '", shapefile_dir, "' directory.\n\n",
    "Download Link: https://drive.google.com/drive/u/0/folders/1bIdtloiKcNgHsFiSLyvIJvu7MZpLHGNw"
  ))
}

# Load shapefiles
district_shapes <- st_read(paste0(shapefile_dir, "schooldistrict_sy1819_tl19.shp"))

illinois_districts <- district_shapes %>% 
  filter(STATEFP == "17")


acs_data_wide <- read.csv("Data/acs_data_wide.csv")


illinois_districts <- illinois_districts %>% 
  mutate(GEOID = as.character(GEOID))

acs_data_wide <- acs_data_wide %>% 
  mutate(GEOID = as.character(GEOID))

shape_files_merged <- illinois_districts %>% 
  left_join(acs_data_wide, by = "GEOID")

# Choropleth Map

# UI
ui <- fluidPage(
  titlePanel("Poverty Rates of Families with Children by School District in Illinois (2019)"),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput(
        "districtType",
        "Select District Type:",
        choices = c("Elementary", "Secondary", "Unified"),
        selected = c("Elementary", "Secondary", "Unified")
      )
    ),
    mainPanel(
      leafletOutput("povertyMap", height = "800px")
    )
  )
)

# Server
server <- function(input, output, session) {
  # Filter data based on selected district type
  filtered_data <- reactive({
    shape_files_merged %>%
      filter(District_Type %in% input$districtType)
  })
  
  output$povertyMap <- renderLeaflet({
    pal <- colorNumeric(palette = "YlOrRd", domain = shape_files_merged$Poverty_Rate, na.color = "transparent")
    
    leaflet(filtered_data()) %>%
      addTiles() %>%
      addPolygons(
        fillColor = ~pal(Poverty_Rate),
        color = "black",
        weight = 1,
        opacity = 1,
        fillOpacity = 0.7,
        label = ~paste(NAME.x, "<br>Poverty Rate: ", round(Poverty_Rate, 2), "%"),
        highlight = highlightOptions(
          weight = 3,
          color = "#666",
          fillOpacity = 0.9,
          bringToFront = TRUE
        )
      ) %>%
      addLegend(
        pal = pal,
        values = ~Poverty_Rate,
        title = "Poverty Rate (%)",
        position = "bottomright"
      )
  })
}

shinyApp(ui, server)
