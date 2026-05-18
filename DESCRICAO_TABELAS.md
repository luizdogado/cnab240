# Descrição das Tabelas — CNAB240
**Projeto:** IPAG — Integração de Pagamentos  
**Padrão:** FEBRABAN 240 posições V10.9  
**Data:** 2026-05-18  

---

## Tabelas de Domínio (IPAGTD)

### IPAGTD001_TIPO_REGISTRO
Domínio dos tipos de registro CNAB240. Cada linha representa um dos sete tipos válidos definidos pelo padrão FEBRABAN: 0=Header Arquivo, 1=Header Lote, 2=Inicial Lote, 3=Detalhe, 4=Final Lote, 5=Trailer Lote, 9=Trailer Arquivo.

### IPAGTD002_TIPO_SERVICO
Domínio dos tipos de serviço/produto CNAB240. Identifica a finalidade do lote. Campo G025 do padrão FEBRABAN. Exemplos: 01=Cobrança, 20=Pagamento Fornecedor, 30=Salário.

### IPAGTD003_TIPO_OPERACAO
Domínio dos tipos de operação do Header de Lote. Campo G028 do padrão FEBRABAN. Indica se o lote é de Crédito (C), Débito (D) ou Extrato (E).

### IPAGTD004_TIPO_MOVIMENTO
Domínio dos tipos de movimento do registro detalhe. Campo G060 do padrão FEBRABAN. Indica a natureza da instrução: 0=Inclusão, 5=Alteração, 9=Exclusão, entre outros.

### IPAGTD005_TIPO_INSCRICAO
Domínio dos tipos de inscrição de pessoa física ou jurídica. Campo G005 do padrão FEBRABAN. Identifica se o número de inscrição é CPF ou CNPJ.

### IPAGTD006_TIPO_MOEDA
Domínio dos tipos de moeda utilizados no CNAB240. Campo G040 do padrão FEBRABAN. Exemplos: BRL=Real Brasileiro, USD=Dólar Americano, EUR=Euro.

### IPAGTD007_CAMARA_CENTRAL
Domínio dos códigos de câmara centralizadora para roteamento de pagamentos. Campo P001 do padrão FEBRABAN. Identifica a via de liquidação: TED, DOC, CC, PIX, etc.

### IPAGTD008_SERVICO_DESTINO
Domínio dos serviços de destino para envio dos lotes CNAB240. Cada registro representa um microsserviço consumidor (Boletos, Pagamentos, Tributos). Configurações de endpoint e política de retry são centralizadas aqui.

---

## Tabelas de Arquivo e Lote (IPAGTB001–007)

### IPAGTB001_ARQUIVO
Entidade raiz do modelo CNAB240. Representa um arquivo físico recebido ou gerado no padrão FEBRABAN 240 posições. É o ponto de entrada da hierarquia Arquivo > Lote > Detalhe > Segmento. Cada registro corresponde a um arquivo distinto, identificado pelo nome físico, banco e data.

### IPAGTB002_HEADER_ARQUIVO
Armazena o registro Header de Arquivo (Tipo 0) do CNAB240. Existe exatamente um registro por arquivo físico. Contém dados de identificação do banco, empresa, conta e metadados do arquivo. Relacionamento 1:1 com IPAGTB001_ARQUIVO. Campos mapeados ao layout FEBRABAN posições 1-240.

### IPAGTB003_TRAILER_ARQUIVO
Armazena o registro Trailer de Arquivo (Tipo 9) do CNAB240. Existe exatamente um por arquivo. Contém totalizadores de controle: quantidade de lotes e quantidade total de registros do arquivo. Relacionamento 1:1 com IPAGTB001_ARQUIVO.

### IPAGTB004_LOTE
Representa um Lote de Serviço/Produto dentro do arquivo CNAB240. Um arquivo pode ter múltiplos lotes. Cada lote contém exclusivamente um tipo de serviço. Relacionamento N:1 com IPAGTB001_ARQUIVO e 1:1 com IPAGTB005_HEADER_LOTE e IPAGTB006_TRAILER_LOTE.

