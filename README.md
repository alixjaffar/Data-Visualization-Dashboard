# Formula 1 Championship Dashboard

An interactive data visualization dashboard built with R Shiny that displays Formula 1 championship statistics and trends from 1950 to present.

## Features
- Interactive line charts showing driver and constructor championship points over time
- Bar charts displaying top drivers by championships
- Summary statistics including total championships, race wins, and points
- Decade-specific filters and driver selection
- Separate views for driver and constructor championships
- Responsive design that works on both desktop and mobile

## Dashboard Sections

### Overview Tab
- Total Driver Championships
- Most Race Wins
- Most Points in a Season
- Total Constructor Championships
- Championship Points Over Time
- Top 10 Drivers by Championships

### Driver Champions Tab
- Driver Championship Points by Year
- Race Wins by Year

### Constructor Champions Tab
- Constructor Championship Points by Year
- Constructor Race Wins by Year

### Data Table Tab
- Raw data view with sorting and filtering capabilities

## Setup Instructions

1. Install R and RStudio if you haven't already
2. Install required R packages by running:
   ```R
   install.packages(c("shiny", "tidyverse", "plotly", "DT", "leaflet", "shinydashboard"))
   ```
3. Run the application by opening `app.R` in RStudio and clicking "Run App"

## Data Source
The dashboard currently uses sample data. Future versions will include real Formula 1 championship data from official sources.

## Dependencies
- shiny
- tidyverse
- plotly
- DT
- leaflet
- shinydashboard 
