# Mapeamento de Tabelas x Segmentos CNAB240
**Projeto:** IPAG — Integração de Pagamentos  
**Padrão:** FEBRABAN 240 posições V10.9  
**Data:** 2026-05-18  

---

## Estrutura do Arquivo CNAB240

```
Arquivo (Tipo 0 + Tipo 9)
 └─ Lote (Tipo 1 + Tipo 5)
      └─ Registro de Detalhe (Tipo 3)
           └─ Segmentos (A, B, C, J, N, O, P, Q, R, T, U, W, Z...)
```

---

## 1. Tabelas de Arquivo e Lote (sem segmento específico)

| Tabela | Tipo Registro | Descrição |
|--------|--------------|-----------|
| `IPAGTB001_ARQUIVO` | — (raiz) | Entidade raiz. Representa o arquivo físico CNAB240 recebido ou gerado. |
| `IPAGTB002_CABECALHO_ARQUIVO` | **Tipo 0** — Cabeçalho de Arquivo | Dados do banco destino, empresa e data/hora de geração do arquivo. |
| `IPAGTB003_RODAPE_ARQUIVO` | **Tipo 9** — Rodapé de Arquivo | Totalizadores: quantidade de lotes e registros do arquivo. |
| `IPAGTB004_LOTE` | — (contêiner) | Representa um Lote de Serviço/Produto. Um arquivo pode ter múltiplos lotes. |
| `IPAGTB005_CABECALHO_LOTE` | **Tipo 1** — Cabeçalho de Lote | Dados da empresa, tipo de serviço, tipo de operação e endereço. |
| `IPAGTB006_RODAPE_LOTE` | **Tipo 5** — Rodapé de Lote | Totalizadores do lote: qtd registros, somatório de valores. |
| `IPAGTB007_DETALHE_REG` | **Tipo 3** — Detalhe (agrupador) | Agrupa os segmentos de um mesmo registro de detalhe. Cada instância pode ter 1 ou mais segmentos filhos. |

---

## 2. Segmentos de Pagamento (Crédito CC / DOC / TED / PIX / Débito em Conta / Vendor / Compror)

| Tabela | Segmento | Obrigatoriedade | Descrição |
|--------|----------|----------------|-----------|
| `IPAGTB010_DET_PAGAMENTO` | **Segmento A** | Obrigatório | Dados do favorecido e do pagamento: banco, agência, conta, nome, valor, data de pagamento. Campo de referência: campos P001–P010. Usado em: Pagamento CC/DOC/TED/PIX, Débito em Conta, Vendor, Compror. |
| `IPAGTB011_DET_INFO_FAVORECIDO` | **Segmento B** | Opcional (complementar ao A) | Informações adicionais do favorecido: tipo e número de inscrição (CPF/CNPJ), endereço, e-mail, PIX. Campo de referência: campos P011–P020. |
| `IPAGTB012_DET_COMPLEMENTAR` | **Segmento C** | Opcional (complementar ao A) | Deduções e abatimentos: valores de IR, ISS, IOF, INSS e conta substituta. Campo de referência: campos P021–P030. |

**Serviços que usam A/B/C:**
- Pagamento (Crédito CC, Cheque, OP, DOC, TED, PIX, Pag. com Autenticação) — Remessa e Retorno
- Débito em Conta Corrente — Remessa e Retorno
- Vendor — Remessa e Retorno
- Compror / Compror Rotativo — Remessa e Retorno

---

## 3. Segmentos de Pagamento de Títulos de Cobrança e Código QR PIX

| Tabela | Segmento | Obrigatoriedade | Descrição |
|--------|----------|----------------|-----------|
| `IPAGTB013_DET_TITULO_COBRANCA` | **Segmento J** | Obrigatório | Código de barras do título, nome do beneficiário, data de vencimento, valor nominal. Campo de referência: campos L001–L010. |
| `IPAGTB014_DET_PARTES_TITULO` | **Segmento J-52** | Obrigatório | Identificação do Pagador, Beneficiário e Sacador/Avalista do título. Campos: inscrição, nome. |
| `IPAGTB015_DET_PIX_CODIGO_QR` | **Segmento J-52 PIX** | Obrigatório (quando PIX) | Variante do J-52 para pagamentos via Código QR PIX. Contém identificação do devedor, favorecido e dados do QR. |

**Serviço:** Pagamento de Títulos de Cobrança e Código QR PIX — Remessa e Retorno

---

## 4. Segmentos de Pagamento de Tributos (sem Código de Barras)

| Tabela | Segmento | Obrigatoriedade | Descrição |
|--------|----------|----------------|-----------|
| `IPAGTB016_DET_TRIBUTO_SEM_CB` | **Segmento N** | Obrigatório | Tributos e impostos sem código de barras: GPS (INSS), DARF, DARF Simples, DARF Simples Parcelamento, DAE, GNRE. Campo de referência: campos N001+. |

