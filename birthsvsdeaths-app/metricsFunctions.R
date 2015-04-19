# For fetching metric the getMetrics functions is filtering an input
# data set which contains either births for deaths for a country or region
# The function returns a numeric vector for the selected years
getMetrics <- function(inputData, filterCode, startYear=1960, endYear=2013) {
    #Filter out requested country / region
    filteredData <- filter(inputData, CountryCode == filterCode)
    
    #Check input for start and end year
    if(is.na(startYear) || startYear < 1960 || startYear > 2013 ) {
        startYear = 1960
    }
    if(is.na(endYear) || endYear < 1960 || endYear > 2013 ) {
        endYear = 2013
    }
    colNames <- paste("Y",startYear:endYear,sep="")
    colNums <- match(colNames,names(inputData))
    # Filter out years and convert them into a numeric vector
    filteredYears <- as.numeric(as.vector(select(filteredData,colNums)))
    filteredYears
}