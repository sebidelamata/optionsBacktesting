library(RPostgreSQL)
library(getPass)

# set driver name
driver_name <- dbDriver(drvName = "PostgreSQL")

# establish database connection
db <- DBI::dbConnect(driver_name,
                     dbname = "sebi",
                     host = "192.168.0.12",
                     port = 5432,
                     user = "sebi",
                     password = getPass("Enter Password:")
)

res <- dbSendQuery(db, "SELECT * FROM watchlist_data;")
data_pull <- dbFetch(res)
dbClearResult(res)
dbDisconnect(db)