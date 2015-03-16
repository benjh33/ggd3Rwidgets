library(ggd3)
library(shiny)
library(htmltools)
library(htmlwidgets)
library(dplyr)
data(iris)
data(baseball)
## "additional" aesthetic needs to be added to stat object

ui = shinyUI(fluidPage(
  selectInput("feature", "select y:",
              choices = c('Petal.Length', 'Petal.Width',
                          'Sepal.Length', 'Sepal.Width')),
  ggd3Output('irisBar'),
  ggd3Output('baseball_lm')
))

server = function(input, output) {
  tt <- 'return el.append("text").text("this is a tooltip");'
  layers <- list(layer1 = list(geom=c(type='bar',
                                      tooltip = tt
                                      ), stat=c(y = 'median'),
                 position='stack'))
  geoms <- list(geom1 = list(type='bar', alpha=0.3))
  output$irisBar <- renderGgd3({
    aes <- list(x='Species',
                y = input$feature,
                # y = 'Petal.Length',
                fill='Sepal.Length',
                additional=list('Petal.Width', 'Sepal.Width'))
    ggd3(iris, layers = layers, aes = aes,
         settings = list(
           fillRange = c('blue', 'green'),
           facet = list(titleSize = list(0,0)),
           width = 300, height = 300,
           yScale = list(axis = list(ticks = 4), label = ""),
           margins = list(left = 60)),
         width = 1200)
  })
  output$baseball_lm <- renderGgd3({
    aes <- list(x = 'ab', y = 'batting', fill='decade', color='decade')
    layers <- list(layer1 = list(geom = 'point'), layer2 = list(geom = 'smooth'))
    facet <- list(x = 'decade', y='team')
    ggd3(baseball, layers = layers, aes = aes,
         settings = list(facet = facet,
                         width = 200,
                         height = 200,
                         yScale = list(axis = list(ticks = 4)),
                         xScale = list(axis = list(ticks = 4)),
                         dtypes = list(year = c('date', 'many', '%Y'),
                                       decade = c('string', 'few'),
                                       stint = c('string', 'many'),
                                       ab = c('number', 'many'),
                                       batting = c('number', 'many', '.3f'))
                    )
         )
  })
}

shinyApp(ui = ui, server = server)
