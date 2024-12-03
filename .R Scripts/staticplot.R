# Plot 1: Average Chronic Absenteeism by CEP Participation

plot1 <- merged_data %>%
  group_by(Poverty_Level, Participates_in_CEP) %>%
  summarise(Avg_Chronic_Absenteeism = mean(Chronic_Absenteeism, na.rm = TRUE)) %>%
  ggplot(aes(x = Poverty_Level, y = Avg_Chronic_Absenteeism, fill = Participates_in_CEP)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(
    title = "Chronic Absenteeism by Poverty Level and CEP Participation",
    x = "Poverty Level",
    y = "Average Chronic Absenteeism Rate",
    fill = "CEP Participation"
  ) +
  theme_minimal()

plot1

ggsave("C:\\Users\\joses\\OneDrive\\Documents\\GitHub\\final_serrano\\Images\\plot1_absenteeism_cep.png", plot1)

# Plot 2: Average Chronic Truancy Rate by CEP Participation

plot2 <- merged_data %>%
  group_by(Poverty_Level, Participates_in_CEP) %>%
  summarise(Avg_Chronic_Truancy = mean(Student_Chronic_Truancy_Rate, na.rm = TRUE)) %>%
  ggplot(aes(x = Poverty_Level, y = Avg_Chronic_Truancy, fill = Participates_in_CEP)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(
    title = "Chronic Truancy by Poverty Level and CEP Participation",
    x = "Poverty Level",
    y = "Average Chronic Truancy Rate",
    fill = "CEP Participation"
  ) +
  theme_minimal()

plot2

ggsave("C:\\Users\\joses\\OneDrive\\Documents\\GitHub\\final_serrano\\Images\\plot2_truancy_cep.png", plot2)

# Plot 3: Chronic Absenteeism vs. Low-Income Percentage

plot3 <- ggplot(merged_data, aes(x = `%_Student_Enrollment_-_Low_Income`, y = Chronic_Absenteeism, color = Participates_in_CEP)) +
  geom_point(alpha = 0.5, shape = 21, fill = "white", size = 2) +  
  geom_smooth(method = "lm", se = FALSE, linetype = "solid", linewidth = 1.5) +  
  labs(
    title = "Chronic Absenteeism vs. Low-Income Percentage",
    x = "Percentage of Low-Income Students",
    y = "Chronic Absenteeism Rate",
    color = "CEP Participation"
  ) +
  theme_minimal() +
  theme(
    legend.position = "bottom"  
  )

plot3

ggsave("C:\\Users\\joses\\OneDrive\\Documents\\GitHub\\final_serrano\\Images\\plot3_absenteeism_low_income.png", plot3)

# Plot 4: Chronic Absenteeism by Title I Status

plot4 <- merged_data %>%
  group_by(Title_1_Binary) %>%
  summarise(Avg_Chronic_Absenteeism = mean(Chronic_Absenteeism, na.rm = TRUE)) %>%
  ggplot(aes(x = Title_1_Binary, y = Avg_Chronic_Absenteeism, fill = Title_1_Binary)) +
  geom_bar(stat = "identity") +
  labs(
    title = "Chronic Absenteeism by Title I Status",
    x = "Title I Status",
    y = "Average Chronic Absenteeism Rate",
    fill = "Title I Status"
  ) +
  theme_minimal()

plot4

ggsave("C:\\Users\\joses\\OneDrive\\Documents\\GitHub\\final_serrano\\Images\\plot4_absenteeism_title1.png", plot4)
