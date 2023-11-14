#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Load libraries and data
library(shiny)
library(caret)
library(tidyverse)
library(DT)
data("GermanCredit")

# Start server
shinyServer(function(input, output, session) {
  output$graph1 <- renderPlot({
    
    #depending on plot type create hist or scatterplot
    if(input$plotType == "classificationOnly"){
      GermanCredit %>%
        ggplot(aes(x = Class, fill = NULL)) + 
        geom_bar(position = 'dodge')
    } else {
      if(input$plotType == "classificatonUnemployed"){
        GermanCredit %>%
          ggplot(aes(x = Class, fill = factor(EmploymentDuration.Unemployed))) + 
          geom_bar(position = 'dodge') +
          scale_fill_discrete(name = "Unemployment status", labels = c("Employed", "Unemployed"))
      } else {
        GermanCredit %>%
          ggplot(aes(x = Class, fill = factor(ForeignWorker))) + 
          geom_bar(position = 'dodge') +
          scale_fill_discrete(name = "Status", labels = c("German", "Foreign"))
      }
    }
    
  })
  
  data1 <- reactive({
    value1 <- input$number
  })
  
  output$mytable1 <- DT::renderDataTable({
    value_number <- data1()
    
    #depending on plot type create hist or scatterplot
    if(input$summarizeVars == "Age"){
      GermanCredit %>%
        group_by(Class, InstallmentRatePercentage) %>%
        summarize(mean = round(mean(Age), value_number))
    } else {
      if(input$summarizeVars == "Amount"){
        GermanCredit %>%
          group_by(Class, InstallmentRatePercentage) %>%
          summarize(mean = round(mean(Amount), value_number))
      } else {
        GermanCredit %>%
          group_by(Class, InstallmentRatePercentage) %>%
          summarize(mean = round(mean(Duration), value_number))
      }
    }
  })
})