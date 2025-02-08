gerar_arquivo_questao_por_pagina <- function(path = "/Users/beatrizmilz/Documents/GitHub/banco-de-questoes/data-raw/questoes/fuvest/2025/prova_pagina-10.txt") {

  texto_por_questao <- readr::read_lines(path)

  prova_ano <- dirname(path) |>
    stringr::str_extract("data-raw/questoes/.*") |>
    stringr::str_remove("data-raw/questoes/") |>
    stringr::str_split("/") |>
    unlist()

  df_questao <- texto_por_questao |>
    tibble::as_tibble() |>
    dplyr::mutate(
      questao = stringr::str_extract(value, "\\{.*[0-9]+\\}"),
      questao = readr::parse_number(questao),
      prova = prova_ano[1],
      ano = prova_ano[2]
    ) |>
    tidyr::fill(questao, .direction = "down") |>
    dplyr::group_by(prova, ano, questao) |>
    dplyr::summarise(texto = paste(value, collapse = "\n")) |>
    dplyr::ungroup() |>
    dplyr::group_split(questao)

  purrr::map(df_questao, gerar_arquivo_questao_multipla_escolha)

}
