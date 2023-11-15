#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
data("msleep")

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel(
      h1(
        textOutput("text1")
      )
    ),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            h3(
              "Select the mammal's biological order:"
            ),
            selectInput(
              "var", "Vore",
              choices = c(
                "carni" = "carni",
                "herbi" = "herbi",
                "insecti" = "insecti",
                "omni" = "omni"
              ),
              selected = "omni"
            ),
            br(),
            sliderInput(
              "sliderValue", "Size of Points on Graph",
              min = 1, max = 10, value = 5
            ),
            br(),
            checkboxInput(
              "colorCode", 
              tags$span(
                style="color: red; font-size: 20px;",
                "Color Code Conversation Status"
              ),
              FALSE
            ),
            # Make condition on checkbox checked
            conditionalPanel(
              condition = "input.colorCode == 1",
              checkboxInput(
                "shapeCode", 
                "Also change symbol based on REM sleep?",
                FALSE
              )
            )
        ),

        # Show a plot of the generated distribution
        mainPanel(
          plotOutput("graph1"),
          textOutput("text2"),
          tableOutput("mytable1")
        )
    )
))