**Serviços que usam N:**
- Pagamento de Tributos sem Código de Barras — Remessa e Retorno
- Consulta de Tributos a Pagar (somente Remessa)

---

## 5. Segmentos de Pagamento de Tributos (com Código de Barras)

| Tabela | Segmento | Obrigatoriedade | Descrição |
|--------|----------|----------------|-----------|
| `IPAGTB017_DET_TRIBUTO_COM_CB` | **Segmento O** | Obrigatório | Contas e tributos com código de barras: concessionárias, impostos estaduais/municipais, FGTS com código. Campo de referência: campos N específicos. |
| `IPAGTB018_DET_COMPL_TRIBUTO` | **Segmento W** | Opcional* | Informações complementares para FGTS (convênios 0181 e 0182) e outros. *Obrigatório para FGTS. |
| `IPAGTB019_DET_IDENT_TRIBUTO` | **Segmento Z** | Opcional | Autenticação e identificação do pagamento conforme legislação e protocolo bancário. Usado em retornos. |

**Serviços que usam O/W/Z:**
- Pagamento de Contas e Tributos com Código de Barras — Remessa e Retorno

**Nota:** O Segmento B também pode ser usado como opcional nesses serviços.

---

## 6. Segmentos de Cobrança — Remessa (Títulos em Cobrança)

| Tabela | Segmento | Obrigatoriedade | Descrição |
|--------|----------|----------------|-----------|
| `IPAGTB020_DET_DADOS_TITULO` | **Segmento P** | Obrigatório | Dados do título em cobrança: nosso número, carteira, espécie, valor, vencimento, instrução de cobrança. Campo de referência: campos C001–C050. |
| `IPAGTB021_DET_DADOS_SACADO` | **Segmento Q** | Obrigatório | Dados complementares do sacado: endereço completo, sacador/avalista, banco correspondente. |
| `IPAGTB022_DET_DESCONTO_TITULO` | **Segmento R** | Opcional | Descontos adicionais (2 e 3), tipo e valor de multa, tipo e valor de mora. |
| `IPAGTB040_DET_MENSAGEM_SACADO` | **Segmento S** | Opcional | Mensagem/informações a serem impressas no boleto. Dois formatos: linha única (140 chars) ou 5 mensagens (40 chars). |
| `IPAGTB060_DET_SACADOR_AVALISTA` | **Segmento Y-01** | Opcional | Dados do sacador/avalista: inscrição, nome e endereço completo. |
| `IPAGTB063_DET_ENVIO_ALTERNATIVO` | **Segmento Y-04** | Opcional | Envio de documento por meio alternativo: e-mail, SMS, chave PIX, URL QR Code, TXID. |
| `IPAGTB065_DET_RATEIO_CREDITO` | **Segmento Y-50** | Opcional | Rateio de crédito entre beneficiários: conta, nosso número, percentual, floating. |
| `IPAGTB066_DET_NOTA_FISCAL` | **Segmento Y-51** | Opcional | Dados de notas fiscais (até 5 por registro): número, valor, data emissão. |
| `IPAGTB067_DET_NOTA_FISCAL_ADICIONAL` | **Segmento Y-52** | Opcional | Informações adicionais de NF com chave DANFE (até 2 por registro). Múltiplas ocorrências. |
| `IPAGTB068_DET_TIPO_PAGAMENTO` | **Segmento Y-53** | Opcional | Tipo de pagamento e regras de alteração do valor nominal (máximo, mínimo, percentual). |

**Serviço:** Cobrança — Títulos em Cobrança — Remessa

---

## 7. Segmentos de Cobrança — Retorno

| Tabela | Segmento | Obrigatoriedade | Descrição |
|--------|----------|----------------|-----------|
| `IPAGTB023_DET_RETORNO_TITULO` | **Segmento T** | Obrigatório | Confirmação dos dados do título no retorno: nosso número, carteira, ocorrência bancária, valor. |
| `IPAGTB024_DET_COMPL_RETORNO` | **Segmento U** | Obrigatório | Valores financeiros da liquidação no retorno: acréscimos, descontos, abatimentos, IOF, outros créditos/débitos. |
| `IPAGTB064_DET_CHEQUE_PAGAMENTO` | **Segmento Y-05** | Opcional | Dados de cheques usados para pagamento (até 6 CMC7 por registro). Múltiplas ocorrências. |

**Serviço:** Cobrança — Títulos em Cobrança — Retorno

---

## 8. Segmentos de Boleto de Pagamento Eletrônico

