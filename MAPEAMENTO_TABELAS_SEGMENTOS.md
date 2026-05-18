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
| `IPAGTB002_HEADER_ARQUIVO` | **Tipo 0** — Header de Arquivo | Dados do banco destino, empresa e data/hora de geração do arquivo. |
| `IPAGTB003_TRAILER_ARQUIVO` | **Tipo 9** — Trailer de Arquivo | Totalizadores: quantidade de lotes e registros do arquivo. |
| `IPAGTB004_LOTE` | — (contêiner) | Representa um Lote de Serviço/Produto. Um arquivo pode ter múltiplos lotes. |
| `IPAGTB005_HEADER_LOTE` | **Tipo 1** — Header de Lote | Dados da empresa, tipo de serviço, tipo de operação e endereço. |
| `IPAGTB006_TRAILER_LOTE` | **Tipo 5** — Trailer de Lote | Totalizadores do lote: qtd registros, somatório de valores. |
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

## 3. Segmentos de Pagamento de Títulos de Cobrança e QR Code PIX

| Tabela | Segmento | Obrigatoriedade | Descrição |
|--------|----------|----------------|-----------|
| `IPAGTB013_DET_TITULO_COBRANCA` | **Segmento J** | Obrigatório | Código de barras do título, nome do beneficiário, data de vencimento, valor nominal. Campo de referência: campos L001–L010. |
| `IPAGTB014_DET_PARTES_TITULO` | **Segmento J-52** | Obrigatório | Identificação do Pagador, Beneficiário e Sacador/Avalista do título. Campos: inscrição, nome. |
| `IPAGTB015_DET_PIX_QR_CODE` | **Segmento J-52 PIX** | Obrigatório (quando PIX) | Variante do J-52 para pagamentos via QR Code PIX. Contém identificação do devedor, favorecido e dados do QR. |

**Serviço:** Pagamento de Títulos de Cobrança e QR Code PIX — Remessa e Retorno

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

**Serviço:** Cobrança — Títulos em Cobrança — Remessa  
**Nota:** Segmentos S e Y também fazem parte deste fluxo mas ainda não estão modelados.

---

## 7. Segmentos de Cobrança — Retorno

| Tabela | Segmento | Obrigatoriedade | Descrição |
|--------|----------|----------------|-----------|
| `IPAGTB023_DET_RETORNO_TITULO` | **Segmento T** | Obrigatório | Confirmação dos dados do título no retorno: nosso número, carteira, ocorrência bancária, valor. |
| `IPAGTB024_DET_COMPL_RETORNO` | **Segmento U** | Obrigatório | Valores financeiros da liquidação no retorno: acréscimos, descontos, abatimentos, IOF, outros créditos/débitos. |

**Serviço:** Cobrança — Títulos em Cobrança — Retorno  
**Nota:** Segmento Y (retorno cobrança) ainda não modelado.

---

## 8. Tabelas de Controle Operacional (sem segmento CNAB)

| Tabela | Descrição |
|--------|-----------|
| `IPAGTB025_CONTROLE_CARGA` | Estado de carga de cada arquivo: PENDENTE, EM_ANDAMENTO, CONCLUIDO, ERRO, AGUARDANDO_RETOMADA. Permite retomada do processamento a partir do último lote concluído. |
| `IPAGTB026_CTRL_CARGA_LOTE` | Estado de carga de cada lote individualmente. Granularidade fina do checkpoint. |
| `IPAGTB027_DISPATCH_LOTE` | Estado atual de envio (dispatch) de cada lote para cada serviço de destino. Visão corrente da máquina de estados. |
| `IPAGTB028_HISTORICO_DISPATCH` | Log imutável (append-only) de todas as tentativas de dispatch. Nunca atualizado após inserção. |
| `IPAGTB029_CONTROLE_LINHA` | Cada linha física (240 posições) do arquivo e seu estado de processamento. |

---

## 9. Tabelas de Domínio (IPAGTB030–037)

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

## 10. Views (IPAGTV)