### IPAGTB005_HEADER_LOTE
Armazena o registro Header de Lote (Tipo 1) do CNAB240. Existe exatamente um por lote. Contém dados da empresa, endereço, convênio e metadados do lote. Relacionamento 1:1 com IPAGTB004_LOTE. Campos mapeados ao layout do Header Lote do serviço de Pagamentos (posições 1-240).

### IPAGTB006_TRAILER_LOTE
Armazena o registro Trailer de Lote (Tipo 5) do CNAB240. Existe exatamente um por lote. Contém totalizadores do lote: quantidade de registros, somatória de valores e número de aviso de débito. Relacionamento 1:1 com IPAGTB004_LOTE.

### IPAGTB007_DETALHE_REG
Agrupa os segmentos de um mesmo registro de detalhe CNAB240 (Tipo 3). Um registro de detalhe pode conter um ou mais segmentos (ex: A+B, J+J52, N+W). Esta tabela é o pai de todas as tabelas de segmentos. Relacionamento N:1 com IPAGTB004_LOTE e 1:0..1 com cada tabela de segmento.

---

## Tabelas de Segmento — Pagamento / Débito / Vendor / Compror (IPAGTB010–012)

### IPAGTB010_DET_PAGAMENTO
**Segmento A.** Obrigatório nos serviços de Pagamento (Crédito CC, DOC, TED, PIX) e Débito em Conta. Contém dados do favorecido (banco, agência, conta) e do pagamento (valor, data, finalidade). Relacionamento 0:1 com IPAGTB007_DETALHE_REG. Layout ref: página 25.

### IPAGTB011_DET_INFO_FAVORECIDO
**Segmento B.** Complementar ao Segmento A. Contém dados adicionais do favorecido: inscrição e informações complementares variáveis (endereço para DOC/TED ou chave PIX). Layout ref: página 26.

### IPAGTB012_DET_COMPLEMENTAR
**Segmento C.** Opcional nos pagamentos. Contém valores de deduções (IR, ISS, IOF, INSS) e dados de conta substituta quando a agência original foi fechada ou fundida. Layout ref: página 27.

---

## Tabelas de Segmento — Títulos de Cobrança e QR Code PIX (IPAGTB013–015)

### IPAGTB013_DET_TITULO_COBRANCA
**Segmento J.** Obrigatório no pagamento de Títulos de Cobrança e QR Code PIX. Contém código de barras, nome do beneficiário, vencimento e valores. Layout ref: página 30.

### IPAGTB014_DET_PARTES_TITULO
**Segmento J-52.** Obrigatório no pagamento de títulos. Contém identificação do Pagador, Beneficiário e Sacador/Avalista (beneficiário original do título). Campo G067=52 nas posições 18-19. Layout ref: página 31.

### IPAGTB015_DET_PIX_QR_CODE
**Segmento J-52 PIX.** Variante do J-52 para pagamentos via QR Code. Contém identificação do devedor, favorecido e a chave de endereçamento PIX (CPF, CNPJ, e-mail, celular ou chave aleatória) mais o TXID. Layout ref: página 32.

---

## Tabelas de Segmento — Tributos sem Código de Barras (IPAGTB016)

### IPAGTB016_DET_TRIBUTO_SEM_CB
**Segmento N.** Obrigatório no pagamento de Tributos e Impostos sem Código de Barras. Cobre GPS, DARF, DARF Simples, GARE-SP, IPVA, DPVAT, Licenciamento e DARJ. As informações complementares (posições 111-230) variam conforme o tipo de tributo. Layout ref: página 36.

---

## Tabelas de Segmento — Tributos com Código de Barras (IPAGTB017–019)

### IPAGTB017_DET_TRIBUTO_COM_CB
**Segmento O.** Obrigatório no pagamento de Contas e Tributos com Código de Barras (concessionárias, impostos estaduais, FGTS). Contém código de barras, nome do órgão, vencimento e valor. Layout ref: página 35.

### IPAGTB018_DET_COMPL_TRIBUTO
**Segmento W.** Opcional no pagamento de tributos. Fornece informações complementares obrigatórias para FGTS (convênios 0181 e 0182) quando usado em conjunto com o Segmento O. Também usado para outros tributos que necessitem de campos adicionais. Layout ref: página 45.

