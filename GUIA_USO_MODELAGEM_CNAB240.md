# Guia de Uso da Modelagem CNAB240 — Projeto IPAG

**Projeto:** IPAG — Integracão de Pagamentos  
**Padrao:** FEBRABAN 240 posicoes V10.9  
**Data:** 2026-06-01  

---

## 1. Visao Geral

O modelo Oracle CNAB240 IPAG persiste e controla o ciclo de vida completo de arquivos bancarios no padrao FEBRABAN 240 posicoes. Ele cobre desde a recepcao do arquivo bruto ate o despacho dos lotes para microsservicos consumidores e o rastreamento individual de cada pagamento.

### Arquitetura de microsservicos

O sistema opera num ambiente de microsservicos onde cada servico processa um tipo de pagamento:

| Servico | Responsabilidade | Segmentos recebidos |
|---------|-----------------|---------------------|
| **pgpb** | Boletos (titulos de cobranca) | J, J-52, O |
| **lifi** | TED, PIX, Debito em Conta | A, B, C |
| **lifi → Itau** | Tributos (2 etapas) | N, W, Z |

O banco de dados e o meio de controle e rastreamento entre esses servicos.

---

## 2. Hierarquia do Modelo — Do Arquivo ao Segmento

```
IPAGTB001_ARQUIVO                           ← Arquivo fisico recebido (raiz)
 ├── IPAGTB002_HEADER_ARQUIVO               ← Registro Tipo 0 (1:1)
 ├── IPAGTB003_TRAILER_ARQUIVO              ← Registro Tipo 9 (1:1)
 ├── IPAGTB025_CONTROLE_CARGA               ← Estado de carga do arquivo (1:1)
 ├── IPAGTB029_CONTROLE_LINHA               ← Cada linha fisica do arquivo (1:N)
 │
 └── IPAGTB004_LOTE                         ← Lote de servico/produto (1:N)
      ├── IPAGTB005_HEADER_LOTE             ← Registro Tipo 1 (1:1)
      ├── IPAGTB006_TRAILER_LOTE            ← Registro Tipo 5 (1:1)
      ├── IPAGTB026_CTRL_CARGA_LOTE         ← Estado de carga do lote (1:1)
      ├── IPAGTB027_DESPACHO_LOTE           ← Estado de envio por servico (1:N)
      │    ├── IPAGTB028_HISTORICO_DESPACHO  ← Log de tentativas do lote (1:N)
      │    └── IPAGTB069_DESPACHO_DETALHE   ← Estado por detalhe individual (1:N)
      │         └── IPAGTB070_HIST_DESP_DET ← Log de tentativas por detalhe (1:N)
      │
      └── IPAGTB007_DETALHE_REG             ← Agrupador de segmentos (1:N)
           ├── IPAGTB010 (Seg A)  — Pagamento TED/PIX
           ├── IPAGTB011 (Seg B)  — Info Favorecido
           ├── IPAGTB012 (Seg C)  — Complementar
           ├── IPAGTB013 (Seg J)  — Titulo Cobranca
           ├── IPAGTB014 (Seg J-52) — Partes Titulo
           ├── IPAGTB015 (Seg J-52 PIX)
           ├── IPAGTB016 (Seg N)  — Tributo sem CB
           ├── IPAGTB017 (Seg O)  — Tributo com CB
           ├── IPAGTB018 (Seg W)  — Compl Tributo
           ├── IPAGTB019 (Seg Z)  — Ident Tributo
           ├── IPAGTB020 (Seg P)  — Cobranca Remessa
           ├── IPAGTB021 (Seg Q)  — Dados Sacado
           ├── IPAGTB022 (Seg R)  — Desconto Titulo
           ├── IPAGTB023 (Seg T)  — Retorno Titulo
           ├── IPAGTB024 (Seg U)  — Compl Retorno
           ├── IPAGTB040 (Seg S)  — Mensagem Sacado
           ├── IPAGTB041 (Seg G)  — Boleto Eletronico
           ├── IPAGTB042 (Seg H)  — Compl Boleto
           ├── IPAGTB043 (Seg E)  — Extrato Conciliacao
           ├── IPAGTB044 (Seg F)  — Extrato Gestao Caixa
           ├── IPAGTB045 (Seg I)  — Valor Lancamento
           ├── IPAGTB046 (Seg K)  — Contrato Vendor
           ├── IPAGTB047 (Seg L)  — Pagamento Vendor
           ├── IPAGTB048 (Seg M)  — Retorno Contrato Vendor
           ├── IPAGTB049 (Seg N)  — Retorno Pagamento Vendor
           ├── IPAGTB050 (Seg D)  — Custodia Cheque
           ├── IPAGTB051 (Seg H)  — Emprestimo Consignacao
           ├── IPAGTB052 (Seg I)  — Compror
           ├── IPAGTB053 (Seg I-11) — Parcela Compror
           ├── IPAGTB060 (Seg Y-01) — Sacador Avalista
           ├── IPAGTB061 (Seg Y-02) — Alegacao Pagador
           ├── IPAGTB062 (Seg Y-03) — Dados Pagador
           ├── IPAGTB063 (Seg Y-04) — Envio Alternativo
           ├── IPAGTB064 (Seg Y-05) — Cheque Pagamento
           ├── IPAGTB065 (Seg Y-50) — Rateio Credito
           ├── IPAGTB066 (Seg Y-51) — Nota Fiscal
           ├── IPAGTB067 (Seg Y-52) — NF Adicional DANFE
           └── IPAGTB068 (Seg Y-53) — Tipo Pagamento
```

