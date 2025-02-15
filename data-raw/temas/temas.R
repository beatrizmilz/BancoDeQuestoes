temas_json <- jsonlite::read_json("data-raw/temas/temas.json")


temas <- temas_json$disciplina |>
  purrr::imap_dfr(~ tibble::tibble(
    disciplina = .y,
    codigo = purrr::map_chr(.x$temas, "codigo"),
    tema = purrr::map_chr(.x$temas, "tema"),
    descricao_tema = purrr::map_chr(.x$temas, "descricao")
  ))

usethis::use_data(temas)
