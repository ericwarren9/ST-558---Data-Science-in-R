#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Load libraries and data
library(caret)
data("GermanCredit")
library(shiny)
library(DT)

# Start ui part of app
shinyUI(
  fluidPage(
    titlePanel(
      "Summaries for German Credit Data"
    ),
    sidebarLayout(
      sidebarPanel(
        h3("This data set comes from the ",
        tags$a(href='https://topepo.github.io/caret/',
               "caret package"),
        " - originally from the UCI machine learning repository"
          ),
        br(),
        h4(
          "You can create a few bar plots using the radio buttons below."
          ),
        radioButtons(
          "plotType", "Select the Plot Type",
          choices = c(
            "Just Classification" = "classificationOnly",
            "Classification and Unemployed" = "classificatonUnemployed",
            "Classification and Foreign" = "classificationForeign"
          ),
          selected = "classificationOnly"
        ),
        br(),
        h4(
          "You can find the ",
          tags$strong("sample mean"),
          " for a few variables below:"
        ),
        selectInput(
          "summarizeVars", "Variables to Summarize",
          choices = c(
            "Duration" = "Duration",
            "Amount" = "Amount",
            "Age" = "Age"
          ),
          selected = "Age"
        ),
        numericInput(
          "number", "Select the number of digits for rounding",
          2, min = 0, max = 5
        )
        ),
      mainPanel(
        plotOutput("graph1"),
        DT::dataTableOutput("mytable1")
        )
      )
    )
  )