---

## 3. Fluxo Completo — Da Recepcao ao Despacho

O processamento de um arquivo CNAB240 segue 6 etapas sequenciais. Cada etapa usa tabelas especificas do modelo.

### ETAPA 1 — Recepcao e Registro do Arquivo

**O que acontece:** O arquivo fisico (.REM ou .RET) e recebido e registrado no banco.

**Tabelas envolvidas:**

| Tabela | Acao |
|--------|------|
| `IPAGTB001_ARQUIVO` | INSERT — cria o registro raiz com nome do arquivo, banco, data |
| `IPAGTB025_CONTROLE_CARGA` | INSERT — status `PENDENTE`, indica que o arquivo foi recebido mas nao processado |

**Estado apos esta etapa:**
- Arquivo registrado, controle de carga em `PENDENTE`
- Nenhum dado do conteudo foi lido ainda

---

### ETAPA 2 — Parse Linha a Linha

**O que acontece:** O arquivo e lido linha por linha (cada linha = 240 posicoes). Cada linha e registrada com seu tipo e estado.

**Tabelas envolvidas:**

| Tabela | Acao |
|--------|------|
| `IPAGTB029_CONTROLE_LINHA` | INSERT — uma linha por registro fisico do arquivo. Registra tipo (0,1,3,5,9), conteudo bruto e status (OK ou ERRO) |
| `IPAGTB030_TIPO_REGISTRO` | SELECT — lookup para classificar o tipo da linha (Header=0, Detalhe=3, etc.) |
| `IPAGTB025_CONTROLE_CARGA` | UPDATE — status muda para `EM_ANDAMENTO` |

**Estado apos esta etapa:**
- Cada linha do arquivo esta mapeada em `TB029`
- Linhas com erro de parse ja estao identificadas
- A view `IPAGTV003_LINHAS_ERRO` mostra linhas com problema

---

### ETAPA 3 — Montagem da Estrutura (Arquivo → Lote → Detalhe → Segmento)

**O que acontece:** As linhas parseadas sao transformadas na estrutura hierarquica do CNAB240. Esta e a etapa que popula o modelo relacional completo.

**Tabelas envolvidas:**

| Tabela | Acao | Origem |
|--------|------|--------|
| `IPAGTB002_HEADER_ARQUIVO` | INSERT | Linha Tipo 0 |
| `IPAGTB003_TRAILER_ARQUIVO` | INSERT | Linha Tipo 9 |
| `IPAGTB004_LOTE` | INSERT | Agrupa linhas entre Tipo 1 e Tipo 5 |
| `IPAGTB005_HEADER_LOTE` | INSERT | Linha Tipo 1 |
| `IPAGTB006_TRAILER_LOTE` | INSERT | Linha Tipo 5 |
| `IPAGTB007_DETALHE_REG` | INSERT | Agrupa segmentos de um mesmo registro Tipo 3 |
| `IPAGTB010–068` (segmentos) | INSERT | Linhas Tipo 3, conforme segmento identificado |
| `IPAGTB026_CTRL_CARGA_LOTE` | INSERT | Um por lote, status `CONCLUIDO` ou `ERRO` |

**Tabelas de dominio consultadas:**

| Tabela | Para que |
|--------|---------|
| `IPAGTB031_TIPO_SERVICO` | Classificar o lote (Cobranca, Pagamento, Salario...) |
| `IPAGTB032_TIPO_OPERACAO` | Tipo de operacao do lote (Credito/Debito/Extrato) |
| `IPAGTB033_TIPO_MOVIMENTO` | Natureza da instrucao (Inclusao/Alteracao/Exclusao) |
| `IPAGTB034_TIPO_INSCRICAO` | Tipo de pessoa (CPF/CNPJ) |
| `IPAGTB035_TIPO_MOEDA` | Moeda (BRL, USD...) |
| `IPAGTB036_CAMARA_CENTRAL` | Via de liquidacao (TED, PIX, DOC...) |

**Estado apos esta etapa:**
- Estrutura completa montada: Arquivo → Lotes → Detalhes → Segmentos
- `TB025` atualizado para `CONCLUIDO` (ou `AGUARDANDO_RETOMADA` se houve falha parcial)
- `TB026` indica quais lotes foram carregados com sucesso

---

### ETAPA 4 — Roteamento e Criacao de Despachos

