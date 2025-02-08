questoes_yaml <- list.files("data-raw/questoes",
           full.names = TRUE,
           recursive = TRUE, pattern = "\\.yaml$")

lista_yaml <- purrr::map(questoes_yaml, yaml::read_yaml)

questoes <- lista_yaml |>
  purrr::map(tibble::as_tibble) |>
  purrr::list_rbind()

usethis::use_data(questoes, overwrite = TRUE)
