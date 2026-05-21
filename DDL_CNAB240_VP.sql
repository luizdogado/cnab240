-- =============================================================================
-- PROJETO    : IPAG - Integracao de Pagamentos
-- SCHEMA     : CNAB240 / FEBRABAN 240 posicoes V10.9
-- BANCO      : Oracle 12c+ (formato Visual Paradigm)
-- PADRAO     : SKILL_CNAB240_ORACLE / IPAGTB[NNN] / 3FN
-- DATA       : 2026-05-18
-- ATENCAO    : Arquivo gerado para importacao no Visual Paradigm.
--              Sequences, comentarios e DMLs foram removidos.
--              DEFAULT ON NULL e DEFAULT SYSDATE foram removidos (VP nao suporta).
-- =============================================================================

-- =============================================================================
-- PROJETO    : IPAG - Integracao de Pagamentos
-- SCHEMA     : CNAB240 / FEBRABAN 240 posicoes V10.9
-- BANCO      : Oracle 12c+
-- PADRAO     : SKILL_CNAB240_ORACLE / IPAGTB[NNN] / 3FN
-- DATA       : 2026-05-18
-- =============================================================================

-- =============================================================================
-- SECAO 1: TABELAS DE DOMINIO (IPAGTD)
-- =============================================================================

-- ----------------------------------------------------------------------------
-- IPAGTB030_TIPO_REGISTRO
-- ----------------------------------------------------------------------------

CREATE TABLE IPAGTB030_TIPO_REGISTRO (
    ID_TIPO_REGISTRO       NUMBER,
    CO_TIPO_REGISTRO       CHAR(1)         NOT NULL,
    NO_TIPO_REGISTRO       VARCHAR2(60)    NOT NULL,
    DH_INCLUSAO            DATE NOT NULL,
    DH_ALTERACAO           DATE,
    NO_USUARIO_INCLUSAO    VARCHAR2(60)    NOT NULL,
    NO_USUARIO_ALTERACAO   VARCHAR2(60),
    CONSTRAINT IPAGTB030_TIPO_REGISTRO_PK   PRIMARY KEY (ID_TIPO_REGISTRO),
    CONSTRAINT IPAGTB030_TIPO_REGISTRO_UK01 UNIQUE (CO_TIPO_REGISTRO)
);

-- ----------------------------------------------------------------------------
-- IPAGTB031_TIPO_SERVICO
-- ----------------------------------------------------------------------------

CREATE TABLE IPAGTB031_TIPO_SERVICO (
    ID_TIPO_SERVICO        NUMBER,
    CO_TIPO_SERVICO        CHAR(2)         NOT NULL,
    NO_TIPO_SERVICO        VARCHAR2(80)    NOT NULL,
    ID_SERVICO_DESTINO     NUMBER,
    DH_INCLUSAO            DATE NOT NULL,
    DH_ALTERACAO           DATE,
    NO_USUARIO_INCLUSAO    VARCHAR2(60)    NOT NULL,
    NO_USUARIO_ALTERACAO   VARCHAR2(60),
    CONSTRAINT IPAGTB031_TIPO_SERVICO_PK   PRIMARY KEY (ID_TIPO_SERVICO),
    CONSTRAINT IPAGTB031_TIPO_SERVICO_UK01 UNIQUE (CO_TIPO_SERVICO)
);

-- ----------------------------------------------------------------------------
-- IPAGTB032_TIPO_OPERACAO
-- ----------------------------------------------------------------------------

CREATE TABLE IPAGTB032_TIPO_OPERACAO (
    ID_TIPO_OPERACAO       NUMBER,
    CO_TIPO_OPERACAO       CHAR(1)         NOT NULL,
    NO_TIPO_OPERACAO       VARCHAR2(60)    NOT NULL,
    DH_INCLUSAO            DATE NOT NULL,
    DH_ALTERACAO           DATE,
    NO_USUARIO_INCLUSAO    VARCHAR2(60)    NOT NULL,
    NO_USUARIO_ALTERACAO   VARCHAR2(60),
    CONSTRAINT IPAGTB032_TIPO_OPERACAO_PK   PRIMARY KEY (ID_TIPO_OPERACAO),
    CONSTRAINT IPAGTB032_TIPO_OPERACAO_UK01 UNIQUE (CO_TIPO_OPERACAO)
);

-- ----------------------------------------------------------------------------
-- IPAGTB033_TIPO_MOVIMENTO
-- ----------------------------------------------------------------------------

CREATE TABLE IPAGTB033_TIPO_MOVIMENTO (
    ID_TIPO_MOVIMENTO      NUMBER,
    CO_TIPO_MOVIMENTO      CHAR(1)         NOT NULL,
    NO_TIPO_MOVIMENTO      VARCHAR2(80)    NOT NULL,
    DH_INCLUSAO            DATE NOT NULL,
    DH_ALTERACAO           DATE,
    NO_USUARIO_INCLUSAO    VARCHAR2(60)    NOT NULL,
    NO_USUARIO_ALTERACAO   VARCHAR2(60),
    CONSTRAINT IPAGTB033_TIPO_MOVIMENTO_PK   PRIMARY KEY (ID_TIPO_MOVIMENTO),
    CONSTRAINT IPAGTB033_TIPO_MOVIMENTO_UK01 UNIQUE (CO_TIPO_MOVIMENTO)
);

-- ----------------------------------------------------------------------------
-- IPAGTB034_TIPO_INSCRICAO
-- ----------------------------------------------------------------------------

CREATE TABLE IPAGTB034_TIPO_INSCRICAO (
    ID_TIPO_INSCRICAO      NUMBER,
    CO_TIPO_INSCRICAO      CHAR(1)         NOT NULL,
    NO_TIPO_INSCRICAO      VARCHAR2(60)    NOT NULL,
    DH_INCLUSAO            DATE NOT NULL,
    DH_ALTERACAO           DATE,
    NO_USUARIO_INCLUSAO    VARCHAR2(60)    NOT NULL,
    NO_USUARIO_ALTERACAO   VARCHAR2(60),
    CONSTRAINT IPAGTB034_TIPO_INSCRICAO_PK   PRIMARY KEY (ID_TIPO_INSCRICAO),
    CONSTRAINT IPAGTB034_TIPO_INSCRICAO_UK01 UNIQUE (CO_TIPO_INSCRICAO)
);

-- ----------------------------------------------------------------------------
-- IPAGTB035_TIPO_MOEDA
-- ----------------------------------------------------------------------------

CREATE TABLE IPAGTB035_TIPO_MOEDA (
    ID_TIPO_MOEDA          NUMBER,
    CO_TIPO_MOEDA          VARCHAR2(3)     NOT NULL,
    NO_TIPO_MOEDA          VARCHAR2(60)    NOT NULL,
    DH_INCLUSAO            DATE NOT NULL,
    DH_ALTERACAO           DATE,
    NO_USUARIO_INCLUSAO    VARCHAR2(60)    NOT NULL,
    NO_USUARIO_ALTERACAO   VARCHAR2(60),
    CONSTRAINT IPAGTB035_TIPO_MOEDA_PK   PRIMARY KEY (ID_TIPO_MOEDA),
    CONSTRAINT IPAGTB035_TIPO_MOEDA_UK01 UNIQUE (CO_TIPO_MOEDA)
);

-- ----------------------------------------------------------------------------
-- IPAGTB036_CAMARA_CENTRAL
-- ----------------------------------------------------------------------------

CREATE TABLE IPAGTB036_CAMARA_CENTRAL (
    ID_CAMARA_CENTRALIZADORA   NUMBER,
    NU_CAMARA_CENTRALIZADORA   CHAR(3)       NOT NULL,
    NO_CAMARA_CENTRALIZADORA   VARCHAR2(80)  NOT NULL,
    DH_INCLUSAO                DATE NOT NULL,
    DH_ALTERACAO               DATE,
    NO_USUARIO_INCLUSAO        VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO       VARCHAR2(60),
    CONSTRAINT IPAGTB036_CAMARA_CENTRAL_PK   PRIMARY KEY (ID_CAMARA_CENTRALIZADORA),
    CONSTRAINT IPAGTB036_CAMARA_CENTRAL_UK01 UNIQUE (NU_CAMARA_CENTRALIZADORA)
);

-- =============================================================================
-- SECAO 2: DADOS DE DOMINIO (INSERTs)
-- =============================================================================

-- =============================================================================
-- SECAO 3: ENTIDADE RAIZ
-- =============================================================================

-- ----------------------------------------------------------------------------
-- IPAGTB001_ARQUIVO - Entidade raiz de todo arquivo CNAB240
-- ----------------------------------------------------------------------------

CREATE TABLE IPAGTB001_ARQUIVO (
    ID_ARQUIVO             NUMBER,
    NO_NOME_ARQUIVO        VARCHAR2(200)   NOT NULL,
    TE_CAMINHO_ARQUIVO     VARCHAR2(500)   NOT NULL,
    CO_REMESSA_RETORNO     CHAR(1)         NOT NULL,
    DH_GERACAO_ARQUIVO     DATE,
    NU_SEQUENCIAL_ARQUIVO  NUMBER(6)       NOT NULL,
    NU_BANCO_COMPENSACAO   NUMBER(3)       NOT NULL,
    IN_PROCESSADO          CHAR(1) NOT NULL,
    NU_TAMANHO_BYTES       NUMBER(15),
    DH_CARGA              DATE,
    DH_INCLUSAO            DATE NOT NULL,
    DH_ALTERACAO           DATE,
    NO_USUARIO_INCLUSAO    VARCHAR2(60)    NOT NULL,
    NO_USUARIO_ALTERACAO   VARCHAR2(60),
    CONSTRAINT IPAGTB001_ARQUIVO_PK   PRIMARY KEY (ID_ARQUIVO),
    CONSTRAINT IPAGTB001_ARQUIVO_UK01 UNIQUE (NO_NOME_ARQUIVO, NU_BANCO_COMPENSACAO, DH_GERACAO_ARQUIVO),
    CONSTRAINT IPAGTB001_ARQUIVO_CO_REMESSA_RETORNO_CK01
        CHECK (CO_REMESSA_RETORNO IN ('1','2')),
    CONSTRAINT IPAGTB001_ARQUIVO_IN_PROCESSADO_CK01
        CHECK (IN_PROCESSADO IN ('S','N'))
);

-- ----------------------------------------------------------------------------
-- IPAGTB002_CABECALHO_ARQUIVO - Registro tipo 0, 1:1 com IPAGTB001
-- ----------------------------------------------------------------------------

