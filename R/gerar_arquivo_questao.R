gerar_arquivo_questao_multipla_escolha <- function(df_texto) {
  prompt <- readr::read_file("data-raw/prompts/prompt_multipla_escolha.md")

  chat <- ellmer::chat_openai(
    model = "gpt-4o-mini",
    system_prompt = prompt
  )

  usethis::ui_info("Iniciando extração de dados da questão: {stringr::str_to_upper(df_texto$prova)}/{df_texto$ano}/Questão {df_texto$questao}...")


  result <- chat$extract_data(
    df_texto$texto[1],
    type = ellmer::type_object(
      "Questão da prova FUVEST.",
      id = ellmer::type_string("Identificador único da questão."),
     validado = ellmer::type_enum("Se a questão possui imagem.", c("FALSE")),
      vestibular = ellmer::type_string("Nome do vestibular."),
      ano = ellmer::type_integer("Ano da prova."),
      prova = ellmer::type_string("Versão da prova."),
      questao_tipo = ellmer::type_string("Tipo da questão."),
      questao_numero = ellmer::type_string("Número da questão."),
      imagem = ellmer::type_enum("Se a questão possui imagem.", c("TRUE", "FALSE")),
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


  jsonlite::write_json(
    result,
    glue::glue("data-raw/questoes/{df_texto$prova}/{df_texto$ano}/{df_texto$questao}.json"),
    auto_unbox = TRUE,
    pretty = TRUE
  )

  usethis::ui_done("Extração de dados da questão {stringr::str_to_upper(df_texto$prova)}/{df_texto$ano}/{df_texto$questao} finalizada!")
}
