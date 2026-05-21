---
name: cnab240-oracle-modeling
description: >
  Use esta skill sempre que for necessário criar, alterar ou evoluir o modelo de dados Oracle
  para arquivos CNAB240 (padrão FEBRABAN 240 posições). Aplica regras rígidas de nomenclatura
  de tabelas e colunas, normalização 3FN e boas práticas Oracle. Deve ser consultada antes de
  qualquer criação de tabela, coluna, constraint ou script DDL relacionado ao projeto CNAB240/IPAG.
---

# Skill: Modelagem Oracle CNAB240 — Padrão IPAG

## Visão Geral

Esta skill define as regras obrigatórias de nomenclatura, modelagem e documentação para o projeto
de persistência de arquivos CNAB240 (Padrão FEBRABAN 240 posições, versão 10.9) no banco Oracle.
O objetivo é garantir consistência, rastreabilidade e aderência à Terceira Forma Normal (3FN) em
todo o schema.

---

## 1. Nomenclatura de Tabelas

### Padrão
```
IPAGTB[NNN]_[NOME_DESCRITIVO]
```

| Parte | Regra |
|---|---|
| `IPAG` | Prefixo fixo do domínio de negócio (Integração de Pagamentos) |
| `TB` | Indica que é uma tabela |
| `[NNN]` | Número sequencial de 3 dígitos com zero à esquerda (001, 002, ...) |
| `_[NOME]` | Nome descritivo em maiúsculas, palavras separadas por `_`, sem acentos |

### Exemplos válidos
- `IPAGTB001_ARQUIVO`
- `IPAGTB002_CABECALHO_ARQUIVO`
- `IPAGTB015_SEG_A_PAGAMENTO`

### Regras adicionais
- Máximo de 30 caracteres (limite Oracle).
- Sempre em MAIÚSCULAS.
- **Todos os nomes devem estar em português.** Proibido usar palavras em inglês.
  - Correto: `CABECALHO_ARQUIVO`, `RODAPE_LOTE`, `DESPACHO_LOTE`, `CONTEUDO_ENVIADO`.
  - Incorreto: `HEADER_ARQUIVO`, `TRAILER_LOTE`, `DISPATCH_LOTE`, `PAYLOAD_ENVIADO`.
  - Exceções aceitas: siglas técnicas universais (`PIX`, `HTTP`, `URL`, `CLOB`, `CNAB`).
- Sem caracteres especiais além de `_`.
- O número sequencial deve ser único e nunca reutilizado (mesmo se a tabela for excluída).
- Tabelas de domínio/código usam o mesmo prefixo `IPAGTB`, numeradas a partir de 030 (ex: `IPAGTB030_TIPO_CODIGO_BANCO`, `IPAGTB031_TIPO_SERVICO`).

---

## 2. Nomenclatura de Colunas

### Prefixos obrigatórios por tipo semântico

| Prefixo | Tipo semântico | Tipo Oracle recomendado |
|---|---|---|
| `ID` | Identificador interno (PK / FK surrogate) | `NUMBER` |
| `NU` | Número / valor numérico de negócio | `NUMBER(p,s)` |
| `CO` | Código (domínio, classificação, referência) | `VARCHAR2` ou `CHAR` |
| `DH` | Data e/ou hora | `DATE` ou `TIMESTAMP` |
| `NO` | Nome (pessoa, empresa, banco, cidade) | `VARCHAR2` |
| `TE` | Texto livre / descrição / observação | `VARCHAR2` ou `CLOB` |
| `QT` | Quantidade | `NUMBER` |
| `IN` | Indicador / flag (S/N, 0/1) | `CHAR(1)` |
| `SG` | Sigla / abreviação | `VARCHAR2` ou `CHAR` |

### Formato completo
```
[PREFIXO]_[CONTEXTO_DESCRITIVO]
```

O contexto deve ser autoexplicativo e descrever o conteúdo, nunca apenas repetir o prefixo.