| Tabela | Segmento | Obrigatoriedade | Descrição |
|--------|----------|----------------|-----------|
| `IPAGTB041_DET_BOLETO_ELETRONICO` | **Segmento G** | Obrigatório | Dados do título capturado: código de barras, beneficiário, vencimento, valor, moeda, carteira, espécie, juros, desconto. |
| `IPAGTB042_DET_COMPLEMENTO_BOLETO` | **Segmento H** | Opcional | Sacador/avalista, descontos 2 e 3, multa, abatimento e mensagens ao pagador. |
| `IPAGTB062_DET_DADOS_PAGADOR` | **Segmento Y-03** | Opcional | Dados do pagador: inscrição, nome e endereço completo. |

**Serviço:** Boleto de Pagamento Eletrônico — Retorno

---

## 9. Segmento de Alegação do Pagador

| Tabela | Segmento | Obrigatoriedade | Descrição |
|--------|----------|----------------|-----------|
| `IPAGTB061_DET_ALEGACAO_PAGADOR` | **Segmento Y-02** | Obrigatório | Contestação de boleto: código de barras, código padrão, ocorrência e complemento. |

**Serviço:** Alegação do Pagador — Remessa e Retorno

---

## 10. Segmentos de Extrato

| Tabela | Segmento | Obrigatoriedade | Descrição |
|--------|----------|----------------|-----------|
| `IPAGTB043_DET_EXTRATO_CONCILIACAO` | **Segmento E** | Obrigatório | Extrato de conta corrente para conciliação: empresa, conta, natureza, valor, tipo, categoria, histórico. |
| `IPAGTB044_DET_EXTRATO_GESTAO_CAIXA` | **Segmento F** | Obrigatório | Extrato para gestão de caixa: similar ao E mas com horário e campo histórico de 5 chars. |
| `IPAGTB045_DET_VALOR_LANCAMENTO` | **Segmento I** | Opcional | Decomposição do lançamento: valor disponível, vinculado e bloqueado. Complementar ao F. |

**Serviço:** Extrato de Conta Corrente (E) e Extrato para Gestão de Caixa (F, I) — Retorno

---

## 11. Segmentos de Débito em Conta Corrente

Reutiliza os mesmos segmentos A, B, C de Pagamento (IPAGTB010–012).

**Serviço:** Débito em Conta Corrente — Remessa e Retorno

---

## 12. Segmentos de Vendor

| Tabela | Segmento | Obrigatoriedade | Descrição |
|--------|----------|----------------|-----------|
| `IPAGTB046_DET_CONTRATO_VENDOR` | **Segmento K** | Obrigatório | Dados do comprador e contrato: inscrição, endereço, conta débito, nosso número, ramo de atividade. |
| `IPAGTB047_DET_PAGAMENTO_VENDOR` | **Segmento L** | Obrigatório | Pagamento ao fornecedor: documento, contrato, taxas, parcelas, multa, desconto, protesto. |
| `IPAGTB048_DET_RETORNO_CONTRATO_VENDOR` | **Segmento M** | Obrigatório | Confirmação do contrato: taxas anuais, equalização, valores (nominal, financiado, IOF, líquido). |
| `IPAGTB049_DET_RETORNO_PAGAMENTO_VENDOR` | **Segmento N** | Obrigatório | Liquidação da parcela: valores pagos, juros, IOF, multa, desconto, situação contrato/parcela. |

**Serviço:** Vendor — Remessa (K, L) e Retorno (K, M, N)

---

## 13. Segmento de Custódia de Cheques

| Tabela | Segmento | Obrigatoriedade | Descrição |
|--------|----------|----------------|-----------|
| `IPAGTB050_DET_CUSTODIA_CHEQUE` | **Segmento D** | Obrigatório | Dados do cheque: CMC7, emitente, valor, datas captura/depósito/crédito, dados de devolução e empréstimo. |

**Serviço:** Custódia de Cheques — Remessa e Retorno

---

## 14. Segmento de Empréstimo por Consignação

| Tabela | Segmento | Obrigatoriedade | Descrição |
|--------|----------|----------------|-----------|
| `IPAGTB051_DET_EMPRESTIMO_CONSIGNACAO` | **Segmento H** | Obrigatório | Dados do mutuário, operação de crédito, parcelas, valores, arrendamento mercantil, conta corrente. |

**Serviço:** Empréstimo por Consignação — Remessa e Retorno

---

## 15. Segmentos de Compror / Compror Rotativo

