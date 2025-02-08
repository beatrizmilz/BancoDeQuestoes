transformar_pagina_pdf_1_colunas_em_txt <- function(path, page) {
  # Criar o caminho absoluto
  arquivo <- here::here(path)

  # Verifica se o arquivo existe
  if (fs::file_exists(arquivo) == FALSE) {
    usethis::ui_stop("O arquivo não foi encontrado. Verifique o argumento path.")
  }

  # Verifica se o arquivo é um PDF
  if (stringr::str_detect(stringr::str_to_lower(arquivo), ".pdf$") != TRUE) {
    usethis::ui_stop("O arquivo não é um PDF. Verifique o argumento path.")
  }

  # Cria o caminho para salvar o arquivo

  arquivo_txt <- glue::glue("{dirname(arquivo)}/prova_pagina-{page}.txt")

  arquivo_txt_col_unica <- usar_pdf_to_text(
    arquivo,
    first_page = page,
    last_page = page,
    x_coordinate = 0,
    y_coordinate = 0,
    width = 800,
    height = 800
  )

  col_unica <- readr::read_file(arquivo_txt_col_unica)

  # Salva o arquivo
  writeLines(col_unica, arquivo_txt)

  # Retorna o conteúdo
  return(col_unica)

}

# transformar_pagina_pdf_2_colunas_em_txt("data-raw/questoes/fuvest/2025/prova.pdf", page = 3)
