transformar_pagina_pdf_2_colunas_em_txt <- function(path, page) {
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

  arquivo_txt_col1 <- usar_pdf_to_text(
    arquivo,
    first_page = page,
    last_page = page,
    x_coordinate = 0,
    y_coordinate = 0,
    width = 300,
    height = 800
  )

  col_1 <- readr::read_file(arquivo_txt_col1)


  arquivo_txt_col2 <- usar_pdf_to_text(
    arquivo,
    first_page = page,
    last_page = page,
    x_coordinate = 300,
    y_coordinate = 0,
    width = 300,
    height = 800
  )


  col_2 <- readr::read_file(arquivo_txt_col2)

  conteudo_pagina <- c(col_1, col_2)

  # Salva o arquivo
  writeLines(conteudo_pagina, arquivo_txt)

  # Retorna o conteúdo
  return(conteudo_pagina)
}

# transformar_pagina_pdf_2_colunas_em_txt("data-raw/questoes/fuvest/2025/prova.pdf", page = 3)
