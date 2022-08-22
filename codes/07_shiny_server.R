library(shiny)
library(tidyverse)

data("mtcars")

shinyServer(function(input, output) {
  
  output$distPlot <- renderPlot({
    mt <- as.data.frame(map_at(mtcars, factor, .at = input$Factores))
    p<- ggplot(mt, aes_string(x = input$Variable, y = "mpg")) 
    if (class(mt[,input$Variable]) == "numeric"){
      p <- p + stat_smooth(method = "lm", formula = input$Formula) + geom_point()
    }
    if (class(mt[,input$Variable]) == "factor"){
      p <- p + geom_boxplot(aes_string(color = input$Variable))
    }
    p + theme_bw()
  })
  
})