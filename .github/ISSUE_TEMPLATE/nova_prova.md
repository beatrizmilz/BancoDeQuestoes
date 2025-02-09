---
name: Adicionar nova prova
about: Tarefas para adicionar nova prova
title: '[ANO] Vestibular'
labels: 'novas-provas'
assignees: 'beatrizmilz'
---
- [ ] Criar um diretório para a prova: `data-raw/questoes/{prova}/{ano}`
- [ ] Salvar o PDF original da prova com o nome `prova.pdf`. Se houver diferentes versões, salvar a versão principal (ou v1).
- [ ] Salvar o gabarito em PDF da prova com o nome `gabarito.pdf`. 
- [ ] Extrair as imagens em PDF e salvar na pasta `images/` (usar a função `extrair_imagens_pdf(arquivo_pdf)`
   - [ ] As imagens deverão ser renomeadas com o número da questão onde são utilizadas. Exemplos:
        - Quando houver apenas uma imagem por questão, usar o número da questão como nome: Exemplo: `1.png`
        - Quando houver mais que uma imagem por questão, utilizar letras para definir ordem. Exemplo: `22_a.png` e `22_b.png`.
        - Quando uma mesma imagem for utilizada em diferentes questões, adicione o número de ambas as questões no nome da imagem. Exemplo: `73-74.png`.
- [ ] Transformar o PDF em txt. Cuidado: alguns PDFs tem páginas com uma ou duas colunas.
- [ ] Usar a função `gerar_arquivo_questao_por_pagina()` para transformar o `.txt` de cada página em `.json` para cada questão
- [ ] Verificação manual dos arquivos `.json`.
