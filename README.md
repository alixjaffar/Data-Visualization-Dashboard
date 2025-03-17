# Data-Visualization-Dashboard
A Data Visualization Dashboard to help you process and understand raw data properly.

An interactive data visualization dashboard built with R Shiny that displays global COVID-19 statistics and trends.

## Features
- Interactive line charts showing COVID-19 cases and deaths over time
- Choropleth map displaying case distribution across countries
- Summary statistics and key metrics
- Country-specific filters and date range selection
- Responsive design that works on both desktop and mobile

## Setup Instructions

1. Install R and RStudio if you haven't already
2. Install required R packages by running:
   ```R
   install.packages(c("shiny", "tidyverse", "plotly", "DT", "leaflet", "shinydashboard"))
   ```
3. Run the application by opening `app.R` in RStudio and clicking "Run App"

## Data Source
The dashboard uses COVID-19 data from Our World in Data (https://ourworldindata.org/covid-data)

## Dependencies
- shiny
- tidyverse
- plotly
- DT
- leaflet
- shinydashboard 