**O que acontece:** Com base no tipo de servico do lote, o sistema decide para qual microsservico cada lote deve ser enviado. Um registro de despacho e criado para cada combinacao lote + servico.

**Regras de roteamento:**

| Segmentos no lote | Tipo de pagamento | Servico destino |
|-------------------|-------------------|-----------------|
| A, B, C | TED / PIX / Debito | **lifi** |
| J, J-52 | Boleto (titulo) | **pgpb** |
| O, W | Tributo com codigo de barras | **pgpb** |
| N | Tributo sem codigo de barras | **lifi** → depois **Itau** |

**Tabelas envolvidas:**

| Tabela | Acao |
|--------|------|
| `IPAGTB037_SERVICO_DESTINO` | SELECT — determina o servico alvo, URL, politica de retry |
| `IPAGTB027_DESPACHO_LOTE` | INSERT — status `PENDENTE`, um registro por lote/servico |
| `IPAGTB069_DESPACHO_DETALHE` | INSERT — status `PENDENTE`, um registro por detalhe individual (para servicos que processam linha a linha, como o lifi) |

**Estado apos esta etapa:**
- Fila de despacho criada
- A view `IPAGTV002_DESPACHO_PENDENTE` lista os lotes prontos para envio
- Cada detalhe individual tem seu proprio registro de controle

---

### ETAPA 5 — Envio aos Servicos (Despacho)

**O que acontece:** Workers consomem a fila de despacho, enviando lotes (ou detalhes individuais) aos servicos externos. As respostas sao processadas e registradas.

**Fluxo do worker:**

```
1. SELECT ... FOR UPDATE SKIP LOCKED em IPAGTV002_DESPACHO_PENDENTE
   → Pega o proximo lote disponivel sem concorrencia

2. Envia ao servico destino (lifi, pgpb, itau)
   → TB027: status ENVIADO
   → TB069: status ENVIADO por detalhe (quando aplicavel)

3. Recebe resposta (sincrona ou via fila assincrona)

4a. Se SUCESSO:
   → TB027: status CONFIRMADO (ou ERRO_PARCIAL se parcial)
   → TB028: INSERT com resultado da tentativa
   → TB069: status PROCESSADO por detalhe
   → TB070: INSERT com resultado individual

4b. Se ERRO retentavel:
   → TB027: status RETENTATIVA, incrementa NU_TENTATIVA_ATUAL, agenda DH_PROXIMO_ENVIO
   → TB028: INSERT com erro
   → TB069: status ERRO_RETENTATIVA por detalhe
   → TB070: INSERT com erro individual

4c. Se ERRO definitivo (ou tentativas esgotadas):
   → TB027: status ERRO
   → TB028: INSERT com erro final
   → TB069: status ERRO_DEFINITIVO por detalhe
   → TB070: INSERT com erro final
```

**Tabelas envolvidas:**

| Tabela | Papel |
|--------|-------|
| `IPAGTB027_DESPACHO_LOTE` | Estado corrente do despacho (atualizado a cada evento) |
| `IPAGTB028_HISTORICO_DESPACHO` | Log imutavel — NUNCA atualizado, sempre INSERT |
| `IPAGTB069_DESPACHO_DETALHE` | Estado corrente por detalhe individual |
| `IPAGTB070_HIST_DESP_DET` | Log imutavel por detalhe — NUNCA atualizado |

**Maquina de estados do lote (TB027):**

```
PENDENTE → ENVIADO → CONFIRMADO          (sucesso total)
               │
               ├──→ ERRO_PARCIAL         (mix de sucesso e erro nos detalhes)
               │
               ├──→ RETENTATIVA → ENVIADO (nova tentativa)
               │
               └──→ ERRO                 (definitivo ou tentativas esgotadas)
```

**Maquina de estados do detalhe (TB069):**

```
PENDENTE → ENVIADO → PROCESSADO           (sucesso)
               │
               ├──→ ERRO_RETENTATIVA → ENVIADO  (retry individual)
               │
               └──→ ERRO_DEFINITIVO       (nao retentavel ou esgotou)
```

---

### ETAPA 6 — Monitoramento e Relatorios

**O que acontece:** Views consolidam o estado de todo o fluxo para dashboards operacionais e relatorios.

**Views disponiveis:**

| View | Uso |
|------|-----|
| `IPAGTV001_STATUS_ARQUIVO` | Painel de monitoramento — mostra progresso de carga e contagem de despachos por status para cada arquivo |
| `IPAGTV002_DESPACHO_PENDENTE` | Fila de trabalho para workers — lotes prontos para envio ou retentativa, ordenados por prioridade |
| `IPAGTV003_LINHAS_ERRO` | Diagnostico — linhas com status ERRO ou PENDENTE, para troubleshooting rapido |

---

## 4. Fluxos por Tipo de Pagamento

### 4.1. TED / PIX (Segmentos A + B + C → lifi)

