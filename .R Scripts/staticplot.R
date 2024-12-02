# Plot 1: Chronic Truancy Rate by Poverty Level and CEP Participation

ggplot(comparison_data, aes(x = Poverty_Level, y = Avg_Chronic_Truancy, fill = Participates_in_CEP)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(
    title = "Chronic Truancy Rate by Poverty Level and CEP Participation",
    x = "Poverty Level",
    y = "Average Chronic Truancy Rate"
  ) +
  theme_minimal()



# Plot 2: Chronic Absenteeism Rate by Poverty Level and CEP Participation

ggplot(comparison_data, aes(x = Poverty_Level, y = Avg_Chronic_Absenteeism, fill = Participates_in_CEP)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(
    title = "Chronic Absenteeism Rate by Poverty Level and CEP Participation",
    x = "Poverty Level",
    y = "Average Chronic Absenteeism Rate"
  ) +
  theme_minimal()







