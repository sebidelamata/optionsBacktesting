library(timeDate)

source("/home/sebi/optionsBacktesting/append_watchlist_data.R")

if(as.POSIXlt(Sys.Date())$wday %in% 1:5 & Sys.Date() !(%in% as.Date(timeDate::holidayNYSE()))){
  append_watchlist_data()
} else {
  message("Market Closed Today")
}
