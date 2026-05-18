# Descrição das Tabelas — CNAB240
**Projeto:** IPAG — Integração de Pagamentos  
**Padrão:** FEBRABAN 240 posições V10.9  
**Data:** 2026-05-18  

---

## IPAGTB001_ARQUIVO
Entidade raiz do modelo CNAB240. Representa um arquivo físico recebido ou gerado no padrão FEBRABAN 240 posições. É o ponto de entrada da hierarquia Arquivo > Lote > Detalhe > Segmento. Cada registro corresponde a um arquivo distinto, identificado pelo nome físico, banco e data.

---

## IPAGTB002_HEADER_ARQUIVO
Armazena o registro Header de Arquivo (Tipo 0) do CNAB240. Existe exatamente um registro por arquivo físico. Contém dados de identificação do banco, empresa, conta e metadados do arquivo. Relacionamento 1:1 com IPAGTB001_ARQUIVO. Campos mapeados ao layout FEBRABAN posições 1-240.

**Chaves Estrangeiras:**

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB001_IPAGTB002_FK01` | `ID_ARQUIVO` | `IPAGTB001_ARQUIVO` | `ID_ARQUIVO` |
| `IPAGTB034_IPAGTB002_FK02` | `ID_TIPO_INSCRICAO` | `IPAGTB034_TIPO_INSCRICAO` | `ID_TIPO_INSCRICAO` |

---

## IPAGTB003_TRAILER_ARQUIVO
Armazena o registro Trailer de Arquivo (Tipo 9) do CNAB240. Existe exatamente um por arquivo. Contém totalizadores de controle: quantidade de lotes e quantidade total de registros do arquivo. Relacionamento 1:1 com IPAGTB001_ARQUIVO.

**Chaves Estrangeiras:**

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB001_IPAGTB003_FK01` | `ID_ARQUIVO` | `IPAGTB001_ARQUIVO` | `ID_ARQUIVO` |

---

## IPAGTB004_LOTE
Representa um Lote de Serviço/Produto dentro do arquivo CNAB240. Um arquivo pode ter múltiplos lotes. Cada lote contém exclusivamente um tipo de serviço. Relacionamento N:1 com IPAGTB001_ARQUIVO e 1:1 com IPAGTB005_HEADER_LOTE e IPAGTB006_TRAILER_LOTE.

**Chaves Estrangeiras:**

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB001_IPAGTB004_FK01` | `ID_ARQUIVO` | `IPAGTB001_ARQUIVO` | `ID_ARQUIVO` |
| `IPAGTB031_IPAGTB004_FK02` | `ID_TIPO_SERVICO` | `IPAGTB031_TIPO_SERVICO` | `ID_TIPO_SERVICO` |
| `IPAGTB032_IPAGTB004_FK02` | `ID_TIPO_OPERACAO` | `IPAGTB032_TIPO_OPERACAO` | `ID_TIPO_OPERACAO` |

---

## IPAGTB005_HEADER_LOTE
Armazena o registro Header de Lote (Tipo 1) do CNAB240. Existe exatamente um por lote. Contém dados da empresa, endereço, convênio e metadados do lote. Relacionamento 1:1 com IPAGTB004_LOTE. Campos mapeados ao layout do Header Lote do serviço de Pagamentos (posições 1-240).

**Chaves Estrangeiras:**

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB004_IPAGTB005_FK01` | `ID_LOTE` | `IPAGTB004_LOTE` | `ID_LOTE` |
| `IPAGTB034_IPAGTB005_FK02` | `ID_TIPO_INSCRICAO` | `IPAGTB034_TIPO_INSCRICAO` | `ID_TIPO_INSCRICAO` |

---

## IPAGTB006_TRAILER_LOTE
Armazena o registro Trailer de Lote (Tipo 5) do CNAB240. Existe exatamente um por lote. Contém totalizadores do lote: quantidade de registros, somatória de valores e número de aviso de débito. Relacionamento 1:1 com IPAGTB004_LOTE.

