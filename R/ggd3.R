#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export

ggd3 <- function(data, layers = NULL, geoms = NULL,
                 aes = NULL, settings = NULL,
                 width = NULL, height = NULL) {

  ## layers and geoms must always be list of lists
  ## a la list(layer1 = list(## details ##), layer2 = list(...))
  x = list(
    data = data,
    layers = layers,
    geoms = geoms,
    aes = aes,
    settings = settings
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'ggd3',
    x = x,
    width = width,
    height = height,
    package = 'ggd3'
  )
}

#' Widget output function for use in Shiny
#'
#' @export
ggd3Output <- function(outputId, width = '100%', height = '400px'){
  shinyWidgetOutput(outputId, 'ggd3', width, height, package = 'ggd3')
}

#' Widget render function for use in Shiny
#'
#' @export
renderGgd3 <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, ggd3Output, env, quoted = TRUE)
}
