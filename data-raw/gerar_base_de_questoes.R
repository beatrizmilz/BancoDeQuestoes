devtools::load_all()

# Listar arquivos json que estão dentro da pasta de questões
# queremos pegar os arquivos recursivamente (dentro de subpastas)
questoes_json <- list.files(
  "data-raw/questoes",
  full.names = TRUE,
  recursive = TRUE,
  pattern = "\\.json$"
)

# Importar todos os arquivos json
lista_json <- purrr::map(questoes_json, jsonlite::fromJSON)

# Manipulação para deixar a base de questões pronta
questoes_preparadas <- lista_json |>
  purrr::map(purrr::compact) |>
  purrr::map(tibble::as_tibble) |>
  purrr::map(~dplyr::mutate(.x, temas = as.list(temas))) |>
  purrr::list_rbind() |>
  dplyr::mutate(
    url_github_base = glue::glue(
      "https://github.com/beatrizmilz/BancoDeQuestoes/blob/main/data-raw/questoes/{stringr::str_to_lower(vestibular)}/{ano}"
    ),
    url_github = glue::glue(
      "{url_github_base}/{questao_numero}.json"
    )
  )



usethis::use_data(questoes_preparadas, overwrite = TRUE)

# Filtrando as questões validadas
questoes_multipla_escolha <- questoes_preparadas |>
  dplyr::filter(validado == TRUE, !is.na(alternativa_correta)) |>
  dplyr::select(-c(validado, vestibular, ano, url_github_base)) |>
  dplyr::filter(is.na(disciplina)) |>
  dplyr::mutate(disciplina = names(temas),
                temas = unlist(temas)) |>
  tidyr::unnest(obras_literarias, names_sep =  "_")

# Criando base de provas
provas <- questoes_preparadas |>
  dplyr::distinct(vestibular, ano, url_github_base) |>
  dplyr::mutate(
    url_pdf_prova = glue::glue("{url_github_base}/prova.pdf"),
    url_pdf_gabarito = glue::glue("{url_github_base}/gabarito.pdf"
  ))


usethis::use_data(provas, overwrite = TRUE)
usethis::use_data(questoes_multipla_escolha, overwrite = TRUE)

# Salvar -------------------------

con <- conectar_sql()

DBI::dbListTables(con)

DBI::dbWriteTable(con, "questoes_multipla_escolha", questoes_multipla_escolha, overwrite = TRUE)

DBI::dbWriteTable(con, "provas", provas, overwrite = TRUE)

DBI::dbDisconnect(con)



# Questões não validadas -------------------------
# Filtrando as questões não validadas
questoes_para_validar <- questoes_preparadas |>
  dplyr::filter(validado == FALSE) |>
  dplyr::select(id, vestibular, ano, questao_numero, url_github) |>
  dplyr::arrange(vestibular, ano, questao_numero)

usethis::ui_info("Existem {nrow(questoes_para_validar)} questões para validar: {paste0(questoes_para_validar$id, collapse = ', ')} ")

readr::write_csv(questoes_para_validar, "data-raw/questoes_para_validar.csv")
