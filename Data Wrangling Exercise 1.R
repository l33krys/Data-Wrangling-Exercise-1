# 0: Installed packages tidyr, dplyr, readxls to import xls file and wrangle data

library(tidyr)
library(dplyr)
library(knitr)
library(readxl)
refine <- read_excel("Documents/Data Science Intro/refine.csv")
View(refine)

# 1: Clean up brand names

# Selected the company column and turned it into a vector of names. Sorted the list of company names in alpha order to make creating a new dataframe easier
sort_company <- sort(as.vector(as.matrix(refine[,1])))

# Used the vector to create a dataframe that corresponds to the correct spelling
sort_company_df <- data_frame(company = unique(sort_company), fixed_company = c("akzo", "akzo", "akzo", "akzo", "akzo", "philips", "philips", "philips", "philips", "philips", "philips", "philips", "philips", "unilever", "unilever", "unilever", "van houten", "van houten", "van houten"))

# Used left_join() to create new column with correct company name
refine1 <- left_join(refine, sort_company_df, by = "company")

# Modified columns by using the select() function to get the columns in order
refine1_1 <- select(refine1, "fixed_company", "Product code / number", "address", "city", "country", "name")

# Renamed new column name back to "company"
names(refine1_1)[names(refine1_1) == "fixed_company"] <- "company"

# 2: Separate product code and number
refine2 <-separate(refine1_1, "Product code / number", c("product_code", "product_number"), sep = "-")

# 3: Add product categories

# Created new dataframe to have the product code line up with product category
prod_cod <- data_frame(product_code = c("p", "v", "x", "q"), product_category = c("Smartphone", "TV", "Laptop", "Tablet"))

# Used left_join to find matches
refine2 <- left_join(refine2, prod_cod, by = "product_code")

# 4: Add full address for geocoding

# Used unite() to combine full address
refine2 <- unite(refine2, "full_address", address, city, country, sep = ",")

# 5: Create dummy variables for company and product category

# Created dataframe for company columns with company names as row 1 and corresponding company columns with binary values
ccode <- data_frame(company = c("philips", "akzo", "van houten", "unilever"), product_philips = c(1, 0, 0, 0), product_akzo = c(0, 1, 0, 0), product_van_houten = c(0, 0, 1, 0), product_unilever = c(0, 0, 0, 1))
refine3 <- left_join(refine2, ccode, by = "company")

# Created dataframe for product code columns with product code as row 1 and corresponding product code columns with binary values
pcode <- data_frame(product_code = c("p", "v", "x", "q"), product_smartphone = c(1, 0, 0, 0), product_tv = c(0, 1, 0, 0), product_laptop = c(0, 0, 1, 0), product_tablet = c(0, 0, 0, 1))
refine_clean <- left_join(refine3, pcode, by = "product_code")

# 6: Submit the project on Github