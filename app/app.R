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
# library(BancoDeQuestoes)

# > dplyr::glimpse(questoes)
# Rows: 2
# Columns: 15
# $ id             <chr> "fuvest-2025-04", "fuvest-2025-08"
# $ vestibular     <chr> "FUVEST", "FUVEST"
# $ ano            <int> 2025, 2025
# $ questao_tipo   <chr> "multipla_escolha", "multipla_escolha"
# $ questao_numero <chr> "4", "8"
# $ disciplina           <chr> "História", "História"
# $ temas          <chr> "Formação do território brasileiro; Colonizaç…
# $ texto_questao  <chr> "“E assim como o branco e os mamelucos se apr…
# $ alternativa_A  <chr> "pela construção de caminhos que os afastasse…
# $ alternativa_B  <chr> "pela desconsideração das rotas de deslocamen…
# $ alternativa_C  <chr> "pela utilização de picadas abertas pelas com…
# $ alternativa_D  <chr> "pelo emprego de tropas de muares, responsáve…
# $ alternativa_E  <chr> "pela exploração do transporte fluvial e marí…

disciplinas_questoes <- questoes |>
  tidyr::separate_longer_delim(disciplina, delim = ";") |>
  dplyr::mutate(disciplina = stringr::str_squish(disciplina)) |>
  dplyr::distinct(disciplina) |>
  dplyr::arrange(disciplina)


# Define UI for application that draws a histogram
ui <- bslib::page_sidebar(
  tags$head(
    tags$style(HTML(
      "img{
        max-width: 40%;
        height: auto;
        display: block;
        margin-left: auto;
        margin-right: auto;

      } "
    ))
  ),
      title = "Banco de questões (em construção)",

      sidebar = bslib::sidebar(
     #   title = "Filtros",
            #   shinyWidgets::pickerInput(
            #   input = "tipo_questao",
            #   label = "Tipo de questão",
            #   choices = c("Múltipla escolha" = "multipla_escolha"),
            #   selected = "multipla_escolha"
            # ),
            shinyWidgets::pickerInput(
              input = "disciplina",
              label = "Disciplina",
              choices = disciplinas_questoes,
              selected = disciplinas_questoes[1]
            )#,
            # shiny::sliderInput(
            #   inputId = "quantidade_questoes",
            #   label = "Quantidade de questões",
            #   value = c(10),
            #   min = 1,
            #   max = 10,
            #   step = 1
            # )

        ),

        # Show a plot of the generated distribution
      bslib::navset_card_underline(
        title = "Questões",
        bslib::nav_panel(
          title = "Questões",
          shiny::htmlOutput("texto_questoes")
        ),
        bslib::nav_panel(
          title = "Gabarito",
          shiny::htmlOutput("gabarito")
        ),
        )
      )



# Define server logic required to draw a histogram
server <- function(input, output) {

  dados <- reactive({
    questoes |>
      dplyr::filter(stringr::str_detect(disciplina, input$disciplina)) |>
      # dplyr::filter(questao_tipo == input$tipo_questao) |>
      # dplyr::slice_sample(n = input$quantidade_questoes) |>
      dplyr::mutate(numero_questao = dplyr::row_number())
  })


  output$texto_questoes <- shiny::renderText({
   dados_com_enunciado <- dados() |>
      dplyr::mutate(
        texto_questao = stringr::str_replace(texto_questao, "\n", "<br>"),
        texto_questao = stringr::str_replace(texto_questao, "\\{imagem_1\\}", glue::glue("<br> <img src='{url_github_base}/images/{imagem_1}?raw=true'><br>")),
        enunciado = glue::glue("{numero_questao}) ({vestibular} - {ano}) <br> <br> {texto_questao} <br><br> <b>a)</b> {alternativa_a} <br> <b>b)</b> {alternativa_b} <br> <b>c)</b> {alternativa_c} <br> <b>d)</b> {alternativa_d} <br> <b>e)</b> {alternativa_e} <br><br> <a href='{url_github}' target='_blank'>Sugerir alteração</a>")
      )


     paste(dados_com_enunciado$enunciado, collapse = "<br><hr>")
    })


  output$gabarito <- shiny::renderText({
    dados() |>
      dplyr::mutate(texto_gabarito = glue::glue("{numero_questao})  {alternativa_correta}")) |>
      dplyr::pull(texto_gabarito) |>
      paste(collapse = "<br>")
  })

}

# Run the application
shinyApp(ui = ui, server = server)
