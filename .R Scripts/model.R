model_absenteeism <- lm(
  Chronic_Absenteeism ~ Participates_in_CEP + `%_Student_Enrollment_-_Low_Income` + Title_1_Binary,
  data = merged_data
)

summary(model_absenteeism)