CREATE TABLE IPAGTB002_CABECALHO_ARQUIVO (
    ID_CABECALHO_ARQUIVO          NUMBER,
    ID_ARQUIVO                 NUMBER        NOT NULL,
    -- G001: posicoes 1-3
    NU_BANCO_COMPENSACAO       NUMBER(3)     NOT NULL,
    -- G005: posicao 18
    CO_TIPO_INSCRICAO_EMPRESA  CHAR(1)       NOT NULL,
    -- G006: posicoes 19-32
    NU_INSCRICAO_EMPRESA       VARCHAR2(14)  NOT NULL,  -- [DADO_PESSOAL]
    -- G007: posicoes 33-52
    CO_CONVENIO_BANCO          VARCHAR2(20),
    -- G008: posicoes 53-57
    NU_AGENCIA_EMPRESA         NUMBER(5)     NOT NULL,
    -- G009: posicao 58
    CO_DV_AGENCIA_EMPRESA      CHAR(1),
    -- G010: posicoes 59-70
    NU_CONTA_CORRENTE_EMPRESA  VARCHAR2(12)  NOT NULL,
    -- G011: posicao 71
    CO_DV_CONTA_EMPRESA        CHAR(1),
    -- G012: posicao 72
    CO_DV_AGENCIA_CONTA        CHAR(1),
    -- G013: posicoes 73-102
    NO_EMPRESA                 VARCHAR2(30)  NOT NULL,
    -- G014: posicoes 103-132
    NO_BANCO                   VARCHAR2(30)  NOT NULL,
    -- G015: posicao 143
    CO_REMESSA_RETORNO         CHAR(1)       NOT NULL,
    -- G016+G017: posicoes 144-157 (data+hora unificadas)
    DH_GERACAO_ARQUIVO         DATE          NOT NULL,
    -- G018: posicoes 158-163
    NU_SEQUENCIAL_ARQUIVO      NUMBER(6)     NOT NULL,
    -- G019: posicoes 164-166
    NU_VERSAO_LAYOUT_ARQUIVO   NUMBER(3)     NOT NULL,
    -- G020: posicoes 167-171
    NU_DENSIDADE_GRAVACAO      NUMBER(5),
    -- G021: posicoes 172-191
    TE_RESERVADO_BANCO         VARCHAR2(20),
    -- G022: posicoes 192-211
    TE_RESERVADO_EMPRESA       VARCHAR2(20),
    DH_INCLUSAO                DATE NOT NULL,
    DH_ALTERACAO               DATE,
    NO_USUARIO_INCLUSAO        VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO       VARCHAR2(60),
    ID_TIPO_INSCRICAO          NUMBER,
    CONSTRAINT IPAGTB002_CABECALHO_ARQUIVO_PK   PRIMARY KEY (ID_CABECALHO_ARQUIVO),
    CONSTRAINT IPAGTB002_CABECALHO_ARQUIVO_UK01 UNIQUE (ID_ARQUIVO),
    CONSTRAINT IPAGTB001_IPAGTB002_FK01
        FOREIGN KEY (ID_ARQUIVO) REFERENCES IPAGTB001_ARQUIVO (ID_ARQUIVO),
    CONSTRAINT IPAGTB034_IPAGTB002_FK02
        FOREIGN KEY (ID_TIPO_INSCRICAO) REFERENCES IPAGTB034_TIPO_INSCRICAO (ID_TIPO_INSCRICAO),
    CONSTRAINT IPAGTB002_CABECALHO_ARQUIVO_CO_TIPO_INSC_CK01
        CHECK (CO_TIPO_INSCRICAO_EMPRESA IN ('0','1','2','3','9')),
    CONSTRAINT IPAGTB002_CABECALHO_ARQUIVO_CO_REMESSA_CK01
        CHECK (CO_REMESSA_RETORNO IN ('1','2'))
);

-- ----------------------------------------------------------------------------
-- IPAGTB003_RODAPE_ARQUIVO - Registro tipo 9, 1:1 com IPAGTB001
-- ----------------------------------------------------------------------------

CREATE TABLE IPAGTB003_RODAPE_ARQUIVO (
    ID_RODAPE_ARQUIVO         NUMBER,
    ID_ARQUIVO                 NUMBER        NOT NULL,
    -- G001: posicoes 1-3
    NU_BANCO_COMPENSACAO       NUMBER(3)     NOT NULL,
    -- G049: posicoes 18-23
    QT_LOTE_ARQUIVO           NUMBER(6)     NOT NULL,
    -- G056: posicoes 24-29
    QT_REGISTRO_ARQUIVO       NUMBER(6)     NOT NULL,
    -- G037: posicoes 30-35 (Qtde de contas para conciliacao)
    QT_CONTAS_CONCILIACAO      NUMBER(6),
    DH_INCLUSAO                DATE NOT NULL,
    DH_ALTERACAO               DATE,
    NO_USUARIO_INCLUSAO        VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO       VARCHAR2(60),
    CONSTRAINT IPAGTB003_RODAPE_ARQUIVO_PK   PRIMARY KEY (ID_RODAPE_ARQUIVO),
    CONSTRAINT IPAGTB003_RODAPE_ARQUIVO_UK01 UNIQUE (ID_ARQUIVO),
    CONSTRAINT IPAGTB001_IPAGTB003_FK01
        FOREIGN KEY (ID_ARQUIVO) REFERENCES IPAGTB001_ARQUIVO (ID_ARQUIVO)
);

-- =============================================================================
-- SECAO 4: LOTE
-- =============================================================================

-- ----------------------------------------------------------------------------
-- IPAGTB004_LOTE - Agrupador de servico/produto, 1:N com IPAGTB001
-- ----------------------------------------------------------------------------

CREATE TABLE IPAGTB004_LOTE (
    ID_LOTE                    NUMBER,
    ID_ARQUIVO                 NUMBER        NOT NULL,
    -- G002: numero do lote dentro do arquivo
    NU_NUMERO_LOTE             NUMBER(4)     NOT NULL,
    -- G028: posicao 9 do cabecalho lote
    CO_TIPO_OPERACAO           CHAR(1)       NOT NULL,
    -- G025: posicoes 10-11
    CO_TIPO_SERVICO            CHAR(2)       NOT NULL,
    -- G029: posicoes 12-13
    NU_FORMA_LANCAMENTO        NUMBER(2),
    -- G030: posicoes 14-16
    NU_VERSAO_LAYOUT_LOTE      NUMBER(3),
    DH_INCLUSAO                DATE NOT NULL,
    DH_ALTERACAO               DATE,
    NO_USUARIO_INCLUSAO        VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO       VARCHAR2(60),
    ID_TIPO_SERVICO            NUMBER,
    ID_TIPO_OPERACAO           NUMBER,
    CONSTRAINT IPAGTB004_LOTE_PK   PRIMARY KEY (ID_LOTE),
    CONSTRAINT IPAGTB004_LOTE_UK01 UNIQUE (ID_ARQUIVO, NU_NUMERO_LOTE),
    CONSTRAINT IPAGTB001_IPAGTB004_FK01
        FOREIGN KEY (ID_ARQUIVO) REFERENCES IPAGTB001_ARQUIVO (ID_ARQUIVO),
    CONSTRAINT IPAGTB031_IPAGTB004_FK02
        FOREIGN KEY (ID_TIPO_SERVICO) REFERENCES IPAGTB031_TIPO_SERVICO (ID_TIPO_SERVICO),
    CONSTRAINT IPAGTB032_IPAGTB004_FK02
        FOREIGN KEY (ID_TIPO_OPERACAO) REFERENCES IPAGTB032_TIPO_OPERACAO (ID_TIPO_OPERACAO),
    CONSTRAINT IPAGTB004_LOTE_CO_TIPO_OPERACAO_CK01
        CHECK (CO_TIPO_OPERACAO IN ('C','D','E','G','I','R','T'))
);

-- ----------------------------------------------------------------------------
-- IPAGTB005_CABECALHO_LOTE - Registro tipo 1, 1:1 com IPAGTB004
-- ----------------------------------------------------------------------------

CREATE TABLE IPAGTB005_CABECALHO_LOTE (
    ID_CABECALHO_LOTE             NUMBER,
    ID_LOTE                    NUMBER        NOT NULL,
    -- G001
    NU_BANCO_COMPENSACAO       NUMBER(3)     NOT NULL,
    -- Empresa
    CO_TIPO_INSCRICAO_EMPRESA  CHAR(1)       NOT NULL,
    NU_INSCRICAO_EMPRESA       VARCHAR2(14)  NOT NULL,  -- [DADO_PESSOAL]
    CO_CONVENIO_BANCO          VARCHAR2(20),
    NU_AGENCIA_EMPRESA         NUMBER(5)     NOT NULL,
    CO_DV_AGENCIA_EMPRESA      CHAR(1),
    NU_CONTA_CORRENTE_EMPRESA  VARCHAR2(12)  NOT NULL,
    CO_DV_CONTA_EMPRESA        CHAR(1),
    CO_DV_AGENCIA_CONTA        CHAR(1),
    NO_EMPRESA                 VARCHAR2(30)  NOT NULL,
    -- G031: posicoes 103-142 (mensagem/finalidade do lote)
    TE_MENSAGEM_LOTE           VARCHAR2(40),
    -- Endereco da empresa G032-G036
    NO_LOGRADOURO_EMPRESA      VARCHAR2(30),
    NU_LOCAL_EMPRESA           NUMBER(5),
    TE_COMPLEMENTO_EMPRESA     VARCHAR2(15),
    NO_CIDADE_EMPRESA          VARCHAR2(20),
    NU_CEP_EMPRESA             NUMBER(5),
    CO_COMPLEMENTO_CEP         CHAR(3),
    SG_ESTADO_EMPRESA          CHAR(2),
    -- P014: posicoes 223-224 (indicativo forma pagamento)
    NU_INDICATIVO_FORMA_PAGTO  NUMBER(2),
    -- G059: posicoes 231-240 (ocorrencias retorno)
    TE_OCORRENCIA             CHAR(10),
    DH_INCLUSAO                DATE NOT NULL,
    DH_ALTERACAO               DATE,
    NO_USUARIO_INCLUSAO        VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO       VARCHAR2(60),
    ID_TIPO_INSCRICAO          NUMBER,
    CONSTRAINT IPAGTB005_CABECALHO_LOTE_PK   PRIMARY KEY (ID_CABECALHO_LOTE),
    CONSTRAINT IPAGTB005_CABECALHO_LOTE_UK01 UNIQUE (ID_LOTE),
    CONSTRAINT IPAGTB004_IPAGTB005_FK01
        FOREIGN KEY (ID_LOTE) REFERENCES IPAGTB004_LOTE (ID_LOTE),
    CONSTRAINT IPAGTB034_IPAGTB005_FK02
        FOREIGN KEY (ID_TIPO_INSCRICAO) REFERENCES IPAGTB034_TIPO_INSCRICAO (ID_TIPO_INSCRICAO),
    CONSTRAINT IPAGTB005_CABECALHO_LOTE_CO_TIPO_INSC_CK01
        CHECK (CO_TIPO_INSCRICAO_EMPRESA IN ('0','1','2','3','9'))
);

-- ----------------------------------------------------------------------------
-- IPAGTB006_RODAPE_LOTE - Registro tipo 5, 1:1 com IPAGTB004
-- ----------------------------------------------------------------------------

