gerar_arquivo_questao_multipla_escolha <- function(df_texto) {
  prompt <- readr::read_file("data-raw/prompts/prompt_multipla_escolha.md")

  chat <- ellmer::chat_openai(
    model = "gpt-4o-mini",
    system_prompt = prompt
  )

  usethis::ui_info("Iniciando extração de dados da questão: {stringr::str_to_upper(df_texto$prova)}/{df_texto$ano}/Questão {df_texto$questao}...")

  imagens <- fs::dir_ls(glue::glue("{df_texto$caminho_prova}/images/")) |>   tibble::as_tibble() |>
    dplyr::mutate(value = basename(value)) |>
    dplyr::filter(
      stringr::str_detect(value, pattern = glue::glue("^{df_texto$questao}.png"))) |>
    dplyr::pull(value)


  result <- chat$extract_data(
    df_texto$texto,
    type = ellmer::type_object(
      "Questão da prova FUVEST.",
      disciplina = ellmer::type_string("Disciplina da questão."),
      temas = ellmer::type_string("Temas da questão."),
      texto_questao = ellmer::type_string("Texto da questão."),
      alternativa_a = ellmer::type_string("Texto da Alternativa A."),
      alternativa_b = ellmer::type_string("Texto da Alternativa B."),
      alternativa_c = ellmer::type_string("Texto da Alternativa C."),
      alternativa_d = ellmer::type_string("Texto da Alternativa D."),
      alternativa_e = ellmer::type_string("Texto da Alternativa E."),
      alternativa_correta = ellmer::type_enum("Alternativa correta.", letters[1:5])
    )
  )

resultado_completo <- list(
  id = df_texto$id_questao,
  validado = FALSE,
  vestibular =  stringr::str_to_upper(df_texto$prova),
  ano = readr::parse_number(df_texto$ano),
  questao_tipo = "multipla_escolha",
  questao_numero = df_texto$questao,
  imagem_1 = imagens[1],
  imagem_2 = imagens[2],
  result
) |>
  purrr::flatten()


  jsonlite::write_json(
    resultado_completo,
    glue::glue("{df_texto$caminho_prova}/{df_texto$questao}.json"),
    auto_unbox = TRUE,
    pretty = TRUE
  )

  usethis::ui_done("Extração de dados da questão {stringr::str_to_upper(df_texto$prova)}/{df_texto$ano}/{df_texto$questao} finalizada!")
}