```
Arquivo recebido
  → TB001 (registro do arquivo)
  → TB004 (lote tipo servico = Pagamento)
  → TB007 (detalhe agrupador)
    → TB010 (Seg A — dados do favorecido, banco, agencia, conta, valor)
    → TB011 (Seg B — CPF/CNPJ, chave PIX, endereco)
    → TB012 (Seg C — deducoes IR/ISS/IOF se aplicavel)
  → TB027 (despacho para lifi, status PENDENTE)
  → TB069 (despacho por detalhe, 1 registro por TED/PIX)
  → Envio ao lifi
  → Respostas individuais pela fila → TB069/TB070 por detalhe
  → Consolidacao → TB027 CONFIRMADO / ERRO_PARCIAL / ERRO
```

### 4.2. Boleto — Titulo de Cobranca (Segmentos J + J-52 → pgpb)

```
Arquivo recebido
  → TB001 → TB004 (lote tipo servico = Pagamento Titulos)
  → TB007 (detalhe agrupador)
    → TB013 (Seg J — codigo de barras, beneficiario, vencimento, valor)
    → TB014 (Seg J-52 — pagador, beneficiario, sacador/avalista)
    → TB015 (Seg J-52 PIX — se for QR Code PIX)
  → TB027 (despacho para pgpb, status PENDENTE)
  → Envio ao pgpb
  → Resposta → TB028 (historico)
  → TB027 CONFIRMADO ou ERRO
```

### 4.3. Tributo sem Codigo de Barras (Segmento N → lifi → Itau)

Este fluxo tem **duas etapas independentes de despacho**:

```
Arquivo recebido
  → TB001 → TB004 (lote tipo servico = Tributos)
  → TB007 (detalhe agrupador)
    → TB016 (Seg N — GPS, DARF, GARE, IPVA, etc.)
  
  ETAPA 1: Envio ao lifi
  → TB027 (despacho #1 para lifi, status PENDENTE)
  → Envio ao lifi → TB027 CONFIRMADO
  
  ETAPA 2: lifi envia ao Itau no formato CNAB240
  → TB027 (despacho #2 para itau, status PENDENTE)
  → lifi encaminha ao Itau → TB027 CONFIRMADO
  
  → Rastreamento separado: "foi enviado ao lifi?" e "foi enviado ao Itau?" sao estados independentes
```

### 4.4. Tributo com Codigo de Barras (Segmentos O + W → pgpb)

```
Arquivo recebido
  → TB001 → TB004 (lote tipo servico = Contas/Tributos com CB)
  → TB007 (detalhe agrupador)
    → TB017 (Seg O — codigo de barras, nome orgao, vencimento, valor)
    → TB018 (Seg W — complementar FGTS, se aplicavel)
    → TB019 (Seg Z — autenticacao, no retorno)
  → TB027 (despacho para pgpb)
  → Envio ao pgpb → TB028 (historico)
```

### 4.5. Cobranca — Remessa (Segmentos P + Q + R + S → banco)

```
Arquivo de remessa gerado pelo sistema
  → TB001 → TB004 (lote tipo servico = Cobranca)
  → TB007 (detalhe agrupador)
    → TB020 (Seg P — nosso numero, carteira, valor, vencimento)
    → TB021 (Seg Q — dados completos do sacado/devedor)
    → TB022 (Seg R — descontos, multa, juros — opcional)
    → TB040 (Seg S — mensagem no boleto — opcional)
    → TB060–068 (Segs Y — sacador, envio alternativo, NF, rateio — opcionais)
```

### 4.6. Cobranca — Retorno (Segmentos T + U ← banco)

```
Arquivo de retorno recebido do banco
  → TB001 → TB004 (lote tipo servico = Cobranca Retorno)
  → TB007 (detalhe agrupador)
    → TB023 (Seg T — confirmacao: nosso numero, ocorrencia, valor)
    → TB024 (Seg U — valores financeiros: desconto, abatimento, IOF, valor pago)
    → TB064 (Seg Y-05 — cheques CMC7, se aplicavel)
```

---

## 5. Tabelas de Dominio (Lookups)

Essas tabelas contem valores fixos do padrao FEBRABAN e sao consultadas durante todo o fluxo:

| Tabela | Conteudo | Exemplo de valores |
|--------|----------|--------------------|
| `IPAGTB030_TIPO_REGISTRO` | Tipos de registro CNAB | 0=Header Arq, 1=Header Lote, 3=Detalhe, 5=Trailer Lote, 9=Trailer Arq |
| `IPAGTB031_TIPO_SERVICO` | Finalidade do lote | 01=Cobranca, 20=Pagamento Fornecedor, 30=Salario |
| `IPAGTB032_TIPO_OPERACAO` | Operacao do lote | C=Credito, D=Debito, E=Extrato |
| `IPAGTB033_TIPO_MOVIMENTO` | Instrucao do detalhe | 0=Inclusao, 5=Alteracao, 9=Exclusao |
| `IPAGTB034_TIPO_INSCRICAO` | Tipo de pessoa | 1=CPF, 2=CNPJ, 3=PIS/PASEP |
| `IPAGTB035_TIPO_MOEDA` | Moedas | BRL=Real, USD=Dolar, EUR=Euro |
| `IPAGTB036_CAMARA_CENTRAL` | Via de liquidacao | TED, DOC, PIX, CC |
| `IPAGTB037_SERVICO_DESTINO` | Microsservicos consumidores | pgpb, lifi, itau (com URL, retry, status) |

