library("dplyr")
library("tidyverse")
library("ggplot2")
library("plotly")
library("rsconnect")
library("shiny")
library("reshape2")
library("highcharter")
library("DT")

# loading dataset
book_data <- read.csv("library_data.csv")
  
first_page <- tabPanel(
  "Introduction",
  h1(strong("Analyzing book checkouts in Seattle library")),
  img("", src = "https://static01.nyt.com/images/2022/01/16/fashion/VIRAL-LIBRARY/VIRAL-LIBRARY-jumbo.jpg?quality=75&auto=webp",
      width = "600", height = "300", align = "center"),
  p("This dataset includes a monthly count of Seattle Public Library checkouts by title for physical and electronic items. 
    The dataset begins with checkouts that occurred in April 2005."),
  p("The dataset contains 100000 variables 12 variables"),
  br(),
  dataTableOutput("sample_table")
)
 
#second page:

second_page <- tabPanel(
  "Table: Book checkouts by year",
  h1(strong("Checkouts by year")),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "CheckoutYear",label = "Select Year:",
        choices = sort(unique(book_data$CheckoutYear)), selected = NULL
      ),
      sliderInput(
        inputId = ".", label = "Select month:",
        min = 1, max = 12, value = c(1, 12)
      ),
    ),
    mainPanel(
      dataTableOutput("chart"),
      verbatimTextOutput("text1"), # add text output
      hr(),
      p("You can see checkouts result by month in selected year. Also, you can change the month rage
        if you don't want to include any specific period."),
      h3(strong("Checkouts result by year")),
    )
  )
)

#third page: 
third_page <-  tabPanel(
  "Book checkouts by year",
  h1(strong("Checkouts by year")),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "UsageClass",
        label = "Select usage class:",
        choices = sort(unique(book_data$UsageClass)),
        selected = NULL
      ),
      checkboxGroupInput(
        inputId = "type",
        label = "Select type:",
        choices = c("OverDrive", "Horizon", "Hoopla", "Freegal", "Zinio"),
        selected = c("OverDrive", "Horizon", "Hoopla", "Freegal", "Zinio")
      ),
      radioButtons(
        inputId = "chartType",
        label = "Select chart type:",
        choices = c("Line", "Bar"),
        selected = "Line"
      )
    ),
    mainPanel(
      plotlyOutput("chart2"),
      verbatimTextOutput("text2"), # add text output
      hr(),
      p("This graph shows total checkout by year depending on specific usage class and check out type. The grap 
        also has two types of visual representation which is line graph and bar graph."),
      p("The dataset contains 100000 variables 12 variables"),
      h3(strong("Checkouts result by year depending on selected usage class or type")),
    )
  )
)







#Define UI
ui <- navbarPage(
  "Book Checkouts",
  first_page,
  second_page,
  third_page
)