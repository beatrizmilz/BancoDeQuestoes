#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#
# devtools::load_all()
library(shiny)
library(dbplyr)
con <- DBI::dbConnect(
    RPostgres::Postgres(),
    user = "postgres",
    host = "suddenly-big-reindeer.data-1.use1.tembo.io",
    port = 5432,
    password = Sys.getenv("SQL_TEMBO_PASSWORD")
  )

questoes_para_validar <- readr::read_csv("https://raw.githubusercontent.com/beatrizmilz/BancoDeQuestoes/refs/heads/main/data-raw/questoes_para_validar.csv")

questoes_multipla_escolha <- dplyr::tbl(con, "questoes_multipla_escolha") |>
  dplyr::collect()


provas <- dplyr::tbl(con, "provas") |>
  dplyr::collect()


questoes <- questoes_multipla_escolha |>
  tidyr::separate(
    id,
    into = c("vestibular", "ano", "n_questao"),
    sep = "-",
    remove = FALSE
  ) |>
  dplyr::mutate(
    vestibular = stringr::str_to_upper(vestibular),
    ano = as.integer(ano),
  ) |>
dplyr::left_join(provas)




disciplinas_temas <- questoes |>
  dplyr::select(disciplina, temas) |>
  tidyr::unnest(cols = c(temas)) |>
  tidyr::separate_longer_delim(temas, "; ") |>
  dplyr::mutate(
    temas = stringr::str_trim(temas)
  ) |>
  dplyr::distinct(disciplina, temas) |>
  dplyr::filter(temas != "") |>
  tidyr::drop_na(temas)

disciplinas_questoes <- sort(unique(disciplinas_temas$disciplina))

# Define UI for application that draws a histogram
ui <- bslib::page_navbar(
  tags$head(
    tags$style(HTML(
      "img {
        max-width: 40%;
        height: auto;
        display: block;
        margin-left: auto;
        margin-right: auto;
      }

      cite {
      text-align: right;
      }"
    ))
  ),
      title = "Banco de questões (em construção)",

      sidebar = bslib::sidebar(
     #   title = "Filtros",
        shinyWidgets::pickerInput(
          input = "prova_vestibular",
          label = "Vestibular",
          choices = unique(provas$vestibular),
          multiple = TRUE,
          selected = unique(provas$vestibular)
        ),
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
            ),
            shinyWidgets::pickerInput(
              input = "temas",
              label = "Temas",
              choices = disciplinas_temas$temas,
              selected = disciplinas_temas$temas
            ),
        #,
            # shiny::sliderInput(
            #   inputId = "quantidade_questoes",
            #   label = "Quantidade de questões",
            #   value = c(10),
            #   min = 1,
            #   max = 10,
            #   step = 1
            # )

        ),
bslib::layout_columns(
  min_height = "100px", fillable = FALSE,
  bslib::value_box(
    title = "Quantidade de questões cadastradas",
    value = nrow(questoes),
    showcase = bsicons::bs_icon("file-check"),
    showcase_layout = "left center",
  ),
    bslib::value_box(
    title = "Quantidade de questões para validação",
    value = nrow(questoes_para_validar),
    showcase = bsicons::bs_icon("file-lock"),
    showcase_layout = "left center",
  )
),
        bslib::navset_card_pill(
        bslib::nav_panel(
          title = "Questões",
          shiny::htmlOutput("texto_questoes")
        ),
        bslib::nav_panel(
          title = "Gabarito",
          shiny::htmlOutput("gabarito")
        )),
        bslib::nav_menu(
        title = "Links",
        bslib::nav_item(tags$a(shiny::icon("github"), "Código", href = "https://github.com/beatrizmilz/BancoDeQuestoes", target = "_blank"),
       bslib::nav_item(tags$a(shiny::icon("github"), "Como contribuir?", href = "https://github.com/beatrizmilz/BancoDeQuestoes#como-contribuir", target = "_blank")))


      )
      )



# Define server logic required to draw a histogram
server <- function(input, output) {

  temas_filtrados_por_disciplina <- reactive({
    disciplinas_temas |>
      dplyr::filter(disciplina %in% input$disciplina) |>
      dplyr::arrange(temas)
  })

    observe({
      shinyWidgets::updatePickerInput(
        inputId = "temas",
        choices = unique(temas_filtrados_por_disciplina()$temas),
        selected = unique(temas_filtrados_por_disciplina()$temas)
      )
    }) |>
      bindEvent(temas_filtrados_por_disciplina(), ignoreNULL = FALSE)

  dados <- reactive({
    questoes |>
      dplyr::filter(stringr::str_detect(disciplina, input$disciplina)) |>
      dplyr::filter(stringr::str_detect(temas, input$temas)) |>
      dplyr::filter(vestibular %in% input$prova_vestibular) |>
      # dplyr::filter(questao_tipo == input$tipo_questao) |>
      # dplyr::slice_sample(n = input$quantidade_questoes) |>
      dplyr::distinct(id, .keep_all = TRUE) |>
      dplyr::mutate(numero_questao = dplyr::row_number())

  })




  output$texto_questoes <- shiny::renderText({
   dados_com_enunciado <- dados() |>
      dplyr::mutate(
        texto_questao = stringr::str_replace_all(texto_questao, "\n", "<br>"),
        texto_questao = stringr::str_replace(texto_questao, "\\{imagem_1\\}", glue::glue("<br> <img src='{url_github_base}/images/{imagem_1}?raw=true'><br>")),
        texto_questao = stringr::str_replace(texto_questao, "\\{imagem_2\\}", glue::glue("<br> <img src='{url_github_base}/images/{imagem_2}?raw=true'><br>")),
        enunciado = glue::glue("{numero_questao}) ({vestibular} - {ano}) <br> <br> {texto_questao} <br><br><br> a) {alternativa_a} <br> b) {alternativa_b} <br> c) {alternativa_c} <br> d) {alternativa_d} <br> e) {alternativa_e} <br><br> <a href='{url_github}' target='_blank'>Sugerir alteração</a>")
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