| Tabela | Segmento | Obrigatoriedade | Descrição |
|--------|----------|----------------|-----------|
| `IPAGTB010_DET_PAGAMENTO` | **Segmento A** | Obrigatório | Reutiliza layout de Pagamento (alternativa ao J). |
| `IPAGTB011_DET_INFO_FAVORECIDO` | **Segmento B** | Obrigatório | Reutiliza layout de Pagamento. |
| `IPAGTB052_DET_COMPROR` | **Segmento I** | Obrigatório | Dados do financiamento Compror: contrato, taxas, parcelas, encargos, IOF, multa. |
| `IPAGTB053_DET_PARCELA_COMPROR` | **Segmento I-11** | Opcional | Informação de parcelas (até 4 por registro). Múltiplas ocorrências. |
| `IPAGTB013_DET_TITULO_COBRANCA` | **Segmento J** | Obrigatório | Reutiliza layout de Pagamento de Títulos (alternativa ao A). |

**Serviço:** Compror / Compror Rotativo — Remessa e Retorno

---

## 16. Tabelas de Controle Operacional

| Tabela | Descrição |
|--------|-----------|
| `IPAGTB025_CONTROLE_CARGA` | Estado de carga de cada arquivo: PENDENTE, EM_ANDAMENTO, CONCLUIDO, ERRO, AGUARDANDO_RETOMADA. Permite retomada do processamento a partir do último lote concluído. |
| `IPAGTB026_CTRL_CARGA_LOTE` | Estado de carga de cada lote individualmente. Granularidade fina do checkpoint. |
| `IPAGTB027_DESPACHO_LOTE` | Estado atual de envio (despacho) de cada lote para cada serviço de destino. Visão corrente da máquina de estados. |
| `IPAGTB028_HISTORICO_DESPACHO` | Log imutável (append-only) de todas as tentativas de despacho. Nunca atualizado após inserção. |
| `IPAGTB029_CONTROLE_LINHA` | Cada linha física (240 posições) do arquivo e seu estado de processamento. |

---

## 17. Tabelas de Domínio (IPAGTB030–037)

| Tabela | Domínio | Campo CNAB |
|--------|---------|-----------|
| `IPAGTB030_TIPO_REGISTRO` | Tipos de registro válidos: 0, 1, 2, 3, 4, 5, 9 | G003 |
| `IPAGTB031_TIPO_SERVICO` | Tipos de serviço/produto do lote (01=Cobrança, 20=Fornecedor, 30=Salário...) | G025 |
| `IPAGTB032_TIPO_OPERACAO` | Operação do lote: C=Crédito, D=Débito, E=Extrato | G028 |
| `IPAGTB033_TIPO_MOVIMENTO` | Natureza da instrução do detalhe: 0=Inclusão, 5=Alteração, 9=Exclusão | G060 |
| `IPAGTB034_TIPO_INSCRICAO` | Tipo de pessoa: 1=CPF, 2=CNPJ, 3=PIS/PASEP | G005 |
| `IPAGTB035_TIPO_MOEDA` | Moedas: BRL, USD, EUR, etc. | G040 |
| `IPAGTB036_CAMARA_CENTRAL` | Câmaras centralizadoras para roteamento de pagamentos (TED, PIX, DOC...) | P001 |
| `IPAGTB037_SERVICO_DESTINO` | Microsserviços consumidores dos lotes (Boleto, Pagamento, Tributo...) | — |

---

## 18. Views (IPAGTV)

| View | Descrição |
|------|-----------|
| `IPAGTV001_STATUS_ARQUIVO` | Status consolidado de carga e despacho por arquivo. |
| `IPAGTV002_DESPACHO_PENDENTE` | Fila de trabalho para processos: lotes prontos para envio ou retentativa. |
| `IPAGTV003_LINHAS_ERRO` | Diagnóstico: linhas com status ERRO ou PENDENTE não processadas. |

---

## 19. Cobertura Completa

Todos os segmentos do padrão CNAB240 FEBRABAN V10.9 estão modelados no schema atual.

---

## 20. Resumo Visual: Tabela x Segmento