CREATE TABLE IPAGTB006_RODAPE_LOTE (
    ID_RODAPE_LOTE            NUMBER,
    ID_LOTE                    NUMBER          NOT NULL,
    NU_BANCO_COMPENSACAO       NUMBER(3)       NOT NULL,
    -- G057: posicoes 18-23
    QT_REGISTRO_LOTE          NUMBER(6)       NOT NULL,
    -- somatoria de valores: posicoes 24-41 (16,2)
    NU_SOMATORIA_VALOR       NUMBER(16,2),
    -- G058: posicoes 42-59 (13,5)
    NU_SOMATORIA_QTDE_MOEDA    NUMBER(13,5),
    -- G066: posicoes 60-65
    NU_NUMERO_AVISO_DEBITO     NUMBER(6),
    -- G059: posicoes 231-240
    TE_OCORRENCIA             CHAR(10),
    DH_INCLUSAO                DATE NOT NULL,
    DH_ALTERACAO               DATE,
    NO_USUARIO_INCLUSAO        VARCHAR2(60)    NOT NULL,
    NO_USUARIO_ALTERACAO       VARCHAR2(60),
    CONSTRAINT IPAGTB006_RODAPE_LOTE_PK   PRIMARY KEY (ID_RODAPE_LOTE),
    CONSTRAINT IPAGTB006_RODAPE_LOTE_UK01 UNIQUE (ID_LOTE),
    CONSTRAINT IPAGTB004_IPAGTB006_FK01
        FOREIGN KEY (ID_LOTE) REFERENCES IPAGTB004_LOTE (ID_LOTE)
);

-- =============================================================================
-- SECAO 5: DETALHE (agrupador de segmentos de um mesmo registro)
-- =============================================================================

-- ----------------------------------------------------------------------------
-- IPAGTB007_DETALHE_REG - Registro tipo 3, 1:N com IPAGTB004
-- ----------------------------------------------------------------------------

CREATE TABLE IPAGTB007_DETALHE_REG (
    ID_DETALHE_REG             NUMBER,
    ID_LOTE                    NUMBER        NOT NULL,
    -- G038: posicoes 9-13 (numero sequencial do registro no lote)
    NU_SEQUENCIAL_REGISTRO     NUMBER(5)     NOT NULL,
    -- G039: posicao 14 (segmento principal do registro: A, B, J, N, O, P, etc.)
    CO_SEGMENTO_PRINCIPAL      CHAR(1)       NOT NULL,
    -- G060: posicao 15
    CO_TIPO_MOVIMENTO          CHAR(1)       NOT NULL,
    -- G061: posicoes 16-17
    NU_CODIGO_INSTRUCAO_MOV    NUMBER(2),
    DH_INCLUSAO                DATE NOT NULL,
    DH_ALTERACAO               DATE,
    NO_USUARIO_INCLUSAO        VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO       VARCHAR2(60),
    ID_TIPO_MOVIMENTO          NUMBER,
    CONSTRAINT IPAGTB007_DETALHE_REG_PK   PRIMARY KEY (ID_DETALHE_REG),
    CONSTRAINT IPAGTB007_DETALHE_REG_UK01 UNIQUE (ID_LOTE, NU_SEQUENCIAL_REGISTRO),
    CONSTRAINT IPAGTB004_IPAGTB007_FK01
        FOREIGN KEY (ID_LOTE) REFERENCES IPAGTB004_LOTE (ID_LOTE),
    CONSTRAINT IPAGTB033_IPAGTB007_FK02
        FOREIGN KEY (ID_TIPO_MOVIMENTO) REFERENCES IPAGTB033_TIPO_MOVIMENTO (ID_TIPO_MOVIMENTO)
);

-- =============================================================================
-- SECAO 6: SEGMENTOS DE PAGAMENTO (Credito/Debito/TED/DOC/PIX)
-- =============================================================================

-- ----------------------------------------------------------------------------
-- IPAGTB010_DET_PAGAMENTO - Segmento A (Obrigatorio - Remessa/Retorno)
--   Pagamento por Credito CC, DOC, TED, PIX
--   Ref: pagina 25 do Layout CNAB240 V10.9
-- ----------------------------------------------------------------------------

CREATE TABLE IPAGTB010_DET_PAGAMENTO (
    ID_SEG_A                   NUMBER,
    ID_DETALHE_REG             NUMBER          NOT NULL,
    NU_CAMARA_CENTRALIZADORA   NUMBER(3)       NOT NULL,
    NU_BANCO_FAVORECIDO        NUMBER(3),
    NU_AGENCIA_FAVORECIDO      NUMBER(5),
    CO_DV_AGENCIA_FAVORECIDO   CHAR(1),
    NU_CONTA_CORRENTE_FAVORECIDO     VARCHAR2(12),
    CO_DV_CONTA_FAVORECIDO     CHAR(1),
    CO_DV_AGENCIA_CONTA_FAVORECIDO   CHAR(1),
    NO_FAVORECIDO              VARCHAR2(30),
    NU_DOCUMENTO_EMPRESA       VARCHAR2(20),
    DH_PAGAMENTO               DATE            NOT NULL,
    CO_TIPO_MOEDA              VARCHAR2(3)     NOT NULL,
    NU_QUANTIDADE_MOEDA        NUMBER(15,5),
    NU_VALOR_PAGAMENTO         NUMBER(15,2)    NOT NULL,
    NU_DOCUMENTO_BANCO         VARCHAR2(20),
    DH_DATA_REAL_EFETIVACAO    DATE,
    NU_VALOR_REAL_EFETIVACAO   NUMBER(15,2),
    TE_OUTRAS_INFORMACOES      VARCHAR2(40),
    CO_FINALIDADE_DOC          VARCHAR2(2),
    CO_FINALIDADE_TED          VARCHAR2(5),
    CO_FINALIDADE_COMPLEMENTAR VARCHAR2(2),
    IN_AVISO_FAVORECIDO        CHAR(1),
    TE_OCORRENCIA             CHAR(10),
    DH_INCLUSAO                DATE NOT NULL,
    DH_ALTERACAO               DATE,
    NO_USUARIO_INCLUSAO        VARCHAR2(60)    NOT NULL,
    NO_USUARIO_ALTERACAO       VARCHAR2(60),
    ID_TIPO_MOEDA              NUMBER,
    ID_CAMARA_CENTRALIZADORA   NUMBER,
    CONSTRAINT IPAGTB010_DET_PAGAMENTO_PK   PRIMARY KEY (ID_SEG_A),
    CONSTRAINT IPAGTB010_DET_PAGAMENTO_UK01 UNIQUE (ID_DETALHE_REG),
    CONSTRAINT IPAGTB007_IPAGTB010_FK01
        FOREIGN KEY (ID_DETALHE_REG) REFERENCES IPAGTB007_DETALHE_REG (ID_DETALHE_REG),
    CONSTRAINT IPAGTB035_IPAGTB010_FK02
        FOREIGN KEY (ID_TIPO_MOEDA) REFERENCES IPAGTB035_TIPO_MOEDA (ID_TIPO_MOEDA),
    CONSTRAINT IPAGTB036_IPAGTB010_FK03
        FOREIGN KEY (ID_CAMARA_CENTRALIZADORA) REFERENCES IPAGTB036_CAMARA_CENTRAL (ID_CAMARA_CENTRALIZADORA)
);

-- ----------------------------------------------------------------------------
-- IPAGTB011_DET_INFO_FAVORECIDO - Segmento B (Complementar - PIX/Endereco)
--   Ref: pagina 26 do Layout CNAB240 V10.9
-- ----------------------------------------------------------------------------

CREATE TABLE IPAGTB011_DET_INFO_FAVORECIDO (
    ID_SEG_B                    NUMBER,
    ID_DETALHE_REG              NUMBER         NOT NULL,
    CO_IDENTIFICACAO_FAVORECIDO VARCHAR2(3),
    CO_TIPO_INSCRICAO_FAVORECIDO      CHAR(1),
    NU_INSCRICAO_FAVORECIDO     VARCHAR2(14),  -- [DADO_PESSOAL]
    TE_INFORMACAO_10            VARCHAR2(35),
    TE_INFORMACAO_11            VARCHAR2(60),
    TE_INFORMACAO_12            VARCHAR2(99),
    NU_CODIGO_UG_CENTRALIZADORA NUMBER(6),
    NU_CODIGO_ISPB              NUMBER(8),
    DH_INCLUSAO                 DATE NOT NULL,
    DH_ALTERACAO                DATE,
    NO_USUARIO_INCLUSAO         VARCHAR2(60)   NOT NULL,
    NO_USUARIO_ALTERACAO        VARCHAR2(60),
    ID_TIPO_INSCRICAO           NUMBER,
    CONSTRAINT IPAGTB011_DET_INFO_FAVORECIDO_PK   PRIMARY KEY (ID_SEG_B),
    CONSTRAINT IPAGTB011_DET_INFO_FAVORECIDO_UK01 UNIQUE (ID_DETALHE_REG),
    CONSTRAINT IPAGTB007_IPAGTB011_FK01
        FOREIGN KEY (ID_DETALHE_REG) REFERENCES IPAGTB007_DETALHE_REG (ID_DETALHE_REG),
    CONSTRAINT IPAGTB034_IPAGTB011_FK02
        FOREIGN KEY (ID_TIPO_INSCRICAO) REFERENCES IPAGTB034_TIPO_INSCRICAO (ID_TIPO_INSCRICAO)
);

-- ----------------------------------------------------------------------------
-- IPAGTB012_DET_COMPLEMENTAR - Segmento C (Opcional - Deducoes e conta substituta)
--   Ref: pagina 27 do Layout CNAB240 V10.9
-- ----------------------------------------------------------------------------

CREATE TABLE IPAGTB012_DET_COMPLEMENTAR (
    ID_SEG_C                   NUMBER,
    ID_DETALHE_REG             NUMBER          NOT NULL,
    NU_VALOR_IR                NUMBER(15,2),
    NU_VALOR_ISS               NUMBER(15,2),
    NU_VALOR_IOF               NUMBER(15,2),
    NU_VALOR_OUTRAS_DEDUCOES   NUMBER(15,2),
    NU_VALOR_OUTROS_ACRESCIMOS NUMBER(15,2),
    NU_AGENCIA_SUBSTITUTA      NUMBER(5),
    CO_DV_AGENCIA_SUBSTITUTA   CHAR(1),
    NU_CONTA_CORRENTE_SUBSTITUTA    VARCHAR2(12),
    CO_DV_CONTA_SUBSTITUTA     CHAR(1),
    CO_DV_AGENCIA_CONTA_SUBSTITUTA   CHAR(1),
    NU_VALOR_INSS              NUMBER(15,2),
    NU_CONTA_PAGAMENTO_CREDITO  VARCHAR2(20),
    DH_INCLUSAO                DATE NOT NULL,
    DH_ALTERACAO               DATE,
    NO_USUARIO_INCLUSAO        VARCHAR2(60)    NOT NULL,
    NO_USUARIO_ALTERACAO       VARCHAR2(60),
    CONSTRAINT IPAGTB012_DET_COMPLEMENTAR_PK   PRIMARY KEY (ID_SEG_C),
    CONSTRAINT IPAGTB012_DET_COMPLEMENTAR_UK01 UNIQUE (ID_DETALHE_REG),
    CONSTRAINT IPAGTB007_IPAGTB012_FK01
        FOREIGN KEY (ID_DETALHE_REG) REFERENCES IPAGTB007_DETALHE_REG (ID_DETALHE_REG)
);

-- =============================================================================
-- SECAO 7: SEGMENTOS DE PAGAMENTO DE TITULOS E QR CODE PIX
-- =============================================================================

-- ----------------------------------------------------------------------------
-- IPAGTB013_DET_TITULO_COBRANCA - Segmento J (Obrigatorio - Pagamento Titulos/Boleto)
--   Ref: pagina 30 do Layout CNAB240 V10.9
-- ----------------------------------------------------------------------------

