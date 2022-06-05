library(RPostgreSQL)
library(getPass)

source("grab_watchlist.R")


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

# create try catch function
error_test <- tryCatch(
  
  {
  # run our main function
  append_watchlist_data()
  },
  {
    error = print("Error writing data to table")
  }
)

error_test
