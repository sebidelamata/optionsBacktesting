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

# update <- paste0("INSERT INTO public.watchlist_data VALUES ('",watchlist_data$bid[1],"','",watchlist_data$bid_size[1],"','",watchlist_data$ask[1],"','",watchlist_data$ask_size[1],"','",watchlist_data$iv[1],"','",watchlist_data$volume[1],"','",watchlist_data$delta[1],"','",watchlist_data$gamma[1],"','",watchlist_data$theta[1],"','",watchlist_data$rho[1],"','",watchlist_data$vega[1],"','",watchlist_data$theo[1],"','",watchlist_data$change[1],"','",watchlist_data$open[1],"','",watchlist_data$high[1],"','",watchlist_data$low[1],"','",watchlist_data$tick[1],"','",watchlist_data$last_trade_price[1],"','",watchlist_data$last_trade_time[1],"','",watchlist_data$percent_change[1],"','",watchlist_data$prev_day_close[1],"','",watchlist_data$underlying_close[1],"','",watchlist_data$stike_price[1],"','",watchlist_data$contract_type[1],"','",watchlist_data$underlying_ticker[1],"','",watchlist_data$expiration_date[1],"','",watchlist_data$scrape_date[1],"');")
# 
# 
# update <- dbSendQuery(
#   db,
#   update
#   )
# 
# dbClearResult(update)

# table_id <- DBI::Id(
#   db,
#   schema  = "public",
#   table   = "watchlist_data"
# )

DBI::dbWriteTable(
  db,
  name = "watchlist_data",
  value = watchlist_data
  # field.types = c(
  #   option = "text",
  #   bid = "double precision",
  #   bid_size = "integer",
  #   ask = "double precision",
  #   ask_size = "integer",
  #   iv = "double precision",
  #   open_interest = "integer",
  #   volume = "integer",
  #   delta = "double precision",
  #   gamma = "double precision",
  #   theta = "double precision",
  #   rho = "double precision",
  #   vega = "double precision",
  #   theo = "double precision",
  #   change = "double precision",
  #   open = "double precision",
  #   high = "double precision",
  #   low = "double precision",
  #   tick = "text",
  #   last_trade_price = "double precision",
  #   last_trade_time = "double precision",
  #   percent_change = "double precision",
  #   prev_day_close = "double precision",
  #   underlying_close = "double precision",
  #   strike_price = "double precision",
  #   contract_type = "text",
  #   underlying_ticker = "text",
  #   expiration_date = "double precision",
  #   scrape_date = "double precision"
  # ),
  row.names = FALSE,
  append = TRUE
)


DBI::dbDisconnect(db)
