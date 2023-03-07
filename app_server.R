library("dplyr")
library("tidyverse")
library("ggplot2")
library("plotly")
library("rsconnect")
library("shiny")
library("reshape2")
library("DT")

# loading dataset
book_data <- read.csv("library_data.csv")

#second page: show the scatter plot of each month checkouts with a corresponding input year. 
server <- function(input, output) {
  
  sample_data <- reactive({
    sample_n(book_data, 5)
  })
  
  # Output the sample data as a DataTable
  output$sample_table <- renderDataTable({
    sample_data()
  })

  
  # Scatter plot of each month checkouts with a corresponding input year
  plot_data <- reactive({
    book_data %>%
      filter(CheckoutYear == input$CheckoutYear) %>%
      filter(CheckoutMonth >= input$"."[1] & CheckoutMonth <= input$"."[2]) %>%
      group_by(CheckoutMonth) %>%
      summarize(total_checkout = sum(Checkouts))
  })
  
  output$chart <- renderDataTable({
    plot_data()
  })
  
  output$text1 <- renderPrint({
    n <- nrow(plot_data())
    paste("Selected subset contains", n, "observations")
  })
  
  # Line chart of total checkouts by year
  bar_data <- reactive({
    book_data %>%
      filter(UsageClass == input$UsageClass) %>%
      filter(CheckoutType %in% input$type) %>%
      group_by(CheckoutYear) %>%
      summarize(total_checkout2 = sum(Checkouts))
  })
  
  output$chart2 <- renderPlotly({
    if(input$chartType == "Line") {
      ggplotly(
        ggplot(bar_data(), aes(x = CheckoutYear, y = total_checkout2)) +
          geom_line(color = "purple") +
          labs(title = "Total checkouts by year", x = "Year", y = "Total checkouts by year")
      )
    } else {
      ggplotly(
        ggplot(bar_data(), aes(x = CheckoutYear, y = total_checkout2)) +
          geom_bar(stat = "identity", fill = "purple") +
          labs(title = "Total checkouts by year", x = "Year", y = "Total checkouts by year")
      )
    }
  })
  
  output$text2 <- renderPrint({
    n <- nrow(bar_data())
    paste("Selected subset contains", n, "observations")
  })
  
}


















  