---

## 6. Controles Operacionais — Como Usar

### 6.1. Controle de Carga (retomada em caso de falha)

Se o processamento falhar no meio:

1. `TB025` registra o status `AGUARDANDO_RETOMADA` e o `ID_ULTIMO_LOTE_CONCLUIDO`
2. `TB026` mostra quais lotes foram carregados com sucesso (status `CONCLUIDO`)
3. Na retomada, o sistema consulta `TB025.ID_ULTIMO_LOTE_CONCLUIDO` e continua a partir do proximo lote

```sql
-- Verificar ponto de retomada
SELECT cc.CO_STATUS_CARGA,
       cc.ID_ULTIMO_LOTE_CONCLUIDO,
       cc.QT_LOTE_ESPERADO,
       cc.QT_LOTE_CONCLUIDO
  FROM IPAGTB025_CONTROLE_CARGA cc
 WHERE cc.ID_ARQUIVO = :ID_ARQUIVO;
```

### 6.2. Rastreamento de Linhas (diagnostico)

Para saber exatamente o que aconteceu com cada linha do arquivo:

```sql
-- Linhas com erro de parse
SELECT cl.NU_NUMERO_LINHA,
       tr.CO_TIPO_REGISTRO,
       cl.CO_STATUS_PROCESSAMENTO,
       cl.TE_MENSAGEM_ERRO,
       cl.TE_CONTEUDO_BRUTO
  FROM IPAGTB029_CONTROLE_LINHA cl
  JOIN IPAGTB030_TIPO_REGISTRO  tr ON tr.ID_TIPO_REGISTRO = cl.ID_TIPO_REGISTRO
 WHERE cl.ID_ARQUIVO = :ID_ARQUIVO
   AND cl.CO_STATUS_PROCESSAMENTO = 'ERRO';
```

Ou use a view pronta: `SELECT * FROM IPAGTV003_LINHAS_ERRO`

### 6.3. Despacho de Lotes (envio aos servicos)

Para consumir a fila de despacho com controle de concorrencia:

```sql
-- Pegar proximo lote pendente (sem concorrencia)
SELECT dl.ID_DESPACHO_LOTE,
       dl.ID_LOTE,
       sd.TE_URL_DESTINO,
       sd.CO_SERVICO
  FROM IPAGTB027_DESPACHO_LOTE       dl
  JOIN IPAGTB037_SERVICO_DESTINO     sd ON sd.ID_SERVICO_DESTINO = dl.ID_SERVICO_DESTINO
 WHERE dl.CO_STATUS_DESPACHO IN ('PENDENTE', 'RETENTATIVA')
   AND (dl.DH_PROXIMO_ENVIO IS NULL OR dl.DH_PROXIMO_ENVIO <= SYSDATE)
   AND dl.NU_TENTATIVA_ATUAL < dl.NU_MAX_TENTATIVA
   AND sd.IN_ATIVO = 'S'
 ORDER BY dl.DH_PROXIMO_ENVIO NULLS FIRST
 FETCH FIRST 1 ROWS ONLY
   FOR UPDATE OF dl.CO_STATUS_DESPACHO SKIP LOCKED;
```

### 6.4. Despacho por Detalhe Individual (processamento linha a linha)

Quando o servico (ex: lifi) processa cada TED/PIX individualmente:

```sql
-- Detalhes pendentes de reenvio apos erro retentavel
SELECT dd.ID_DESPACHO_DETALHE,
       dd.ID_DETALHE_REG,
       dd.CO_ORIGEM_ERRO,
       dd.NU_TENTATIVA_ATUAL,
       dd.NU_MAX_TENTATIVA
  FROM IPAGTB069_DESPACHO_DETALHE dd
 WHERE dd.CO_STATUS_DESPACHO = 'ERRO_RETENTATIVA'
   AND dd.NU_TENTATIVA_ATUAL < dd.NU_MAX_TENTATIVA
 ORDER BY dd.DH_ULTIMA_RESPOSTA;
```

### 6.5. Painel Consolidado por Arquivo

