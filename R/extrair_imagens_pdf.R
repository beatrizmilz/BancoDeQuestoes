
extrair_imagens_pdf <- function(path) {

    pdfimages <- "/opt/homebrew/bin/pdfimages"


  arquivo_txt_temp <- tempfile(fileext = ".txt")

  codigo_pdfimages <- stringr::str_glue(
    '{pdfimages} {path} -png "{path}" '
  )

  system(codigo_pdfimages)


  fs::dir_ls(dirname(path), glob = "*.png") |>
    purrr::map( ~ fs::file_move(.x, paste0(dirname(path), "/images/")))

}

# extrair_imagens_pdf("data-raw/questoes/fuvest/2025/prova.pdf")
