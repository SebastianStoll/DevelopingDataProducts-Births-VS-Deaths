library(dplyr)

# Function for parse and cleaning the source the data files, which have the same structure
parseSourceData <- function(sourceFileName) {
    yearColumns <- paste("Y",1960:2013,sep="")
    colNames <- c("CountryName", "CountryCode", "IndicatorName", "IndicatorCode", yearColumns, "r1", "r2")
    colClasses <- c(rep("character",58), rep("NULL",2))
    sourceDataRaw <- read.table(sourceFileName, 
                               skip = 3, 
                               col.names = colNames,
                               colClasses = colClasses,
                               stringsAsFactors = FALSE,
                               header = FALSE,
                               sep = ",",
                               quote = "\"")
    
    # converting the year columns into numeric columns
    for(i in c(5:58)) {
        sourceDataRaw[,i] <- as.numeric(sourceDataRaw[,i])
    }
    sourceDataRaw
}

# Function cleaning and parsing the meta data source files
parseSourceMetaData <- function(sourceMetadataFileName) {
    colNames <- c("CountryName", "CountryCode", "Region", "IncomeGroup", "SpecialNotes","r1")
    colClasses <- c(rep("character",5),"NULL")
    sourceMetaDataRaw <- read.table(sourceMetadataFileName, 
                                skip = 1, 
                                col.names = colNames,
                                colClasses = colClasses,
                                stringsAsFactors = FALSE,
                                header = FALSE,
                                sep = ",",
                                na.strings = c("NA"," ",""),
                                quote = "\"")
    sourceMetaDataRaw
}

# Extracts all countries from the meta data
# Countries are all rows with an existing region
getCountries <- function(metaDataSourceFile) {
    metaData <- parseSourceMetaData(metaDataSourceFile)
    metaData <- metaData[!is.na(metaData$Region),]
    metaData[,1:4]
}

# Extracts all regions from the meta data
# Regions are all rows with an empty region column
# because they define the region themselves
getRegions <- function(metaDataSourceFile) {
    metaData <- parseSourceMetaData(metaDataSourceFile)
    metaData <- metaData[is.na(metaData$Region),]
    metaData[,1:4]
}

# Retrieves a named list with all country codes and names for them
getCountryOptions <- function(sourceMetaDataFile) {
    countries <- getCountries(sourceMetaDataFile)
    countries <- rbind(countries, c("Select a country","DEFAULT","",""))
    countryOptions <- setNames(as.list(countries$CountryCode),countries$CountryName)
}

# Retrieves a named list with all region codes and names for them
getRegionOptions <- function(sourceMetaDataFile) {
    regions <- getRegions(sourceMetaDataFile)
    regions <- rbind(regions, c("Select a region","DEFAULT","",""))
    setNames(as.list(regions$CountryCode),regions$CountryName)
}