**Chaves Estrangeiras:**

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB004_IPAGTB006_FK01` | `ID_LOTE` | `IPAGTB004_LOTE` | `ID_LOTE` |

---

## IPAGTB007_DETALHE_REG
Agrupa os segmentos de um mesmo registro de detalhe CNAB240 (Tipo 3). Um registro de detalhe pode conter um ou mais segmentos (ex: A+B, J+J52, N+W). Esta tabela é o pai de todas as tabelas de segmentos. Relacionamento N:1 com IPAGTB004_LOTE e 1:0..1 com cada tabela de segmento.

**Chaves Estrangeiras:**

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB004_IPAGTB007_FK01` | `ID_LOTE` | `IPAGTB004_LOTE` | `ID_LOTE` |
| `IPAGTB033_IPAGTB007_FK02` | `ID_TIPO_MOVIMENTO` | `IPAGTB033_TIPO_MOVIMENTO` | `ID_TIPO_MOVIMENTO` |

---

## IPAGTB010_DET_PAGAMENTO
**Segmento A.** Obrigatório nos serviços de Pagamento (Crédito CC, DOC, TED, PIX) e Débito em Conta. Contém dados do favorecido (banco, agência, conta) e do pagamento (valor, data, finalidade). Relacionamento 0:1 com IPAGTB007_DETALHE_REG. Layout ref: página 25.

**Chaves Estrangeiras:**

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB007_IPAGTB010_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` | `ID_DETALHE_REG` |
| `IPAGTB035_IPAGTB010_FK02` | `ID_TIPO_MOEDA` | `IPAGTB035_TIPO_MOEDA` | `ID_TIPO_MOEDA` |
| `IPAGTB036_IPAGTB010_FK03` | `ID_CAMARA_CENTRALIZADORA` | `IPAGTB036_CAMARA_CENTRAL` | `ID_CAMARA_CENTRALIZADORA` |

---

## IPAGTB011_DET_INFO_FAVORECIDO
**Segmento B.** Complementar ao Segmento A. Contém dados adicionais do favorecido: inscrição e informações complementares variáveis (endereço para DOC/TED ou chave PIX). Layout ref: página 26.

**Chaves Estrangeiras:**

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB007_IPAGTB011_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` | `ID_DETALHE_REG` |
| `IPAGTB034_IPAGTB011_FK02` | `ID_TIPO_INSCRICAO` | `IPAGTB034_TIPO_INSCRICAO` | `ID_TIPO_INSCRICAO` |

---

## IPAGTB012_DET_COMPLEMENTAR
**Segmento C.** Opcional nos pagamentos. Contém valores de deduções (IR, ISS, IOF, INSS) e dados de conta substituta quando a agência original foi fechada ou fundida. Layout ref: página 27.

**Chaves Estrangeiras:**

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB007_IPAGTB012_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` | `ID_DETALHE_REG` |

---

## IPAGTB013_DET_TITULO_COBRANCA
**Segmento J.** Obrigatório no pagamento de Títulos de Cobrança e QR Code PIX. Contém código de barras, nome do beneficiário, vencimento e valores. Layout ref: página 30.

**Chaves Estrangeiras:**

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB007_IPAGTB013_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` | `ID_DETALHE_REG` |

---

## IPAGTB014_DET_PARTES_TITULO
**Segmento J-52.** Obrigatório no pagamento de títulos. Contém identificação do Pagador, Beneficiário e Sacador/Avalista (beneficiário original do título). Campo G067=52 nas posições 18-19. Layout ref: página 31.

**Chaves Estrangeiras:**

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB007_IPAGTB014_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` | `ID_DETALHE_REG` |
| `IPAGTB034_IPAGTB014_FK02` | `ID_TIPO_INSCRICAO_PAGADOR` | `IPAGTB034_TIPO_INSCRICAO` | `ID_TIPO_INSCRICAO` |
| `IPAGTB034_IPAGTB014_FK03` | `ID_TIPO_INSCRICAO_BENEF` | `IPAGTB034_TIPO_INSCRICAO` | `ID_TIPO_INSCRICAO` |
| `IPAGTB034_IPAGTB014_FK04` | `ID_TIPO_INSCRICAO_SACADOR` | `IPAGTB034_TIPO_INSCRICAO` | `ID_TIPO_INSCRICAO` |

---

## IPAGTB015_DET_PIX_QR_CODE
**Segmento J-52 PIX.** Variante do J-52 para pagamentos via QR Code. Contém identificação do devedor, favorecido e a chave de endereçamento PIX (CPF, CNPJ, e-mail, celular ou chave aleatória) mais o TXID. Layout ref: página 32.

**Chaves Estrangeiras:**

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB007_IPAGTB015_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` | `ID_DETALHE_REG` |
| `IPAGTB034_IPAGTB015_FK02` | `ID_TIPO_INSCRICAO_DEVEDOR` | `IPAGTB034_TIPO_INSCRICAO` | `ID_TIPO_INSCRICAO` |
| `IPAGTB034_IPAGTB015_FK03` | `ID_TIPO_INSCRICAO_FAVO` | `IPAGTB034_TIPO_INSCRICAO` | `ID_TIPO_INSCRICAO` |