### IPAGTB019_DET_IDENT_TRIBUTO
**Segmento Z.** Opcional nos retornos. Fornece autenticação do pagamento conforme legislação e protocolo bancário. Pode ser usado para qualquer forma de lançamento. Deve ser único por pagamento. Layout ref: página 47.

---

## Tabelas de Segmento — Cobrança Remessa (IPAGTB020–022)

### IPAGTB020_DET_DADOS_TITULO
**Segmento P.** Obrigatório na Cobrança Remessa (títulos em cobrança). Contém dados do título: nosso número, carteira, valor nominal, vencimento, instruções de cobrança e dados do sacado (devedor). Registro enviado do beneficiário ao banco.

### IPAGTB021_DET_DADOS_SACADO
**Segmento Q.** Obrigatório na Cobrança Remessa. Contém dados complementares do sacado (endereço completo), sacador/avalista e banco correspondente para cobrança em outras praças.

### IPAGTB022_DET_DESCONTO_TITULO
**Segmento R.** Opcional na Cobrança Remessa. Contém descontos adicionais (2 e 3), tipo e valor de multa, tipo e valor de juros de mora e mensagem adicional ao sacado. Complementa as instruções do Segmento P.

---

## Tabelas de Segmento — Cobrança Retorno (IPAGTB023–024)

### IPAGTB023_DET_RETORNO_TITULO
**Segmento T.** Obrigatório no retorno da Cobrança. Contém confirmação dos dados do título: nosso número, carteira, sacado, vencimento e valores. Enviado pelo banco ao beneficiário confirmando movimentações dos títulos.

### IPAGTB024_DET_COMPL_RETORNO
**Segmento U.** Obrigatório no retorno da Cobrança. Contém os valores financeiros da liquidação: acréscimos, descontos, abatimento, IOF, valor pago, valor líquido, data de ocorrência e crédito e dados do pagador. Complementa o Segmento T.

---

## Tabelas de Controle Operacional (IPAGTB025–029)

### IPAGTB025_CONTROLE_CARGA
Registra o estado de carga de cada arquivo CNAB240 no banco de dados. Permite retomada de processamento a partir do último lote concluído em caso de falha. Relação 1:1 com IPAGTB001_ARQUIVO.

### IPAGTB026_CTRL_CARGA_LOTE
Registra o estado de carga de cada lote CNAB240 individualmente. Granularidade fina do checkpoint: permite saber exatamente quais lotes foram carregados com sucesso e quais precisam ser reprocessados em caso de retomada.

### IPAGTB027_DISPATCH_LOTE
Registra o estado atual de envio (dispatch) de cada lote para cada serviço de destino. Representa a visão corrente da máquina de estados: PENDENTE → ENVIADO → CONFIRMADO ou ERRO → RETENTATIVA. Relação N:N entre lotes e serviços de destino com estado de controle.

### IPAGTB028_HISTORICO_DISPATCH
Log imutável (append-only) de todas as tentativas de dispatch de lotes para serviços externos. Nunca atualizado após insert — cada tentativa gera um novo registro. Permite auditoria completa do histórico de envios, falhas e retentativas por lote/serviço.

### IPAGTB029_CONTROLE_LINHA
Registra cada linha física (240 posições) de um arquivo CNAB240 e seu estado de processamento. Permite saber exatamente quais linhas foram persistidas com sucesso, quais falharam e em qual tabela Oracle cada linha resultou — garantindo rastreabilidade completa do arquivo bruto ao modelo.

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

