library(dplyr)
library(jsonlite)

# grab option data
grab_option_data <- function(ticker){
  
  # create our scraping address
  scrape_target <- paste0(
    "https://cdn.cboe.com/api/global/delayed_quotes/options/",
    ticker,
    ".json"
    )
  
  # read json data
  scrape_data <- read_json(
    scrape_target,
    simplifyVector = TRUE
  )
  
  # make it into a data frame
  option_data <- as.data.frame(
    scrape_data$data$options
  )
  
  # grab umderlying close
  option_data$underlying_close <- scrape_data$data$close
  
  # return our dataframe
  return(option_data)
  
}