---

## IPAGTB016_DET_TRIBUTO_SEM_CB
**Segmento N.** Obrigatório no pagamento de Tributos e Impostos sem Código de Barras. Cobre GPS, DARF, DARF Simples, GARE-SP, IPVA, DPVAT, Licenciamento e DARJ. As informações complementares (posições 111-230) variam conforme o tipo de tributo. Layout ref: página 36.

**Chaves Estrangeiras:**

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB007_IPAGTB016_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` | `ID_DETALHE_REG` |

---

## IPAGTB017_DET_TRIBUTO_COM_CB
**Segmento O.** Obrigatório no pagamento de Contas e Tributos com Código de Barras (concessionárias, impostos estaduais, FGTS). Contém código de barras, nome do órgão, vencimento e valor. Layout ref: página 35.

**Chaves Estrangeiras:**

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB007_IPAGTB017_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` | `ID_DETALHE_REG` |

---

## IPAGTB018_DET_COMPL_TRIBUTO
**Segmento W.** Opcional no pagamento de tributos. Fornece informações complementares obrigatórias para FGTS (convênios 0181 e 0182) quando usado em conjunto com o Segmento O. Também usado para outros tributos que necessitem de campos adicionais. Layout ref: página 45.

**Chaves Estrangeiras:**

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB007_IPAGTB018_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` | `ID_DETALHE_REG` |

---

## IPAGTB019_DET_IDENT_TRIBUTO
**Segmento Z.** Opcional nos retornos. Fornece autenticação do pagamento conforme legislação e protocolo bancário. Pode ser usado para qualquer forma de lançamento. Deve ser único por pagamento. Layout ref: página 47.

**Chaves Estrangeiras:**

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB007_IPAGTB019_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` | `ID_DETALHE_REG` |

---

## IPAGTB020_DET_DADOS_TITULO
**Segmento P.** Obrigatório na Cobrança Remessa (títulos em cobrança). Contém dados do título: nosso número, carteira, valor nominal, vencimento, instruções de cobrança e dados do sacado (devedor). Registro enviado do beneficiário ao banco.

**Chaves Estrangeiras:**

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB007_IPAGTB020_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` | `ID_DETALHE_REG` |
| `IPAGTB034_IPAGTB020_FK02` | `ID_TIPO_INSCRICAO_SACADO` | `IPAGTB034_TIPO_INSCRICAO` | `ID_TIPO_INSCRICAO` |

---

## IPAGTB021_DET_DADOS_SACADO
**Segmento Q.** Obrigatório na Cobrança Remessa. Contém dados complementares do sacado (endereço completo), sacador/avalista e banco correspondente para cobrança em outras praças.

**Chaves Estrangeiras:**

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB007_IPAGTB021_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` | `ID_DETALHE_REG` |
| `IPAGTB034_IPAGTB021_FK02` | `ID_TIPO_INSCRICAO_SACADO` | `IPAGTB034_TIPO_INSCRICAO` | `ID_TIPO_INSCRICAO` |
| `IPAGTB034_IPAGTB021_FK03` | `ID_TIPO_INSCRICAO_SACADOR` | `IPAGTB034_TIPO_INSCRICAO` | `ID_TIPO_INSCRICAO` |

---

## IPAGTB022_DET_DESCONTO_TITULO
**Segmento R.** Opcional na Cobrança Remessa. Contém descontos adicionais (2 e 3), tipo e valor de multa, tipo e valor de juros de mora e mensagem adicional ao sacado. Complementa as instruções do Segmento P.

