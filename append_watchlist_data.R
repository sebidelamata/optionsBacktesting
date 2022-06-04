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


update <- dbSendQuery(
  db, 
  'insert into public.watchlist_data set "option = ?,
  bid = ?,
  bid_size = ?,
  ask = ?,
  ask_size = ?,
  iv = ?,
  open_interest = ?,
  volume = ?,
  delta = ?,
  gamma = ?,
  theta = ?,
  rho = ?
  vega = ?,
  theo = ?,
  change = ?,
  open = ?,
  high = ?,
  low = ?,
  tick = ?,
  last_trade_price = ?,
  last_trade_time = ?,
  percent_change = ?,
  prev_day_close = ?,
  underlying_close = ?,
  strike_price = ?,
  contract_type = ?,
  underlying_ticker = ?,
  expiration_date = ?,
  scrape_date = ?'
  )


dbBind(update, watchlist_data[1,])  # send the updated data


dbClearResult(update)

# DBI::dbWriteTable(
#   db,
#   "watchlist_data",
#   watchlist_data,
#   row.names = FALSE,
#   append = TRUE
# )


DBI::dbDisconnect(db)
