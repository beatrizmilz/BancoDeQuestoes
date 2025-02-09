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
    url_github_base = glue::glue(
      "https://github.com/beatrizmilz/BancoDeQuestoes/blob/main/data-raw/questoes/{stringr::str_to_lower(vestibular)}/{ano}"
    ),
    url_github = glue::glue(
      "{url_github_base}/{questao_numero}.json"
    )
  )

questoes

provas <- questoes |>
  dplyr::distinct(vestibular, ano, prova, url_github_base) |>
  dplyr::mutate(
    url_pdf_prova = glue::glue("{url_github_base}/prova.pdf"),
    url_pdf_gabarito = glue::glue("{url_github_base}/gabarito.pdf"
  ))


usethis::use_data(questoes, overwrite = TRUE)
usethis::use_data(provas, overwrite = TRUE)
