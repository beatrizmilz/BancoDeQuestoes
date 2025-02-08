# Código por @jtrecenti
library(ellmer)

# link <- "https://www.fuvest.br/wp-content/uploads/fuvest2025_primeira_fase_prova_V1.pdf"
# txt_prova_2025 <- pdftools::pdf_text(link)



## precisei transformar usando `pdftotext` pois o `pdftools` está crashando aqui
paginas <- readr::read_file(
  "data-raw/questoes/fuvest/2025/fuvest2025_primeira_fase_prova_V1.txt",
  locale = readr::locale(encoding = "latin1")
) |>
  stringr::str_split("\f") |>
  purrr::pluck(1)

paginas_validas <- paginas[2:33]

prompt <- readr::read_file("data-raw/prompts/prompt_multipla_escolha.md")

chat <- ellmer::chat_openai(
  model = "gpt-4o-mini",
  system_prompt = prompt
)

texto <- paginas_validas[1] |>
  stringr::str_c(collapse = "\n")

# Rodar para cada batch de páginas.
# Pode usar purrr::map(). Tratar erros
result <- chat$extract_data(
  texto,
  type = ellmer::type_object(
    "Questão da prova FUVEST.",
    id = ellmer::type_string("Identificador único da questão."),
    vestibular = ellmer::type_string("Nome do vestibular."),
    ano = ellmer::type_integer("Ano da prova."),
    prova = ellmer::type_string("Versão da prova."),
    questao_tipo = ellmer::type_string("Tipo da questão."),
    questao_numero = ellmer::type_string("Número da questão."),
    imagem = ellmer::type_enum("Se a questão possui imagem.", c("Sim", "Não")),
    area = ellmer::type_string("Área da questão."),
    temas = ellmer::type_string("Temas da questão."),
    texto_questao = ellmer::type_string("Texto da questão."),
    alternativa_a = ellmer::type_string("Texto da Alternativa A."),
    alternativa_b = ellmer::type_string("Texto da Alternativa B."),
    alternativa_c = ellmer::type_string("Texto da Alternativa C."),
    alternativa_d = ellmer::type_string("Texto da Alternativa D."),
    alternativa_e = ellmer::type_string("Texto da Alternativa E."),
    alternativa_correta = ellmer::type_enum("Alternativa correta.", letters[1:5])
  )
)

jsonlite::write_json(
  result,
  "data-raw/questoes/fuvest/2025/01.json",
  auto_unbox = TRUE,
  pretty = TRUE
)
