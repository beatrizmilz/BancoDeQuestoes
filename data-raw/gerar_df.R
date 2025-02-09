questoes_json <- list.files("data-raw/questoes",
  full.names = TRUE,
  recursive = TRUE, pattern = "\\.json$"
)

lista_json <- purrr::map(questoes_json, jsonlite::fromJSON)

questoes <- lista_json |>
  purrr::map(tibble::as_tibble) |>
  purrr::list_rbind()

usethis::use_data(questoes, overwrite = TRUE)
