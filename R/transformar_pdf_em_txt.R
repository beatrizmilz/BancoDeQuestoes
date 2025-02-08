transformar_pdf_em_txt <- function(caminho_pdf, salvar = TRUE){

  pdf_em_txt <- pdftools::pdf_text(caminho_pdf)

  if(salvar){
    caminho_txt <- stringr::str_replace(caminho_pdf, "\\.pdf$", ".txt")

    writeLines(pdf_em_txt, caminho_txt)
  }

}

# transformar_pdf_em_txt("data-raw/questoes/fuvest/2025/prova.pdf")
