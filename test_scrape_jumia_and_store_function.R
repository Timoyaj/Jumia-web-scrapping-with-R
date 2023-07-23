# Load the function and testthat package (if not already loaded)
library(testthat)
source("C:/Users/USER/Documents/practice_R/scrape_jumia_and_store_function.R")

# Define a test context
test_that("Test scrape_jumia_and_store function", {
  
  # Test if the function returns a data frame
  test_data_frame <- scrape_jumia_and_store(category_url = "https://www.jumia.com.ng/mobile-phones/",
                                            max_pages = 1,
                                            delay_seconds = 0,
                                            db_username = "root",
                                            db_password = "Your_DB_Password",
                                            db_name = "test_jumia",
                                            db_host = "localhost")
  
  expect_is(test_data_frame, "data.frame")
  
  # Test MySQL database connection and data insertion
  con <- DBI::dbConnect(RMySQL::MySQL(), 
                        user = "root",
                        password = "Your_DB_Password",
                        dbname = "test_jumia",
                        host = "localhost")
  
  # Check if the 'phones' table exists in the database
  expect_true("phones" %in% DBI::dbListTables(con))
  
  # Check the number of rows in the 'phones' table
  query_result <- DBI::dbGetQuery(con, "SELECT COUNT(*) FROM phones")
  expect_equal(query_result, nrow(test_data_frame))
  
  # Close the database connection
  DBI::dbDisconnect(con)
})