CREATE TABLE IPAGTB013_DET_TITULO_COBRANCA (
    ID_SEG_J                     NUMBER,
    ID_DETALHE_REG               NUMBER        NOT NULL,
    NU_CODIGO_BARRAS             VARCHAR2(44)  NOT NULL,
    NO_BENEFICIARIO              VARCHAR2(30),
    DH_VENCIMENTO                DATE,
    NU_VALOR_TITULO              NUMBER(15,2),
    NU_VALOR_DESCONTO_ABATIMENTO NUMBER(15,2),
    NU_VALOR_MORA_MULTA          NUMBER(15,2),
    DH_PAGAMENTO                 DATE          NOT NULL,
    NU_VALOR_PAGAMENTO           NUMBER(15,2)  NOT NULL,
    NU_QUANTIDADE_MOEDA          NUMBER(15,5),
    NU_DOCUMENTO_EMPRESA         VARCHAR2(20),
    NU_DOCUMENTO_BANCO           VARCHAR2(20),
    CO_CODIGO_MOEDA              VARCHAR2(2),
    TE_OCORRENCIA               CHAR(10),
    DH_INCLUSAO                  DATE NOT NULL,
    DH_ALTERACAO                 DATE,
    NO_USUARIO_INCLUSAO          VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO         VARCHAR2(60),
    CONSTRAINT IPAGTB013_DET_TITULO_COBRANCA_PK   PRIMARY KEY (ID_SEG_J),
    CONSTRAINT IPAGTB013_DET_TITULO_COBRANCA_UK01 UNIQUE (ID_DETALHE_REG),
    CONSTRAINT IPAGTB007_IPAGTB013_FK01
        FOREIGN KEY (ID_DETALHE_REG) REFERENCES IPAGTB007_DETALHE_REG (ID_DETALHE_REG)
);

-- ----------------------------------------------------------------------------
-- IPAGTB014_DET_PARTES_TITULO - Segmento J-52 (Pagador/Beneficiario/Sacador)
--   Ref: pagina 31 do Layout CNAB240 V10.9
-- ----------------------------------------------------------------------------

CREATE TABLE IPAGTB014_DET_PARTES_TITULO (
    ID_SEG_J52                 NUMBER,
    ID_DETALHE_REG             NUMBER        NOT NULL,
    CO_IDENTIFICACAO_REG       VARCHAR2(2) NOT NULL,
    CO_TIPO_INSCRICAO_PAGADOR  CHAR(1),
    NU_INSCRICAO_PAGADOR       VARCHAR2(15),  -- [DADO_PESSOAL]
    NO_PAGADOR                 VARCHAR2(40),
    CO_TIPO_INSCRICAO_BENEFICIARIO    CHAR(1),
    NU_INSCRICAO_BENEFICIARIO  VARCHAR2(15),  -- [DADO_PESSOAL]
    NO_BENEFICIARIO            VARCHAR2(40),
    CO_TIPO_INSCRICAO_SACADOR  CHAR(1),
    NU_INSCRICAO_SACADOR       VARCHAR2(15),  -- [DADO_PESSOAL]
    NO_SACADOR                 VARCHAR2(40),
    DH_INCLUSAO                DATE NOT NULL,
    DH_ALTERACAO               DATE,
    NO_USUARIO_INCLUSAO        VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO       VARCHAR2(60),
    ID_TIPO_INSCRICAO_PAGADOR  NUMBER,
    ID_TIPO_INSCRICAO_BENEFICIARIO    NUMBER,
    ID_TIPO_INSCRICAO_SACADOR  NUMBER,
    CONSTRAINT IPAGTB014_DET_PARTES_TITULO_PK   PRIMARY KEY (ID_SEG_J52),
    CONSTRAINT IPAGTB014_DET_PARTES_TITULO_UK01 UNIQUE (ID_DETALHE_REG),
    CONSTRAINT IPAGTB007_IPAGTB014_FK01
        FOREIGN KEY (ID_DETALHE_REG) REFERENCES IPAGTB007_DETALHE_REG (ID_DETALHE_REG),
    CONSTRAINT IPAGTB034_IPAGTB014_FK02
        FOREIGN KEY (ID_TIPO_INSCRICAO_PAGADOR) REFERENCES IPAGTB034_TIPO_INSCRICAO (ID_TIPO_INSCRICAO),
    CONSTRAINT IPAGTB034_IPAGTB014_FK03
        FOREIGN KEY (ID_TIPO_INSCRICAO_BENEFICIARIO) REFERENCES IPAGTB034_TIPO_INSCRICAO (ID_TIPO_INSCRICAO),
    CONSTRAINT IPAGTB034_IPAGTB014_FK04
        FOREIGN KEY (ID_TIPO_INSCRICAO_SACADOR) REFERENCES IPAGTB034_TIPO_INSCRICAO (ID_TIPO_INSCRICAO)
);

-- ----------------------------------------------------------------------------
-- IPAGTB015_DET_PIX_CODIGO_QR - Segmento J-52 PIX (Chave/TXID QR Code)
--   Ref: pagina 32 do Layout CNAB240 V10.9
-- ----------------------------------------------------------------------------

CREATE TABLE IPAGTB015_DET_PIX_CODIGO_QR (
    ID_SEG_J52_PIX             NUMBER,
    ID_DETALHE_REG             NUMBER        NOT NULL,
    CO_IDENTIFICACAO_REG       VARCHAR2(2) NOT NULL,
    CO_TIPO_INSCRICAO_DEVEDOR  CHAR(1),
    NU_INSCRICAO_DEVEDOR       VARCHAR2(15),  -- [DADO_PESSOAL]
    NO_DEVEDOR                 VARCHAR2(40),
    CO_TIPO_INSCRICAO_FAVORECIDO     CHAR(1),
    NU_INSCRICAO_FAVORECIDO    VARCHAR2(15),  -- [DADO_PESSOAL]
    NO_FAVORECIDO              VARCHAR2(40),
    TE_CHAVE_PAGAMENTO_PIX     VARCHAR2(79),  -- [DADO_PESSOAL]
    CO_TXID_CODIGO_QR             VARCHAR2(30),
    DH_INCLUSAO                DATE NOT NULL,
    DH_ALTERACAO               DATE,
    NO_USUARIO_INCLUSAO        VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO       VARCHAR2(60),
    ID_TIPO_INSCRICAO_DEVEDOR  NUMBER,
    ID_TIPO_INSCRICAO_FAVORECIDO     NUMBER,
    CONSTRAINT IPAGTB015_DET_PIX_CODIGO_QR_PK   PRIMARY KEY (ID_SEG_J52_PIX),
    CONSTRAINT IPAGTB015_DET_PIX_CODIGO_QR_UK01 UNIQUE (ID_DETALHE_REG),
    CONSTRAINT IPAGTB007_IPAGTB015_FK01
        FOREIGN KEY (ID_DETALHE_REG) REFERENCES IPAGTB007_DETALHE_REG (ID_DETALHE_REG),
    CONSTRAINT IPAGTB034_IPAGTB015_FK02
        FOREIGN KEY (ID_TIPO_INSCRICAO_DEVEDOR) REFERENCES IPAGTB034_TIPO_INSCRICAO (ID_TIPO_INSCRICAO),
    CONSTRAINT IPAGTB034_IPAGTB015_FK03
        FOREIGN KEY (ID_TIPO_INSCRICAO_FAVORECIDO) REFERENCES IPAGTB034_TIPO_INSCRICAO (ID_TIPO_INSCRICAO)
);

-- =============================================================================
-- SECAO 8: SEGMENTOS DE TRIBUTOS (N, O, W, Z)
-- =============================================================================

-- ----------------------------------------------------------------------------
-- IPAGTB016_DET_TRIBUTO_SEM_CB - Segmento N (Tributos sem Codigo de Barras)
--   Ref: pagina 36 do Layout CNAB240 V10.9
-- ----------------------------------------------------------------------------

CREATE TABLE IPAGTB016_DET_TRIBUTO_SEM_CB (
    ID_SEG_N                     NUMBER,
    ID_DETALHE_REG               NUMBER        NOT NULL,
    NU_DOCUMENTO_EMPRESA         VARCHAR2(20),
    NU_DOCUMENTO_BANCO           VARCHAR2(20),
    NO_CONTRIBUINTE              VARCHAR2(30),
    DH_PAGAMENTO                 DATE          NOT NULL,
    NU_VALOR_TOTAL_PAGAMENTO     NUMBER(15,2)  NOT NULL,
    -- Informacoes complementares variaveis por tipo de tributo (posicoes 111-230)
    CO_RECEITA_TRIBUTO           VARCHAR2(6),
    CO_TIPO_IDENTIFICACAO_CONTRIBUINTE   VARCHAR2(2),
    NU_IDENTIFICACAO_CONTRIBUINTE     VARCHAR2(14),  -- [DADO_PESSOAL]
    CO_IDENTIFICACAO_TRIBUTO     VARCHAR2(2),
    TE_PERIODO_APURACAO          VARCHAR2(8),
    NU_REFERENCIA_TRIBUTO        VARCHAR2(17),
    NU_VALOR_PRINCIPAL           NUMBER(15,2),
    NU_VALOR_MULTA               NUMBER(15,2),
    NU_VALOR_JUROS_ENCARGOS      NUMBER(15,2),
    DH_VENCIMENTO                DATE,
    TE_INFORMACOES_LIVRES        VARCHAR2(120),
    TE_OCORRENCIA               CHAR(10),
    DH_INCLUSAO                  DATE NOT NULL,
    DH_ALTERACAO                 DATE,
    NO_USUARIO_INCLUSAO          VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO         VARCHAR2(60),
    CONSTRAINT IPAGTB016_DET_TRIBUTO_SEM_CB_PK   PRIMARY KEY (ID_SEG_N),
    CONSTRAINT IPAGTB016_DET_TRIBUTO_SEM_CB_UK01 UNIQUE (ID_DETALHE_REG),
    CONSTRAINT IPAGTB007_IPAGTB016_FK01
        FOREIGN KEY (ID_DETALHE_REG) REFERENCES IPAGTB007_DETALHE_REG (ID_DETALHE_REG)
);

-- ----------------------------------------------------------------------------
-- IPAGTB017_DET_TRIBUTO_COM_CB - Segmento O (Tributos com Codigo de Barras)
--   Ref: pagina 35 do Layout CNAB240 V10.9
-- ----------------------------------------------------------------------------

CREATE TABLE IPAGTB017_DET_TRIBUTO_COM_CB (
    ID_SEG_O                   NUMBER,
    ID_DETALHE_REG             NUMBER        NOT NULL,
    NU_CODIGO_BARRAS           VARCHAR2(44)  NOT NULL,
    NO_CONCESSIONARIA          VARCHAR2(30),
    DH_VENCIMENTO              DATE,
    DH_PAGAMENTO               DATE          NOT NULL,
    NU_VALOR_PAGAMENTO         NUMBER(15,2)  NOT NULL,
    NU_DOCUMENTO_EMPRESA       VARCHAR2(20),
    NU_DOCUMENTO_BANCO         VARCHAR2(20),
    TE_OCORRENCIA             CHAR(10),
    DH_INCLUSAO                DATE NOT NULL,
    DH_ALTERACAO               DATE,
    NO_USUARIO_INCLUSAO        VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO       VARCHAR2(60),
    CONSTRAINT IPAGTB017_DET_TRIBUTO_COM_CB_PK   PRIMARY KEY (ID_SEG_O),
    CONSTRAINT IPAGTB017_DET_TRIBUTO_COM_CB_UK01 UNIQUE (ID_DETALHE_REG),
    CONSTRAINT IPAGTB007_IPAGTB017_FK01
        FOREIGN KEY (ID_DETALHE_REG) REFERENCES IPAGTB007_DETALHE_REG (ID_DETALHE_REG)
);

