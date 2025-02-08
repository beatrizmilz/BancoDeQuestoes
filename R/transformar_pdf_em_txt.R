transformar_pdf_em_txt <- function(path) {
  # criar o caminho absoluto
  arquivo <- here::here(path)

  # Verifica se o arquivo existe
  if (fs::file_exists(arquivo) == FALSE) {
    usethis::ui_stop("O arquivo não foi encontrado. Verifique o argumento path.")
  }

  # Verifica se o arquivo é um PDF
  if (stringr::str_detect(stringr::str_to_lower(arquivo), ".pdf$") != TRUE) {
    usethis::ui_stop("O arquivo não é um PDF. Verifique o argumento path.")
  }


  # Transforma o PDF em texto com o PDF tools
  # TODO: Essa parte precisa ser melhorada, o PDF tools não funciona bem com páginas com colunas.
  pdf_em_txt <- pdftools::pdf_text(arquivo)


  # Cria o caminho para salvar o arquivo
  caminho_txt <- stringr::str_replace(arquivo, "\\.pdf$", ".txt")

  # Salva o arquivo
  writeLines(pdf_em_txt, caminho_txt)

  # Retorna o caminho do arquivo
  return(caminho_txt)
}

# transformar_pdf_em_txt("data-raw/questoes/fuvest/2025/prova.pdf")
