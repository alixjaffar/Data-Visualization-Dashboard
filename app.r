# Load required packages
library(shiny)
library(shinydashboard)
library(tidyverse)
library(plotly)
library(DT)
library(leaflet)
library(lubridate)

# Define UI
ui <- dashboardPage(
  dashboardHeader(title = "Formula 1 Championship Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Overview", tabName = "overview", icon = icon("dashboard")),
      menuItem("Driver Champions", tabName = "drivers", icon = icon("user")),
      menuItem("Constructor Champions", tabName = "constructors", icon = icon("car")),
      menuItem("Data Table", tabName = "data", icon = icon("table"))
    ),
    selectInput("decade", "Select Decade:", 
                choices = c("All", "1950s", "1960s", "1970s", "1980s", "1990s", "2000s", "2010s", "2020s")),
    selectInput("driver", "Select Driver:", 
                choices = c("All", "Lewis Hamilton", "Michael Schumacher", "Ayrton Senna", "Alain Prost", "Sebastian Vettel"))
  ),
  dashboardBody(
    tabItems(
      # Overview Tab
      tabItem(tabName = "overview",
        fluidRow(
          valueBoxOutput("total_championships", width = 3),
          valueBoxOutput("most_wins", width = 3),
          valueBoxOutput("most_points", width = 3),
          valueBoxOutput("most_constructors", width = 3)
        ),
        fluidRow(
          box(
            title = "Championship Points Over Time",
            status = "primary",
            solidHeader = TRUE,
            plotlyOutput("points_trend_plot")
          ),
          box(
            title = "Top 10 Drivers by Championships",
            status = "info",
            solidHeader = TRUE,
            plotlyOutput("top_drivers_plot")
          )
        )
      ),
      
      # Driver Champions Tab
      tabItem(tabName = "drivers",
        fluidRow(
          box(
            title = "Driver Championship Points",
            status = "primary",
            solidHeader = TRUE,
            plotlyOutput("driver_points_plot")
          ),
          box(
            title = "Driver Championship Wins",
            status = "success",
            solidHeader = TRUE,
            plotlyOutput("driver_wins_plot")
          )
        )
      ),
      
      # Constructor Champions Tab
      tabItem(tabName = "constructors",
        fluidRow(
          box(
            title = "Constructor Championship Points",
            status = "primary",
            solidHeader = TRUE,
            plotlyOutput("constructor_points_plot")
          ),
          box(
            title = "Constructor Championship Wins",
            status = "success",
            solidHeader = TRUE,
            plotlyOutput("constructor_wins_plot")
          )
        )
      ),
      
      # Data Table Tab
      tabItem(tabName = "data",
        fluidRow(
          box(
            title = "Raw Data",
            status = "warning",
            solidHeader = TRUE,
            DTOutput("f1_table")
          )
        )
      )
    )
  )
)

