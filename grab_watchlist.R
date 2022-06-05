# grab our scraper script
source("/home/sebi/optionsBacktesting/scraper.R")


grab_watchlist <- function(){

  # declare the tickers we want in our watchlist
  watchlist <- c(
    "QQQ",
    "SPY",
    "IWM",
    "SLYV",
    "FXI",
    "DIA",
    "ARKK",
    "FEZ",
    "EEM",
    "EWW",
    "EWZ",
    "XLB",
    "XLV",
    "XLU",
    "XLF",
    "XLI",
    "XOP",
    "GLD",
    "SLV",
    "TLT",
    "HYG"
  )
  
  # create an empty dataframe 
  watchlist_data <- data.frame()
  
  # for each ticker in the watchlist grab the option data
  # and union it to the watchlist_data df
  watchlist_data <- do.call(
    rbind,
    lapply(
      watchlist,
      grab_option_data
      )
    )
  
  return(watchlist_data)

}