-- ----------------------------------------------------------------------------
-- IPAGTB018_DET_COMPL_TRIBUTO - Segmento W (Informacoes Complementares de Tributo)
--   Ref: pagina 45 do Layout CNAB240 V10.9
-- ----------------------------------------------------------------------------

CREATE TABLE IPAGTB018_DET_COMPL_TRIBUTO (
    ID_SEG_W                     NUMBER,
    ID_DETALHE_REG               NUMBER        NOT NULL,
    NU_COMPLEMENTO_REGISTRO      NUMBER(1),
    CO_IDENTIFICACAO_INFORMACOES CHAR(1),
    TE_INFORMACAO_COMPLEMENTAR_1   VARCHAR2(80),
    TE_INFORMACAO_COMPLEMENTAR_2   VARCHAR2(80),
    CO_IDENTIFICADOR_TRIBUTO     VARCHAR2(2),
    TE_INFORMACAO_TRIBUTO        VARCHAR2(48),
    TE_OCORRENCIA               CHAR(10),
    DH_INCLUSAO                  DATE NOT NULL,
    DH_ALTERACAO                 DATE,
    NO_USUARIO_INCLUSAO          VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO         VARCHAR2(60),
    CONSTRAINT IPAGTB018_DET_COMPL_TRIBUTO_PK   PRIMARY KEY (ID_SEG_W),
    CONSTRAINT IPAGTB018_DET_COMPL_TRIBUTO_UK01 UNIQUE (ID_DETALHE_REG),
    CONSTRAINT IPAGTB007_IPAGTB018_FK01
        FOREIGN KEY (ID_DETALHE_REG) REFERENCES IPAGTB007_DETALHE_REG (ID_DETALHE_REG)
);

-- ----------------------------------------------------------------------------
-- IPAGTB019_DET_IDENT_TRIBUTO - Segmento Z (Autenticacao do Pagamento - Retorno)
--   Ref: pagina 47 do Layout CNAB240 V10.9
-- ----------------------------------------------------------------------------

CREATE TABLE IPAGTB019_DET_IDENT_TRIBUTO (
    ID_SEG_Z                   NUMBER,
    ID_DETALHE_REG             NUMBER        NOT NULL,
    TE_AUTENTICACAO_LEGISLACAO VARCHAR2(64),
    TE_AUTENTICACAO_BANCARIA   VARCHAR2(25),
    TE_OCORRENCIA             CHAR(10),
    DH_INCLUSAO                DATE NOT NULL,
    DH_ALTERACAO               DATE,
    NO_USUARIO_INCLUSAO        VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO       VARCHAR2(60),
    CONSTRAINT IPAGTB019_DET_IDENT_TRIBUTO_PK   PRIMARY KEY (ID_SEG_Z),
    CONSTRAINT IPAGTB019_DET_IDENT_TRIBUTO_UK01 UNIQUE (ID_DETALHE_REG),
    CONSTRAINT IPAGTB007_IPAGTB019_FK01
        FOREIGN KEY (ID_DETALHE_REG) REFERENCES IPAGTB007_DETALHE_REG (ID_DETALHE_REG)
);

-- =============================================================================
-- SECAO 9: SEGMENTOS DE COBRANCA - REMESSA (P, Q, R, S)
-- =============================================================================

-- ----------------------------------------------------------------------------
-- IPAGTB020_DET_DADOS_TITULO - Segmento P (Obrigatorio - Cobranca Remessa - Titulo)
-- ----------------------------------------------------------------------------

CREATE TABLE IPAGTB020_DET_DADOS_TITULO (
    ID_SEG_P                   NUMBER,
    ID_DETALHE_REG             NUMBER        NOT NULL,
    -- Conta do beneficiario (campos 08.3P a 12.3P)
    NU_AGENCIA_BENEFICIARIO    NUMBER(5),
    CO_DV_AGENCIA_BENEFICIARIO        CHAR(1),
    NU_CONTA_BENEFICIARIO      VARCHAR2(12),
    CO_DV_CONTA_BENEFICIARIO          CHAR(1),
    CO_DV_AGENCIA_CONTA_BENEFICIARIO  CHAR(1),
    -- Dados do titulo (campos 13.3P a 26.3P)
    NU_NOSSO_NUMERO            VARCHAR2(20),
    CO_CARTEIRA                CHAR(1),
    CO_FORMA_CADASTRAMENTO     CHAR(1),
    CO_TIPO_DOCUMENTO          CHAR(1),
    CO_EMISSAO_BLOQUETO        CHAR(1),
    CO_DISTRIBUICAO_BLOQUETO   CHAR(1),
    NU_NUMERO_DOCUMENTO        VARCHAR2(15),
    DH_VENCIMENTO              DATE,
    NU_VALOR_NOMINAL           NUMBER(15,2),
    NU_AGENCIA_COBRADORA       NUMBER(5),
    CO_DV_AGENCIA_COBRADORA    CHAR(1),
    CO_ESPECIE_TITULO          VARCHAR2(2),
    IN_ACEITE                  CHAR(1),
    DH_EMISSAO_TITULO          DATE,
    -- Juros de mora (campos 27.3P a 29.3P)
    CO_JUROS_MORA              CHAR(1),
    DH_DATA_JUROS_MORA         DATE,
    NU_VALOR_JUROS_MORA        NUMBER(15,2),
    -- Desconto 1 (campos 30.3P a 32.3P)
    CO_TIPO_DESCONTO_1         CHAR(1),
    DH_DATA_DESCONTO_1         DATE,
    NU_VALOR_DESCONTO_1        NUMBER(15,2),
    -- IOF e abatimento (campos 33.3P e 34.3P)
    NU_VALOR_IOF               NUMBER(15,2),
    NU_VALOR_ABATIMENTO        NUMBER(15,2),
    -- Identificacao e instrucoes (campos 35.3P a 42.3P)
    TE_IDENTIFICACAO_TITULO_EMPRESA VARCHAR2(25),
    CO_PROTESTO                CHAR(1),
    NU_PRAZO_PROTESTO          NUMBER(2),
    CO_BAIXA_DEVOLUCAO         CHAR(1),
    NU_PRAZO_BAIXA_DEVOLUCAO   NUMBER(3),
    CO_MOEDA                   NUMBER(2),
    NU_NUMERO_CONTRATO         VARCHAR2(10),
    CO_USO_LIVRE               CHAR(1),
    -- Ocorrencias retorno
    TE_OCORRENCIA             CHAR(10),
    DH_INCLUSAO                DATE NOT NULL,
    DH_ALTERACAO               DATE,
    NO_USUARIO_INCLUSAO        VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO       VARCHAR2(60),
    CONSTRAINT IPAGTB020_DET_DADOS_TITULO_PK   PRIMARY KEY (ID_SEG_P),
    CONSTRAINT IPAGTB020_DET_DADOS_TITULO_UK01 UNIQUE (ID_DETALHE_REG),
    CONSTRAINT IPAGTB007_IPAGTB020_FK01
        FOREIGN KEY (ID_DETALHE_REG) REFERENCES IPAGTB007_DETALHE_REG (ID_DETALHE_REG)
);

-- ----------------------------------------------------------------------------
-- IPAGTB021_DET_DADOS_SACADO - Segmento Q (Obrigatorio - Cobranca Remessa - Sacador/Pagador)
-- ----------------------------------------------------------------------------

CREATE TABLE IPAGTB021_DET_DADOS_SACADO (
    ID_SEG_Q                   NUMBER,
    ID_DETALHE_REG             NUMBER        NOT NULL,
    CO_TIPO_INSCRICAO_SACADO   CHAR(1),
    NU_INSCRICAO_SACADO        VARCHAR2(15),  -- [DADO_PESSOAL]
    NO_SACADO                  VARCHAR2(40),
    NO_LOGRADOURO_SACADO       VARCHAR2(40),
    NO_BAIRRO_SACADO           VARCHAR2(15),
    NO_CIDADE_SACADO           VARCHAR2(15),
    NO_CEP_SACADO              NUMBER(5),
    CO_COMPLEMENTO_CEP_SACADO  CHAR(3),
    SG_UF_SACADO               CHAR(2),
    CO_TIPO_INSCRICAO_SACADOR  CHAR(1),
    NU_INSCRICAO_SACADOR       VARCHAR2(15),  -- [DADO_PESSOAL]
    NO_SACADOR_AVALISTA        VARCHAR2(40),
    NU_BANCO_CORRESPONDENTE    NUMBER(3),
    NU_NOSSO_NUMERO_CORRESPONDENTE    VARCHAR2(20),
    TE_OCORRENCIA             CHAR(10),
    DH_INCLUSAO                DATE NOT NULL,
    DH_ALTERACAO               DATE,
    NO_USUARIO_INCLUSAO        VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO       VARCHAR2(60),
    ID_TIPO_INSCRICAO_SACADO   NUMBER,
    ID_TIPO_INSCRICAO_SACADOR  NUMBER,
    CONSTRAINT IPAGTB021_DET_DADOS_SACADO_PK   PRIMARY KEY (ID_SEG_Q),
    CONSTRAINT IPAGTB021_DET_DADOS_SACADO_UK01 UNIQUE (ID_DETALHE_REG),
    CONSTRAINT IPAGTB007_IPAGTB021_FK01
        FOREIGN KEY (ID_DETALHE_REG) REFERENCES IPAGTB007_DETALHE_REG (ID_DETALHE_REG),
    CONSTRAINT IPAGTB034_IPAGTB021_FK02
        FOREIGN KEY (ID_TIPO_INSCRICAO_SACADO) REFERENCES IPAGTB034_TIPO_INSCRICAO (ID_TIPO_INSCRICAO),
    CONSTRAINT IPAGTB034_IPAGTB021_FK03
        FOREIGN KEY (ID_TIPO_INSCRICAO_SACADOR) REFERENCES IPAGTB034_TIPO_INSCRICAO (ID_TIPO_INSCRICAO)
);

-- ----------------------------------------------------------------------------
-- IPAGTB022_DET_DESCONTO_TITULO - Segmento R (Opcional - Cobranca Remessa - Descontos/Penalidades)
-- ----------------------------------------------------------------------------