```sql
-- Status de todos os arquivos — progresso de carga + despachos
SELECT arq.NO_NOME_ARQUIVO,
       cc.CO_STATUS_CARGA,
       ROUND(cc.QT_LOTE_CONCLUIDO * 100.0 / NULLIF(cc.QT_LOTE_ESPERADO, 0), 1) AS PERC_CARGA,
       SUM(CASE WHEN dl.CO_STATUS_DESPACHO = 'PENDENTE'    THEN 1 ELSE 0 END) AS QT_PENDENTE,
       SUM(CASE WHEN dl.CO_STATUS_DESPACHO = 'CONFIRMADO'  THEN 1 ELSE 0 END) AS QT_CONFIRMADO,
       SUM(CASE WHEN dl.CO_STATUS_DESPACHO = 'ERRO'        THEN 1 ELSE 0 END) AS QT_ERRO
  FROM IPAGTB001_ARQUIVO              arq
  LEFT JOIN IPAGTB025_CONTROLE_CARGA  cc ON cc.ID_ARQUIVO = arq.ID_ARQUIVO
  LEFT JOIN IPAGTB004_LOTE            lt ON lt.ID_ARQUIVO = arq.ID_ARQUIVO
  LEFT JOIN IPAGTB027_DESPACHO_LOTE   dl ON dl.ID_LOTE    = lt.ID_LOTE
 GROUP BY arq.NO_NOME_ARQUIVO, cc.CO_STATUS_CARGA,
          cc.QT_LOTE_CONCLUIDO, cc.QT_LOTE_ESPERADO
 ORDER BY arq.NO_NOME_ARQUIVO;
```

Ou use a view pronta: `SELECT * FROM IPAGTV001_STATUS_ARQUIVO`

---

## 7. Resumo dos 4 Niveis de Rastreamento

O modelo suporta rastreamento em 4 granularidades:

| Nivel | Tabela | Pergunta que responde |
|-------|--------|-----------------------|
| **Arquivo** | `TB025_CONTROLE_CARGA` | O arquivo foi carregado com sucesso? Onde parou? |
| **Lote** | `TB027_DESPACHO_LOTE` | O lote foi enviado ao servico? Quantas tentativas? |
| **Detalhe** | `TB069_DESPACHO_DETALHE` | Esse TED especifico foi processado? Esse boleto foi pago? |
| **Linha fisica** | `TB029_CONTROLE_LINHA` | Essa linha do arquivo bruto virou o que no banco? |

---

## 8. Arquivos de Referencia na Pasta de Modelagem

| Arquivo | Conteudo |
|---------|----------|
| `DDL_CNAB240_ORACLE.sql` | DDL principal com todas as tabelas (TB001–TB037), views e sequences |
| `DDL_CNAB240_VP.sql` | DDL complementar com tabelas de segmentos novos (TB040–TB068) |
| `DESCRICAO_TABELAS.md` | Descricao detalhada de cada tabela com chaves estrangeiras |
| `MAPEAMENTO_TABELAS_SEGMENTOS.md` | Mapa completo: qual tabela armazena qual segmento CNAB |
| `SKILL_CNAB240_ORACLE.md` | Regras de nomenclatura e padroes de modelagem Oracle |
| `PROPOSTA_DESPACHO_DETALHE.md` | Proposta das tabelas TB069/TB070 para rastreamento por detalhe |
| `CONSULTAS_EXEMPLO.sql` | 10 queries prontas para operacao (fila, painel, erros, historico) |
| `Layout padrao CNAB240 V 10 09.pdf` | Especificacao oficial FEBRABAN |
| `gerar_ddl_novos_segmentos.py` | Script para gerar DDL de novos segmentos automaticamente |

---

## 9. Cobertura de Segmentos

O modelo cobre **todos** os segmentos do padrao CNAB240 FEBRABAN V10.9:

| Servico | Segmentos | Tabelas |
|---------|-----------|---------|
| Pagamento (TED/PIX/DOC/CC) | A, B, C | TB010, TB011, TB012 |
| Pagamento Titulos Cobranca | J, J-52, J-52 PIX | TB013, TB014, TB015 |
| Tributos sem CB | N | TB016 |
| Tributos com CB | O, W, Z | TB017, TB018, TB019 |
| Cobranca Remessa | P, Q, R, S, Y-01 a Y-53 | TB020–TB022, TB040, TB060–TB068 |
| Cobranca Retorno | T, U, Y-05 | TB023, TB024, TB064 |
| Boleto Eletronico | G, H, Y-03 | TB041, TB042, TB062 |
| Extrato | E, F, I | TB043, TB044, TB045 |
| Vendor | K, L, M, N | TB046–TB049 |
| Custodia Cheques | D | TB050 |
| Emprestimo Consignacao | H | TB051 |
| Compror | I, I-11 | TB052, TB053 |
| Alegacao Pagador | Y-02 | TB061 |

---

## 10. Adendo — Use Cases por Servico

### 10.1. Use Case: pgpb (Pagamento de Boletos)

**Responsabilidade:** Processar boletos de cobranca e tributos com codigo de barras.