| # | Tabela | Segmento | Serviço Principal |
|---|--------|----------|------------------|
| TB001 | IPAGTB001_ARQUIVO | — | Raiz |
| TB002 | IPAGTB002_CABECALHO_ARQUIVO | Tipo 0 | Cabeçalho Arquivo |
| TB003 | IPAGTB003_RODAPE_ARQUIVO | Tipo 9 | Rodapé Arquivo |
| TB004 | IPAGTB004_LOTE | — | Contêiner de Lote |
| TB005 | IPAGTB005_CABECALHO_LOTE | Tipo 1 | Cabeçalho Lote |
| TB006 | IPAGTB006_RODAPE_LOTE | Tipo 5 | Rodapé Lote |
| TB007 | IPAGTB007_DETALHE_REG | Tipo 3 | Agrupador Detalhe |
| TB010 | IPAGTB010_DET_PAGAMENTO | **Seg A** | Pagamento / Débito / Vendor / Compror |
| TB011 | IPAGTB011_DET_INFO_FAVORECIDO | **Seg B** | Complementar ao A |
| TB012 | IPAGTB012_DET_COMPLEMENTAR | **Seg C** | Deduções (IR/ISS/IOF) |
| TB013 | IPAGTB013_DET_TITULO_COBRANCA | **Seg J** | Pag. Títulos Cobrança / Código QR PIX |
| TB014 | IPAGTB014_DET_PARTES_TITULO | **Seg J-52** | Partes do Título |
| TB015 | IPAGTB015_DET_PIX_CODIGO_QR | **Seg J-52 PIX** | Código QR PIX |
| TB016 | IPAGTB016_DET_TRIBUTO_SEM_CB | **Seg N** | Tributos sem Código de Barras |
| TB017 | IPAGTB017_DET_TRIBUTO_COM_CB | **Seg O** | Tributos com Código de Barras |
| TB018 | IPAGTB018_DET_COMPL_TRIBUTO | **Seg W** | Complementar Tributos / FGTS |
| TB019 | IPAGTB019_DET_IDENT_TRIBUTO | **Seg Z** | Autenticação Pagamento |
| TB020 | IPAGTB020_DET_DADOS_TITULO | **Seg P** | Cobrança Remessa — Dados Título |
| TB021 | IPAGTB021_DET_DADOS_SACADO | **Seg Q** | Cobrança Remessa — Dados Sacado |
| TB022 | IPAGTB022_DET_DESCONTO_TITULO | **Seg R** | Cobrança Remessa — Descontos |
| TB023 | IPAGTB023_DET_RETORNO_TITULO | **Seg T** | Cobrança Retorno — Confirmação |
| TB024 | IPAGTB024_DET_COMPL_RETORNO | **Seg U** | Cobrança Retorno — Valores |
| TB040 | IPAGTB040_DET_MENSAGEM_SACADO | **Seg S** | Cobrança Remessa — Mensagem Boleto |
| TB041 | IPAGTB041_DET_BOLETO_ELETRONICO | **Seg G** | Boleto Eletrônico (Retorno) |
| TB042 | IPAGTB042_DET_COMPLEMENTO_BOLETO | **Seg H** | Boleto Eletrônico — Complemento |
| TB043 | IPAGTB043_DET_EXTRATO_CONCILIACAO | **Seg E** | Extrato Conciliação (Retorno) |
| TB044 | IPAGTB044_DET_EXTRATO_GESTAO_CAIXA | **Seg F** | Extrato Gestão de Caixa (Retorno) |
| TB045 | IPAGTB045_DET_VALOR_LANCAMENTO | **Seg I** | Decomposição Lançamento — Gestão Caixa |
| TB046 | IPAGTB046_DET_CONTRATO_VENDOR | **Seg K** | Vendor — Contrato Comprador |
| TB047 | IPAGTB047_DET_PAGAMENTO_VENDOR | **Seg L** | Vendor — Pagamento (Remessa) |
| TB048 | IPAGTB048_DET_RETORNO_CONTRATO_VENDOR | **Seg M** | Vendor — Retorno Contrato |
| TB049 | IPAGTB049_DET_RETORNO_PAGAMENTO_VENDOR | **Seg N** | Vendor — Retorno Pagamento |
| TB050 | IPAGTB050_DET_CUSTODIA_CHEQUE | **Seg D** | Custódia de Cheques |
| TB051 | IPAGTB051_DET_EMPRESTIMO_CONSIGNACAO | **Seg H** | Empréstimo por Consignação |
| TB052 | IPAGTB052_DET_COMPROR | **Seg I** | Compror — Financiamento |
| TB053 | IPAGTB053_DET_PARCELA_COMPROR | **Seg I-11** | Compror — Parcelas |
| TB060 | IPAGTB060_DET_SACADOR_AVALISTA | **Seg Y-01** | Cobrança — Sacador/Avalista |
| TB061 | IPAGTB061_DET_ALEGACAO_PAGADOR | **Seg Y-02** | Alegação do Pagador |
| TB062 | IPAGTB062_DET_DADOS_PAGADOR | **Seg Y-03** | Boleto Eletrônico — Dados Pagador |
| TB063 | IPAGTB063_DET_ENVIO_ALTERNATIVO | **Seg Y-04** | Envio Alternativo (e-mail/SMS/PIX) |
| TB064 | IPAGTB064_DET_CHEQUE_PAGAMENTO | **Seg Y-05** | Cobrança Retorno — Cheques CMC7 |
| TB065 | IPAGTB065_DET_RATEIO_CREDITO | **Seg Y-50** | Cobrança — Rateio de Crédito |
| TB066 | IPAGTB066_DET_NOTA_FISCAL | **Seg Y-51** | Cobrança — Notas Fiscais |
| TB067 | IPAGTB067_DET_NOTA_FISCAL_ADICIONAL | **Seg Y-52** | Cobrança — NF com DANFE |
| TB068 | IPAGTB068_DET_TIPO_PAGAMENTO | **Seg Y-53** | Cobrança — Tipo de Pagamento |
| TB025 | IPAGTB025_CONTROLE_CARGA | — | Controle de Carga (operacional) |
| TB026 | IPAGTB026_CTRL_CARGA_LOTE | — | Controle de Carga por Lote |
| TB027 | IPAGTB027_DESPACHO_LOTE | — | Estado de Despacho |
| TB028 | IPAGTB028_HISTORICO_DESPACHO | — | Log de Despacho |
| TB029 | IPAGTB029_CONTROLE_LINHA | — | Controle de Linhas Físicas |
| TB030 | IPAGTB030_TIPO_REGISTRO | — | Domínio tipos de registro |
| TB031 | IPAGTB031_TIPO_SERVICO | — | Domínio tipos de serviço/produto |
| TB032 | IPAGTB032_TIPO_OPERACAO | — | Domínio operação do lote |
| TB033 | IPAGTB033_TIPO_MOVIMENTO | — | Domínio natureza da instrução |
| TB034 | IPAGTB034_TIPO_INSCRICAO | — | Domínio tipo de pessoa (CPF/CNPJ) |
| TB035 | IPAGTB035_TIPO_MOEDA | — | Domínio moedas |
| TB036 | IPAGTB036_CAMARA_CENTRAL | — | Domínio câmara centralizadora |
| TB037 | IPAGTB037_SERVICO_DESTINO | — | Domínio microsserviços consumidores |
| TV001–TV003 | IPAGTV001 a IPAGTV003 | — | Views Operacionais |