**Chaves Estrangeiras:**

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB007_IPAGTB022_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` | `ID_DETALHE_REG` |

---

## IPAGTB023_DET_RETORNO_TITULO
**Segmento T.** Obrigatório no retorno da Cobrança. Contém confirmação dos dados do título: nosso número, carteira, sacado, vencimento e valores. Enviado pelo banco ao beneficiário confirmando movimentações dos títulos.

**Chaves Estrangeiras:**

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB007_IPAGTB023_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` | `ID_DETALHE_REG` |
| `IPAGTB034_IPAGTB023_FK02` | `ID_TIPO_INSCRICAO_SACADO` | `IPAGTB034_TIPO_INSCRICAO` | `ID_TIPO_INSCRICAO` |

---

## IPAGTB024_DET_COMPL_RETORNO
**Segmento U.** Obrigatório no retorno da Cobrança. Contém os valores financeiros da liquidação: acréscimos, descontos, abatimento, IOF, valor pago, valor líquido, data de ocorrência e crédito e dados do pagador. Complementa o Segmento T.

**Chaves Estrangeiras:**

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB007_IPAGTB024_FK01` | `ID_DETALHE_REG` | `IPAGTB007_DETALHE_REG` | `ID_DETALHE_REG` |

---

## IPAGTB025_CONTROLE_CARGA
Registra o estado de carga de cada arquivo CNAB240 no banco de dados. Permite retomada de processamento a partir do último lote concluído em caso de falha. Relação 1:1 com IPAGTB001_ARQUIVO.

**Chaves Estrangeiras:**

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB001_IPAGTB025_FK01` | `ID_ARQUIVO` | `IPAGTB001_ARQUIVO` | `ID_ARQUIVO` |
| `IPAGTB004_IPAGTB025_FK02` | `ID_ULTIMO_LOTE_CONCLUIDO` | `IPAGTB004_LOTE` | `ID_LOTE` |

---

## IPAGTB026_CTRL_CARGA_LOTE
Registra o estado de carga de cada lote CNAB240 individualmente. Granularidade fina do checkpoint: permite saber exatamente quais lotes foram carregados com sucesso e quais precisam ser reprocessados em caso de retomada.

**Chaves Estrangeiras:**

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB025_IPAGTB026_FK01` | `ID_CONTROLE_CARGA` | `IPAGTB025_CONTROLE_CARGA` | `ID_CONTROLE_CARGA` |
| `IPAGTB004_IPAGTB026_FK02` | `ID_LOTE` | `IPAGTB004_LOTE` | `ID_LOTE` |

---

## IPAGTB027_DISPATCH_LOTE
Registra o estado atual de envio (dispatch) de cada lote para cada serviço de destino. Representa a visão corrente da máquina de estados: PENDENTE → ENVIADO → CONFIRMADO ou ERRO → RETENTATIVA. Relação N:N entre lotes e serviços de destino com estado de controle.

**Chaves Estrangeiras:**

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB004_IPAGTB027_FK01` | `ID_LOTE` | `IPAGTB004_LOTE` | `ID_LOTE` |
| `IPAGTB037_IPAGTB027_FK02` | `ID_SERVICO_DESTINO` | `IPAGTB037_SERVICO_DESTINO` | `ID_SERVICO_DESTINO` |

---

## IPAGTB028_HISTORICO_DISPATCH
Log imutável (append-only) de todas as tentativas de dispatch de lotes para serviços externos. Nunca atualizado após insert — cada tentativa gera um novo registro. Permite auditoria completa do histórico de envios, falhas e retentativas por lote/serviço.

**Chaves Estrangeiras:**

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB027_IPAGTB028_FK01` | `ID_DISPATCH_LOTE` | `IPAGTB027_DISPATCH_LOTE` | `ID_DISPATCH_LOTE` |

---

## IPAGTB029_CONTROLE_LINHA
Registra cada linha física (240 posições) de um arquivo CNAB240 e seu estado de processamento. Permite saber exatamente quais linhas foram persistidas com sucesso, quais falharam e em qual tabela Oracle cada linha resultou — garantindo rastreabilidade completa do arquivo bruto ao modelo.

**Chaves Estrangeiras:**

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB001_IPAGTB029_FK01` | `ID_ARQUIVO` | `IPAGTB001_ARQUIVO` | `ID_ARQUIVO` |
| `IPAGTB030_IPAGTB029_FK02` | `ID_TIPO_REGISTRO` | `IPAGTB030_TIPO_REGISTRO` | `ID_TIPO_REGISTRO` |

