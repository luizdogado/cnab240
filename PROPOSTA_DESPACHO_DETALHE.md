# Proposta: Rastreamento de Despacho por Detalhe Individual

**Projeto:** IPAG — Integracao de Pagamentos  
**Padrao:** FEBRABAN CNAB240 V10.9  
**Data:** 2026-05-28  
**Status:** Em validacao

---

## 1. Problema

O modelo atual rastreia o despacho de lotes para servicos externos (lifi, pgpb, itau) no nivel do **lote** (`IPAGTB027_DESPACHO_LOTE`). Porem, o servico **lifi** processa cada linha individualmente e retorna resultado por segmento via fila assincrona.

Quando um lote com 500 TEDs e enviado ao lifi:
- O lifi processa TED por TED
- A fila retorna resultado individual (TED 1 OK, TED 2 ERRO, TED 3 OK...)
- **Nao existe tabela para gravar o resultado por detalhe**

### Impacto

- Nao e possivel saber qual TED especifico falhou dentro de um lote
- Nao e possivel reenviar apenas os detalhes que falharam
- Nao e possivel gerar relatorio diario de erros por linha para o fornecedor
- Nao e possivel classificar erros por origem para decidir se retenta ou nao

---

## 2. Requisitos de Negocio

| # | Requisito | Origem |
|---|-----------|--------|
| R1 | Rastrear status de processamento de cada detalhe individual no lifi | Fluxo de pagamento TED/PIX |
| R2 | Classificar erros por origem para decidir se retenta ou encerra | Regra de negocio — depende do tipo de erro |
| R3 | Controlar retry individual por detalhe (nao por lote inteiro) | Fluxo de retentativa |
| R4 | Gerar relatorio diario de erros para repasse ao fornecedor | Processo operacional fim de dia |
| R5 | Manter historico completo de tentativas por detalhe (auditoria) | Rastreabilidade e troubleshooting |
| R6 | Correlacionar resposta da fila do lifi com o detalhe original | Integracao via fila assincrona |

---

## 3. Solucao Proposta

Duas novas tabelas no esquema operacional, seguindo a hierarquia existente:

```
IPAGTB027_DESPACHO_LOTE                (estado do LOTE por servico — ja existe)
   └── IPAGTB069_DESPACHO_DETALHE       (estado ATUAL de cada detalhe — NOVA)
         └── IPAGTB070_HIST_DESP_DET     (log de cada tentativa — NOVA, append-only)
```

### Relacao com o modelo existente

```
IPAGTB001_ARQUIVO
  └── IPAGTB004_LOTE
       └── IPAGTB007_DETALHE_REG ─────────────┐
       │                                        │
       └── IPAGTB027_DESPACHO_LOTE             │ (FK)
            └── IPAGTB069_DESPACHO_DETALHE ────┘
                 └── IPAGTB070_HIST_DESP_DET
```

---

## 4. Estrutura das Tabelas

### 4.1. IPAGTB069_DESPACHO_DETALHE

**Descricao:** Registra o estado atual de despacho de cada registro de detalhe (`IPAGTB007_DETALHE_REG`) dentro de um despacho de lote. Cada linha representa um detalhe individual enviado a um servico externo. Atualizado a cada resposta recebida da fila. Relacao N:1 com `IPAGTB027_DESPACHO_LOTE` e N:1 com `IPAGTB007_DETALHE_REG`.

| Coluna | Tipo Oracle | Null? | Descricao |
|--------|-------------|-------|-----------|
| `ID_DESPACHO_DETALHE` | NUMBER | NOT NULL (PK) | Identificador surrogate. Sequence: `IPAGTB069_DESPACHO_DETALHE_SQ` |
| `ID_DESPACHO_LOTE` | NUMBER | NOT NULL (FK → TB027) | Despacho de lote ao qual este detalhe pertence |
| `ID_DETALHE_REG` | NUMBER | NOT NULL (FK → TB007) | Registro de detalhe individual sendo despachado |
| `CO_STATUS_DESPACHO` | VARCHAR2(20) | NOT NULL | Estado atual: PENDENTE, ENVIADO, PROCESSADO, ERRO_RETENTATIVA, ERRO_DEFINITIVO |
| `CO_ORIGEM_ERRO` | VARCHAR2(60) | NULL | Classificacao da origem do erro. Define se o detalhe e retentavel ou nao. Null quando sem erro |
| `TE_CORRELACAO_ENVIO` | VARCHAR2(200) | NULL | Dado enviado ao lifi que sera devolvido na fila para correlacao (ex: ID_DETALHE_REG ou chave composta) |
| `NU_TENTATIVA_ATUAL` | NUMBER(3) | NOT NULL | Numero da tentativa atual. Inicia em 1 no primeiro envio |
| `NU_MAX_TENTATIVA` | NUMBER(3) | NOT NULL | Limite maximo de tentativas. Pode variar conforme origem do erro |
| `DH_ULTIMO_ENVIO` | DATE | NULL | Data/hora do ultimo envio ao servico |
| `DH_ULTIMA_RESPOSTA` | DATE | NULL | Data/hora da ultima resposta recebida da fila |
| `CO_STATUS_HTTP` | NUMBER(3) | NULL | Codigo HTTP da ultima resposta, se aplicavel |
| `TE_RESPOSTA_SERVICO` | VARCHAR2(4000) | NULL | Conteudo da ultima resposta do servico |
| `DH_INCLUSAO` | DATE | NOT NULL | Data/hora de inclusao do registro |
| `DH_ALTERACAO` | DATE | NULL | Data/hora da ultima alteracao |
| `NO_USUARIO_INCLUSAO` | VARCHAR2(60) | NOT NULL | Usuario que incluiu |
| `NO_USUARIO_ALTERACAO` | VARCHAR2(60) | NULL | Usuario que alterou |