**Segmentos que recebe:**
- Segmento J (titulo de cobranca) — `IPAGTB013_DET_TITULO_COBRANCA`
- Segmento J-52 (partes do titulo) — `IPAGTB014_DET_PARTES_TITULO`
- Segmento J-52 PIX (QR Code) — `IPAGTB015_DET_PIX_QR_CODE`
- Segmento O (tributo com codigo de barras) — `IPAGTB017_DET_TRIBUTO_COM_CB`
- Segmento W (complementar FGTS) — `IPAGTB018_DET_COMPL_TRIBUTO`

**Fluxo no modelo:**

```
1. Arquivo recebido → IPAGTB001_ARQUIVO

2. Parse e carga:
   → TB029 (controle de linhas)
   → TB004 (lote tipo servico = Pagamento Titulos ou Tributos com CB)
   → TB007 → TB013/TB014/TB015 (segmentos de boleto)
         ou TB007 → TB017/TB018 (segmentos de tributo com CB)

3. Roteamento:
   → TB037 busca o servico destino "pgpb"
   → TB027 INSERT com ID_SERVICO_DESTINO = pgpb, status PENDENTE

4. Worker consome a fila:
   → SELECT ... FOR UPDATE SKIP LOCKED em TB027
   → Envia lote ao pgpb
   → TB027 status ENVIADO

5. Resposta do pgpb:
   → Sucesso: TB027 status CONFIRMADO, TB028 INSERT com resultado
   → Erro retentavel: TB027 status RETENTATIVA, TB028 INSERT, agenda proximo envio
   → Erro definitivo: TB027 status ERRO, TB028 INSERT com erro final

6. Monitoramento:
   → IPAGTV001 mostra status consolidado
   → IPAGTV002 mostra lotes pendentes de envio/retentativa
```

**Pontos de atencao:**
- O pgpb processa o **lote inteiro** (nao linha a linha)
- O rastreamento e feito no nivel de lote (TB027/TB028)
- Se houver confirmacao de que o pgpb tambem processa individualmente, ativar TB069/TB070

---

### 10.2. Use Case: lifi (Pagamentos TED/PIX)

**Responsabilidade:** Processar transferencias TED, PIX e debitos em conta.

**Segmentos que recebe:**
- Segmento A (dados do pagamento) — `IPAGTB010_DET_PAGAMENTO`
- Segmento B (info do favorecido) — `IPAGTB011_DET_INFO_FAVORECIDO`
- Segmento C (complementar) — `IPAGTB012_DET_COMPLEMENTAR`

**Fluxo no modelo:**

```
1. Arquivo recebido → IPAGTB001_ARQUIVO

2. Parse e carga:
   → TB029 (controle de linhas)
   → TB004 (lote tipo servico = Pagamento Credito/DOC/TED/PIX)
   → TB007 → TB010 (Seg A) + TB011 (Seg B) + TB012 (Seg C, opcional)

3. Roteamento:
   → TB037 busca o servico destino "lifi"
   → TB027 INSERT com ID_SERVICO_DESTINO = lifi, status PENDENTE
   → TB069 INSERT — um registro por detalhe individual (1 por TED/PIX)

4. Worker consome a fila:
   → SELECT em IPAGTV002 (fila de despacho pendente)
   → Envia lote ao lifi
   → TB027 status ENVIADO
   → TB069 status ENVIADO para cada detalhe

5. Lifi processa CADA TED/PIX INDIVIDUALMENTE:
   → Respostas chegam pela fila assincrona, uma por detalhe
   → Correlacao via TB069.TE_CORRELACAO_ENVIO

6. Para cada resposta individual:
   a) Sucesso:
      → TB069 status PROCESSADO
      → TB070 INSERT com CO_STATUS_RESULTADO = PROCESSADO
   
   b) Erro retentavel:
      → TB069 status ERRO_RETENTATIVA, incrementa NU_TENTATIVA_ATUAL
      → TB070 INSERT com CO_STATUS_RESULTADO = ERRO_RETENTATIVA
      → Se tentativas < maximo: reenvia SO ESSE DETALHE (nao o lote inteiro)
      → Se tentativas >= maximo: TB069 status ERRO_DEFINITIVO
   
   c) Erro nao retentavel:
      → TB069 status ERRO_DEFINITIVO
      → TB070 INSERT com CO_STATUS_RESULTADO = ERRO_DEFINITIVO

7. Consolidacao do lote (quando todos detalhes tem status terminal):
   → Todos PROCESSADO: TB027 status CONFIRMADO
   → Todos ERRO_DEFINITIVO: TB027 status ERRO
   → Mix: TB027 status ERRO_PARCIAL

8. Relatorio diario de erros:
   → Consulta TB070 para erros do dia
   → Repassa ao fornecedor
```

**Diferencial do lifi:**
- Processa **linha a linha** (detalhe por detalhe), nao lote inteiro
- Exige as tabelas TB069/TB070 para rastreamento individual
- Permite reenvio granular: reenvia so o TED que falhou, nao o lote inteiro
- Respostas sao assincronas (fila), necessitando correlacao

---

### 10.3. Use Case: Tributo sem Codigo de Barras (lifi → Itau)

