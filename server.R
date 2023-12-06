# Import libraries
library(shiny)
library(shinythemes)
library(ggplot2)

##################################################################
# If not exist then install package
##################################################################
need_lib <- c("ggplot2","dplyr","shiny","shinythemes")

need_2install_lib <- need_lib[!need_lib %in% installed.packages()]
for(lib in need_2install_lib) install.packages(lib,dependencies=TRUE)
sapply(need_lib,require,character=TRUE)
##################################################################

## python setting
use_python("/Users/yongholim/opt/anaconda3/bin/python") 


# cities = "Toronto, Vancouver, Halifax"
# nchar(cities)
# unlist(strsplit(cities, ","))

city_find = function(cities){ ### text var cities
  return( unlist(strsplit(cities, ",")) )
}

city_write_and_read = function(cities){
  cities = city_find(cities)
  cities = r_to_py(cities)
  code = paste0("cities =", cities)
  
  ## Web scrapping from Google weather search and save data to sqlite3
  py_run_string(code)
  source_python('Get_weather_data.py')
  
  con = DBI::dbConnect(RSQLite::SQLite(), "weather.db")
  
  # dbListTables(con)
  # dbGetQuery(con, "SELECT * FROM weather_table")
  
  weather_data = tbl(con, "weather_table")
  weather_data_temp = weather_data %>% select(city, temperature)
  return(weather_data_temp)
}






####################################
# Server                           #
####################################

server <- function(input, output, session) {
  
  
  
  # Input Data
  datasetInput <- reactive({  
   
    city_data = city_write_and_read(input$cities)
    print(city_data)
    
  })
  
  
   # Prediction results table
  output$tabledata <- renderTable({
    if (input$submitbutton>0) {
      isolate(datasetInput())
    }
  })
  
  output$barPlot <- renderPlot({
    if (input$submitbutton>0) {
      ggplot(datasetInput(), aes(city, temperature)) + geom_bar(stat='identity')
      
    }
    
  })
  
  
  
}