**Constraints:**
- PK: `IPAGTB069_PK` em `ID_DESPACHO_DETALHE`
- FK01: `IPAGTB027_IPAGTB069_FK01` — `ID_DESPACHO_LOTE` → `IPAGTB027_DESPACHO_LOTE.ID_DESPACHO_LOTE`
- FK02: `IPAGTB007_IPAGTB069_FK02` — `ID_DETALHE_REG` → `IPAGTB007_DETALHE_REG.ID_DETALHE_REG`
- UK01: `IPAGTB069_UK01` — (`ID_DESPACHO_LOTE`, `ID_DETALHE_REG`) — um detalhe aparece uma unica vez por despacho de lote

---

### 4.2. IPAGTB070_HIST_DESP_DET

**Descricao:** Log imutavel (append-only) de todas as tentativas de despacho de cada detalhe individual. Nunca atualizado apos insert — cada tentativa gera um novo registro. Permite auditoria completa e geracao de relatorio diario de erros para o fornecedor. Relacao N:1 com `IPAGTB069_DESPACHO_DETALHE`.

| Coluna | Tipo Oracle | Null? | Descricao |
|--------|-------------|-------|-----------|
| `ID_HIST_DESPACHO_DET` | NUMBER | NOT NULL (PK) | Identificador surrogate. Sequence: `IPAGTB070_HIST_DESP_DET_SQ` |
| `ID_DESPACHO_DETALHE` | NUMBER | NOT NULL (FK → TB069) | Despacho de detalhe ao qual esta tentativa pertence |
| `NU_NUMERO_TENTATIVA` | NUMBER(3) | NOT NULL | Numero sequencial da tentativa (1, 2, 3...) |
| `CO_STATUS_RESULTADO` | VARCHAR2(20) | NOT NULL | Resultado: PROCESSADO, ERRO_RETENTATIVA, ERRO_DEFINITIVO |
| `CO_ORIGEM_ERRO` | VARCHAR2(60) | NULL | Classificacao da origem do erro nesta tentativa. Null quando sucesso |
| `TE_RESPOSTA_SERVICO` | VARCHAR2(4000) | NULL | Resposta completa do servico nesta tentativa |
| `CO_STATUS_HTTP` | NUMBER(3) | NULL | Codigo HTTP desta tentativa, se aplicavel |
| `DH_ENVIO` | DATE | NOT NULL | Data/hora do envio desta tentativa |
| `DH_RESPOSTA` | DATE | NULL | Data/hora da resposta desta tentativa. Null se ainda aguardando |
| `NU_DURACAO_MS` | NUMBER(10) | NULL | Tempo entre envio e resposta em milissegundos |
| `DH_INCLUSAO` | DATE | NOT NULL | Data/hora de inclusao do registro |
| `DH_ALTERACAO` | DATE | NULL | Data/hora da ultima alteracao |
| `NO_USUARIO_INCLUSAO` | VARCHAR2(60) | NOT NULL | Usuario que incluiu |
| `NO_USUARIO_ALTERACAO` | VARCHAR2(60) | NULL | Usuario que alterou |

**Constraints:**
- PK: `IPAGTB070_PK` em `ID_HIST_DESPACHO_DET`
- FK01: `IPAGTB069_IPAGTB070_FK01` — `ID_DESPACHO_DETALHE` → `IPAGTB069_DESPACHO_DETALHE.ID_DESPACHO_DETALHE`
- UK01: `IPAGTB070_UK01` — (`ID_DESPACHO_DETALHE`, `NU_NUMERO_TENTATIVA`) — uma tentativa por numero por despacho

---

## 5. Maquina de Estados

### 5.1. Status do detalhe (TB069)

