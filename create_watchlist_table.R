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


create_table_query <- "CREATE TABLE [IF NOT EXISTS] watchlist_data (
	


