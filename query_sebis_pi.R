
# function to connect to sebis raspberry pi and query the PostgreSQL db
query_sebis_pi <- function(sql_query_string){
  
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
  
  # combination of our connnection stuff and our query stuff
  res <- dbSendQuery(db, sql_query_string)
  
  # fetch our data query from the database and return a dataframe
  data_pull <- dbFetch(res)
  
  # clear our query results
  dbClearResult(res)
  
  # politely disconnect from the database
  dbDisconnect(db)
  
  # return our query result dataframe
  return(data_pull)
  
}