| View | Descrição |
|------|-----------|
| `IPAGTV001_STATUS_ARQUIVO` | Status consolidado de carga e dispatch por arquivo. |
| `IPAGTV002_DISPATCH_PENDENTE` | Fila de trabalho para workers: lotes prontos para envio ou retentativa. |
| `IPAGTV003_LINHAS_ERRO` | Diagnóstico: linhas com status ERRO ou PENDENTE não processadas. |

---

## 11. Segmentos FEBRABAN ainda não modelados

Os segmentos abaixo constam no padrão CNAB240 V10.9 (PDF FEBRABAN) mas ainda não possuem tabela no modelo atual:

| Segmento | Serviço | Obs |
|----------|---------|-----|
| **D** | Custódia de Cheques — Remessa e Retorno | — |
| **E** | Extrato de Conta Corrente para Conciliação Bancária | Somente Retorno |
| **F** | Extrato para Gestão de Caixa | Somente Retorno |
| **G** | Boleto de Pagamento Eletrônico (Captura de Títulos) | Somente Retorno |
| **H** | Empréstimo por Consignação | Remessa e Retorno |
| **I** | Extrato para Gestão de Caixa (opcional) / Compror | Retorno |
| **K** | Vendor — Remessa | Obrigatório |
| **L** | Vendor — Remessa | Obrigatório |
| **M** | Vendor — Retorno | Obrigatório |
| **S** | Cobrança Remessa — Títulos em Cobrança | Opcional |
| **Y** | Cobrança Remessa/Retorno, Boleto Eletrônico, Alegação do Pagador | Obrigatório em Alegação |

---

## 12. Resumo Visual: Tabela x Segmento

| # | Tabela | Segmento | Serviço Principal |
|---|--------|----------|------------------|
| TB001 | IPAGTB001_ARQUIVO | — | Raiz |
| TB002 | IPAGTB002_HEADER_ARQUIVO | Tipo 0 | Header Arquivo |
| TB003 | IPAGTB003_TRAILER_ARQUIVO | Tipo 9 | Trailer Arquivo |
| TB004 | IPAGTB004_LOTE | — | Contêiner de Lote |
| TB005 | IPAGTB005_HEADER_LOTE | Tipo 1 | Header Lote |
| TB006 | IPAGTB006_TRAILER_LOTE | Tipo 5 | Trailer Lote |
| TB007 | IPAGTB007_DETALHE_REG | Tipo 3 | Agrupador Detalhe |
| TB010 | IPAGTB010_DET_PAGAMENTO | **Seg A** | Pagamento / Débito / Vendor / Compror |
| TB011 | IPAGTB011_DET_INFO_FAVORECIDO | **Seg B** | Complementar ao A |
| TB012 | IPAGTB012_DET_COMPLEMENTAR | **Seg C** | Deduções (IR/ISS/IOF) |
| TB013 | IPAGTB013_DET_TITULO_COBRANCA | **Seg J** | Pag. Títulos Cobrança / QR Code PIX |
| TB014 | IPAGTB014_DET_PARTES_TITULO | **Seg J-52** | Partes do Título |
| TB015 | IPAGTB015_DET_PIX_QR_CODE | **Seg J-52 PIX** | QR Code PIX |
| TB016 | IPAGTB016_DET_TRIBUTO_SEM_CB | **Seg N** | Tributos sem Código de Barras |
| TB017 | IPAGTB017_DET_TRIBUTO_COM_CB | **Seg O** | Tributos com Código de Barras |
| TB018 | IPAGTB018_DET_COMPL_TRIBUTO | **Seg W** | Complementar Tributos / FGTS |
| TB019 | IPAGTB019_DET_IDENT_TRIBUTO | **Seg Z** | Autenticação Pagamento |
| TB020 | IPAGTB020_DET_DADOS_TITULO | **Seg P** | Cobrança Remessa — Dados Título |
| TB021 | IPAGTB021_DET_DADOS_SACADO | **Seg Q** | Cobrança Remessa — Dados Sacado |
| TB022 | IPAGTB022_DET_DESCONTO_TITULO | **Seg R** | Cobrança Remessa — Descontos |
| TB023 | IPAGTB023_DET_RETORNO_TITULO | **Seg T** | Cobrança Retorno — Confirmação |
| TB024 | IPAGTB024_DET_COMPL_RETORNO | **Seg U** | Cobrança Retorno — Valores |
| TB025 | IPAGTB025_CONTROLE_CARGA | — | Controle de Carga (operacional) |
| TB026 | IPAGTB026_CTRL_CARGA_LOTE | — | Controle de Carga por Lote |
| TB027 | IPAGTB027_DISPATCH_LOTE | — | Estado de Dispatch |
| TB028 | IPAGTB028_HISTORICO_DISPATCH | — | Log de Dispatch |
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

