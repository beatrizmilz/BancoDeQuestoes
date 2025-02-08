#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
devtools::load_all()

# > dplyr::glimpse(questoes)
# Rows: 2
# Columns: 15
# $ id             <chr> "fuvest-2025-04", "fuvest-2025-08"
# $ vestibular     <chr> "FUVEST", "FUVEST"
# $ ano            <int> 2025, 2025
# $ prova          <chr> "v1", "v1"
# $ questao_tipo   <chr> "multipla_escolha", "multipla_escolha"
# $ questao_numero <chr> "4", "8"
# $ imagem         <lgl> FALSE, FALSE
# $ area           <chr> "História", "História"
# $ temas          <chr> "Formação do território brasileiro; Colonizaç…
# $ texto_questao  <chr> "“E assim como o branco e os mamelucos se apr…
# $ alternativa_A  <chr> "pela construção de caminhos que os afastasse…
# $ alternativa_B  <chr> "pela desconsideração das rotas de deslocamen…
# $ alternativa_C  <chr> "pela utilização de picadas abertas pelas com…
# $ alternativa_D  <chr> "pelo emprego de tropas de muares, responsáve…
# $ alternativa_E  <chr> "pela exploração do transporte fluvial e marí…

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Gerar lista de questões"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
              shinyWidgets::pickerInput(
              input = "tipo_questao",
              label = "Tipo de questão",
              choices = c("Múltipla escolha" = "multipla_escolha",
                          "Dissertativa" = "dissertativa"),
              selected = "multipla_escolha"
            ),
            shinyWidgets::pickerInput(
              input = "disciplina",
              label = "Disciplina",
              choices = unique(questoes$area),
              selected = unique(questoes$area)[1]
            ),
            shiny::sliderInput(
              inputId = "quantidade_questoes",
              label = "Quantidade de questões",
              value = c(10),
              min = 1,
              max = 10,
              step = 1
            )

        ),

        # Show a plot of the generated distribution
        mainPanel(
          shiny::h2("Questões"),
          shiny::htmlOutput("texto_questoes"),
          shiny::h2("Gabarito"),
          shiny::htmlOutput("gabarito")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

  dados <- reactive({
    questoes |>
      dplyr::filter(area == input$disciplina) |>
      dplyr::filter(questao_tipo == input$tipo_questao) |>
      dplyr::slice_sample(n = input$quantidade_questoes) |>
      dplyr::mutate(numero_questao = dplyr::row_number())
  })


  output$texto_questoes <- shiny::renderText({
   dados_com_enunciado <- dados() |>
      dplyr::mutate(
        enunciado = glue::glue("{numero_questao}) ({vestibular} - {ano}) <br> {texto_questao}: <br><br> a) {alternativa_A} <br> b) {alternativa_B} <br> c) {alternativa_C} <br> d) {alternativa_D} <br> e) {alternativa_E}")
      )


     paste(dados_com_enunciado$enunciado, collapse = "<br><hr>")
    })


  output$gabarito <- shiny::renderText({
    dados() |>
      dplyr::mutate(texto_gabarito = glue::glue("{numero_questao}:  {alternativa_correta}")) |>
      dplyr::pull(texto_gabarito) |>
      paste(collapse = "<br>")
  })

}

# Run the application
shinyApp(ui = ui, server = server)
