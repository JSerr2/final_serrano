# Model 1

model_absenteeism <- lm(
  Chronic_Absenteeism ~ Participates_in_CEP * Poverty_Level + `%_Student_Enrollment_-_Low_Income` + Title_1_Binary,
  data = merged_data
)

summary(model_absenteeism)

# Model 2

model_truancy <- lm(
  Student_Chronic_Truancy_Rate ~ Participates_in_CEP * Poverty_Level + `%_Student_Enrollment_-_Low_Income` + Title_1_Binary,
  data = merged_data
)

summary(model_truancy)