**Responsabilidade:** Processar tributos (GPS, DARF, GARE, IPVA, etc.) que nao possuem codigo de barras. Este e o unico fluxo com **duas etapas de despacho independentes**.

**Segmentos que recebe:**
- Segmento N (tributo sem CB) — `IPAGTB016_DET_TRIBUTO_SEM_CB`
- Segmento W (complementar) — `IPAGTB018_DET_COMPL_TRIBUTO` (quando aplicavel)
- Segmento Z (autenticacao) — `IPAGTB019_DET_IDENT_TRIBUTO` (no retorno)

**Fluxo no modelo — DUAS ETAPAS:**

```
ETAPA 1 — Envio ao lifi
═══════════════════════

1. Arquivo recebido → IPAGTB001_ARQUIVO

2. Parse e carga:
   → TB029 (controle de linhas)
   → TB004 (lote tipo servico = Tributos sem CB)
   → TB007 → TB016 (Seg N) + TB018 (Seg W, opcional)

3. Roteamento — PRIMEIRO DESPACHO:
   → TB037 busca o servico destino "lifi"
   → TB027 INSERT — DESPACHO #1, ID_SERVICO_DESTINO = lifi, status PENDENTE
   → TB069 INSERT — um registro por tributo individual

4. Worker envia ao lifi:
   → TB027 (despacho #1) status ENVIADO
   → Respostas individuais processadas via TB069/TB070

5. Consolidacao do DESPACHO #1:
   → TB027 (despacho #1) status CONFIRMADO quando todos detalhes processados


ETAPA 2 — lifi envia ao Itau (formato CNAB240)
═══════════════════════════════════════════════

6. Apos confirmacao da etapa 1, cria SEGUNDO DESPACHO:
   → TB037 busca o servico destino "itau"
   → TB027 INSERT — DESPACHO #2, ID_SERVICO_DESTINO = itau, status PENDENTE
     (MESMO ID_LOTE, servico destino DIFERENTE)

7. Worker envia ao Itau:
   → O lifi remonta o arquivo CNAB240 e envia ao Itau
   → TB027 (despacho #2) status ENVIADO

8. Resposta do Itau:
   → TB027 (despacho #2) status CONFIRMADO ou ERRO
   → TB028 INSERT com resultado da tentativa

9. Rastreamento independente das duas etapas:
   → "Foi enviado ao lifi?" → TB027 WHERE ID_SERVICO_DESTINO = lifi
   → "Foi enviado ao Itau?" → TB027 WHERE ID_SERVICO_DESTINO = itau
   → Cada etapa tem seu proprio historico em TB028
```

**Diagrama de despachos para um mesmo lote de tributo:**

```
IPAGTB004_LOTE (lote de tributo N)
  │
  ├── TB027 DESPACHO #1 → lifi    [PENDENTE → ENVIADO → CONFIRMADO]
  │    ├── TB028 tentativa 1 (lifi)
  │    └── TB069 detalhes individuais
  │         └── TB070 historico por detalhe
  │
  └── TB027 DESPACHO #2 → itau    [PENDENTE → ENVIADO → CONFIRMADO]
       └── TB028 tentativa 1 (itau)
```

**Consulta: status das duas etapas de um tributo:**

```sql
SELECT
    arq.NO_NOME_ARQUIVO,
    lt.NU_NUMERO_LOTE,
    sd.CO_SERVICO                     AS SERVICO_DESTINO,
    dl.CO_STATUS_DESPACHO,
    dl.NU_TENTATIVA_ATUAL,
    dl.DH_ULTIMO_ENVIO
FROM IPAGTB027_DESPACHO_LOTE       dl
JOIN IPAGTB004_LOTE                lt  ON lt.ID_LOTE            = dl.ID_LOTE
JOIN IPAGTB001_ARQUIVO             arq ON arq.ID_ARQUIVO        = lt.ID_ARQUIVO
JOIN IPAGTB037_SERVICO_DESTINO     sd  ON sd.ID_SERVICO_DESTINO = dl.ID_SERVICO_DESTINO
WHERE lt.ID_LOTE = :ID_LOTE_TRIBUTO
ORDER BY dl.DH_INCLUSAO;

-- Resultado esperado:
-- ARQUIVO_TRIBUTOS.REM | Lote 1 | lifi | CONFIRMADO | 1 | 2026-06-01 10:00
-- ARQUIVO_TRIBUTOS.REM | Lote 1 | itau | ENVIADO    | 1 | 2026-06-01 10:30
```

**Pontos de atencao:**
- O mesmo lote (TB004) tem **dois registros** em TB027 — um por servico destino
- A chave composta (ID_LOTE + ID_SERVICO_DESTINO) garante unicidade
- O despacho #2 (itau) so e criado apos confirmacao do despacho #1 (lifi)
- Falha na etapa 1 bloqueia a etapa 2
- O lifi e responsavel por remontar o CNAB240 no formato aceito pelo Itau