| Tabela | Tipo | Segmento | Descrição Resumida |
|--------|------|----------|--------------------|
| IPAGTD001_TIPO_REGISTRO | Domínio | — | Tipos de registro: 0,1,2,3,4,5,9 |
| IPAGTD002_TIPO_SERVICO | Domínio | — | Tipos de serviço/produto do lote (G025) |
| IPAGTD003_TIPO_OPERACAO | Domínio | — | Operação do lote: C/D/E (G028) |
| IPAGTD004_TIPO_MOVIMENTO | Domínio | — | Natureza da instrução do detalhe (G060) |
| IPAGTD005_TIPO_INSCRICAO | Domínio | — | Tipo de pessoa: CPF / CNPJ (G005) |
| IPAGTD006_TIPO_MOEDA | Domínio | — | Moedas: BRL, USD, EUR (G040) |
| IPAGTD007_CAMARA_CENTRAL | Domínio | — | Câmara de roteamento: TED/DOC/PIX (P001) |
| IPAGTD008_SERVICO_DESTINO | Domínio | — | Microsserviços consumidores dos lotes |
| IPAGTB001_ARQUIVO | Negócio | — | Arquivo CNAB240 (raiz da hierarquia) |
| IPAGTB002_HEADER_ARQUIVO | Negócio | Tipo 0 | Header do arquivo |
| IPAGTB003_TRAILER_ARQUIVO | Negócio | Tipo 9 | Trailer do arquivo |
| IPAGTB004_LOTE | Negócio | — | Lote de serviço/produto |
| IPAGTB005_HEADER_LOTE | Negócio | Tipo 1 | Header do lote |
| IPAGTB006_TRAILER_LOTE | Negócio | Tipo 5 | Trailer do lote |
| IPAGTB007_DETALHE_REG | Negócio | Tipo 3 | Agrupador de segmentos do detalhe |
| IPAGTB010_DET_PAGAMENTO | Negócio | **Seg A** | Dados do favorecido e pagamento |
| IPAGTB011_DET_INFO_FAVORECIDO | Negócio | **Seg B** | Informações adicionais do favorecido |
| IPAGTB012_DET_COMPLEMENTAR | Negócio | **Seg C** | Deduções fiscais (IR/ISS/IOF/INSS) |
| IPAGTB013_DET_TITULO_COBRANCA | Negócio | **Seg J** | Título de cobrança / QR Code PIX |
| IPAGTB014_DET_PARTES_TITULO | Negócio | **Seg J-52** | Pagador, Beneficiário e Sacador |
| IPAGTB015_DET_PIX_QR_CODE | Negócio | **Seg J-52 PIX** | Chave PIX e TXID do QR Code |
| IPAGTB016_DET_TRIBUTO_SEM_CB | Negócio | **Seg N** | Tributos sem código de barras |
| IPAGTB017_DET_TRIBUTO_COM_CB | Negócio | **Seg O** | Tributos com código de barras |
| IPAGTB018_DET_COMPL_TRIBUTO | Negócio | **Seg W** | Complementar tributos / FGTS |
| IPAGTB019_DET_IDENT_TRIBUTO | Negócio | **Seg Z** | Autenticação do pagamento |
| IPAGTB020_DET_DADOS_TITULO | Negócio | **Seg P** | Cobrança remessa — título |
| IPAGTB021_DET_DADOS_SACADO | Negócio | **Seg Q** | Cobrança remessa — sacado |
| IPAGTB022_DET_DESCONTO_TITULO | Negócio | **Seg R** | Cobrança remessa — descontos/multa |
| IPAGTB023_DET_RETORNO_TITULO | Negócio | **Seg T** | Cobrança retorno — confirmação |
| IPAGTB024_DET_COMPL_RETORNO | Negócio | **Seg U** | Cobrança retorno — valores financeiros |
| IPAGTB025_CONTROLE_CARGA | Controle | — | Estado de carga do arquivo |
| IPAGTB026_CTRL_CARGA_LOTE | Controle | — | Estado de carga por lote |
| IPAGTB027_DISPATCH_LOTE | Controle | — | Estado atual de dispatch |
| IPAGTB028_HISTORICO_DISPATCH | Controle | — | Log imutável de tentativas de dispatch |
| IPAGTB029_CONTROLE_LINHA | Controle | — | Rastreamento de linhas físicas |
| IPAGTV001_STATUS_ARQUIVO | View | — | Status consolidado por arquivo |
| IPAGTV002_DISPATCH_PENDENTE | View | — | Fila de work para workers de dispatch |
| IPAGTV003_LINHAS_ERRO | View | — | Linhas com erro ou pendentes |
