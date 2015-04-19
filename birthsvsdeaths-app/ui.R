library(shiny)

source("dataLoader.R")

# Load country and region options based on the supplied metadata
# The files for births and deaths are the same so it is sufficient to
# only read and generate options from the birth metadata file
sourceMetadataFile <- "data/Metadata_Country_sp.dyn.cbrt.in_Indicator_en_csv_v2.csv"
countryOptions <- getCountryOptions(sourceMetadataFile)
regionOptions <- getRegionOptions(sourceMetadataFile)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Global development of crude births and deaths"),
    
    # Sidebar with a slider input for the number of bins
    sidebarLayout(
        sidebarPanel(
            selectInput("country", 
                        label = "Select a country to display:",
                        choices = countryOptions,
                        selected = "DEFAULT"),
            selectInput("region", 
                        label = "Select a region to display:",
                        choices = regionOptions,
                        selected = "DEFAULT"),
            sliderInput("years", "Select a year range:",
                        min = 1960, max = 2013, value = c(1960,2013)),
            checkboxInput("zeroYLimit", label = "Set y limit to 0", value = TRUE)
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("bsvdPlot")
        )
    )
))