CREATE TABLE IPAGTB022_DET_DESCONTO_TITULO (
    ID_SEG_R                   NUMBER,
    ID_DETALHE_REG             NUMBER        NOT NULL,
    CO_TIPO_DESCONTO_2         CHAR(1),
    DH_DATA_DESCONTO_2         DATE,
    NU_VALOR_DESCONTO_2        NUMBER(15,2),
    CO_TIPO_DESCONTO_3         CHAR(1),
    DH_DATA_DESCONTO_3         DATE,
    NU_VALOR_DESCONTO_3        NUMBER(15,2),
    CO_TIPO_MULTA              CHAR(1),
    DH_DATA_MULTA              DATE,
    NU_VALOR_MULTA_PERCENTUAL     NUMBER(15,2),
    TE_INFORMACAO_PAGADOR      VARCHAR2(10),
    TE_MENSAGEM_3              VARCHAR2(40),
    TE_MENSAGEM_4              VARCHAR2(40),
    CO_OCORRENCIA_PAGADOR      NUMBER(8),
    NU_BANCO_DEBITO            NUMBER(3),
    NU_AGENCIA_DEBITO          NUMBER(5),
    CO_DV_AGENCIA_DEBITO       CHAR(1),
    NU_CONTA_CORRENTE_DEBITO   VARCHAR2(12),
    CO_DV_CONTA_DEBITO         CHAR(1),
    CO_DV_AGENCIA_CONTA_DEBITO    CHAR(1),
    CO_AVISO_DEBITO_AUTOMATICO CHAR(1),
    TE_OCORRENCIA             CHAR(10),
    DH_INCLUSAO                DATE NOT NULL,
    DH_ALTERACAO               DATE,
    NO_USUARIO_INCLUSAO        VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO       VARCHAR2(60),
    CONSTRAINT IPAGTB022_DET_DESCONTO_TITULO_PK   PRIMARY KEY (ID_SEG_R),
    CONSTRAINT IPAGTB022_DET_DESCONTO_TITULO_UK01 UNIQUE (ID_DETALHE_REG),
    CONSTRAINT IPAGTB007_IPAGTB022_FK01
        FOREIGN KEY (ID_DETALHE_REG) REFERENCES IPAGTB007_DETALHE_REG (ID_DETALHE_REG)
);

-- =============================================================================
-- SECAO 10: SEGMENTOS DE COBRANCA - RETORNO (T, U)
-- =============================================================================

-- ----------------------------------------------------------------------------
-- IPAGTB023_DET_RETORNO_TITULO - Segmento T (Obrigatorio - Cobranca Retorno - Titulo)
-- ----------------------------------------------------------------------------

CREATE TABLE IPAGTB023_DET_RETORNO_TITULO (
    ID_SEG_T                   NUMBER,
    ID_DETALHE_REG             NUMBER        NOT NULL,
    NU_AGENCIA_BENEFICIARIO    NUMBER(5),
    CO_DV_AGENCIA_BENEFICIARIO        CHAR(1),
    NU_CONTA_BENEFICIARIO      VARCHAR2(12),
    CO_DV_CONTA_BENEFICIARIO          CHAR(1),
    CO_DV_AGENCIA_CONTA_BENEFICIARIO  CHAR(1),
    NU_NOSSO_NUMERO            VARCHAR2(20),
    CO_CARTEIRA                CHAR(1),
    NU_NUMERO_DOCUMENTO        VARCHAR2(15),
    DH_VENCIMENTO              DATE,
    NU_VALOR_NOMINAL           NUMBER(15,2),
    NU_BANCO_COBRADOR          NUMBER(3),
    NU_AGENCIA_COBRADORA       NUMBER(5),
    CO_DV_AGENCIA_COBRADORA    CHAR(1),
    TE_IDENTIFICACAO_TITULO_EMPRESA VARCHAR2(25),
    CO_MOEDA                   NUMBER(2),
    CO_TIPO_INSCRICAO_SACADO   CHAR(1),
    NU_INSCRICAO_SACADO        VARCHAR2(15),  -- [DADO_PESSOAL]
    NO_SACADO                  VARCHAR2(40),
    NU_NUMERO_CONTRATO         VARCHAR2(10),
    NU_VALOR_TARIFA_CUSTAS     NUMBER(15,2),
    TE_MOTIVO_OCORRENCIA       VARCHAR2(10),
    TE_OCORRENCIA             CHAR(10),
    DH_INCLUSAO                DATE NOT NULL,
    DH_ALTERACAO               DATE,
    NO_USUARIO_INCLUSAO        VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO       VARCHAR2(60),
    ID_TIPO_INSCRICAO_SACADO   NUMBER,
    CONSTRAINT IPAGTB023_DET_RETORNO_TITULO_PK   PRIMARY KEY (ID_SEG_T),
    CONSTRAINT IPAGTB023_DET_RETORNO_TITULO_UK01 UNIQUE (ID_DETALHE_REG),
    CONSTRAINT IPAGTB007_IPAGTB023_FK01
        FOREIGN KEY (ID_DETALHE_REG) REFERENCES IPAGTB007_DETALHE_REG (ID_DETALHE_REG),
    CONSTRAINT IPAGTB034_IPAGTB023_FK02
        FOREIGN KEY (ID_TIPO_INSCRICAO_SACADO) REFERENCES IPAGTB034_TIPO_INSCRICAO (ID_TIPO_INSCRICAO)
);

-- ----------------------------------------------------------------------------
-- IPAGTB024_DET_COMPL_RETORNO - Segmento U (Obrigatorio - Cobranca Retorno - Valores)
-- ----------------------------------------------------------------------------

CREATE TABLE IPAGTB024_DET_COMPL_RETORNO (
    ID_SEG_U                   NUMBER,
    ID_DETALHE_REG             NUMBER        NOT NULL,
    NU_VALOR_ACRESCIMOS        NUMBER(15,2),
    NU_VALOR_DESCONTO          NUMBER(15,2),
    NU_VALOR_ABATIMENTO        NUMBER(15,2),
    NU_VALOR_IOF               NUMBER(15,2),
    NU_VALOR_PAGO              NUMBER(15,2),
    NU_VALOR_LIQUIDO           NUMBER(15,2),
    NU_VALOR_OUTRAS_DEDUCOES   NUMBER(15,2),
    NU_VALOR_OUTROS_ACRESCIMOS NUMBER(15,2),
    DH_OCORRENCIA              DATE,
    DH_CREDITO                 DATE,
    CO_OCORRENCIA_PAGADOR      VARCHAR2(4),
    DH_OCORRENCIA_PAGADOR      DATE,
    NU_VALOR_OCORRENCIA        NUMBER(15,2),
    TE_COMPLEMENTO_OCORRENCIA  VARCHAR2(30),
    NU_BANCO_CORRESPONDENTE    NUMBER(3),
    NU_NOSSO_NUMERO_CORRESPONDENTE    VARCHAR2(20),
    TE_OCORRENCIA             CHAR(10),
    DH_INCLUSAO                DATE NOT NULL,
    DH_ALTERACAO               DATE,
    NO_USUARIO_INCLUSAO        VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO       VARCHAR2(60),
    CONSTRAINT IPAGTB024_DET_COMPL_RETORNO_PK   PRIMARY KEY (ID_SEG_U),
    CONSTRAINT IPAGTB024_DET_COMPL_RETORNO_UK01 UNIQUE (ID_DETALHE_REG),
    CONSTRAINT IPAGTB007_IPAGTB024_FK01
        FOREIGN KEY (ID_DETALHE_REG) REFERENCES IPAGTB007_DETALHE_REG (ID_DETALHE_REG)
);

-- =============================================================================
-- SECAO 11: FIM DO SCRIPT
-- =============================================================================
-- Total de objetos criados:
--   Tabelas de dominio : 7  (IPAGTB030-007)
--   Tabelas principais : 17 (IPAGTB001-007 + IPAGTB010-024)
--   Sequences          : 24 (uma por tabela)
--   Primary Keys       : 24
--   Foreign Keys       : 18
--   Unique Keys        : 24
--   Check Constraints  : 8
--   Indexes            : 11
--
-- Hierarquia implementada:
--   IPAGTB001_ARQUIVO
--     |-- IPAGTB002_CABECALHO_ARQUIVO  (1:1)
--     |-- IPAGTB003_RODAPE_ARQUIVO (1:1)
--     |-- IPAGTB004_LOTE            (1:N)
--           |-- IPAGTB005_CABECALHO_LOTE     (1:1)
--           |-- IPAGTB006_RODAPE_LOTE    (1:1)
--           |-- IPAGTB007_DETALHE_REG     (1:N)
--                 |-- IPAGTB010_DET_PAGAMENTO     (0:1)
--                 |-- IPAGTB011_DET_INFO_FAVORECIDO     (0:1)
--                 |-- IPAGTB012_DET_COMPLEMENTAR     (0:1)
--                 |-- IPAGTB013_DET_TITULO_COBRANCA     (0:1)
--                 |-- IPAGTB014_DET_PARTES_TITULO   (0:1)
--                 |-- IPAGTB015_DET_PIX_CODIGO_QR (0:1)
--                 |-- IPAGTB016_DET_TRIBUTO_SEM_CB     (0:1)
--                 |-- IPAGTB017_DET_TRIBUTO_COM_CB     (0:1)
--                 |-- IPAGTB018_DET_COMPL_TRIBUTO     (0:1)
--                 |-- IPAGTB019_DET_IDENT_TRIBUTO     (0:1)
--                 |-- IPAGTB020_DET_DADOS_TITULO     (0:1)
--                 |-- IPAGTB021_DET_DADOS_SACADO     (0:1)
--                 |-- IPAGTB022_DET_DESCONTO_TITULO     (0:1)
--                 |-- IPAGTB023_DET_RETORNO_TITULO     (0:1)
--                 |-- IPAGTB024_DET_COMPL_RETORNO     (0:1)
-- =============================================================================

-- =============================================================================
-- MODULO DE CONTROLE DE CARGA E DISPATCH
-- Controle de retomada de carga e envio para servicos de destino:
--   * IPAGTB037_SERVICO_DESTINO  - dominio dos servicos de destino
--   * IPAGTB025_CONTROLE_CARGA   - checkpoint de carga por arquivo
--   * IPAGTB026_CTRL_CARGA_LOTE  - checkpoint de carga por lote
--   * IPAGTB027_DESPACHO_LOTE    - estado atual de despacho por lote/servico
--   * IPAGTB028_HISTORICO_DESPACHO - log imutavel de tentativas de despacho
--   * ALTER em IPAGTB031_TIPO_SERVICO - FK para servico de destino
--   * IPAGTV001_STATUS_ARQUIVO   - view de monitoramento de arquivos
--   * IPAGTV002_DESPACHO_PENDENTE - fila de trabalho para processos
-- =============================================================================

-- =============================================================================
-- DOMINIO: IPAGTB037_SERVICO_DESTINO
-- =============================================================================

CREATE TABLE IPAGTB037_SERVICO_DESTINO (
    ID_SERVICO_DESTINO   NUMBER,
    CO_SERVICO           VARCHAR2(20)  NOT NULL,
    NO_SERVICO           VARCHAR2(100) NOT NULL,
    TE_URL_DESTINO      VARCHAR2(500),
    NU_MAX_TENTATIVA    NUMBER(2)     DEFAULT 3    NOT NULL,
    NU_INTERVALO_RETENTATIVA NUMBER(6)     DEFAULT 300  NOT NULL,
    IN_ATIVO             CHAR(1)  NOT NULL,
    DH_INCLUSAO          DATE NOT NULL,
    DH_ALTERACAO         DATE,
    NO_USUARIO_INCLUSAO  VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO VARCHAR2(60),
    CONSTRAINT IPAGTB037_SERVICO_DESTINO_PK   PRIMARY KEY (ID_SERVICO_DESTINO),
    CONSTRAINT IPAGTB037_SERVICO_DESTINO_UK01 UNIQUE (CO_SERVICO),
    CONSTRAINT IPAGTB037_SERVICO_DESTINO_IN_ATIVO_CK01
        CHECK (IN_ATIVO IN ('S','N'))
);

