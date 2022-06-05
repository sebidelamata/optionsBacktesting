library(RPostgreSQL)
library(getPass)

source("/home/sebi/optionsBacktesting/grab_watchlist.R")


append_watchlist_data <- function(){
  
  # grab our watchlist data
  watchlist_data <- grab_watchlist()
  
  # establish driver name
  driver_name <- dbDriver(drvName = "PostgreSQL")
  
  # create database connection
  db <- DBI::dbConnect(driver_name,
                       dbname="sebi",
                       host="localhost",
                       port = 5432
  )
  
  # append our scraped data to the table
  DBI::dbWriteTable(
    db,
    name = "watchlist_data",
    value = watchlist_data,
    row.names = FALSE,
    append = TRUE
  )
  
  # close database connection
  DBI::dbDisconnect(db)
}
