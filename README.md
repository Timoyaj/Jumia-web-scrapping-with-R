# Web Scraping Jumia Nigeria Product Information with R
This project aims to demonstrate a web scraping approach to collect product information from Jumia, a popular online marketplace in Nigeria. The data collected includes details such as product prices, ratings, discounts, and brands from the mobile phones category. The project is implemented using R and utilizes various R packages, such as 'rvest', 'dplyr', 'stringr', 'glue', 'tidyverse', 'RMySQL', and 'DBI', to scrape, manipulate, and store the data.

## Table of Contents
- [Introduction](#Introduction)
- [Requirements](#Requirements)
- [Installation](#Installation)
- [Usage](#Usage)
- [Unit Testing](#UnitTesting)
- [Results](#Results)
- [Contributing](#Contribution)
- [License](#License)
## Introduction
The growth of online marketplaces has created vast amounts of valuable data that can be utilized for various purposes, including market analysis, pricing insights, and trend identification. Web scraping allows us to extract this data from web pages and organize it for further analysis. This project focuses on scraping product details from Jumia's mobile phones category and storing it in both CSV files and a MySQL database.

## Requirements
Before running the project, you need to have the following prerequisites:
R (version 4.3.0 or higher)
R packages: 'rvest', 'dplyr', 'stringr', 'glue', 'tidyverse', 'RMySQL', 'DBI', and 'testthat'
MySQL database (optional, required only for database storage)

## Installation
Make sure you have R installed on your system. If not, download and install R from the official R website: https://www.r-project.org/
Install the required R packages by running the following command in your R environment:
``` {r}
install.packages(c("rvest", "dplyr", "stringr", "glue", "tidyverse", "RMySQL", "DBI", "testthat"))
```
If you want to store the data in a MySQL database, ensure a MySQL server is running, and create a database and table to store the scraped data.

## Usage
- Clone this repository to your local machine using the following command:
```{r}
bash
git clone https://github.com/your-username/your-repository.git
 ```
- Navigate to the project directory:
```{r}cd your-repository
```
- Open the R script scrape_jumia.R using your preferred R development environment (e.g., RStudio).

- Modify the BASE_URL variable in the script to the desired Jumia mobile phones category URL.

- Run the script to start the web scraping process:

```{r}
source("scrape_jumia.R")
```
The script will collect product information from multiple pages of Jumia's mobile phones category, clean the data, and save it in a CSV file (data.csv) and, if configured, a MySQL database.

## Unit Testing

To ensure the functionality and reliability of the scraping function, this project includes unit tests using the testthat package. The unit test checks if the function returns a data frame with the expected columns and values for a given URL.

To run the unit tests, execute the following command in your R environment:

```{R}
#code
testthat::test_dir("tests")
```

## Results
The project results provide insights into the distribution of product prices, ratings, discounts, and brands across the scraped dataset. These results can be used for further analysis and decision-making processes.

## Contributing
Contributions to this project are welcome. If you find any issues or want to enhance the functionality, feel free to submit a pull request.

## License
This project is licensed under the MIT License. Feel free to use and modify the code as per the terms of the license.

We hope this project helps you understand how to utilize web scraping techniques and SQL integration in R to collect and manage online data effectively. Should you have any questions or feedback, please don't hesitate to reach out.

*Happy scraping!* 🚀