---

## IPAGTB030_TIPO_REGISTRO
Domínio dos tipos de registro CNAB240. Cada linha representa um dos sete tipos válidos definidos pelo padrão FEBRABAN: 0=Header Arquivo, 1=Header Lote, 2=Inicial Lote, 3=Detalhe, 4=Final Lote, 5=Trailer Lote, 9=Trailer Arquivo.

---

## IPAGTB031_TIPO_SERVICO
Domínio dos tipos de serviço/produto CNAB240. Identifica a finalidade do lote. Campo G025 do padrão FEBRABAN. Exemplos: 01=Cobrança, 20=Pagamento Fornecedor, 30=Salário.

**Chaves Estrangeiras:**

| Constraint | Coluna(s) | Tabela Pai | Coluna(s) Pai |
|------------|-----------|------------|---------------|
| `IPAGTB037_IPAGTB031_FK01` | `ID_SERVICO_DESTINO` | `IPAGTB037_SERVICO_DESTINO` | `ID_SERVICO_DESTINO` |
---

## IPAGTB032_TIPO_OPERACAO
Domínio dos tipos de operação do Header de Lote. Campo G028 do padrão FEBRABAN. Indica se o lote é de Crédito (C), Débito (D) ou Extrato (E).

---

## IPAGTB033_TIPO_MOVIMENTO
Domínio dos tipos de movimento do registro detalhe. Campo G060 do padrão FEBRABAN. Indica a natureza da instrução: 0=Inclusão, 5=Alteração, 9=Exclusão, entre outros.

---

## IPAGTB034_TIPO_INSCRICAO
Domínio dos tipos de inscrição de pessoa física ou jurídica. Campo G005 do padrão FEBRABAN. Identifica se o número de inscrição é CPF ou CNPJ.

---

## IPAGTB035_TIPO_MOEDA
Domínio dos tipos de moeda utilizados no CNAB240. Campo G040 do padrão FEBRABAN. Exemplos: BRL=Real Brasileiro, USD=Dólar Americano, EUR=Euro.

---

## IPAGTB036_CAMARA_CENTRAL
Domínio dos códigos de câmara centralizadora para roteamento de pagamentos. Campo P001 do padrão FEBRABAN. Identifica a via de liquidação: TED, DOC, CC, PIX, etc.

---

## IPAGTB037_SERVICO_DESTINO
Domínio dos serviços de destino para envio dos lotes CNAB240. Cada registro representa um microsserviço consumidor (Boletos, Pagamentos, Tributos). Configurações de endpoint e política de retry são centralizadas aqui.

---

## Views (IPAGTV)

### IPAGTV001_STATUS_ARQUIVO
Visão consolidada do status de carga e dispatch de cada arquivo CNAB240. Exibe o progresso da carga e a contagem de lotes por estado para cada serviço de destino (BOLETO, PAGAMENTO, TRIBUTO). Uso recomendado: painel de monitoramento operacional.

### IPAGTV002_DISPATCH_PENDENTE
Fila de trabalho para workers de dispatch: lista os lotes prontos para envio ou retentativa. Retorna apenas dispatches PENDENTES ou em RETENTATIVA cujo DH_PROXIMO_ENVIO já passou. Ordenada por prioridade (PENDENTE antes de RETENTATIVA) e depois por tempo de espera. Workers devem selecionar e travar registros com SELECT ... FOR UPDATE SKIP LOCKED.

### IPAGTV003_LINHAS_ERRO
Visão de diagnóstico: exibe todas as linhas de arquivos CNAB240 que estão com status ERRO ou PENDENTE (não processadas). Permite identificar rapidamente quais linhas falharam, em qual arquivo, o conteúdo bruto e a mensagem de erro. Uso recomendado: troubleshooting operacional.

---

## Resumo Rápido

