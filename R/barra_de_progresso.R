barra_de_progresso <- function(porcentagem) {
  barra <- utils::txtProgressBar(
    initial = porcentagem,
    min = 0,
    max = 100,
    style = 3
  )
}