```
PENDENTE ──→ ENVIADO ──→ PROCESSADO         (sucesso)
                │
                └──→ ERRO_RETENTATIVA ──→ ENVIADO  (retry)
                │         │
                │         └──→ ERRO_DEFINITIVO      (esgotou tentativas ou origem nao permite)
                │
                └──→ ERRO_DEFINITIVO                (origem nao permite retry desde a 1a falha)
```

### 5.2. Regra de classificacao por origem

| CO_ORIGEM_ERRO | Retentavel? | Acao |
|----------------|-------------|------|
| (a definir com fornecedor) | SIM | Reenviar ate NU_MAX_TENTATIVA |
| (a definir com fornecedor) | NAO | Marcar ERRO_DEFINITIVO, reportar no relatorio diario |

> **Nota:** Os valores de `CO_ORIGEM_ERRO` serao definidos apos alinhamento com o fornecedor sobre os codigos de erro que o lifi retorna.

### 5.3. Propagacao para o lote (TB027)

Quando todos os detalhes de um despacho de lote tiverem status terminal:

| Condicao | Status do lote (TB027) |
|----------|----------------------|
| Todos PROCESSADO | CONFIRMADO |
| Todos ERRO_DEFINITIVO | ERRO |
| Mix de PROCESSADO + ERRO_DEFINITIVO | ERRO_PARCIAL (novo status sugerido) |

---

## 6. Fluxo Operacional Completo

```
ETAPA 1 — Preparacao
  1.1  Arquivo carregado           → TB025 status EM_ANDAMENTO
  1.2  Linhas parseadas            → TB029 status OK/ERRO por linha
  1.3  Lotes montados              → TB004
  1.4  Detalhes criados            → TB007 + TB010-068 (segmentos)

ETAPA 2 — Despacho do Lote
  2.1  Cria despacho do lote       → TB027 status PENDENTE (para lifi)
  2.2  Cria despacho por detalhe   → TB069 status PENDENTE (1 por detalhe do lote)

ETAPA 3 — Envio ao Lifi
  3.1  Envia lote ao lifi          → TB027 status ENVIADO
  3.2  Atualiza cada detalhe       → TB069 status ENVIADO, DH_ULTIMO_ENVIO = SYSDATE

ETAPA 4 — Recebimento de Respostas (fila assincrona)
  4.1  Recebe resposta da fila
  4.2  Correlaciona com TB069 via TE_CORRELACAO_ENVIO
  4.3  Se OK:
         → TB069 status PROCESSADO
         → TB070 grava tentativa com CO_STATUS_RESULTADO = PROCESSADO
  4.4  Se ERRO retentavel:
         → TB069 status ERRO_RETENTATIVA, incrementa NU_TENTATIVA_ATUAL
         → TB070 grava tentativa com CO_STATUS_RESULTADO = ERRO_RETENTATIVA
         → Se NU_TENTATIVA_ATUAL < NU_MAX_TENTATIVA: volta pra etapa 3 (so esse detalhe)
         → Se NU_TENTATIVA_ATUAL >= NU_MAX_TENTATIVA: TB069 status ERRO_DEFINITIVO
  4.5  Se ERRO nao retentavel:
         → TB069 status ERRO_DEFINITIVO
         → TB070 grava tentativa com CO_STATUS_RESULTADO = ERRO_DEFINITIVO

ETAPA 5 — Consolidacao do Lote
  5.1  Quando todos os detalhes tem status terminal:
         → TB027 atualiza status conforme regra da secao 5.3

ETAPA 6 — Relatorio Diario (fim do dia)
  6.1  Consulta TB070 para erros do dia
  6.2  Repassa ao fornecedor para decisao sobre proximo dia
```

---

## 7. Consultas de Referencia

### 7.1. Detalhes com erro no dia (relatorio pro fornecedor)

```sql
SELECT
    arq.NO_NOME_ARQUIVO,
    lt.NU_NUMERO_LOTE,
    dd.ID_DETALHE_REG,
    dd.CO_STATUS_DESPACHO,
    dd.CO_ORIGEM_ERRO,
    dd.NU_TENTATIVA_ATUAL,
    hd.NU_NUMERO_TENTATIVA,
    hd.CO_STATUS_RESULTADO,
    hd.TE_RESPOSTA_SERVICO,
    hd.DH_ENVIO,
    hd.DH_RESPOSTA
FROM IPAGTB070_HIST_DESP_DET      hd
JOIN IPAGTB069_DESPACHO_DETALHE   dd  ON dd.ID_DESPACHO_DETALHE = hd.ID_DESPACHO_DETALHE
JOIN IPAGTB027_DESPACHO_LOTE      dl  ON dl.ID_DESPACHO_LOTE    = dd.ID_DESPACHO_LOTE
JOIN IPAGTB004_LOTE               lt  ON lt.ID_LOTE             = dl.ID_LOTE
JOIN IPAGTB001_ARQUIVO            arq ON arq.ID_ARQUIVO         = lt.ID_ARQUIVO
WHERE hd.CO_STATUS_RESULTADO IN ('ERRO_RETENTATIVA', 'ERRO_DEFINITIVO')
  AND hd.DH_RESPOSTA >= TRUNC(SYSDATE)
ORDER BY
    arq.NO_NOME_ARQUIVO,
    lt.NU_NUMERO_LOTE,
    dd.ID_DETALHE_REG,
    hd.NU_NUMERO_TENTATIVA;
```