### Exemplos válidos
- `ID_ARQUIVO` — chave surrogate do arquivo
- `NU_BANCO_COMPENSACAO` — código do banco na câmara de compensação
- `CO_TIPO_REGISTRO` — código do tipo de registro CNAB
- `DH_GERACAO_ARQUIVO` — data e hora de geração do arquivo
- `NO_EMPRESA` — nome da empresa
- `TE_OCORRENCIA` — texto com código de ocorrência de retorno
- `QT_REGISTRO_LOTE` — quantidade de registro no lote
- `IN_REMESSA_RETORNO` — indicador se o arquivo é de remessa (R) ou retorno (T)

### Regras adicionais
- Máximo de 30 caracteres.
- Sempre em MAIÚSCULAS.
- **Todos os nomes de coluna devem estar no singular.** Correto: `QT_REGISTRO_LOTE`, `TE_OCORRENCIA`. Incorreto: `QT_REGISTROS_LOTE`, `TE_OCORRENCIAS`.
- **Proibido abreviar nomes de colunas.** Usar sempre o nome completo, sem truncar palavras.
  - Correto: `CO_DV_AGENCIA_CONTA_BENEFICIARIO`, `NU_NOSSO_NUMERO_CORRESPONDENTE`, `NU_VALOR_MULTA_PERCENTUAL`.
  - Incorreto: `CO_DV_AGENCIA_CONTA_BENEF`, `NU_NOSSO_NUMERO_CORRESP`, `NU_VALOR_MULTA_PERCENT`.
  - Exceções aceitas: siglas consagradas do domínio bancário (`DV` = Dígito Verificador, `CEP`, `UF`, `IOF`, `CPF`, `CNPJ`, `PIX`, `IR`, `ISS`, `INSS`).
- Colunas de auditoria padrão (obrigatórias em toda tabela):
  - `DH_INCLUSAO DATE NOT NULL` — data/hora de inclusão do registro
  - `DH_ALTERACAO DATE` — data/hora da última alteração
  - `NO_USUARIO_INCLUSAO VARCHAR2(60)` — usuário que incluiu
  - `NO_USUARIO_ALTERACAO VARCHAR2(60)` — usuário que alterou

---

## 3. Nomenclatura de Constraints

### Primary Key
```
[NOME_TABELA]_PK
```
Exemplo: `IPAGTB001_PK`

### Foreign Key
```
[IPAGTB_PAI]_[IPAGTB_FILHA]_FK[NN]
```
Onde:
- `[IPAGTB_PAI]` é a tabela **pai** (referenciada pela FK)
- `[IPAGTB_FILHA]` é a tabela **filha** (que declara a FK)
- `NN` é o número sequencial **por tabela filha** — contador único de todas as FKs declaradas na FILHA, independentemente da tabela pai (01, 02, 03, ...)

Exemplos:
- `IPAGTB001_IPAGTB002_FK01` — primeira (e única) FK da tabela IPAGTB002
- `IPAGTB001_IPAGTB004_FK01` — primeira FK da tabela IPAGTB004 (vinda de IPAGTB001)
- `IPAGTB031_IPAGTB004_FK02` — segunda FK da tabela IPAGTB004 (vinda de IPAGTB031)
- `IPAGTB032_IPAGTB004_FK02` — FK de IPAGTB032 para IPAGTB004 (mesmo número não conflita pois o prefixo PAI difere)
- `IPAGTB007_IPAGTB014_FK01`, `IPAGTB034_IPAGTB014_FK02`, `IPAGTB034_IPAGTB014_FK03`, `IPAGTB034_IPAGTB014_FK04` — múltiplas FKs de IPAGTB034 para IPAGTB014

### Unique Key
```
[NOME_TABELA]_UK[NN]
```
Exemplo: `IPAGTB001_ARQUIVO_UK01`

### Check Constraint
```
[NOME_TABELA]_[COLUNA]_CK[NN]
```
Exemplo: `IPAGTB002_CABECALHO_ARQUIVO_CO_TIPO_REGISTRO_CK01`

### Index
```
[NOME_TABELA]_IDX[NN]
```
Exemplo: `IPAGTB001_ARQUIVO_IDX01`

---

## 4. Normalização — Terceira Forma Normal (3FN)

### Regras obrigatórias
1. **1FN**: Toda coluna deve conter valor atômico. Sem grupos repetidos.
2. **2FN**: Toda coluna não-chave deve depender funcionalmente da chave primária inteira.
3. **3FN**: Toda coluna não-chave deve depender **exclusivamente** da chave primária, sem dependências transitivas.