---

## 21. Chaves Estrangeiras por Tabela

### IPAGTB002_CABECALHO_ARQUIVO

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB001_IPAGTB002_FK01` | `ID_ARQUIVO` | `IPAGTB001_ARQUIVO` | `ID_ARQUIVO` |
| `IPAGTB034_IPAGTB002_FK02` | `ID_TIPO_INSCRICAO` | `IPAGTB034_TIPO_INSCRICAO` | `ID_TIPO_INSCRICAO` |

### IPAGTB003_RODAPE_ARQUIVO

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB001_IPAGTB003_FK01` | `ID_ARQUIVO` | `IPAGTB001_ARQUIVO` | `ID_ARQUIVO` |

### IPAGTB004_LOTE

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB001_IPAGTB004_FK01` | `ID_ARQUIVO` | `IPAGTB001_ARQUIVO` | `ID_ARQUIVO` |
| `IPAGTB031_IPAGTB004_FK02` | `ID_TIPO_SERVICO` | `IPAGTB031_TIPO_SERVICO` | `ID_TIPO_SERVICO` |
| `IPAGTB032_IPAGTB004_FK02` | `ID_TIPO_OPERACAO` | `IPAGTB032_TIPO_OPERACAO` | `ID_TIPO_OPERACAO` |

### IPAGTB005_CABECALHO_LOTE

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB004_IPAGTB005_FK01` | `ID_LOTE` | `IPAGTB004_LOTE` | `ID_LOTE` |
| `IPAGTB034_IPAGTB005_FK02` | `ID_TIPO_INSCRICAO` | `IPAGTB034_TIPO_INSCRICAO` | `ID_TIPO_INSCRICAO` |

### IPAGTB006_RODAPE_LOTE

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB004_IPAGTB006_FK01` | `ID_LOTE` | `IPAGTB004_LOTE` | `ID_LOTE` |

### IPAGTB007_DETALHE_REG

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB004_IPAGTB007_FK01` | `ID_LOTE` | `IPAGTB004_LOTE` | `ID_LOTE` |
| `IPAGTB033_IPAGTB007_FK02` | `ID_TIPO_MOVIMENTO` | `IPAGTB033_TIPO_MOVIMENTO` | `ID_TIPO_MOVIMENTO` |

### IPAGTB010_DET_PAGAMENTO

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB007_IPAGTB010_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` | `ID_DETALHE_REG` |
| `IPAGTB035_IPAGTB010_FK02` | `ID_TIPO_MOEDA` | `IPAGTB035_TIPO_MOEDA` | `ID_TIPO_MOEDA` |
| `IPAGTB036_IPAGTB010_FK03` | `ID_CAMARA_CENTRALIZADORA` | `IPAGTB036_CAMARA_CENTRAL` | `ID_CAMARA_CENTRALIZADORA` |

### IPAGTB011_DET_INFO_FAVORECIDO

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB007_IPAGTB011_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` | `ID_DETALHE_REG` |
| `IPAGTB034_IPAGTB011_FK02` | `ID_TIPO_INSCRICAO` | `IPAGTB034_TIPO_INSCRICAO` | `ID_TIPO_INSCRICAO` |

