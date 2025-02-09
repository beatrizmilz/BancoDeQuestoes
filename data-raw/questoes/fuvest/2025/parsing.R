devtools::load_all()
# Fuvest 2025 --------


arquivo <- here::here("data-raw/questoes/fuvest/2025/prova.pdf")
pasta <- dirname(arquivo)

# Extrair imagens do PDF

# extrair_imagens_pdf(arquivo)


# Parte  1 - Transformar PDF em txt
# Isso é necessário ver manualmente.
# TODO: Descobrir alguma forma de automatizar isso.
# paginas_1_coluna <- c(2, 12)
#
# numero_de_paginas <- pdftools::pdf_length(arquivo)
#
# # As páginas de 2 colunas são as que não estão nas páginas de 1 coluna.
# paginas_2_colunas <- c(2:numero_de_paginas) |>
#   purrr::discard(~ .x %in% paginas_1_coluna)
#
# # Transformar as páginas de 2 colunas em texto.
# purrr::map(
#   paginas_2_colunas,
#   ~ transformar_pagina_pdf_2_colunas_em_txt(arquivo, page = .x)
# )
#
# # Transformar as páginas de 1 coluna em texto.
# purrr::map(
#   paginas_1_coluna,
#   ~ transformar_pagina_pdf_1_colunas_em_txt(arquivo, page = .x)
# )

# Parte 2 - Transformar txt em json - OK

# ler arquivos txt:
# arquivos_txt <- tibble::tibble(arquivos = as.character(fs::dir_ls(pasta)),
#                                arquivo_nome = basename(arquivos)) |>
#   dplyr::filter(
#     stringr::str_detect(arquivos, pattern = ".txt"),
#     stringr::str_detect(arquivos, pattern = "_pagina-")
#   )
#
# purrr::map(
#   arquivos_txt$arquivos,
#   gerar_arquivo_questao_por_pagina,
#   .progress = TRUE
# )

# Parte 3 - verificando manualmente os arquivos json

# Em andamento

porcentagem <- questoes_preparadas |>
  dplyr::filter(
    stringr::str_detect(id, "fuvest-2025")
  ) |>
  dplyr::count(validado) |>
  dplyr::mutate(
    porcentagem = (n / sum(n)) *100
  ) |>
  dplyr::filter(validado == TRUE)

barra_de_progresso(porcentagem$porcentagem)


# Parte 4 - Double check se as alternativas estão corretas

# preparando gabarito ----
arquivo_gabarito <- paste0(pasta, "/gabarito.pdf")

gabarito <- pdftools::pdf_text(arquivo_gabarito)

gabarito_v1_prelim <- gabarito[1] |>
  readr::read_fwf(skip = 6) |>
  dplyr::select(questao = X1, alternativa_correta = X2,
                questao_2 = X3, alternativa_correta_2 = X4)

gabarito_1 <- tibble::tibble(
questao = gabarito_v1_prelim$questao,
alternativa = gabarito_v1_prelim$alternativa_correta
)
gabarito_2 <- tibble::tibble(
questao = gabarito_v1_prelim$questao_2,
alternativa = gabarito_v1_prelim$alternativa_correta_2
)

gabarito <- dplyr::bind_rows(gabarito_1, gabarito_2) |>
  tidyr::drop_na() |>
  dplyr::mutate(alternativa = stringr::str_to_lower(alternativa))

# join gabarito e questoes

gabarito_validado <- questoes_preparadas |>
  dplyr::filter(
    stringr::str_detect(id, "fuvest-2025")
  ) |>
  dplyr::left_join(gabarito, by = c("questao_numero" = "questao")) |>
  dplyr::mutate(
    questao_correta = alternativa_correta == alternativa
  )

questoes_para_corrigir <- gabarito_validado |>
  dplyr::filter(questao_correta == FALSE) |>
  dplyr::arrange(questao_numero) |>
  dplyr::select(questao_numero, alternativa)