-- Dados iniciais dos tres servicos de destino

-- =============================================================================
-- ALTER IPAGTB031_TIPO_SERVICO: FK para servico de destino (coluna ja inline na CREATE TABLE)
-- =============================================================================

ALTER TABLE IPAGTB031_TIPO_SERVICO
    ADD CONSTRAINT IPAGTB037_IPAGTB031_FK01
        FOREIGN KEY (ID_SERVICO_DESTINO)
        REFERENCES IPAGTB037_SERVICO_DESTINO (ID_SERVICO_DESTINO);

-- Mapeamento inicial: tipos de servico -> servico de destino
-- Cobranca e Boleto -> BOLETO

-- Pagamentos, Salarios, Vendor, Compror, Debito -> PAGAMENTO

-- Tributos (com e sem CB), GPS -> TRIBUTO

-- =============================================================================
-- IPAGTB025_CONTROLE_CARGA: checkpoint de carga por arquivo
-- =============================================================================

CREATE TABLE IPAGTB025_CONTROLE_CARGA (
    ID_CONTROLE_CARGA       NUMBER,
    ID_ARQUIVO              NUMBER        NOT NULL,
    CO_STATUS_CARGA         VARCHAR2(20) NOT NULL,
    NU_TENTATIVA            NUMBER(3)     DEFAULT 0 NOT NULL,
    QT_LOTE_ESPERADO      NUMBER(6),
    QT_LOTE_CONCLUIDO     NUMBER(6)     DEFAULT 0 NOT NULL,
    QT_REGISTRO_ESPERADO  NUMBER(10),
    QT_REGISTRO_PROCESSADO NUMBER(10)   DEFAULT 0 NOT NULL,
    ID_ULTIMO_LOTE_CONCLUIDO NUMBER,
    DH_INICIO_CARGA         DATE,
    DH_FIM_CARGA            DATE,
    DH_ULTIMA_ATUALIZACAO   DATE,
    TE_MENSAGEM_ERRO        VARCHAR2(4000),
    DH_INCLUSAO             DATE NOT NULL,
    DH_ALTERACAO            DATE,
    NO_USUARIO_INCLUSAO     VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO    VARCHAR2(60),
    CONSTRAINT IPAGTB025_CONTROLE_CARGA_PK   PRIMARY KEY (ID_CONTROLE_CARGA),
    CONSTRAINT IPAGTB025_CONTROLE_CARGA_UK01 UNIQUE (ID_ARQUIVO),
    CONSTRAINT IPAGTB001_IPAGTB025_FK01
        FOREIGN KEY (ID_ARQUIVO) REFERENCES IPAGTB001_ARQUIVO (ID_ARQUIVO),
    CONSTRAINT IPAGTB004_IPAGTB025_FK02
        FOREIGN KEY (ID_ULTIMO_LOTE_CONCLUIDO) REFERENCES IPAGTB004_LOTE (ID_LOTE),
    CONSTRAINT IPAGTB025_CONTROLE_CARGA_CO_STATUS_CK01
        CHECK (CO_STATUS_CARGA IN ('PENDENTE','EM_ANDAMENTO','CONCLUIDO','ERRO','AGUARDANDO_RETOMADA'))
);

-- =============================================================================
-- IPAGTB026_CTRL_CARGA_LOTE: checkpoint de carga por lote
-- =============================================================================

CREATE TABLE IPAGTB026_CTRL_CARGA_LOTE (
    ID_CTRL_CARGA_LOTE      NUMBER,
    ID_CONTROLE_CARGA       NUMBER        NOT NULL,
    ID_LOTE                 NUMBER        NOT NULL,
    CO_STATUS_LOTE          VARCHAR2(20) NOT NULL,
    QT_DETALHE_ESPERADO   NUMBER(8),
    QT_DETALHE_PROCESSADO NUMBER(8)     DEFAULT 0 NOT NULL,
    QT_SEGMENTO_PROCESSADO NUMBER(10)   DEFAULT 0 NOT NULL,
    DH_INICIO_LOTE          DATE,
    DH_FIM_LOTE             DATE,
    TE_MENSAGEM_ERRO        VARCHAR2(4000),
    DH_INCLUSAO             DATE NOT NULL,
    DH_ALTERACAO            DATE,
    NO_USUARIO_INCLUSAO     VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO    VARCHAR2(60),
    CONSTRAINT IPAGTB026_CTRL_CARGA_LOTE_PK   PRIMARY KEY (ID_CTRL_CARGA_LOTE),
    CONSTRAINT IPAGTB026_CTRL_CARGA_LOTE_UK01 UNIQUE (ID_CONTROLE_CARGA, ID_LOTE),
    CONSTRAINT IPAGTB025_IPAGTB026_FK01
        FOREIGN KEY (ID_CONTROLE_CARGA) REFERENCES IPAGTB025_CONTROLE_CARGA (ID_CONTROLE_CARGA),
    CONSTRAINT IPAGTB004_IPAGTB026_FK02
        FOREIGN KEY (ID_LOTE) REFERENCES IPAGTB004_LOTE (ID_LOTE),
    CONSTRAINT IPAGTB026_CTRL_CARGA_LOTE_CO_STATUS_CK01
        CHECK (CO_STATUS_LOTE IN ('PENDENTE','EM_ANDAMENTO','CONCLUIDO','ERRO'))
);

-- =============================================================================
-- IPAGTB027_DESPACHO_LOTE: estado atual de despacho por lote e servico
-- =============================================================================

CREATE TABLE IPAGTB027_DESPACHO_LOTE (
    ID_DESPACHO_LOTE        NUMBER,
    ID_LOTE                 NUMBER        NOT NULL,
    ID_SERVICO_DESTINO      NUMBER        NOT NULL,
    CO_STATUS_DESPACHO      VARCHAR2(20) NOT NULL,
    NU_TENTATIVA_ATUAL      NUMBER(3)     DEFAULT 0 NOT NULL,
    NU_MAX_TENTATIVA       NUMBER(3)     DEFAULT 3 NOT NULL,
    DH_PROXIMO_ENVIO        DATE,
    DH_ULTIMO_ENVIO         DATE,
    DH_CONFIRMACAO          DATE,
    NU_PROTOCOLO_EXTERNO    VARCHAR2(100),
    NU_CORRELACAO_EXTERNA   VARCHAR2(100),
    CO_STATUS_HTTP          NUMBER(3),
    TE_CONTEUDO_ENVIADO      CLOB,
    TE_RESPOSTA_SERVICO     CLOB,
    DH_INCLUSAO             DATE NOT NULL,
    DH_ALTERACAO            DATE,
    NO_USUARIO_INCLUSAO     VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO    VARCHAR2(60),
    CONSTRAINT IPAGTB027_DESPACHO_LOTE_PK   PRIMARY KEY (ID_DESPACHO_LOTE),
    CONSTRAINT IPAGTB027_DESPACHO_LOTE_UK01 UNIQUE (ID_LOTE, ID_SERVICO_DESTINO),
    CONSTRAINT IPAGTB004_IPAGTB027_FK01
        FOREIGN KEY (ID_LOTE) REFERENCES IPAGTB004_LOTE (ID_LOTE),
    CONSTRAINT IPAGTB037_IPAGTB027_FK02
        FOREIGN KEY (ID_SERVICO_DESTINO) REFERENCES IPAGTB037_SERVICO_DESTINO (ID_SERVICO_DESTINO),
    CONSTRAINT IPAGTB027_DESPACHO_LOTE_CO_STATUS_CK01
        CHECK (CO_STATUS_DESPACHO IN ('PENDENTE','ENVIADO','CONFIRMADO','ERRO','RETENTATIVA','CANCELADO'))
);

-- =============================================================================
-- IPAGTB028_HISTORICO_DESPACHO: log imutavel de tentativas de despacho
-- =============================================================================

CREATE TABLE IPAGTB028_HISTORICO_DESPACHO (
    ID_HISTORICO_DESPACHO   NUMBER,
    ID_DESPACHO_LOTE        NUMBER        NOT NULL,
    NU_NUMERO_TENTATIVA     NUMBER(3)     NOT NULL,
    CO_STATUS_RESULTADO     VARCHAR2(20)  NOT NULL,
    DH_ENVIO                DATE          NOT NULL,
    DH_RESPOSTA             DATE,
    NU_DURACAO_MS           NUMBER(10),
    CO_STATUS_HTTP          NUMBER(3),
    NU_PROTOCOLO_EXTERNO    VARCHAR2(100),
    TE_CONTEUDO_ENVIADO      CLOB,
    TE_RESPOSTA_SERVICO     CLOB,
    TE_MENSAGEM_ERRO        VARCHAR2(4000),
    NO_PROCESSO_EXECUTOR    VARCHAR2(100),
    NO_SERVIDOR_EXECUTOR    VARCHAR2(100),
    DH_INCLUSAO             DATE NOT NULL,
    NO_USUARIO_INCLUSAO     VARCHAR2(60)  NOT NULL,
    CONSTRAINT IPAGTB028_HISTORICO_DESPACHO_PK   PRIMARY KEY (ID_HISTORICO_DESPACHO),
    CONSTRAINT IPAGTB028_HISTORICO_DESPACHO_UK01 UNIQUE (ID_DESPACHO_LOTE, NU_NUMERO_TENTATIVA),
    CONSTRAINT IPAGTB027_IPAGTB028_FK01
        FOREIGN KEY (ID_DESPACHO_LOTE) REFERENCES IPAGTB027_DESPACHO_LOTE (ID_DESPACHO_LOTE),
    CONSTRAINT IPAGTB028_HISTORICO_DESPACHO_CO_STATUS_CK01
        CHECK (CO_STATUS_RESULTADO IN ('ENVIADO','CONFIRMADO','ERRO','TIMEOUT','CANCELADO'))
);