### 7.2. Detalhes pendentes de resposta da fila

```sql
SELECT
    dd.ID_DESPACHO_DETALHE,
    dd.ID_DETALHE_REG,
    dd.CO_STATUS_DESPACHO,
    dd.DH_ULTIMO_ENVIO,
    dd.NU_TENTATIVA_ATUAL,
    sd.CO_SERVICO
FROM IPAGTB069_DESPACHO_DETALHE   dd
JOIN IPAGTB027_DESPACHO_LOTE      dl  ON dl.ID_DESPACHO_LOTE    = dd.ID_DESPACHO_LOTE
JOIN IPAGTB037_SERVICO_DESTINO    sd  ON sd.ID_SERVICO_DESTINO  = dl.ID_SERVICO_DESTINO
WHERE dd.CO_STATUS_DESPACHO = 'ENVIADO'
ORDER BY dd.DH_ULTIMO_ENVIO;
```

### 7.3. Resumo do lote — quantos detalhes em cada status

```sql
SELECT
    dl.ID_DESPACHO_LOTE,
    lt.NU_NUMERO_LOTE,
    dd.CO_STATUS_DESPACHO,
    COUNT(*) AS QT_DETALHE
FROM IPAGTB069_DESPACHO_DETALHE   dd
JOIN IPAGTB027_DESPACHO_LOTE      dl  ON dl.ID_DESPACHO_LOTE = dd.ID_DESPACHO_LOTE
JOIN IPAGTB004_LOTE               lt  ON lt.ID_LOTE          = dl.ID_LOTE
GROUP BY
    dl.ID_DESPACHO_LOTE,
    lt.NU_NUMERO_LOTE,
    dd.CO_STATUS_DESPACHO
ORDER BY
    lt.NU_NUMERO_LOTE,
    dd.CO_STATUS_DESPACHO;
```

### 7.4. Detalhes retentaveis prontos para reenvio

```sql
SELECT
    dd.ID_DESPACHO_DETALHE,
    dd.ID_DETALHE_REG,
    dd.CO_ORIGEM_ERRO,
    dd.NU_TENTATIVA_ATUAL,
    dd.NU_MAX_TENTATIVA
FROM IPAGTB069_DESPACHO_DETALHE   dd
WHERE dd.CO_STATUS_DESPACHO = 'ERRO_RETENTATIVA'
  AND dd.NU_TENTATIVA_ATUAL < dd.NU_MAX_TENTATIVA
ORDER BY dd.DH_ULTIMA_RESPOSTA;
```

---

## 8. Impacto no Modelo Existente

### Tabelas novas
| Tabela | Descricao |
|--------|-----------|
| `IPAGTB069_DESPACHO_DETALHE` | Estado atual de despacho por detalhe individual |
| `IPAGTB070_HIST_DESP_DET` | Log imutavel de tentativas por detalhe |

### Alteracao sugerida em tabela existente
| Tabela | Alteracao |
|--------|-----------|
| `IPAGTB027_DESPACHO_LOTE` | Novo valor de status: `ERRO_PARCIAL` (mix de sucesso e erro no lote) |

### Tabelas inalteradas
Todas as demais tabelas (TB001-068, TV001-TV003) permanecem sem alteracao.

---

## 9. Pontos em Aberto

| # | Ponto | Responsavel | Prazo |
|---|-------|-------------|-------|
| 1 | Definir valores de `CO_ORIGEM_ERRO` com base nos codigos de erro do lifi | Alinhar com fornecedor | — |
| 2 | Confirmar dado de correlacao que o lifi devolve na fila (`TE_CORRELACAO_ENVIO`) | Alinhar com fornecedor | — |
| 3 | Definir `NU_MAX_TENTATIVA` padrao e se varia por origem de erro | Regra de negocio | — |
| 4 | Confirmar se o pgpb tambem processa linha a linha (mesmo cenario) ou se processa lote inteiro | Alinhar com equipe pgpb | — |
| 5 | Definir se `ERRO_PARCIAL` e suficiente ou se precisa de mais granularidade no status do lote | Regra de negocio | — |
| 6 | Formato do relatorio diario para o fornecedor (campos, ordenacao, agrupamento) | Operacao | — |
