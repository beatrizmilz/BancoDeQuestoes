questoes_json <- list.files(
  "data-raw/questoes",
  full.names = TRUE,
  recursive = TRUE,
  pattern = "\\.json$"
)

lista_json <- purrr::map(questoes_json, jsonlite::fromJSON)

questoes <- lista_json |>
  purrr::map(tibble::as_tibble) |>
  purrr::list_rbind() |>
  dplyr::filter(validado %in% c("TRUE", TRUE)) |>
  dplyr::mutate(
    url_github = glue::glue(
      "https://github.com/beatrizmilz/BancoDeQuestoes/blob/main/data-raw/questoes/{stringr::str_to_lower(vestibular)}/{ano}/{questao_numero}.json"
    )
  )

questoes


usethis::use_data(questoes, overwrite = TRUE)
