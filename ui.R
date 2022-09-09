
##################################################################
# If not exist then install package
##################################################################
need_lib <- c("ggplot2","dplyr","shiny","shinythemes","ggvis","reticulate", "RSQLite", "shinydashboard", "leaflet")

need_2install_lib <- need_lib[!need_lib %in% installed.packages()]
for(lib in need_2install_lib) install.packages(lib,dependencies=TRUE)
sapply(need_lib,require,character=TRUE)
##################################################################

header <- dashboardHeader(
  title = "Google weather search"
)

body <- dashboardBody(
  column(width = 9,
              plotOutput('barPlot'),
             box(width = NULL,
                 tableOutput("tabledata")
             )
         ),
  column(width = 3,
         box(width = NULL, status = "warning",
             uiOutput("cities"),
             textAreaInput("cities", "City", "")    ),
  column(width=6, actionButton("submitbutton", "Submit", class = "btn btn-primary"))
  ) 
  
)


dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  body
)