## 13. Chaves Estrangeiras por Tabela

### IPAGTB002_HEADER_ARQUIVO

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB001_IPAGTB002_FK01` | `ID_ARQUIVO` | `IPAGTB001_ARQUIVO` | `ID_ARQUIVO` |
| `IPAGTB034_IPAGTB002_FK01` | `ID_TIPO_INSCRICAO` | `IPAGTB034_TIPO_INSCRICAO` | `ID_TIPO_INSCRICAO` |

### IPAGTB003_TRAILER_ARQUIVO

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB001_IPAGTB003_FK01` | `ID_ARQUIVO` | `IPAGTB001_ARQUIVO` | `ID_ARQUIVO` |

### IPAGTB004_LOTE

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB001_IPAGTB004_FK01` | `ID_ARQUIVO` | `IPAGTB001_ARQUIVO` | `ID_ARQUIVO` |
| `IPAGTB031_IPAGTB004_FK01` | `ID_TIPO_SERVICO` | `IPAGTB031_TIPO_SERVICO` | `ID_TIPO_SERVICO` |
| `IPAGTB032_IPAGTB004_FK01` | `ID_TIPO_OPERACAO` | `IPAGTB032_TIPO_OPERACAO` | `ID_TIPO_OPERACAO` |

### IPAGTB005_HEADER_LOTE

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB004_IPAGTB005_FK01` | `ID_LOTE` | `IPAGTB004_LOTE` | `ID_LOTE` |
| `IPAGTB034_IPAGTB005_FK01` | `ID_TIPO_INSCRICAO` | `IPAGTB034_TIPO_INSCRICAO` | `ID_TIPO_INSCRICAO` |

### IPAGTB006_TRAILER_LOTE

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB004_IPAGTB006_FK01` | `ID_LOTE` | `IPAGTB004_LOTE` | `ID_LOTE` |

### IPAGTB007_DETALHE_REG

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB004_IPAGTB007_FK01` | `ID_LOTE` | `IPAGTB004_LOTE` | `ID_LOTE` |
| `IPAGTB033_IPAGTB007_FK01` | `ID_TIPO_MOVIMENTO` | `IPAGTB033_TIPO_MOVIMENTO` | `ID_TIPO_MOVIMENTO` |

### IPAGTB010_DET_PAGAMENTO

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB007_IPAGTB010_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` | `ID_DETALHE_REG` |
| `IPAGTB035_IPAGTB010_FK01` | `ID_TIPO_MOEDA` | `IPAGTB035_TIPO_MOEDA` | `ID_TIPO_MOEDA` |
| `IPAGTB036_IPAGTB010_FK01` | `ID_CAMARA_CENTRALIZADORA` | `IPAGTB036_CAMARA_CENTRAL` | `ID_CAMARA_CENTRALIZADORA` |

### IPAGTB011_DET_INFO_FAVORECIDO

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB007_IPAGTB011_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` | `ID_DETALHE_REG` |
| `IPAGTB034_IPAGTB011_FK01` | `ID_TIPO_INSCRICAO` | `IPAGTB034_TIPO_INSCRICAO` | `ID_TIPO_INSCRICAO` |

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
| `IPAGTB034_IPAGTB014_FK01` | `ID_TIPO_INSCRICAO_PAGADOR` | `IPAGTB034_TIPO_INSCRICAO` | `ID_TIPO_INSCRICAO` |
| `IPAGTB034_IPAGTB014_FK02` | `ID_TIPO_INSCRICAO_BENEF` | `IPAGTB034_TIPO_INSCRICAO` | `ID_TIPO_INSCRICAO` |
| `IPAGTB034_IPAGTB014_FK03` | `ID_TIPO_INSCRICAO_SACADOR` | `IPAGTB034_TIPO_INSCRICAO` | `ID_TIPO_INSCRICAO` |

