library(RPostgreSQL)
library(getPass)

driver_name <- dbDriver(drvName = "PostgreSQL")

db <- DBI::dbConnect(driver_name,
		     dbname="sebi",
		     host="localhost",
		     port = 5432,
		     user = "sebi",
		     password = getPass("Enter Password:")
		     )

watchlist_data_table <- data.frame(
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
)


# create_table_query_one <- 'CREATE SCHEMA [IF NOT EXISTS] options;'
# 
# create_table_query_two <- 'CREATE TABLE [IF NOT EXISTS] options.watchlist_data (
#   option VARCHAR ( 32 ) PRIMARY KEY,
#   bid NUMERIC ( 8 ) NOT NULL,
#   bid_size INT NOT NULL,
#   ask NUMERIC ( 8 ) NOT NULL,
#   ask_size INT NOT NULL,
#   iv NUMERIC ( 8 ) NOT NULL,
#   open_interest INT NOT NULL,
#   volume INT NOT NULL,
#   delta NUMERIC ( 8 ) NOT NULL,
#   gamma NUMERIC ( 8 ) NOT NULL,
#   theta NUMERIC ( 8 ) NOT NULL,
#   rho NUMERIC ( 8 ) NOT NULL,
#   vega NUMERIC ( 8 ) NOT NULL,
#   theo NUMERIC ( 8 ) NOT NULL,
#   change NUMERIC ( 8 ) NOT NULL,
#   open NUMERIC ( 8 ) NOT NULL,
#   high NUMERIC ( 8 ) NOT NULL,
#   low NUMERIC ( 8 ) NOT NULL,
#   tick VARCHAR ( 4 ) NOT NULL,
#   last_trade_price NUMERIC ( 8 ) NULL,
#   last_trade_time TIMESTAMP NULL,
#   percent_change NUMERIC ( 8 ) NULL,
#   prev_day_close NUMERIC ( 8 ) NULL,
#   underlying_close NUMERIC ( 8 ) NOT NULL,
#   strike_price NUMERIC ( 8 ) NOT NULL,
#   contract_type CHAR ( 1 ) NOT NULL,
#   underlying_ticker VARCHAR ( 4 ) NOT NULL,
#   expiration_date DATE NOT NULL,
#   scrape_date DATE NOT NULL
#   );
#   '

DBI::dbWriteTable(
  db,
  "watchlist_data",
  watchlist_data_table
)


DBI::dbDisconnect(db)
