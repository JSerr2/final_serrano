library(tidyverse)

# Importing original data sets, change directory to your saved file location

attendance <- readxl::read_xlsx("C:\\Users\\joses\\OneDrive\\Documents\\GitHub\\final_serrano\\Data\\24-RC-Pub-Data-Set.xlsx", sheet = "General")

cep <- readxl::read_xlsx("C:\\Users\\joses\\OneDrive\\Documents\\GitHub\\final_serrano\\Data\\fy24-eligibility.xlsx")

# Data cleaning by eliminating spaces and creating consistent column names

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