### IPAGTB015_DET_PIX_QR_CODE

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB007_IPAGTB015_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` | `ID_DETALHE_REG` |
| `IPAGTB034_IPAGTB015_FK01` | `ID_TIPO_INSCRICAO_DEVEDOR` | `IPAGTB034_TIPO_INSCRICAO` | `ID_TIPO_INSCRICAO` |
| `IPAGTB034_IPAGTB015_FK02` | `ID_TIPO_INSCRICAO_FAVO` | `IPAGTB034_TIPO_INSCRICAO` | `ID_TIPO_INSCRICAO` |

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
| `IPAGTB034_IPAGTB020_FK01` | `ID_TIPO_INSCRICAO_SACADO` | `IPAGTB034_TIPO_INSCRICAO` | `ID_TIPO_INSCRICAO` |

### IPAGTB021_DET_DADOS_SACADO

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB007_IPAGTB021_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` | `ID_DETALHE_REG` |
| `IPAGTB034_IPAGTB021_FK01` | `ID_TIPO_INSCRICAO_SACADO` | `IPAGTB034_TIPO_INSCRICAO` | `ID_TIPO_INSCRICAO` |
| `IPAGTB034_IPAGTB021_FK02` | `ID_TIPO_INSCRICAO_SACADOR` | `IPAGTB034_TIPO_INSCRICAO` | `ID_TIPO_INSCRICAO` |

### IPAGTB022_DET_DESCONTO_TITULO

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB007_IPAGTB022_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` | `ID_DETALHE_REG` |

### IPAGTB023_DET_RETORNO_TITULO

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB007_IPAGTB023_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` | `ID_DETALHE_REG` |
| `IPAGTB034_IPAGTB023_FK01` | `ID_TIPO_INSCRICAO_SACADO` | `IPAGTB034_TIPO_INSCRICAO` | `ID_TIPO_INSCRICAO` |

### IPAGTB024_DET_COMPL_RETORNO

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB007_IPAGTB024_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` | `ID_DETALHE_REG` |

### IPAGTB025_CONTROLE_CARGA

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB001_IPAGTB025_FK01` | `ID_ARQUIVO` | `IPAGTB001_ARQUIVO` | `ID_ARQUIVO` |
| `IPAGTB004_IPAGTB025_FK01` | `ID_ULTIMO_LOTE_CONCLUIDO` | `IPAGTB004_LOTE` | `ID_LOTE` |

### IPAGTB026_CTRL_CARGA_LOTE

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB004_IPAGTB026_FK01` | `ID_LOTE` | `IPAGTB004_LOTE` | `ID_LOTE` |
| `IPAGTB025_IPAGTB026_FK01` | `ID_CONTROLE_CARGA` | `IPAGTB025_CONTROLE_CARGA` | `ID_CONTROLE_CARGA` |

### IPAGTB027_DISPATCH_LOTE

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB004_IPAGTB027_FK01` | `ID_LOTE` | `IPAGTB004_LOTE` | `ID_LOTE` |
| `IPAGTB037_IPAGTB027_FK01` | `ID_SERVICO_DESTINO` | `IPAGTB037_SERVICO_DESTINO` | `ID_SERVICO_DESTINO` |

### IPAGTB028_HISTORICO_DISPATCH

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB027_IPAGTB028_FK01` | `ID_DISPATCH_LOTE` | `IPAGTB027_DISPATCH_LOTE` | `ID_DISPATCH_LOTE` |

### IPAGTB029_CONTROLE_LINHA

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB001_IPAGTB029_FK01` | `ID_ARQUIVO` | `IPAGTB001_ARQUIVO` | `ID_ARQUIVO` |
| `IPAGTB030_IPAGTB029_FK01` | `ID_TIPO_REGISTRO` | `IPAGTB030_TIPO_REGISTRO` | `ID_TIPO_REGISTRO` |

### IPAGTB031_TIPO_SERVICO

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB037_IPAGTB031_FK01` | `ID_SERVICO_DESTINO` | `IPAGTB037_SERVICO_DESTINO` | `ID_SERVICO_DESTINO` |

