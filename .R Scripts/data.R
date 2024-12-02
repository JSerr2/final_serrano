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

merged_data <- merged_data %>% 
  select(
    RCDTS,
    RCDT,
    Site_Number,
    Site_County,
    District_Clean,
    City_Clean,
    Site_Address,
    Site_Zip,
    School_Name_Clean,
    Title_1_Status,
    `#_Student_Enrollment`,
    `%_Student_Enrollment_-_Low_Income`,
    Student_Attendance_Rate,
    Student_Chronic_Truancy_Rate,
    Chronically_Truant_Students,
    `High_School_Dropout_Rate_-_Total`,
    `High_School_4-Year_Graduation_Rate_-_Total`,
    Chronic_Absenteeism,
    Free_Eligibles,
    Reduced_Eligibles,
    PaidEligibles,
    Enrollment,
    Eligibility_Percent,
    Participates_in_CEP,
    )

merged_data <- merged_data %>%
  mutate(
    Participates_in_CEP = ifelse(is.na(Participates_in_CEP), "Non-CEP", "CEP")
  )

# Define poverty levels based on FRPL eligibility
merged_data <- merged_data %>%
  mutate(
    Poverty_Level = case_when(
      `%_Student_Enrollment_-_Low_Income` <= 25.0 ~ "Low Poverty",
      `%_Student_Enrollment_-_Low_Income` <= 50.0 ~ "Mid-Low Poverty",
      `%_Student_Enrollment_-_Low_Income` <= 75.0 ~ "Mid-High Poverty",
      TRUE ~ "High Poverty"
    )
  )


# Saved cleaned data, change directory to location where you want to save the data

write_csv(merged_data, "C:/Users/joses/OneDrive/Documents/GitHub/final_serrano/Data/final_merged_data.csv")

# Automatic Data Retrieval, input key in this line of code
census_api_key("ae01069c564a94c61d198e88a6563d408de746a1", install = TRUE)

# Toggle between API data and archived data
use_api <- TRUE  # Set to TRUE to pull fresh data from the API

# Data Paths for Archived Data
county_data_path <- "C:\\Users\\joses\\OneDrive\\Documents\\GitHub\\final_serrano\\Data\\county_wide.csv"
acs_data_path <- "C:\\Users\\joses\\OneDrive\\Documents\\GitHub\\final_serrano\\Data\\acs_data_wide.csv"

if (use_api) {
  # Load or retrieve ACS school district data
  
  # Elementary School Districts
  elementary_data <- get_acs(
    geography = "school district (elementary)",
    variables = c("B17010_002E"), 
    state = "IL",
    year = 2019
  )
  
  # Secondary School Districts
  secondary_data <- get_acs(
    geography = "school district (secondary)",
    variables = c("B17010_002E"),
    state = "IL", 
    year = 2019
  )
  
  # Unified School Districts
  unified_data <- get_acs(
    geography = "school district (unified)",
    variables = c("B17010_002E"),
    state = "IL",
    year = 2019
  )
  
  # County
  county_acs <- get_acs(
    geography = "county",
    variables = c("B17010_002E"),
    state = "IL",
    year = 2019
  )
  
  # Merging ACS School Data
  elementary_data <- elementary_data %>% mutate(District_Type = "Elementary")
  secondary_data <- secondary_data %>% mutate(District_Type = "Secondary")
  unified_data <- unified_data %>% mutate(District_Type = "Unified")
  
  acs_data <- bind_rows(elementary_data, secondary_data, unified_data)
  
  # Reshaping ACS School and County Data
  acs_data_wide <- acs_data %>% 
    select(GEOID, NAME, variable, estimate, District_Type) %>% 
    pivot_wider(
      names_from = variable,
      values_from = estimate
    )
  
  county_wide <- county_acs %>% 
    select(GEOID, NAME, variable, estimate) %>% 
    pivot_wider(
      names_from = variable,
      values_from = estimate
    )
  
  # Final ACS School and County Cleaning
  acs_data_wide <- acs_data_wide %>% 
    mutate(District_Clean = tolower(gsub("[^a-zA-Z0-9 ]", "", NAME)))
  
  acs_data_wide <- acs_data_wide %>%
    mutate(District_Clean = tolower(gsub(", Illinois$", "", NAME)))
  
  county_wide <- county_wide %>%
    mutate(
      County_Clean = gsub("County, Illinois", "", NAME),  
      County_Clean = trimws(County_Clean)          
    )
  
  # Save the retrieved data
  write_csv(county_wide, county_data_path)
  write_csv(acs_data_wide, acs_data_path)
  
  print("Data pulled from the API and saved.")
  
} else {
  # Load archived data
  county_wide <- read_csv(county_data_path)
  acs_data_wide <- read_csv(acs_data_path)
  
  print("Data loaded from archived files.")
}

# Grouping by poverty level and CEP participation
comparison_data <- merged_data %>%
  group_by(Poverty_Level, Participates_in_CEP) %>%
  summarise(
    Avg_Chronic_Truancy = mean(Student_Chronic_Truancy_Rate, na.rm = TRUE),
    Avg_Chronic_Absenteeism = mean(Chronic_Absenteeism, na.rm = TRUE),
    n = n()
  )

# Title 1 Binary Variable
merged_data <- merged_data %>%
  mutate(
    Title_1_Binary = case_when(
      Title_1_Status %in% c("Schoolwide Title I Program", "Targeted Assistance Title I Program") ~ "Participates",
      Title_1_Status == "Eligible, but Not a Participant in Title I Program" ~ "Eligible But Not Participating",
      TRUE ~ "Not Eligible"
    )
  )