### Entidades normalizadas do domínio CNAB240
As seguintes entidades são compartilhadas entre vários segmentos e DEVEM ser normalizadas:

| Entidade | Justificativa |
|---|---|
| Arquivo (`IPAGTB001`) | Raiz de todos os registros |
| Cabeçalho/Rodapé do Arquivo | Unicidade por arquivo |
| Lote de Serviço (`IPAGTB004`) | Agrupa segmentos por tipo de serviço |
| Cabeçalho/Rodapé do Lote | Um por lote |
| Dados de Empresa (CNPJ, nome, conta) | Aparecem no Cabeçalho de Arquivo e Cabeçalho de Lote |
| Dados de Banco/Agência/Conta | Reaparecem em múltiplos segmentos |

### Tabelas de lookup/domínio
Criar tabelas de domínio (`IPAGTB030`–`IPAGTB037`) para:
- Tipos de registro (0,1,2,3,4,5,9)
- Tipos de serviço
- Tipos de operação
- Tipos de movimento
- Tipos de inscrição (CPF=1, CNPJ=2)
- Tipos de moeda

---

## 5. Comentários e Documentação

### Obrigatório para TODA tabela
```sql
COMMENT ON TABLE IPAGTB001_ARQUIVO IS
  'Representa um arquivo CNAB240 recebido ou enviado. Cada registro corresponde a um '
  'arquivo físico no padrão FEBRABAN 240 posições. É a entidade raiz da hierarquia '
  'Arquivo > Lote > Detalhe > Segmento.';
```

### Obrigatório para TODA coluna
TODAS DAS COLUNAS E TABELAS DEVEM TER O NOME NO SINGULAR
```sql
COMMENT ON COLUMN IPAGTB001_ARQUIVO.ID_ARQUIVO IS
  'Identificador surrogate gerado por sequence Oracle. Chave primária interna. '
  'Não possui significado de negócio.';

COMMENT ON COLUMN IPAGTB001_ARQUIVO.NO_NOME_ARQUIVO IS
  'Nome físico do arquivo CNAB240 recebido/gerado, incluindo extensão. '
  'Exemplo: PAGAMENTOS_20241001.REM';
```

### Padrão de comentário
- Sempre em português.
- Mínimo de 2 frases: (1) o que é; (2) para que serve / como é usado.
- Incluir exemplos de valores quando relevante.
- Referenciar o campo CNAB de origem quando aplicável (ex: "Campo G001 do CNAB240").

### Classificação de dados pessoais — Tag `[DADO_PESSOAL]`

Toda coluna que armazene **CPF, CNPJ ou outro número de identificação de pessoa física/jurídica** deve
ser marcada com a tag `[DADO_PESSOAL]` para permitir rastreabilidade e conformidade com LGPD.

#### Como aplicar

**No DDL Oracle (COMMENT ON COLUMN):**
Prefixar o texto do comentário com `[DADO_PESSOAL]`:
```sql
COMMENT ON COLUMN IPAGTB021_DET_DADOS_SACADO.NU_INSCRICAO_SACADO IS
  '[DADO_PESSOAL] Numero de inscricao (CPF/CNPJ) do pagador. Campo 09.3Q (G006).';
```

**No DDL Visual Paradigm (comentário inline):**
Adicionar `-- [DADO_PESSOAL]` ao final da definição da coluna:
```sql
NU_INSCRICAO_SACADO        VARCHAR2(15),  -- [DADO_PESSOAL]
```

#### Colunas que DEVEM receber a tag
| Padrão de nome | Conteúdo |
|---|---|
| `NU_INSCRICAO_*` | CPF ou CNPJ de pessoa/empresa |
| `NU_IDENTIFICACAO_CONTRIBUINTE` | CPF/CNPJ/RENAVAM do contribuinte |
| `TE_CHAVE_PAGAMENTO_PIX` | Chave PIX (pode conter CPF, celular ou e-mail) |

#### Consulta para listar colunas sensíveis no Oracle
```sql
SELECT table_name, column_name, comments
  FROM user_col_comments
 WHERE comments LIKE '%[DADO_PESSOAL]%'
 ORDER BY table_name, column_name;
```

