devtools::load_all()
# Fuvest 2025 --------

arquivo <- here::here("data-raw/questoes/fuvest/2025/prova.pdf")
pasta <- dirname(arquivo)

# Isso é necessário ver manualmente.
# TODO: Descobrir alguma forma de automatizar isso.
paginas_1_coluna <- c(2, 12)

numero_de_paginas <- pdftools::pdf_length(arquivo)

# As páginas de 2 colunas são as que não estão nas páginas de 1 coluna.
paginas_2_colunas <- c(2:numero_de_paginas) |>
  purrr::discard(~ .x %in% paginas_1_coluna)

# Transformar as páginas de 2 colunas em texto.
purrr::map(
  paginas_2_colunas,
  ~ transformar_pagina_pdf_2_colunas_em_txt(arquivo, page = .x)
)

# Transformar as páginas de 1 coluna em texto.
purrr::map(
  paginas_1_coluna,
  ~ transformar_pagina_pdf_1_colunas_em_txt(arquivo, page = .x)
)


# ler arquivos txt:
arquivos_txt <- tibble::tibble(arquivos = as.character(fs::dir_ls(pasta))) |>
  dplyr::filter(
    stringr::str_detect(arquivos, pattern = ".txt"),
    stringr::str_detect(arquivos, pattern = "_pagina-")
  )

purrr::map(
  arquivos_txt$arquivos[2],
  gerar_arquivo_questao_por_pagina,
  .progress = TRUE
)
