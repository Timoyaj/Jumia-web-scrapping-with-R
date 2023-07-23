# Load required packages
library(rvest)
library(dplyr)
library(stringr)
library(glue)
library(tidyverse)
library(RMySQL)
library(DBI)

# Function to scrape Jumia product information and store it in MySQL database
scrape_jumia_and_store <- function(category_url, max_pages = 50, delay_seconds = 3,
                                   db_username, db_password, db_name, db_host) {
  # Function to scrape Jumia product information
  scrape_jumia <- function(url) {
    page <- read_html(url)
    
    # Extract all product divs
    product_divs <- page %>%
      html_nodes(".c-prd")  # Replace "product-class" with the actual class name of the product divs
    
    # Initialize an empty list to store product data
    product_list <- vector("list", length = length(product_divs))
    
    # Iterate over each product div
    for (i in seq_along(product_divs)) {
      product_div <- product_divs[i]
      
      # Extract the variables of interest from the product div, handling missing classes
      name <- product_div %>%
        html_node(".name") %>%
        html_text()  # Replace "name-class" with the actual class name of the product name
      
      price <- product_div %>%
        html_node(".prc") %>%
        html_text() # Replace "price-class" with the actual class name of the product price
      
      # Extract product discount
      discount <- product_div %>%
        html_nodes("._sm") %>%
        html_text() %>%
        ifelse(is_empty(.), "0", .) %>%
        as.character()
      
      # Extract product ratings
      ratting <- product_div %>%
        html_nodes(".rev") %>%
        html_text() %>%
        ifelse(is_empty(.), "0", .)
      rating <- str_extract(ratting, "\\d+\\.?\\d*") %>%
        as.numeric()
      
      # Extract product reviews
      reviews <- product_div %>%
        html_nodes(".rev") %>%
        html_text() %>%
        ifelse(is_empty(.), "0", .)
      review <- str_extract(reviews, "(?<=\\()\\d+(?=\\))") %>%ifelse(is_empty(.), "0", .) %>%
        as.numeric()
      
      # Extract the URL to the product image
      img_url <- product_div %>%
        html_node(".core") %>%
        html_attr("href")  # Replace "image-class" with the actual class name of the product image URL
      image_url <- glue("https://www.jumia.com.ng{img_url}")
      
      brand <- product_div %>%
        html_node(".core") %>%
        html_attr("data-brand")
      
      # Create a data frame for the current product
      product_data <- data_frame(Name = name, Brand = brand, Price = price, Discount = discount,
                                 Rating = rating, Reviews = review, Image_url = image_url)
      
      # Add the current product data to the list
      product_list[[i]] <- product_data
    }
    
    # Combine the product list into a single data frame
    product_data <- bind_rows(product_list) %>% filter(!is.na(Name))
    
    # Return the data frame
    return(product_data)
  }
  
  # Scrape Jumia Product Information
  scrape_jumia_data <- function(url) {
    # Scrape the category page
    product_data <- scrape_jumia(url)
    
    # Delay between requests (in seconds)
    delay <- delay_seconds
    
    # Maximum number of pages to scrape
    max_pages <- max_pages
    
    # Scrape additional pages with delays between requests
    page_num <- 2
    while (page_num <= max_pages) {
      page_url <- glue("{url}?page={page_num}#catalog-listing")  # Create the URL for each additional page
      
      # Scrape the page
      additional_data <- scrape_jumia(page_url)  # Call the scrape_jumia function with the additional page URL
      
      # Check if there is any data to append
      if (nrow(additional_data) == 0) {
        # No more pages to scrape, exit the loop
        break
      }
      
      # Append the additional data to the main data frame
      product_data <- bind_rows(product_data, additional_data)
      
      # Pause for the specified delay
      Sys.sleep(delay)
      
      # Increment the page number
      page_num <- page_num + 1
    }
    
    return(product_data)
  }
  
  # Scrape Jumia product data
  product_data <- scrape_jumia_data(category_url)
  
  # Save scraped data to CSV file
  write.csv(product_data, "Jumia_phones_scrap2.csv", row.names = FALSE)
  
  # Connect to MySQL database
  con <- dbConnect(MySQL(),
                   user = db_username,
                   password = db_password,
                   dbname = db_name,
                   host = db_host)
  
  # Save DataFrame to MySQL database table named 'phones'
  dbWriteTable(con, "phones", product_data, row.names = FALSE, overwrite = TRUE)
  dbListTables(con)
  dbDisconnect(con)
  
  return(invisible(product_data))
}

# Example Usage:
category_url <- "https://www.jumia.com.ng/mobile-phones/"
db_username <- "root"
db_password <- "Yaji@1986"
db_name <- "jumia"
db_host <- "localhost"

scraped_data <- scrape_jumia_and_store(category_url, db_username = db_username, 
                                       db_password = db_password, db_name = db_name, 
                                       db_host = db_host)





  
  
  
  