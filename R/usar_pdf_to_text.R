usar_pdf_to_text <- function(arquivo,
                             first_page,
                             last_page,
                             x_coordinate = 0,
                             y_coordinate = 0,
                             width = 800,
                             height = 800) {
  pdf_to_text <- "/opt/homebrew/bin/pdftotext"

  arquivo_txt_temp <- tempfile(fileext = ".txt")

  cmd_col_1 <- stringr::str_glue(
    '{pdf_to_text} -f {first_page} -l {last_page} -x {x_coordinate} -y {y_coordinate} -W {width} -H {height} -layout "{arquivo}" "{arquivo_txt_temp}"'
  )

  system(cmd_col_1)

  # Retorna o caminho do arquivo
  return(arquivo_txt_temp)
}
