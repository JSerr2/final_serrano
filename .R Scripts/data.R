library(tidyverse)
library(tidycensus)

# Importing original data sets, change directory to your saved file location

attendance <- readxl::read_xlsx("C:\\Users\\joses\\OneDrive\\Documents\\GitHub\\final_serrano\\Data\\2019-Report-Card-Public-Data-Set.xlsx", sheet = "General")

cep <- readxl::read_xlsx("C:\\Users\\joses\\OneDrive\\Documents\\GitHub\\final_serrano\\Data\\fy19-eligibilitydata.xlsx")

# Data cleaning by eliminating spaces and creating consistent column names

new_colnames <- as.character(cep[3, ])
colnames(cep) <- new_colnames

cep <- cep %>% 
  slice(-1, -2, -3)

colnames(cep) <- gsub(" ", "_", colnames(cep))
colnames(attendance) <- gsub(" ", "_", colnames(attendance))

attendance <- attendance %>%
  mutate(School_Name_Clean = tolower(gsub("[^a-zA-Z0-9 ]", "", School_Name)),
         District_Clean = tolower(gsub("[^a-zA-Z0-9 ]", "", District)),
         City_Clean = tolower(gsub("[^a-zA-Z0-9 ]", "", City)))

cep <- cep %>%
  mutate(School_Name_Clean = tolower(gsub("[^a-zA-Z0-9 ]", "", Site)),
         District_Clean = tolower(gsub("[^a-zA-Z0-9 ]", "", District)),
         City_Clean = tolower(gsub("[^a-zA-Z0-9 ]", "", Site_City)))

# Merging data

merged_data <- attendance %>%
  inner_join(cep, by = c("School_Name_Clean", "District_Clean", "City_Clean"))

# Saved cleaned data, change directory to location where you want to save the data

write_csv(merged_data, "C:/Users/joses/OneDrive/Documents/GitHub/final_serrano/Data/final_merged_data.csv")

# Automatic Data Retrieval, input key in this line of code

census_api_key("ae01069c564a94c61d198e88a6563d408de746a1", install = TRUE)

# Elementary School Districts
elementary_data <- get_acs(
  geography = "school district (elementary)",
  variables = c("B17020_002E"), 
  state = "IL",
  year = 2019
)

# Secondary School Districts
secondary_data <- get_acs(
  geography = "school district (secondary)",
  variables = c("B17020_002E"),
  state = "IL", 
  year = 2019
)

# Unified School Districts
unified_data <- get_acs(
  geography = "school district (unified)",
  variables = c("B17020_002E"),
  state = "IL",
  year = 2019
)



