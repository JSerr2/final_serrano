library(shiny)
library(tidyverse)

# Data preparation

summary_data <- merged_data %>%
  group_by(Poverty_Level, Participates_in_CEP) %>%
  summarise(
    Avg_Attendance = mean(Student_Attendance_Rate, na.rm = TRUE),
    Avg_Chronic_Truancy = mean(Student_Chronic_Truancy_Rate, na.rm = TRUE),
    Avg_Chronic_Absenteeism = mean(Chronic_Absenteeism, na.rm = TRUE),
    n = n()
  )

# UI
ui <- fluidPage(
  titlePanel("CEP Impact Explorer"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "metric",
        "Select Metric to Explore:",
        choices = c(
          "Average Attendance Rate" = "Avg_Attendance",
          "Average Chronic Truancy Rate" = "Avg_Chronic_Truancy",
          "Average Chronic Absenteeism Rate" = "Avg_Chronic_Absenteeism"
        ),
        selected = "Avg_Attendance"
      )
    ),
    mainPanel(
      plotOutput("impactPlot", height = "600px")
    )
  )
)

# Server
server <- function(input, output, session) {
  output$impactPlot <- renderPlot({
    metric <- input$metric
    metric_label <- switch(
      metric,
      "Avg_Attendance" = "Average Attendance Rate",
      "Avg_Chronic_Truancy" = "Average Chronic Truancy Rate",
      "Avg_Chronic_Absenteeism" = "Average Chronic Absenteeism Rate"
    )
    
    # plot
    ggplot(summary_data, aes(x = Poverty_Level, y = .data[[metric]], fill = Participates_in_CEP)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(
        title = paste(metric_label, "by Poverty Level and CEP Participation"),
        x = "Poverty Level",
        y = metric_label,
        fill = "CEP Participation"
      ) +
      theme_minimal() +
      theme(
        text = element_text(size = 14),
        axis.text.x = element_text(angle = 45, hjust = 1)
      )
  })
}


shinyApp(ui, server)
