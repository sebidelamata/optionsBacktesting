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

# update <- paste0("INSERT INTO myschema.fruits VALUES ('",watchlist_data$bid,"','",watchlist_data$bid_size,"','",watchlist_data$ask,"','",watchlist_data$ask_size,"','",watchlist_data$iv,"','",watchlist_data$volume,"','",watchlist_data$delta,"','",watchlist_data$gamma,"','",watchlist_data$theta,"','",watchlist_data$rho,"','",watchlist_data$vega,"','",watchlist_data$theo,"','",watchlist_data$change,"','",watchlist_data$open,"','",watchlist_data$high,"','",watchlist_data$low,"','",watchlist_data$tick,"','",watchlist_data$last_trade_price,"','",watchlist_data$last_trade_time,"','",watchlist_data$percent_change,"','",watchlist_data$prev_day_close,"','",watchlist_data$underlying_close,"','",watchlist_data$stike_price,"','",watchlist_data$contract_type,"','",watchlist_data$bid,"','",watchlist_data$bid_size,"','",watchlist_data$ask,"','",watchlist_data$ask_size,"','",watchlist_data$iv,"','",watchlist_data$volume,"','",watchlist_data$delta,"','",watchlist_data$gamma,"','",watchlist_data$theta,"','",watchlist_data$rho,"','",watchlist_data$vega,"','",watchlist_data$theo,"','",watchlist_data$change,"','",watchlist_data$open,"','",watchlist_data$high,"','",watchlist_data$low,"','",watchlist_data$tick,"','",watchlist_data$last_trade_price,"','",watchlist_data$last_trade_time,"','",watchlist_data$percent_change,"','",watchlist_data$prev_day_close,"','",watchlist_data$underlying_close,"','",watchlist_data$stike_price,"');")

# 
# update <- dbSendQuery(
#   db, 
#   'insert into watchlist_data set "option = ?,
#   bid = ?,
#   bid_size = ?,
#   ask = ?,
#   ask_size = ?,
#   iv = ?,
#   open_interest = ?,
#   volume = ?,
#   delta = ?,
#   gamma = ?,
#   theta = ?,
#   rho = ?
#   vega = ?,
#   theo = ?,
#   change = ?,
#   open = ?,
#   high = ?,
#   low = ?,
#   tick = ?,
#   last_trade_price = ?,
#   last_trade_time = ?,
#   percent_change = ?,
#   prev_day_close = ?,
#   underlying_close = ?,
#   strike_price = ?,
#   contract_type = ?,
#   underlying_ticker = ?,
#   expiration_date = ?,
#   scrape_date = ?'
#   )
# 
# 
# dbBind(update, watchlist_data)  # send the updated data
# 
# 
# dbClearResult(update)

DBI::dbWriteTable(
  db,
  name = c("public","watchlist_data"),
  value = watchlist_data[1,],
  field.types = c(
    option = character(),
    bid = numeric(),
    bid_size = integer(),
    ask = numeric(),
    ask_size = integer(),
    iv = numeric(),
    open_interest = integer(),
    volume = integer(),
    delta = numeric(),
    gamma = numeric(),
    theta = numeric(),
    rho = numeric(),
    vega = numeric(),
    theo = numeric(),
    change = numeric(),
    open = numeric(),
    high = numeric(),
    low = numeric(),
    tick = character(),
    last_trade_price = numeric(),
    last_trade_time = numeric(),
    percent_change = numeric(),
    prev_day_close = numeric(),
    underlying_close = numeric(),
    strike_price = numeric(),
    contract_type = character(),
    underlying_ticker = character(),
    expiration_date = numeric(),
    scrape_date = numeric()
  ),
  row.names = FALSE,
  append = TRUE
)


DBI::dbDisconnect(db)
