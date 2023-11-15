#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
data("msleep")

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

  upperTextValue <- reactive({
    req("input$var")
    if(input$var == "carni"){
      "Carni"
    } else if(input$var == "herbi"){
      "Herbi"
    } else {
      if(input$var == "insecti"){
        "Insecti"
      } else {
        "Omni"
      }
    }
  }) 
  
  lowerTextValue <- reactive({
    req("input$var")
    if(input$var == "carni"){
      "carni"
    } else if(input$var == "herbi"){
      "herbi"
    } else {
      if(input$var == "insecti"){
        "insecti"
      } else {
        "omni"
      }
    }
  }) 
  
  shapeSizes <- reactive({
    req("input$sliderValue")
    input$sliderValue
  })
  
  shapeColor <- reactive({
    req("input$colorCode")
    if(input$colorCode == 1){
      "yes"
    } else {
      "no"
    }
  })
  
  shapeSymbols <- reactive({
    req("input$shapeCode")
    if(input$shapeCode == 1){
      value <- "yes"
    } else {
      value <- "no"
    }
  })
  
  output$text1 <- renderText({
      texts <- upperTextValue()
      paste0("Investigation of ", texts, "vore Mammal Sleep Data")
    })
    
  output$text2 <- renderText({
    
    # Get the text value for the ui
    texts <- lowerTextValue()
    
    # Get the body weight mean
    mean1 <- msleep %>%
      dplyr::filter(vore == texts) %>%
      summarize(mean = round(mean(bodywt, na.rm = T), 2))
    
    # Get the sleep total average
    mean2 <- msleep %>%
      dplyr::filter(vore == texts) %>%
      summarize(mean = round(mean(sleep_total, na.rm = T), 2))
    
    paste0("The average body weight for vore ", texts, " is ", mean1[[1]], " and the average total sleep time is ", mean2[[1]])
  })
  
  output$mytable1 <- renderTable({
    # Get the text value for the ui
    texts <- lowerTextValue()
    
    # Get the table
    msleep %>%
      dplyr::filter(vore == texts)
  })
  
  # Update the slider input when second check box is checked
  observe({
    val <- shapeSymbols()
    if(val == "yes"){
      updateSliderInput(
        session, 
        "sliderValue", 
        value = 5,
        min = 3, 
        max = 10,
      )
    } else {
      updateSliderInput(
        session, 
        "sliderValue", 
        value = 5,
        min = 1, 
        max = 10,
      )
    }
  })
  
  output$graph1 <- renderPlot({
    # Get the text value for the ui
    texts <- lowerTextValue()
    
    # Get the size 
    size <- shapeSizes()
    
    # Get the first check box (for color)
    check1 <- shapeColor()
    
    # Get the second check box (for shape)
    check2 <- shapeSymbols()
    
    # Make plot depending on check boxes
    if((check1 == "yes") & (check2 == "yes")){
      msleep %>%
        dplyr::filter(vore == texts) %>%
        ggplot(aes(x = bodywt, y = sleep_total, color = conservation, alpha = sleep_rem)) +
        geom_point(size = size) +
        scale_shape_binned()
    } else {
      if((check1 == "yes") & (check2 == "no")){
        msleep %>%
          dplyr::filter(vore == texts) %>%
          ggplot(aes(x = bodywt, y = sleep_total, color = conservation)) +
          geom_point(size = size)
      } else {
        msleep %>%
          dplyr::filter(vore == texts) %>%
          ggplot(aes(x = bodywt, y = sleep_total)) +
          geom_point(size = size)
      }
    }
  })

})
