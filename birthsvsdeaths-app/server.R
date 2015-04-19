library(shiny)

source("dataFunctions.R")
source("metricsFunctions.R")

# Prepare and load all source data and metadata files
birthSourceFile <- "data/sp.dyn.cbrt.in_Indicator_en_csv_v2.csv"
deathSourceFile <- "data/sp.dyn.cdrt.in_Indicator_en_csv_v2.csv"
sourceMetadataFile <- "data/Metadata_Country_sp.dyn.cbrt.in_Indicator_en_csv_v2.csv"

birthData <- parseSourceData(birthSourceFile)
deathData <- parseSourceData(deathSourceFile)

# The options are required for generating the correct graph titles later on
countryOptions <- getCountryOptions(sourceMetadataFile)
regionOptions <- getRegionOptions(sourceMetadataFile)
print(countryOptions)
print(names(which(countryOptions == "DEU")))
#print(names("Germany" %in% countryOptions))

shinyServer(function(input, output, session) {
    
    # Reset the country selector to its default value if 
    # the region selection changes.
    observe({
        region <- input$region
        if(region != "DEFAULT") {
            updateSelectInput(session, "country", selected = "DEFAULT")
        } 
    })
    
    # Reset the region selector to its default value if 
    # the country selection changes
    observe({
        country <- input$country
        if(country != "DEFAULT") {
            updateSelectInput(session, "region", selected = "DEFAULT")
        }         
    })
    
    # The main plot function for rendering the output
    # It distinguishes between selected regions and countries
    output$bsvdPlot <- renderPlot({
          # Evaluating the input and setting a code for filtering births / deaths
          code <- NA
          codeName <- " - empty selection - "
          if(input$region != "DEFAULT") {
              code <- input$region
              codeName <- names(which(regionOptions == code))
          }
          if(input$country != "DEFAULT") {
              code <- input$country
              codeName <- names(which(countryOptions == code))
          }
          
          # calculating the year range
          yearStart <- input$years[1]    
          yearEnd <- input$years[2]    
          xAxisYears <- yearStart:yearEnd
          yearCount <- length(xAxisYears)
          
          # Setting default values in case no country or region selection is present
          yMax = 1
          yMin = 0
          births <- c(rep(0,yearCount))
          deaths <- c(rep(0,yearCount))      
          
          #Get metrics for selected country or region if selected
          if(!is.na(code)) {
              births <- getMetrics(birthData,code,yearStart,yearEnd)
              deaths <- getMetrics(deathData,code,yearStart,yearEnd)
              yMax <- max(max(births, na.rm = TRUE),max(deaths, na.rm = TRUE))
              yMin <- min(min(births, na.rm = TRUE),min(deaths, na.rm = TRUE))
              if(input$zeroYLimit == TRUE) {
                yMin <- 0    
              }
          } 
          
          # Plotting the results and adding the legend to the graph
          plot(xAxisYears,births, 
               type = "l", 
               ylim = c(yMin,yMax), 
               col = "green", 
               ylab = "Crude births / deaths per 1000 population",
               xlab = "Years",
               main = paste("Births vs. Deaths for",codeName))
          lines(xAxisYears,deaths,col="red")
          legend("topright", legend = c("Births", "Deaths"), col = c("green","red"), lty=c(1,1))    
    })
})