---

## 6. Sequences e PKs

- Toda tabela deve ter PK surrogate via `NUMBER` + `SEQUENCE` Oracle.
- Nome da sequence: `[NOME_TABELA]_SQ`
  - Exemplo: `IPAGTB001_ARQUIVO_SQ`
- Usar `DEFAULT ON NULL [SEQUENCE].NEXTVAL` no Oracle 12c+.
- Nunca usar como PK campos de negócio (código de banco, CNPJ, etc.).

---

## 7. Tipos de Dados Oracle Recomendados

| Conteúdo CNAB | Tipo Oracle |
|---|---|
| Campo Numérico (Num) | `NUMBER(precisão, decimais)` |
| Campo Alfanumérico (Alfa) | `VARCHAR2(tamanho)` |
| Data DDMMAAAA | `DATE` (armazenar convertida) |
| Hora HHMMSS | `DATE` ou `VARCHAR2(6)` |
| Valor monetário (2 decimais) | `NUMBER(15,2)` |
| Quantidade de moeda (5 decimais) | `NUMBER(15,5)` |
| Indicadores (S/N) | `CHAR(1)` |
| Textos longos | `VARCHAR2(4000)` ou `CLOB` |

---

## 8. Hierarquia de Tabelas CNAB240

```
IPAGTB001_ARQUIVO
  └─ IPAGTB002_CABECALHO_ARQUIVO (1:1 com Arquivo)
  └─ IPAGTB003_RODAPE_ARQUIVO    (1:1 com Arquivo)
  └─ IPAGTB004_LOTE              (1:N com Arquivo)
       └─ IPAGTB005_CABECALHO_LOTE  (1:1 com Lote)
       └─ IPAGTB006_RODAPE_LOTE     (1:1 com Lote)
       └─ IPAGTB007_DETALHE_REG     (1:N com Lote — agrupa segmentos de um mesmo registro)
            └─ IPAGTB010_SEG_A      (0:1 com Detalhe)
            └─ IPAGTB011_SEG_B      ...
            └─ ...
```

---

## 9. Checklist antes de criar/alterar tabela

- [ ] Nome segue padrão `IPAGTB[NNN]_NOME`?
- [ ] Número sequencial único e disponível?
- [ ] Todas as colunas com prefixo correto?
- [ ] PK surrogate com sequence?
- [ ] FKs com nomenclatura correta?
- [ ] COMMENT ON TABLE criado?
- [ ] COMMENT ON COLUMN criado para cada coluna?
- [ ] Colunas de auditoria incluídas?
- [ ] 3FN verificada (sem dependências transitivas)?
- [ ] Campos de negócio CNAB mapeados com referência ao campo original (ex: G001, G002)?

---

## 10. Serviços/Produtos CNAB240 e seus Segmentos

| Serviço/Produto | Segmentos Remessa | Segmentos Retorno |
|---|---|---|
| Pagamento (Crédito, DOC, TED, Pix) | A, B, C | A, B, C |
| Pagamento Títulos Cobrança / QR Pix | J, J-52, J-52Pix | J, J-52, J-52Pix |
| Pagamento Tributos (com CB) | O, W, Z, B | O, W, Z, B |
| Pagamento Tributos (sem CB) | N, W, Z, B | N, W, Z, B |
| Cobrança (Títulos) | P, Q, R, S, Y | T, U, Y |
| Boleto Eletrônico | — | G, H, Y |
| Alegação do Pagador | Y | Y |
| Extrato Conciliação | — | E |
| Débito em Conta | A, B, C | A, B, C |
| Vendor | K, L | K, M, N |
| Custódia de Cheques | D | D |
| Extrato Gestão de Caixa | — | F, I |
| Empréstimo Consignação | H | H |
| Compror | A, B, C, I (ou J) | A, B, C, I (ou J) |

---

## 11. Evolução do Modelo

Ao adicionar novos segmentos ou campos:
1. Verificar se o campo já existe em tabela compartilhada.
2. Atribuir número sequencial ao final da série.
3. Jamais renomear tabelas/colunas existentes — criar nova versão se necessário.
4. Sempre adicionar `COMMENT ON` nos novos objetos.
5. Registrar a alteração no histórico de versões do projeto.
