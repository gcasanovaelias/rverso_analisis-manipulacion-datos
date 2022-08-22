library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Datos de motor trends de 1974"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "Variable",
        label = "Selecciona la Variable x:",
        choices = c("cyl", "disp", "hp", "drat", "wt", "qsec", "vs", "am", "gear", "carb"),
        selected = "wt"),
      checkboxGroupInput(
        inputId = "Factores",
        label = "Transformar a factores",
        choices = c("cyl", "disp", "hp", "drat", "wt", "qsec", "vs", "am", "gear", "carb"),
        selected = "am"
      ),
      textInput(
        inputId = "Formula", 
        label = "Escribe la formula de tu modelo:",
        value =  "y ~ x + I(x^2)"
      ),
      submitButton(
        text = "Actualizar modelo",
        icon = icon(name = "refresh")
      )
    ),
    
    mainPanel(
      plotOutput("distPlot")
    )
  )
))