| Tabela | Segmento | Descrição Resumida |
|--------|----------|--------------------|
| IPAGTB001_ARQUIVO | — | Arquivo CNAB240 (raiz da hierarquia) |
| IPAGTB002_HEADER_ARQUIVO | Tipo 0 | Header do arquivo |
| IPAGTB003_TRAILER_ARQUIVO | Tipo 9 | Trailer do arquivo |
| IPAGTB004_LOTE | — | Lote de serviço/produto |
| IPAGTB005_HEADER_LOTE | Tipo 1 | Header do lote |
| IPAGTB006_TRAILER_LOTE | Tipo 5 | Trailer do lote |
| IPAGTB007_DETALHE_REG | Tipo 3 | Agrupador de segmentos do detalhe |
| IPAGTB010_DET_PAGAMENTO | **Seg A** | Dados do favorecido e pagamento |
| IPAGTB011_DET_INFO_FAVORECIDO | **Seg B** | Informações adicionais do favorecido |
| IPAGTB012_DET_COMPLEMENTAR | **Seg C** | Deduções fiscais (IR/ISS/IOF/INSS) |
| IPAGTB013_DET_TITULO_COBRANCA | **Seg J** | Título de cobrança / QR Code PIX |
| IPAGTB014_DET_PARTES_TITULO | **Seg J-52** | Pagador, Beneficiário e Sacador |
| IPAGTB015_DET_PIX_QR_CODE | **Seg J-52 PIX** | Chave PIX e TXID do QR Code |
| IPAGTB016_DET_TRIBUTO_SEM_CB | **Seg N** | Tributos sem código de barras |
| IPAGTB017_DET_TRIBUTO_COM_CB | **Seg O** | Tributos com código de barras |
| IPAGTB018_DET_COMPL_TRIBUTO | **Seg W** | Complementar tributos / FGTS |
| IPAGTB019_DET_IDENT_TRIBUTO | **Seg Z** | Autenticação do pagamento |
| IPAGTB020_DET_DADOS_TITULO | **Seg P** | Cobrança remessa — título |
| IPAGTB021_DET_DADOS_SACADO | **Seg Q** | Cobrança remessa — sacado |
| IPAGTB022_DET_DESCONTO_TITULO | **Seg R** | Cobrança remessa — descontos/multa |
| IPAGTB023_DET_RETORNO_TITULO | **Seg T** | Cobrança retorno — confirmação |
| IPAGTB024_DET_COMPL_RETORNO | **Seg U** | Cobrança retorno — valores financeiros |
| IPAGTB025_CONTROLE_CARGA | — | Estado de carga do arquivo |
| IPAGTB026_CTRL_CARGA_LOTE | — | Estado de carga por lote |
| IPAGTB027_DISPATCH_LOTE | — | Estado atual de dispatch |
| IPAGTB028_HISTORICO_DISPATCH | — | Log imutável de tentativas de dispatch |
| IPAGTB029_CONTROLE_LINHA | — | Rastreamento de linhas físicas |
| IPAGTB030_TIPO_REGISTRO | — | Domínio tipos de registro: 0,1,2,3,4,5,9 |
| IPAGTB031_TIPO_SERVICO | — | Domínio tipos de serviço/produto (G025) |
| IPAGTB032_TIPO_OPERACAO | — | Domínio operação do lote: C/D/E (G028) |
| IPAGTB033_TIPO_MOVIMENTO | — | Domínio natureza da instrução (G060) |
| IPAGTB034_TIPO_INSCRICAO | — | Domínio tipo de pessoa: CPF/CNPJ (G005) |
| IPAGTB035_TIPO_MOEDA | — | Domínio moedas: BRL, USD, EUR (G040) |
| IPAGTB036_CAMARA_CENTRAL | — | Domínio câmara de roteamento (P001) |
| IPAGTB037_SERVICO_DESTINO | — | Domínio microsserviços consumidores |
| IPAGTV001_STATUS_ARQUIVO | — | Status consolidado por arquivo |
| IPAGTV002_DISPATCH_PENDENTE | — | Fila de trabalho para workers de dispatch |
| IPAGTV003_LINHAS_ERRO | — | Linhas com erro ou pendentes |
