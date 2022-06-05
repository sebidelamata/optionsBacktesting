library(RPostgreSQL)
library(getPass)

source("./grab_watchlist.R")

create_watchlist_table <- function(){
  
  # set driver name
  driver_name <- dbDriver(drvName = "PostgreSQL")
  
  # establish database connection
  db <- DBI::dbConnect(driver_name,
  		     dbname="sebi",
  		     host="localhost",
  		     port = 5432
  		     )
  
  # grab todays watchlist data
  watchlist_data <- grab_watchlist()
  
  
  # create our table with todays data (overwrite if already exists)
  DBI::dbWriteTable(
    db,
    value =  watchlist_data,
    name = "watchlist_data",
    overwrite = TRUE,
    row.names = FALSE
  )
  
  # set primary key column
  DBI::dbSendQuery(
    db,
    'ALTER TABLE watchlist_data ADD PRIMARY KEY ("option")'
    )
  
  # disconnect from database
  DBI::dbDisconnect(db)

}

create_watchlist_table()