-- =============================================================================
-- VIEW IPAGTV001_STATUS_ARQUIVO: painel de monitoramento de arquivos
-- =============================================================================
CREATE OR REPLACE VIEW IPAGTV001_STATUS_ARQUIVO AS
SELECT
    arq.ID_ARQUIVO,
    arq.NO_NOME_ARQUIVO,
    arq.NU_BANCO_COMPENSACAO,
    arq.CO_REMESSA_RETORNO,
    arq.DH_GERACAO_ARQUIVO,
    cc.CO_STATUS_CARGA,
    cc.NU_TENTATIVA                              AS NU_TENTATIVA_CARGA,
    cc.QT_LOTE_ESPERADO,
    cc.QT_LOTE_CONCLUIDO,
    ROUND(cc.QT_LOTE_CONCLUIDO * 100.0 / NULLIF(cc.QT_LOTE_ESPERADO, 0), 1)
                                                 AS NU_PERC_LOTES_CONCLUIDOS,
    cc.QT_REGISTRO_ESPERADO,
    cc.QT_REGISTRO_PROCESSADO,
    cc.DH_INICIO_CARGA,
    cc.DH_FIM_CARGA,
    cc.DH_ULTIMA_ATUALIZACAO,
    -- Contagem de despachos por status para cada servico
    SUM(CASE WHEN sd.CO_SERVICO = 'BOLETO'    AND dl.CO_STATUS_DESPACHO = 'CONFIRMADO' THEN 1 ELSE 0 END)
                                                 AS QT_LOTE_BOLETO_CONFIRMADO,
    SUM(CASE WHEN sd.CO_SERVICO = 'BOLETO'    AND dl.CO_STATUS_DESPACHO = 'PENDENTE'   THEN 1 ELSE 0 END)
                                                 AS QT_LOTE_BOLETO_PENDENTE,
    SUM(CASE WHEN sd.CO_SERVICO = 'BOLETO'    AND dl.CO_STATUS_DESPACHO = 'ERRO'       THEN 1 ELSE 0 END)
                                                 AS QT_LOTE_BOLETO_ERRO,
    SUM(CASE WHEN sd.CO_SERVICO = 'PAGAMENTO' AND dl.CO_STATUS_DESPACHO = 'CONFIRMADO' THEN 1 ELSE 0 END)
                                                 AS QT_LOTE_PAGAMENTO_CONFIRMADO,
    SUM(CASE WHEN sd.CO_SERVICO = 'PAGAMENTO' AND dl.CO_STATUS_DESPACHO = 'PENDENTE'   THEN 1 ELSE 0 END)
                                                 AS QT_LOTE_PAGAMENTO_PENDENTE,
    SUM(CASE WHEN sd.CO_SERVICO = 'PAGAMENTO' AND dl.CO_STATUS_DESPACHO = 'ERRO'       THEN 1 ELSE 0 END)
                                                 AS QT_LOTE_PAGAMENTO_ERRO,
    SUM(CASE WHEN sd.CO_SERVICO = 'TRIBUTO'   AND dl.CO_STATUS_DESPACHO = 'CONFIRMADO' THEN 1 ELSE 0 END)
                                                 AS QT_LOTE_TRIBUTO_CONFIRMADO,
    SUM(CASE WHEN sd.CO_SERVICO = 'TRIBUTO'   AND dl.CO_STATUS_DESPACHO = 'PENDENTE'   THEN 1 ELSE 0 END)
                                                 AS QT_LOTE_TRIBUTO_PENDENTE,
    SUM(CASE WHEN sd.CO_SERVICO = 'TRIBUTO'   AND dl.CO_STATUS_DESPACHO = 'ERRO'       THEN 1 ELSE 0 END)
                                                 AS QT_LOTE_TRIBUTO_ERRO
FROM
    IPAGTB001_ARQUIVO            arq
    LEFT JOIN IPAGTB025_CONTROLE_CARGA   cc  ON cc.ID_ARQUIVO = arq.ID_ARQUIVO
    LEFT JOIN IPAGTB004_LOTE             lt  ON lt.ID_ARQUIVO = arq.ID_ARQUIVO
    LEFT JOIN IPAGTB027_DESPACHO_LOTE    dl  ON dl.ID_LOTE    = lt.ID_LOTE
    LEFT JOIN IPAGTB037_SERVICO_DESTINO  sd  ON sd.ID_SERVICO_DESTINO = dl.ID_SERVICO_DESTINO
GROUP BY
    arq.ID_ARQUIVO,
    arq.NO_NOME_ARQUIVO,
    arq.NU_BANCO_COMPENSACAO,
    arq.CO_REMESSA_RETORNO,
    arq.DH_GERACAO_ARQUIVO,
    cc.CO_STATUS_CARGA,
    cc.NU_TENTATIVA,
    cc.QT_LOTE_ESPERADO,
    cc.QT_LOTE_CONCLUIDO,
    cc.QT_REGISTRO_ESPERADO,
    cc.QT_REGISTRO_PROCESSADO,
    cc.DH_INICIO_CARGA,
    cc.DH_FIM_CARGA,
    cc.DH_ULTIMA_ATUALIZACAO;

-- =============================================================================
-- VIEW IPAGTV002_DESPACHO_PENDENTE: fila de trabalho para processos de despacho
-- =============================================================================
CREATE OR REPLACE VIEW IPAGTV002_DESPACHO_PENDENTE AS
SELECT
    dl.ID_DESPACHO_LOTE,
    dl.ID_LOTE,
    lt.ID_ARQUIVO,
    arq.NO_NOME_ARQUIVO,
    lt.NU_SEQUENCIAL_LOTE,
    ts.CO_TIPO_SERVICO,
    ts.NO_TIPO_SERVICO,
    sd.ID_SERVICO_DESTINO,
    sd.CO_SERVICO,
    sd.NO_SERVICO,
    sd.TE_URL_DESTINO,
    dl.CO_STATUS_DESPACHO,
    dl.NU_TENTATIVA_ATUAL,
    dl.NU_MAX_TENTATIVA,
    dl.DH_PROXIMO_ENVIO,
    dl.DH_ULTIMO_ENVIO,
    CASE
        WHEN dl.CO_STATUS_DESPACHO = 'PENDENTE'    THEN 1
        WHEN dl.CO_STATUS_DESPACHO = 'RETENTATIVA' THEN 2
        ELSE 9
    END AS NU_PRIORIDADE_FILA
FROM
    IPAGTB027_DESPACHO_LOTE      dl
    JOIN IPAGTB004_LOTE          lt  ON lt.ID_LOTE             = dl.ID_LOTE
    JOIN IPAGTB001_ARQUIVO       arq ON arq.ID_ARQUIVO          = lt.ID_ARQUIVO
    JOIN IPAGTB031_TIPO_SERVICO  ts  ON ts.ID_TIPO_SERVICO      = lt.ID_TIPO_SERVICO
    JOIN IPAGTB037_SERVICO_DESTINO sd ON sd.ID_SERVICO_DESTINO  = dl.ID_SERVICO_DESTINO
WHERE
    dl.CO_STATUS_DESPACHO IN ('PENDENTE', 'RETENTATIVA')
    AND (dl.DH_PROXIMO_ENVIO IS NULL OR dl.DH_PROXIMO_ENVIO <= SYSDATE)
    AND dl.NU_TENTATIVA_ATUAL < dl.NU_MAX_TENTATIVA
    AND sd.IN_ATIVO = 'S'
ORDER BY
    NU_PRIORIDADE_FILA,
    dl.DH_PROXIMO_ENVIO NULLS FIRST,
    dl.ID_DESPACHO_LOTE;

-- =============================================================================
-- RESUMO DO FLUXO OPERACIONAL
-- =============================================================================
-- 1. CARGA DO ARQUIVO
--    a. Inserir em IPAGTB001_ARQUIVO (arquivo fisico identificado)
--    b. Inserir em IPAGTB025_CONTROLE_CARGA (CO_STATUS_CARGA='PENDENTE')
--    c. Para cada lote do arquivo:
--       - Inserir em IPAGTB004_LOTE
--       - Inserir em IPAGTB026_CTRL_CARGA_LOTE (CO_STATUS_LOTE='PENDENTE')
--       - Processar Cabecalho, Rodape, Detalhes e Segmentos do lote
--       - Atualizar IPAGTB026: CO_STATUS_LOTE='CONCLUIDO'
--       - Criar IPAGTB027_DESPACHO_LOTE para o servico mapeado no tipo de servico do lote
--       - Atualizar IPAGTB025: ID_ULTIMO_LOTE_CONCLUIDO = ID deste lote
--    d. Ao fim: IPAGTB025.CO_STATUS_CARGA='CONCLUIDO'
--
-- 2. RETOMADA DE CARGA (caso de falha)
--    a. Verificar IPAGTB025.CO_STATUS_CARGA='AGUARDANDO_RETOMADA'
--    b. Obter ID_ULTIMO_LOTE_CONCLUIDO -> retomar a partir do lote seguinte
--    c. Lotes ja com CO_STATUS_LOTE='CONCLUIDO' em IPAGTB026 sao ignorados (skip)
--    d. Incrementar NU_TENTATIVA em IPAGTB025
--
-- 3. DISPATCH PARA SERVICOS
--    a. Worker consulta IPAGTV002_DESPACHO_PENDENTE (SELECT FOR 

-- =============================================================================
-- VIEW IPAGTV003_LINHAS_ERRO: diagnostico de linhas com falha de processamento
-- =============================================================================
CREATE OR REPLACE VIEW IPAGTV003_LINHAS_ERRO AS
SELECT
    arq.ID_ARQUIVO,
    arq.NO_NOME_ARQUIVO,
    arq.NU_BANCO_COMPENSACAO,
    cl.ID_CONTROLE_LINHA,
    cl.NU_NUMERO_LINHA,
    cl.CO_TIPO_REGISTRO,
    cl.CO_SEGMENTO,
    cl.NU_LOTE_CNAB,
    cl.CO_STATUS_LINHA,
    cl.TE_CONTEUDO_LINHA,
    cl.TE_MENSAGEM_ERRO,
    cl.DH_PROCESSAMENTO,
    cl.DH_INCLUSAO
FROM
    IPAGTB029_CONTROLE_LINHA cl
    JOIN IPAGTB001_ARQUIVO   arq ON arq.ID_ARQUIVO = cl.ID_ARQUIVO
WHERE
    cl.CO_STATUS_LINHA IN ('ERRO', 'PENDENTE')
ORDER BY
    arq.ID_ARQUIVO,
    cl.NU_NUMERO_LINHA;

-- =============================================================================
-- CORRECOES DO MODELO: FKs para tabelas de dominio (IPAGTB030 a IPAGTB036)
-- As tabelas abaixo armazenavam o codigo de dominio como CO_ (dado bruto do CNAB).
-- Adicionamos colunas ID_ surrogate para ligacao relacional com as tabelas de dominio,
-- mantendo o CO_ original para fidelidade ao arquivo fonte.
-- =============================================================================

-- IPAGTB004_LOTE: FK para tipo de servico e tipo de operacao

-- IPAGTB007_DETALHE_REG: FK para tipo de movimento

-- IPAGTB002_CABECALHO_ARQUIVO: FK para tipo de inscricao da empresa

-- IPAGTB005_CABECALHO_LOTE: FK para tipo de inscricao da empresa no lote

-- IPAGTB010_DET_PAGAMENTO: FK para tipo de moeda e camara centralizadora

-- IPAGTB011_DET_INFO_FAVORECIDO: FK para tipo de inscricao do favorecido

-- IPAGTB014_DET_PARTES_TITULO: FKs para tipos de inscricao (pagador, beneficiario, sacador)

-- IPAGTB015_DET_PIX_CODIGO_QR: FKs para tipos de inscricao (devedor e favorecido)

-- IPAGTB020_DET_DADOS_TITULO: FK para tipo de inscricao do sacado

-- IPAGTB021_DET_DADOS_SACADO: FKs para tipo de inscricao (sacado e sacador)

-- IPAGTB023_DET_RETORNO_TITULO: FK para tipo de inscricao do sacado (retorno de cobranca)

-- IPAGTB029_CONTROLE_LINHA: FK para tipo de registro