# Define server logic
server <- function(input, output) {
  # Load and preprocess data
  f1_data <- reactive({
    # In a real application, you would load your data here
    # For demonstration, we'll create sample data
    years <- 1950:2023
    drivers <- c("Lewis Hamilton", "Michael Schumacher", "Ayrton Senna", "Alain Prost", "Sebastian Vettel")
    constructors <- c("Mercedes", "Ferrari", "Red Bull", "McLaren", "Williams")
    
    # Create driver championship data
    driver_data <- expand.grid(year = years, driver = drivers) %>%
      mutate(
        points = round(runif(n(), 0, 100)),
        wins = round(runif(n(), 0, 10)),
        championship = ifelse(runif(n()) > 0.9, 1, 0)
      )
    
    # Create constructor championship data
    constructor_data <- expand.grid(year = years, constructor = constructors) %>%
      mutate(
        points = round(runif(n(), 0, 200)),
        wins = round(runif(n(), 0, 15)),
        championship = ifelse(runif(n()) > 0.9, 1, 0)
      )
    
    list(drivers = driver_data, constructors = constructor_data)
  })
  
  # Filtered data based on inputs
  filtered_data <- reactive({
    data <- f1_data()
    
    # Filter by decade if selected
    if (input$decade != "All") {
      decade_start <- as.numeric(substr(input$decade, 1, 4))
      decade_end <- decade_start + 9
      data$drivers <- data$drivers %>% filter(year >= decade_start, year <= decade_end)
      data$constructors <- data$constructors %>% filter(year >= decade_start, year <= decade_end)
    }
    
    # Filter by driver if selected
    if (input$driver != "All") {
      data$drivers <- data$drivers %>% filter(driver == input$driver)
    }
    
    data
  })
  
  # Value boxes
  output$total_championships <- renderValueBox({
    total <- sum(filtered_data()$drivers$championship)
    valueBox(
      total,
      "Total Driver Championships",
      icon = icon("trophy"),
      color = "blue"
    )
  })
  
  output$most_wins <- renderValueBox({
    max_wins <- max(filtered_data()$drivers$wins)
    valueBox(
      max_wins,
      "Most Race Wins",
      icon = icon("flag-checkered"),
      color = "green"
    )
  })
  
  output$most_points <- renderValueBox({
    max_points <- max(filtered_data()$drivers$points)
    valueBox(
      max_points,
      "Most Points in a Season",
      icon = icon("star"),
      color = "yellow"
    )
  })
  
  output$most_constructors <- renderValueBox({
    total <- sum(filtered_data()$constructors$championship)
    valueBox(
      total,
      "Total Constructor Championships",
      icon = icon("car"),
      color = "red"
    )
  })
  
  # Plots
  output$points_trend_plot <- renderPlotly({
    plot_ly(filtered_data()$drivers, x = ~year, y = ~points, color = ~driver, type = "scatter", mode = "lines") %>%
      layout(title = "Driver Championship Points Over Time",
             xaxis = list(title = "Year"),
             yaxis = list(title = "Points"))
  })
  
  output$top_drivers_plot <- renderPlotly({
    top_drivers <- filtered_data()$drivers %>%
      group_by(driver) %>%
      summarise(total_championships = sum(championship)) %>%
      arrange(desc(total_championships)) %>%
      head(10)
    
    plot_ly(top_drivers, x = ~driver, y = ~total_championships, type = "bar") %>%
      layout(title = "Top 10 Drivers by Championships",
             xaxis = list(title = "Driver"),
             yaxis = list(title = "Number of Championships"))
  })
  
  output$driver_points_plot <- renderPlotly({
    plot_ly(filtered_data()$drivers, x = ~year, y = ~points, color = ~driver, type = "scatter", mode = "lines") %>%
      layout(title = "Driver Championship Points by Year",
             xaxis = list(title = "Year"),
             yaxis = list(title = "Points"))
  })
  
  output$driver_wins_plot <- renderPlotly({
    plot_ly(filtered_data()$drivers, x = ~year, y = ~wins, color = ~driver, type = "scatter", mode = "lines") %>%
      layout(title = "Race Wins by Year",
             xaxis = list(title = "Year"),
             yaxis = list(title = "Number of Wins"))
  })
  
  output$constructor_points_plot <- renderPlotly({
    plot_ly(filtered_data()$constructors, x = ~year, y = ~points, color = ~constructor, type = "scatter", mode = "lines") %>%
      layout(title = "Constructor Championship Points by Year",
             xaxis = list(title = "Year"),
             yaxis = list(title = "Points"))
  })
  
  output$constructor_wins_plot <- renderPlotly({
    plot_ly(filtered_data()$constructors, x = ~year, y = ~wins, color = ~constructor, type = "scatter", mode = "lines") %>%
      layout(title = "Constructor Race Wins by Year",
             xaxis = list(title = "Year"),
             yaxis = list(title = "Number of Wins"))
  })
  
  # Data table
  output$f1_table <- renderDT({
    datatable(filtered_data()$drivers,
              options = list(pageLength = 10),
              rownames = FALSE)
  })
}

# Run the application
shinyApp(ui, server)
