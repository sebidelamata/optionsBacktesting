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


update <- postgresqlExecStatement(
  db, 
  'insert into public.watchlist_data VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29)',
  list(watchlist_data[1,])
  )


dbClearResult(update)

# DBI::dbWriteTable(
#   db,
#   "watchlist_data",
#   watchlist_data,
#   row.names = FALSE,
#   append = TRUE
# )


DBI::dbDisconnect(db)
