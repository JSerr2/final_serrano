# Impact of the Community Eligibility Provision on Chronic Absenteeism and Truancy

## Project Summary

This project examines the relationship between Community Eligibility Provision (CEP) participation and attendance outcomes (chronic absenteeism and truancy) in Illinois
public schools. Using multiple datasets, I investigated whether schools participating in CEP have different attendance patterns than non-CEP schools, particularly
across varying poverty levels. The project includes data cleaning, merging, regression analysis, visualization, an interactive Shiny dashboard, and text analysis of related media coverage. 

##### R and Package information

* R version: 4.3.1
* Packages Used and Versions:
    * tidyverse
    * sf: 1.3.2
    * leflet: 1.1.3
    * rvest: 1.0.3
    * tidytext: 0.4.1
    * shiny: 1.7.4

### Original Data Sources

* CEP Data:
    * Source: Illinois State Board of Education
    * Link: https://www.isbe.net/Pages/Nutrition-Data-Analytics-Maps.aspx
    * Description: Includes school-level CEP participation information for 2019
    * File name: fy19-eligibilitydata.xlsx

* Attendance Data:
    * Source: Illinois State Board of Education
    * Link: https://www.isbe.net/ilreportcarddata
    * Description: School-level data on attendance, chronic absenteeism, and truancy in Illinois for 2019
    * File name: 2019-Report-Card-Public-Data-Set.xlsx

* American Community Survey (ACS) Data:
    * Source: US Census Bureau API
    * Description: School district-level poverty data (number and percentage of families with children below the poverty line in 2019)
    * File name: Automatically retrieved via API (saved locally as acs_data_wide.csv)

* Shapefiles for School District Boundaries:
   * Source: National Center for Education Statistics
   * Link: https://nces.ed.gov/programs/edge/Geographic/DistrictBoundaries
   * Description: Geographic boundaries for school districts nationwide for 2018-2019
   * File name: EDGE_SCHOOLDISTRICT_TL19_SY1819/schooldistrict_sy1819_tl19.shp
   * FILE HOSTED ON GOOGLE DRIVE, DOWNLOAD HERE: https://drive.google.com/drive/folders/13KOAnpvZkTlgG_3xUFO4WHaZLEaeaMwN?usp=sharing

  ### Code Instructions

1. data.R
      * This R script cleans and merges the attendance and CEP data. It also pulls ACS data via API, cleans it, and computes family poverty rates. It then saves the cleand datasets for further analysis
      * Run this first
      * Modifications: Replace census_api_key("your_api_key_here", install = TRUE) with your API key. You can request a key here -> https://api.census.gov/data/key_signup.html
      * Update paths for readxl::read_xlsx() and write_csv() functions to match your directory structure
2. staticplot.R
    * Uses ggplot2 to create several plots to visualize the differences between schools in terms of truancy and absenteeism
    * Run this second
    * Modifications: Replace path files to save plots
3. model.R
    * Runs the regression analysis and summarizes the results
    * Run this third
4. shiny_app_1.R
    * Creates an interactive Shiny app displaying a choropleth map of school district poverty rates using ACS data and shapefiles
    * Run after downloading the shapefiles and running data.R
    * Ensure the shapefile directory (Data/EDGE_SCHOOLDISTRICT_TL19_SY1819/) exists or modify the path
    * Replace the shapefile directory with the hosted Google Drive link if necessary
5. shiny_app_2.R
    * Creates an interactive Shiny app for visualizing average truancy and absenteeism rates by poverty level and CEP participation
    * Run after data.R and analysis.R
    * Ensure the cleaned merged_data file path is correctly referenced
6. text_analysis.R
    * Scrapes AP News articles related to CEP, cleans the text data, and conducts sentiment and word frequency analysis
    * Ensure the working directory matches the project structure for saving text data

  Date: December 2024
  Author: Jose Serrano