### IPAGTB012_DET_COMPLEMENTAR

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB007_IPAGTB012_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` | `ID_DETALHE_REG` |

### IPAGTB013_DET_TITULO_COBRANCA

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB007_IPAGTB013_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` | `ID_DETALHE_REG` |

### IPAGTB014_DET_PARTES_TITULO

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB007_IPAGTB014_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` | `ID_DETALHE_REG` |
| `IPAGTB034_IPAGTB014_FK02` | `ID_TIPO_INSCRICAO_PAGADOR` | `IPAGTB034_TIPO_INSCRICAO` | `ID_TIPO_INSCRICAO` |
| `IPAGTB034_IPAGTB014_FK03` | `ID_TIPO_INSCRICAO_BENEFICIARIO` | `IPAGTB034_TIPO_INSCRICAO` | `ID_TIPO_INSCRICAO` |
| `IPAGTB034_IPAGTB014_FK04` | `ID_TIPO_INSCRICAO_SACADOR` | `IPAGTB034_TIPO_INSCRICAO` | `ID_TIPO_INSCRICAO` |

### IPAGTB015_DET_PIX_CODIGO_QR

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB007_IPAGTB015_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` | `ID_DETALHE_REG` |
| `IPAGTB034_IPAGTB015_FK02` | `ID_TIPO_INSCRICAO_DEVEDOR` | `IPAGTB034_TIPO_INSCRICAO` | `ID_TIPO_INSCRICAO` |
| `IPAGTB034_IPAGTB015_FK03` | `ID_TIPO_INSCRICAO_FAVORECIDO` | `IPAGTB034_TIPO_INSCRICAO` | `ID_TIPO_INSCRICAO` |

### IPAGTB016_DET_TRIBUTO_SEM_CB

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB007_IPAGTB016_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` | `ID_DETALHE_REG` |

### IPAGTB017_DET_TRIBUTO_COM_CB

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB007_IPAGTB017_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` | `ID_DETALHE_REG` |

### IPAGTB018_DET_COMPL_TRIBUTO

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB007_IPAGTB018_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` | `ID_DETALHE_REG` |

### IPAGTB019_DET_IDENT_TRIBUTO

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB007_IPAGTB019_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` | `ID_DETALHE_REG` |

### IPAGTB020_DET_DADOS_TITULO

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB007_IPAGTB020_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` | `ID_DETALHE_REG` |
| `IPAGTB034_IPAGTB020_FK02` | `ID_TIPO_INSCRICAO_SACADO` | `IPAGTB034_TIPO_INSCRICAO` | `ID_TIPO_INSCRICAO` |

### IPAGTB021_DET_DADOS_SACADO

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB007_IPAGTB021_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` | `ID_DETALHE_REG` |
| `IPAGTB034_IPAGTB021_FK02` | `ID_TIPO_INSCRICAO_SACADO` | `IPAGTB034_TIPO_INSCRICAO` | `ID_TIPO_INSCRICAO` |
| `IPAGTB034_IPAGTB021_FK03` | `ID_TIPO_INSCRICAO_SACADOR` | `IPAGTB034_TIPO_INSCRICAO` | `ID_TIPO_INSCRICAO` |

### IPAGTB022_DET_DESCONTO_TITULO

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB007_IPAGTB022_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` | `ID_DETALHE_REG` |

### IPAGTB023_DET_RETORNO_TITULO

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB007_IPAGTB023_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` | `ID_DETALHE_REG` |
| `IPAGTB034_IPAGTB023_FK02` | `ID_TIPO_INSCRICAO_SACADO` | `IPAGTB034_TIPO_INSCRICAO` | `ID_TIPO_INSCRICAO` |

### IPAGTB024_DET_COMPL_RETORNO

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB007_IPAGTB024_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` | `ID_DETALHE_REG` |

### IPAGTB025_CONTROLE_CARGA

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB001_IPAGTB025_FK01` | `ID_ARQUIVO` | `IPAGTB001_ARQUIVO` | `ID_ARQUIVO` |
| `IPAGTB004_IPAGTB025_FK02` | `ID_ULTIMO_LOTE_CONCLUIDO` | `IPAGTB004_LOTE` | `ID_LOTE` |

