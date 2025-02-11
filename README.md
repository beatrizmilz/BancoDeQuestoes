# Banco de questões

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->
  
  
Este repositório tem como objetivo armazenar questões utilizadas em provas para vestibulares e vestibulinhos, com o intuito de facilitar a busca por questões de determinados assuntos em provas anteriores.

As questões são extraídas das provas em PDF utilizando algumas técnicas de programação e são armazenadas em arquivos `.json`.

## Vestibulares

Aos poucos, estamos adicionando questões de vestibulares e vestibulinhos.

Você também pode consultar os sites oficiais dos vestibulares para acessar as provas anteriores e gabaritos.

### Provas para ingresso no ensino superior

- Brasil:
  - [ENEM](https://www.gov.br/inep/pt-br/areas-de-atuacao/avaliacao-e-exames-educacionais/enem/provas-e-gabaritos)

- Estado de São Paulo:
  - [FATEC](https://www.cps.sp.gov.br/fatec/vestibular/)
  - [FUVEST - Vestibular USP](https://acervo.fuvest.br/?t=vestibular)
  - [ITA](https://vestibular.ita.br/provas.htm)
  - [Provão Paulista](https://provaopaulistaseriado.vunesp.com.br/) - para estudantes do Ensino Médio matriculados em escolas públicas
  - [UNESP](https://vestibular.unesp.br/)
  - [UNICAMP](https://www.comvest.unicamp.br/vestibulares-anteriores/)
  - [UNIVESP](https://univesp.br/vestibular)

### Vestibulinhos

- Estado de São Paulo:
  - [ETEC](https://www.vestibulinhoetec.com.br/provas-gabaritos/)


## Etapas de extração

1. Extração de imagens das provas em PDF: utilizamos a biblioteca [poppler](https://poppler.freedesktop.org/releases.html) e funções em R. 

2. Conversão de PDF para texto: utilizamos a biblioteca [poppler](https://poppler.freedesktop.org/releases.html) e funções em R.

3. Extração de questões: utilizamos funções em R e a API da Open AI (utilizando o modelo GPT-4o mini) para extrair questões de múltipla escolha.

4. Validar questões: manualmente, validamos as questões extraídas e fazemos ajustes necessários.


## Como contribuir

Uma forma de contribuir é ajudando a [validar as questões](https://github.com/beatrizmilz/BancoDeQuestoes/tree/main/data-raw/questoes/fuvest/2025) que já foram extraídas (arquivos `.json` que estão com a informação  `"validado": false`). O arquivo [`data-raw/questoes_para_validar.csv`](https://github.com/beatrizmilz/BancoDeQuestoes/blob/main/data-raw/questoes_para_validar.csv) apresenta uma lista de questões que precisam ser validadas.

## Autoria

Este projeto está sendo desenvolvido por [Beatriz Milz](https://beamilz.com) e [Julio Trecenti](https://jtrecenti.com/).

## Licença

Este trabalho está licenciado sob a licença [CC BY-NC-SA 4.0 - Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.en).
