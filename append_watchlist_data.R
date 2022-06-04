library(RPostgreSQL)
library(getPass)

source("grab_watchlist.R")


watchlist_data <- grab_watchlist()


driver_name <- dbDriver(drvName = "PostgreSQL")

db <- DBI::dbConnect(driver_name,
                     dbname="sebi",
                     host="localhost",
                     port = 5432,
                     user = "sebi",
                     password = getPass("Enter Password:")
)


DBI::dbWriteTable(
  db,
  "public.watchlist_data",
  watchlist_data,
  append = TRUE
)


DBI::dbDisconnect(db)
