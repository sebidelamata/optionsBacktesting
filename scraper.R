library(dplyr)
library(jsonlite)
library(stringi)

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
  
  # clean last trade datetime from string
  option_data$last_trade_time <- as.POSIXct(
    option_data$last_trade_time, 
    "%Y-%m-%dT%H:%M:%S", 
    tz = "America/Chicago"
    )
  
  # grab umderlying close
  option_data$underlying_close <- scrape_data$data$close
  
  # grab our strike price from the option name string
  option_data$strike_price <- as.numeric(stri_sub(option_data$option, -8)) / 1000
   
  # grab our contract type from the option name string
  option_data$contract_type <- as.factor(stri_sub(option_data$option, -9, -9))
  
  # grab our underlying ticker from the option name string
  option_data$underlying_ticker <- as.factor(stri_sub(option_data$option, -999, -16))
  
  # grab our underlying ticker from the option name string
  option_data$expiration_date <- as.Date(
    stri_sub(option_data$option, -15, -10),
    format = "%y%m%d"
    )
  
  # if we want to set this up to scrape every day
  # we need to create a column to record 
  # on what day the data was scraped
  option_data$scrape_date <- Sys.Date()
  
  # since we have already taken all the useful data
  # from the option column, we can keep using it as
  # a unique identifier for our table if we append
  # the scrape date to the end of the string
  option_data$option <- paste0(
    option_data$option,
    as.character(Sys.Date())
  )
  
  # return our dataframe
  return(option_data)
  
}