### IPAGTB026_CTRL_CARGA_LOTE

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB004_IPAGTB026_FK02` | `ID_LOTE` | `IPAGTB004_LOTE` | `ID_LOTE` |
| `IPAGTB025_IPAGTB026_FK01` | `ID_CONTROLE_CARGA` | `IPAGTB025_CONTROLE_CARGA` | `ID_CONTROLE_CARGA` |

### IPAGTB027_DESPACHO_LOTE

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB004_IPAGTB027_FK01` | `ID_LOTE` | `IPAGTB004_LOTE` | `ID_LOTE` |
| `IPAGTB037_IPAGTB027_FK02` | `ID_SERVICO_DESTINO` | `IPAGTB037_SERVICO_DESTINO` | `ID_SERVICO_DESTINO` |

### IPAGTB028_HISTORICO_DESPACHO

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB027_IPAGTB028_FK01` | `ID_DESPACHO_LOTE` | `IPAGTB027_DESPACHO_LOTE` | `ID_DESPACHO_LOTE` |

### IPAGTB029_CONTROLE_LINHA

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB001_IPAGTB029_FK01` | `ID_ARQUIVO` | `IPAGTB001_ARQUIVO` | `ID_ARQUIVO` |
| `IPAGTB030_IPAGTB029_FK02` | `ID_TIPO_REGISTRO` | `IPAGTB030_TIPO_REGISTRO` | `ID_TIPO_REGISTRO` |

### IPAGTB031_TIPO_SERVICO

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB037_IPAGTB031_FK01` | `ID_SERVICO_DESTINO` | `IPAGTB037_SERVICO_DESTINO` | `ID_SERVICO_DESTINO` |

### IPAGTB040–068 (Novos Segmentos)

Todas as 23 novas tabelas de segmento possuem uma única FK para IPAGTB007_DETALHE_REG:

| Tabela | Constraint | Coluna(s) | Tabela Pai |
|--------|------------|-----------|------------|
| `IPAGTB040_DET_MENSAGEM_SACADO` | `IPAGTB007_IPAGTB040_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` |
| `IPAGTB041_DET_BOLETO_ELETRONICO` | `IPAGTB007_IPAGTB041_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` |
| `IPAGTB042_DET_COMPLEMENTO_BOLETO` | `IPAGTB007_IPAGTB042_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` |
| `IPAGTB043_DET_EXTRATO_CONCILIACAO` | `IPAGTB007_IPAGTB043_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` |
| `IPAGTB044_DET_EXTRATO_GESTAO_CAIXA` | `IPAGTB007_IPAGTB044_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` |
| `IPAGTB045_DET_VALOR_LANCAMENTO` | `IPAGTB007_IPAGTB045_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` |
| `IPAGTB046_DET_CONTRATO_VENDOR` | `IPAGTB007_IPAGTB046_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` |
| `IPAGTB047_DET_PAGAMENTO_VENDOR` | `IPAGTB007_IPAGTB047_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` |
| `IPAGTB048_DET_RETORNO_CONTRATO_VENDOR` | `IPAGTB007_IPAGTB048_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` |
| `IPAGTB049_DET_RETORNO_PAGAMENTO_VENDOR` | `IPAGTB007_IPAGTB049_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` |
| `IPAGTB050_DET_CUSTODIA_CHEQUE` | `IPAGTB007_IPAGTB050_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` |
| `IPAGTB051_DET_EMPRESTIMO_CONSIGNACAO` | `IPAGTB007_IPAGTB051_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` |
| `IPAGTB052_DET_COMPROR` | `IPAGTB007_IPAGTB052_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` |
| `IPAGTB053_DET_PARCELA_COMPROR` | `IPAGTB007_IPAGTB053_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` |
| `IPAGTB060_DET_SACADOR_AVALISTA` | `IPAGTB007_IPAGTB060_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` |
| `IPAGTB061_DET_ALEGACAO_PAGADOR` | `IPAGTB007_IPAGTB061_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` |
| `IPAGTB062_DET_DADOS_PAGADOR` | `IPAGTB007_IPAGTB062_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` |
| `IPAGTB063_DET_ENVIO_ALTERNATIVO` | `IPAGTB007_IPAGTB063_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` |
| `IPAGTB064_DET_CHEQUE_PAGAMENTO` | `IPAGTB007_IPAGTB064_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` |
| `IPAGTB065_DET_RATEIO_CREDITO` | `IPAGTB007_IPAGTB065_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` |
| `IPAGTB066_DET_NOTA_FISCAL` | `IPAGTB007_IPAGTB066_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` |
| `IPAGTB067_DET_NOTA_FISCAL_ADICIONAL` | `IPAGTB007_IPAGTB067_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` |
| `IPAGTB068_DET_TIPO_PAGAMENTO` | `IPAGTB007_IPAGTB068_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` |

