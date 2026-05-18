-- =============================================================================
-- PROJETO    : IPAG - Integracao de Pagamentos
-- SCHEMA     : CNAB240 / FEBRABAN 240 posicoes V10.9
-- BANCO      : Oracle 12c+
-- PADRAO     : SKILL_CNAB240_ORACLE / IPAGTB[NNN] / 3FN
-- DATA       : 2026-05-18
-- =============================================================================

-- =============================================================================
-- SECAO 1: TABELAS DE DOMINIO (IPAGTB030-IPAGTB037)
-- =============================================================================

-- ----------------------------------------------------------------------------
-- IPAGTB030_TIPO_REGISTRO
-- ----------------------------------------------------------------------------
CREATE SEQUENCE IPAGTB030_TIPO_REGISTRO_SQ START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE IPAGTB030_TIPO_REGISTRO (
    ID_TIPO_REGISTRO       NUMBER          DEFAULT ON NULL IPAGTB030_TIPO_REGISTRO_SQ.NEXTVAL,
    CO_TIPO_REGISTRO       CHAR(1)         NOT NULL,
    NO_TIPO_REGISTRO       VARCHAR2(60)    NOT NULL,
    DH_INCLUSAO            DATE            DEFAULT SYSDATE NOT NULL,
    DH_ALTERACAO           DATE,
    NO_USUARIO_INCLUSAO    VARCHAR2(60)    NOT NULL,
    NO_USUARIO_ALTERACAO   VARCHAR2(60),
    CONSTRAINT IPAGTB030_TIPO_REGISTRO_PK   PRIMARY KEY (ID_TIPO_REGISTRO),
    CONSTRAINT IPAGTB030_TIPO_REGISTRO_UK01 UNIQUE (CO_TIPO_REGISTRO)
);

COMMENT ON TABLE IPAGTB030_TIPO_REGISTRO IS
  'Dominio dos tipos de registro CNAB240. Cada linha representa um dos sete tipos validos '
  'definidos pelo padrao FEBRABAN: 0=Header Arquivo, 1=Header Lote, 2=Inicial Lote, '
  '3=Detalhe, 4=Final Lote, 5=Trailer Lote, 9=Trailer Arquivo.';
COMMENT ON COLUMN IPAGTB030_TIPO_REGISTRO.ID_TIPO_REGISTRO     IS 'Identificador surrogate gerado por sequence. Chave primaria interna sem significado de negocio.';
COMMENT ON COLUMN IPAGTB030_TIPO_REGISTRO.CO_TIPO_REGISTRO     IS 'Codigo do tipo de registro conforme padrao CNAB240. Campo G003. Valores: 0,1,2,3,4,5,9.';
COMMENT ON COLUMN IPAGTB030_TIPO_REGISTRO.NO_TIPO_REGISTRO     IS 'Descricao por extenso do tipo de registro. Exemplo: Header de Arquivo.';
COMMENT ON COLUMN IPAGTB030_TIPO_REGISTRO.DH_INCLUSAO          IS 'Data e hora em que o registro foi incluido na tabela.';
COMMENT ON COLUMN IPAGTB030_TIPO_REGISTRO.DH_ALTERACAO         IS 'Data e hora da ultima alteracao do registro. Nulo se nunca alterado.';
COMMENT ON COLUMN IPAGTB030_TIPO_REGISTRO.NO_USUARIO_INCLUSAO  IS 'Login do usuario que incluiu o registro.';
COMMENT ON COLUMN IPAGTB030_TIPO_REGISTRO.NO_USUARIO_ALTERACAO IS 'Login do usuario que realizou a ultima alteracao. Nulo se nunca alterado.';

-- ----------------------------------------------------------------------------
-- IPAGTB031_TIPO_SERVICO
-- ----------------------------------------------------------------------------
CREATE SEQUENCE IPAGTB031_TIPO_SERVICO_SQ START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE IPAGTB031_TIPO_SERVICO (
    ID_TIPO_SERVICO        NUMBER          DEFAULT ON NULL IPAGTB031_TIPO_SERVICO_SQ.NEXTVAL,
    CO_TIPO_SERVICO        CHAR(2)         NOT NULL,
    NO_TIPO_SERVICO        VARCHAR2(80)    NOT NULL,
    ID_SERVICO_DESTINO     NUMBER,
    DH_INCLUSAO            DATE            DEFAULT SYSDATE NOT NULL,
    DH_ALTERACAO           DATE,
    NO_USUARIO_INCLUSAO    VARCHAR2(60)    NOT NULL,
    NO_USUARIO_ALTERACAO   VARCHAR2(60),
    CONSTRAINT IPAGTB031_TIPO_SERVICO_PK   PRIMARY KEY (ID_TIPO_SERVICO),
    CONSTRAINT IPAGTB031_TIPO_SERVICO_UK01 UNIQUE (CO_TIPO_SERVICO)
);

COMMENT ON TABLE IPAGTB031_TIPO_SERVICO IS
  'Dominio dos tipos de servico/produto CNAB240. Identifica a finalidade do lote. '
  'Campo G025 do padrao FEBRABAN. Exemplos: 01=Cobranca, 20=Pagamento Fornecedor, 30=Salario.';
COMMENT ON COLUMN IPAGTB031_TIPO_SERVICO.CO_TIPO_SERVICO IS 'Codigo de 2 digitos do tipo de servico. Campo G025. Exemplos: 01, 20, 22, 30, 98.';
COMMENT ON COLUMN IPAGTB031_TIPO_SERVICO.NO_TIPO_SERVICO IS 'Descricao do servico/produto. Exemplo: Pagamento de Fornecedores e Honorarios.';
COMMENT ON COLUMN IPAGTB031_TIPO_SERVICO.ID_TIPO_SERVICO IS 'Identificador surrogate gerado por sequence. Chave primaria interna.';
COMMENT ON COLUMN IPAGTB031_TIPO_SERVICO.DH_INCLUSAO          IS 'Data e hora de inclusao do registro.';
COMMENT ON COLUMN IPAGTB031_TIPO_SERVICO.DH_ALTERACAO         IS 'Data e hora da ultima alteracao.';
COMMENT ON COLUMN IPAGTB031_TIPO_SERVICO.NO_USUARIO_INCLUSAO  IS 'Login do usuario que incluiu.';
COMMENT ON COLUMN IPAGTB031_TIPO_SERVICO.NO_USUARIO_ALTERACAO IS 'Login do usuario que alterou.';

-- ----------------------------------------------------------------------------
-- IPAGTB032_TIPO_OPERACAO
-- ----------------------------------------------------------------------------
CREATE SEQUENCE IPAGTB032_TIPO_OPERACAO_SQ START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE IPAGTB032_TIPO_OPERACAO (
    ID_TIPO_OPERACAO       NUMBER          DEFAULT ON NULL IPAGTB032_TIPO_OPERACAO_SQ.NEXTVAL,
    CO_TIPO_OPERACAO       CHAR(1)         NOT NULL,
    NO_TIPO_OPERACAO       VARCHAR2(60)    NOT NULL,
    DH_INCLUSAO            DATE            DEFAULT SYSDATE NOT NULL,
    DH_ALTERACAO           DATE,
    NO_USUARIO_INCLUSAO    VARCHAR2(60)    NOT NULL,
    NO_USUARIO_ALTERACAO   VARCHAR2(60),
    CONSTRAINT IPAGTB032_TIPO_OPERACAO_PK   PRIMARY KEY (ID_TIPO_OPERACAO),
    CONSTRAINT IPAGTB032_TIPO_OPERACAO_UK01 UNIQUE (CO_TIPO_OPERACAO)
);

COMMENT ON TABLE IPAGTB032_TIPO_OPERACAO IS
  'Dominio dos tipos de operacao do Header de Lote. Campo G028 do padrao FEBRABAN. '
  'Indica se o lote e de Credito (C), Debito (D) ou Extrato (E).';
COMMENT ON COLUMN IPAGTB032_TIPO_OPERACAO.ID_TIPO_OPERACAO     IS 'Identificador surrogate gerado por sequence.';
COMMENT ON COLUMN IPAGTB032_TIPO_OPERACAO.CO_TIPO_OPERACAO     IS 'Codigo da operacao. Campo G028. Valores: C=Credito, D=Debito, E=Extrato Conciliacao.';
COMMENT ON COLUMN IPAGTB032_TIPO_OPERACAO.NO_TIPO_OPERACAO     IS 'Descricao da operacao. Exemplo: Credito em Conta Corrente.';
COMMENT ON COLUMN IPAGTB032_TIPO_OPERACAO.DH_INCLUSAO          IS 'Data e hora de inclusao.';
COMMENT ON COLUMN IPAGTB032_TIPO_OPERACAO.DH_ALTERACAO         IS 'Data e hora da ultima alteracao.';
COMMENT ON COLUMN IPAGTB032_TIPO_OPERACAO.NO_USUARIO_INCLUSAO  IS 'Login do usuario que incluiu.';
COMMENT ON COLUMN IPAGTB032_TIPO_OPERACAO.NO_USUARIO_ALTERACAO IS 'Login do usuario que alterou.';

-- ----------------------------------------------------------------------------
-- IPAGTB033_TIPO_MOVIMENTO
-- ----------------------------------------------------------------------------
CREATE SEQUENCE IPAGTB033_TIPO_MOVIMENTO_SQ START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE IPAGTB033_TIPO_MOVIMENTO (
    ID_TIPO_MOVIMENTO      NUMBER          DEFAULT ON NULL IPAGTB033_TIPO_MOVIMENTO_SQ.NEXTVAL,
    CO_TIPO_MOVIMENTO      CHAR(1)         NOT NULL,
    NO_TIPO_MOVIMENTO      VARCHAR2(80)    NOT NULL,
    DH_INCLUSAO            DATE            DEFAULT SYSDATE NOT NULL,
    DH_ALTERACAO           DATE,
    NO_USUARIO_INCLUSAO    VARCHAR2(60)    NOT NULL,
    NO_USUARIO_ALTERACAO   VARCHAR2(60),
    CONSTRAINT IPAGTB033_TIPO_MOVIMENTO_PK   PRIMARY KEY (ID_TIPO_MOVIMENTO),
    CONSTRAINT IPAGTB033_TIPO_MOVIMENTO_UK01 UNIQUE (CO_TIPO_MOVIMENTO)
);

COMMENT ON TABLE IPAGTB033_TIPO_MOVIMENTO IS
  'Dominio dos tipos de movimento do registro detalhe. Campo G060 do padrao FEBRABAN. '
  'Indica a natureza da instrucao: 0=Inclusao, 5=Alteracao, 9=Exclusao, entre outros.';
COMMENT ON COLUMN IPAGTB033_TIPO_MOVIMENTO.ID_TIPO_MOVIMENTO     IS 'Identificador surrogate gerado por sequence.';
COMMENT ON COLUMN IPAGTB033_TIPO_MOVIMENTO.CO_TIPO_MOVIMENTO     IS 'Codigo do tipo de movimento. Campo G060. Exemplos: 0=Inclusao, 5=Alteracao, 9=Exclusao.';
COMMENT ON COLUMN IPAGTB033_TIPO_MOVIMENTO.NO_TIPO_MOVIMENTO     IS 'Descricao do tipo de movimento.';
COMMENT ON COLUMN IPAGTB033_TIPO_MOVIMENTO.DH_INCLUSAO           IS 'Data e hora de inclusao.';
COMMENT ON COLUMN IPAGTB033_TIPO_MOVIMENTO.DH_ALTERACAO          IS 'Data e hora da ultima alteracao.';
COMMENT ON COLUMN IPAGTB033_TIPO_MOVIMENTO.NO_USUARIO_INCLUSAO   IS 'Login do usuario que incluiu.';
COMMENT ON COLUMN IPAGTB033_TIPO_MOVIMENTO.NO_USUARIO_ALTERACAO  IS 'Login do usuario que alterou.';

-- ----------------------------------------------------------------------------
-- IPAGTB034_TIPO_INSCRICAO
-- ----------------------------------------------------------------------------
CREATE SEQUENCE IPAGTB034_TIPO_INSCRICAO_SQ START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE IPAGTB034_TIPO_INSCRICAO (
    ID_TIPO_INSCRICAO      NUMBER          DEFAULT ON NULL IPAGTB034_TIPO_INSCRICAO_SQ.NEXTVAL,
    CO_TIPO_INSCRICAO      CHAR(1)         NOT NULL,
    NO_TIPO_INSCRICAO      VARCHAR2(60)    NOT NULL,
    DH_INCLUSAO            DATE            DEFAULT SYSDATE NOT NULL,
    DH_ALTERACAO           DATE,
    NO_USUARIO_INCLUSAO    VARCHAR2(60)    NOT NULL,
    NO_USUARIO_ALTERACAO   VARCHAR2(60),
    CONSTRAINT IPAGTB034_TIPO_INSCRICAO_PK   PRIMARY KEY (ID_TIPO_INSCRICAO),
    CONSTRAINT IPAGTB034_TIPO_INSCRICAO_UK01 UNIQUE (CO_TIPO_INSCRICAO)
);

COMMENT ON TABLE IPAGTB034_TIPO_INSCRICAO IS
  'Dominio dos tipos de inscricao de pessoa fisica ou juridica. Campo G005 do padrao FEBRABAN. '
  'Identifica se o numero de inscricao e CPF ou CNPJ.';
COMMENT ON COLUMN IPAGTB034_TIPO_INSCRICAO.ID_TIPO_INSCRICAO     IS 'Identificador surrogate gerado por sequence.';
COMMENT ON COLUMN IPAGTB034_TIPO_INSCRICAO.CO_TIPO_INSCRICAO     IS 'Codigo do tipo de inscricao. Campo G005. Valores: 1=CPF, 2=CNPJ.';
COMMENT ON COLUMN IPAGTB034_TIPO_INSCRICAO.NO_TIPO_INSCRICAO     IS 'Descricao do tipo de inscricao. Exemplo: CNPJ - Cadastro Nacional de Pessoa Juridica.';
COMMENT ON COLUMN IPAGTB034_TIPO_INSCRICAO.DH_INCLUSAO           IS 'Data e hora de inclusao.';
COMMENT ON COLUMN IPAGTB034_TIPO_INSCRICAO.DH_ALTERACAO          IS 'Data e hora da ultima alteracao.';
COMMENT ON COLUMN IPAGTB034_TIPO_INSCRICAO.NO_USUARIO_INCLUSAO   IS 'Login do usuario que incluiu.';
COMMENT ON COLUMN IPAGTB034_TIPO_INSCRICAO.NO_USUARIO_ALTERACAO  IS 'Login do usuario que alterou.';

-- ----------------------------------------------------------------------------
-- IPAGTB035_TIPO_MOEDA
-- ----------------------------------------------------------------------------
CREATE SEQUENCE IPAGTB035_TIPO_MOEDA_SQ START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE IPAGTB035_TIPO_MOEDA (
    ID_TIPO_MOEDA          NUMBER          DEFAULT ON NULL IPAGTB035_TIPO_MOEDA_SQ.NEXTVAL,
    CO_TIPO_MOEDA          VARCHAR2(3)     NOT NULL,
    NO_TIPO_MOEDA          VARCHAR2(60)    NOT NULL,
    DH_INCLUSAO            DATE            DEFAULT SYSDATE NOT NULL,
    DH_ALTERACAO           DATE,
    NO_USUARIO_INCLUSAO    VARCHAR2(60)    NOT NULL,
    NO_USUARIO_ALTERACAO   VARCHAR2(60),
    CONSTRAINT IPAGTB035_TIPO_MOEDA_PK   PRIMARY KEY (ID_TIPO_MOEDA),
    CONSTRAINT IPAGTB035_TIPO_MOEDA_UK01 UNIQUE (CO_TIPO_MOEDA)
);

COMMENT ON TABLE IPAGTB035_TIPO_MOEDA IS
  'Dominio dos tipos de moeda utilizados no CNAB240. Campo G040 do padrao FEBRABAN. '
  'Exemplos: BRL=Real Brasileiro, USD=Dolar Americano, EUR=Euro.';
COMMENT ON COLUMN IPAGTB035_TIPO_MOEDA.ID_TIPO_MOEDA          IS 'Identificador surrogate gerado por sequence.';
COMMENT ON COLUMN IPAGTB035_TIPO_MOEDA.CO_TIPO_MOEDA          IS 'Sigla ISO 4217 da moeda. Campo G040. Exemplo: BRL, USD.';
COMMENT ON COLUMN IPAGTB035_TIPO_MOEDA.NO_TIPO_MOEDA          IS 'Nome completo da moeda. Exemplo: Real Brasileiro.';
COMMENT ON COLUMN IPAGTB035_TIPO_MOEDA.DH_INCLUSAO            IS 'Data e hora de inclusao.';
COMMENT ON COLUMN IPAGTB035_TIPO_MOEDA.DH_ALTERACAO           IS 'Data e hora da ultima alteracao.';
COMMENT ON COLUMN IPAGTB035_TIPO_MOEDA.NO_USUARIO_INCLUSAO    IS 'Login do usuario que incluiu.';
COMMENT ON COLUMN IPAGTB035_TIPO_MOEDA.NO_USUARIO_ALTERACAO   IS 'Login do usuario que alterou.';

-- ----------------------------------------------------------------------------
-- IPAGTB036_CAMARA_CENTRAL
-- ----------------------------------------------------------------------------
CREATE SEQUENCE IPAGTB036_CAMARA_CENTRAL_SQ START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE IPAGTB036_CAMARA_CENTRAL (
    ID_CAMARA_CENTRALIZADORA   NUMBER        DEFAULT ON NULL IPAGTB036_CAMARA_CENTRAL_SQ.NEXTVAL,
    NU_CAMARA_CENTRALIZADORA   CHAR(3)       NOT NULL,
    NO_CAMARA_CENTRALIZADORA   VARCHAR2(80)  NOT NULL,
    DH_INCLUSAO                DATE          DEFAULT SYSDATE NOT NULL,
    DH_ALTERACAO               DATE,
    NO_USUARIO_INCLUSAO        VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO       VARCHAR2(60),
    CONSTRAINT IPAGTB036_CAMARA_CENTRAL_PK   PRIMARY KEY (ID_CAMARA_CENTRALIZADORA),
    CONSTRAINT IPAGTB036_CAMARA_CENTRAL_UK01 UNIQUE (NU_CAMARA_CENTRALIZADORA)
);

COMMENT ON TABLE IPAGTB036_CAMARA_CENTRAL IS
  'Dominio dos codigos de camara centralizadora para roteamento de pagamentos. Campo P001 do '
  'padrao FEBRABAN. Identifica a via de liquidacao: TED, DOC, CC, PIX, etc.';
COMMENT ON COLUMN IPAGTB036_CAMARA_CENTRAL.ID_CAMARA_CENTRALIZADORA  IS 'Identificador surrogate gerado por sequence.';
COMMENT ON COLUMN IPAGTB036_CAMARA_CENTRAL.NU_CAMARA_CENTRALIZADORA  IS 'Codigo numerico de 3 digitos da camara. Campo P001. Exemplos: 000=CC/TED, 988=PIX.';
COMMENT ON COLUMN IPAGTB036_CAMARA_CENTRAL.NO_CAMARA_CENTRALIZADORA  IS 'Descricao da camara centralizadora. Exemplo: PIX - Sistema de Pagamentos Instantaneos.';
COMMENT ON COLUMN IPAGTB036_CAMARA_CENTRAL.DH_INCLUSAO               IS 'Data e hora de inclusao.';
COMMENT ON COLUMN IPAGTB036_CAMARA_CENTRAL.DH_ALTERACAO              IS 'Data e hora da ultima alteracao.';
COMMENT ON COLUMN IPAGTB036_CAMARA_CENTRAL.NO_USUARIO_INCLUSAO       IS 'Login do usuario que incluiu.';
COMMENT ON COLUMN IPAGTB036_CAMARA_CENTRAL.NO_USUARIO_ALTERACAO      IS 'Login do usuario que alterou.';


-- =============================================================================
-- SECAO 2: DADOS DE DOMINIO (INSERTs)
-- =============================================================================

INSERT INTO IPAGTB030_TIPO_REGISTRO (CO_TIPO_REGISTRO, NO_TIPO_REGISTRO, NO_USUARIO_INCLUSAO)
VALUES ('0', 'Header de Arquivo', 'SISTEMA');
INSERT INTO IPAGTB030_TIPO_REGISTRO (CO_TIPO_REGISTRO, NO_TIPO_REGISTRO, NO_USUARIO_INCLUSAO)
VALUES ('1', 'Header de Lote', 'SISTEMA');
INSERT INTO IPAGTB030_TIPO_REGISTRO (CO_TIPO_REGISTRO, NO_TIPO_REGISTRO, NO_USUARIO_INCLUSAO)
VALUES ('2', 'Registro Inicial de Lote', 'SISTEMA');
INSERT INTO IPAGTB030_TIPO_REGISTRO (CO_TIPO_REGISTRO, NO_TIPO_REGISTRO, NO_USUARIO_INCLUSAO)
VALUES ('3', 'Registro Detalhe', 'SISTEMA');
INSERT INTO IPAGTB030_TIPO_REGISTRO (CO_TIPO_REGISTRO, NO_TIPO_REGISTRO, NO_USUARIO_INCLUSAO)
VALUES ('4', 'Registro Final de Lote', 'SISTEMA');
INSERT INTO IPAGTB030_TIPO_REGISTRO (CO_TIPO_REGISTRO, NO_TIPO_REGISTRO, NO_USUARIO_INCLUSAO)
VALUES ('5', 'Trailer de Lote', 'SISTEMA');
INSERT INTO IPAGTB030_TIPO_REGISTRO (CO_TIPO_REGISTRO, NO_TIPO_REGISTRO, NO_USUARIO_INCLUSAO)
VALUES ('9', 'Trailer de Arquivo', 'SISTEMA');

INSERT INTO IPAGTB031_TIPO_SERVICO (CO_TIPO_SERVICO, NO_TIPO_SERVICO, NO_USUARIO_INCLUSAO)
VALUES ('01', 'Cobranca', 'SISTEMA');
INSERT INTO IPAGTB031_TIPO_SERVICO (CO_TIPO_SERVICO, NO_TIPO_SERVICO, NO_USUARIO_INCLUSAO)
VALUES ('03', 'Boleto de Pagamento Eletronico - Captura de Titulos', 'SISTEMA');
INSERT INTO IPAGTB031_TIPO_SERVICO (CO_TIPO_SERVICO, NO_TIPO_SERVICO, NO_USUARIO_INCLUSAO)
VALUES ('20', 'Pagamento Fornecedor', 'SISTEMA');
INSERT INTO IPAGTB031_TIPO_SERVICO (CO_TIPO_SERVICO, NO_TIPO_SERVICO, NO_USUARIO_INCLUSAO)
VALUES ('22', 'Pagamento de Salario', 'SISTEMA');
INSERT INTO IPAGTB031_TIPO_SERVICO (CO_TIPO_SERVICO, NO_TIPO_SERVICO, NO_USUARIO_INCLUSAO)
VALUES ('23', 'Pagamento Dividendos', 'SISTEMA');
INSERT INTO IPAGTB031_TIPO_SERVICO (CO_TIPO_SERVICO, NO_TIPO_SERVICO, NO_USUARIO_INCLUSAO)
VALUES ('24', 'Pagamento Beneficios', 'SISTEMA');
INSERT INTO IPAGTB031_TIPO_SERVICO (CO_TIPO_SERVICO, NO_TIPO_SERVICO, NO_USUARIO_INCLUSAO)
VALUES ('25', 'Pagamento Honorarios', 'SISTEMA');
INSERT INTO IPAGTB031_TIPO_SERVICO (CO_TIPO_SERVICO, NO_TIPO_SERVICO, NO_USUARIO_INCLUSAO)
VALUES ('30', 'Pagamento de Titulos de Cobranca', 'SISTEMA');
INSERT INTO IPAGTB031_TIPO_SERVICO (CO_TIPO_SERVICO, NO_TIPO_SERVICO, NO_USUARIO_INCLUSAO)
VALUES ('40', 'Vendor', 'SISTEMA');
INSERT INTO IPAGTB031_TIPO_SERVICO (CO_TIPO_SERVICO, NO_TIPO_SERVICO, NO_USUARIO_INCLUSAO)
VALUES ('41', 'Vendor a Termo', 'SISTEMA');
INSERT INTO IPAGTB031_TIPO_SERVICO (CO_TIPO_SERVICO, NO_TIPO_SERVICO, NO_USUARIO_INCLUSAO)
VALUES ('50', 'Pagamento Sinistros Seguradoras', 'SISTEMA');
INSERT INTO IPAGTB031_TIPO_SERVICO (CO_TIPO_SERVICO, NO_TIPO_SERVICO, NO_USUARIO_INCLUSAO)
VALUES ('60', 'Pagamento Despesas Viajante em Transito', 'SISTEMA');
INSERT INTO IPAGTB031_TIPO_SERVICO (CO_TIPO_SERVICO, NO_TIPO_SERVICO, NO_USUARIO_INCLUSAO)
VALUES ('70', 'Pagamento Autorizacao Comercio Eletronico', 'SISTEMA');
INSERT INTO IPAGTB031_TIPO_SERVICO (CO_TIPO_SERVICO, NO_TIPO_SERVICO, NO_USUARIO_INCLUSAO)
VALUES ('75', 'Pagamento de Creditos em Conta Corrente', 'SISTEMA');
INSERT INTO IPAGTB031_TIPO_SERVICO (CO_TIPO_SERVICO, NO_TIPO_SERVICO, NO_USUARIO_INCLUSAO)
VALUES ('77', 'Pagamento de Debitos de Conta Corrente', 'SISTEMA');
INSERT INTO IPAGTB031_TIPO_SERVICO (CO_TIPO_SERVICO, NO_TIPO_SERVICO, NO_USUARIO_INCLUSAO)
VALUES ('80', 'Extrato para Gestao de Caixa', 'SISTEMA');
INSERT INTO IPAGTB031_TIPO_SERVICO (CO_TIPO_SERVICO, NO_TIPO_SERVICO, NO_USUARIO_INCLUSAO)
VALUES ('90', 'Pagamento Tributos - Com Codigo de Barras', 'SISTEMA');
INSERT INTO IPAGTB031_TIPO_SERVICO (CO_TIPO_SERVICO, NO_TIPO_SERVICO, NO_USUARIO_INCLUSAO)
VALUES ('91', 'Pagamento Tributos - Sem Codigo de Barras', 'SISTEMA');
INSERT INTO IPAGTB031_TIPO_SERVICO (CO_TIPO_SERVICO, NO_TIPO_SERVICO, NO_USUARIO_INCLUSAO)
VALUES ('98', 'Debito em Conta Corrente', 'SISTEMA');
INSERT INTO IPAGTB031_TIPO_SERVICO (CO_TIPO_SERVICO, NO_TIPO_SERVICO, NO_USUARIO_INCLUSAO)
VALUES ('99', 'Pagamento de Emprestimo por Consignacao', 'SISTEMA');

INSERT INTO IPAGTB032_TIPO_OPERACAO (CO_TIPO_OPERACAO, NO_TIPO_OPERACAO, NO_USUARIO_INCLUSAO)
VALUES ('C', 'Credito', 'SISTEMA');
INSERT INTO IPAGTB032_TIPO_OPERACAO (CO_TIPO_OPERACAO, NO_TIPO_OPERACAO, NO_USUARIO_INCLUSAO)
VALUES ('D', 'Debito', 'SISTEMA');
INSERT INTO IPAGTB032_TIPO_OPERACAO (CO_TIPO_OPERACAO, NO_TIPO_OPERACAO, NO_USUARIO_INCLUSAO)
VALUES ('E', 'Extrato de Conta Corrente', 'SISTEMA');
INSERT INTO IPAGTB032_TIPO_OPERACAO (CO_TIPO_OPERACAO, NO_TIPO_OPERACAO, NO_USUARIO_INCLUSAO)
VALUES ('G', 'Extrato para Gestao de Caixa', 'SISTEMA');
INSERT INTO IPAGTB032_TIPO_OPERACAO (CO_TIPO_OPERACAO, NO_TIPO_OPERACAO, NO_USUARIO_INCLUSAO)
VALUES ('I', 'Informacoes de Titulos Capturados Boleto Eletronico', 'SISTEMA');
INSERT INTO IPAGTB032_TIPO_OPERACAO (CO_TIPO_OPERACAO, NO_TIPO_OPERACAO, NO_USUARIO_INCLUSAO)
VALUES ('R', 'Remessa', 'SISTEMA');
INSERT INTO IPAGTB032_TIPO_OPERACAO (CO_TIPO_OPERACAO, NO_TIPO_OPERACAO, NO_USUARIO_INCLUSAO)
VALUES ('T', 'Retorno', 'SISTEMA');

INSERT INTO IPAGTB033_TIPO_MOVIMENTO (CO_TIPO_MOVIMENTO, NO_TIPO_MOVIMENTO, NO_USUARIO_INCLUSAO)
VALUES ('0', 'Inclusao', 'SISTEMA');
INSERT INTO IPAGTB033_TIPO_MOVIMENTO (CO_TIPO_MOVIMENTO, NO_TIPO_MOVIMENTO, NO_USUARIO_INCLUSAO)
VALUES ('1', 'Consulta', 'SISTEMA');
INSERT INTO IPAGTB033_TIPO_MOVIMENTO (CO_TIPO_MOVIMENTO, NO_TIPO_MOVIMENTO, NO_USUARIO_INCLUSAO)
VALUES ('2', 'Suspensao Temporaria', 'SISTEMA');
INSERT INTO IPAGTB033_TIPO_MOVIMENTO (CO_TIPO_MOVIMENTO, NO_TIPO_MOVIMENTO, NO_USUARIO_INCLUSAO)
VALUES ('3', 'Entrada em Cartorio', 'SISTEMA');
INSERT INTO IPAGTB033_TIPO_MOVIMENTO (CO_TIPO_MOVIMENTO, NO_TIPO_MOVIMENTO, NO_USUARIO_INCLUSAO)
VALUES ('4', 'Retirada de Cartorio', 'SISTEMA');
INSERT INTO IPAGTB033_TIPO_MOVIMENTO (CO_TIPO_MOVIMENTO, NO_TIPO_MOVIMENTO, NO_USUARIO_INCLUSAO)
VALUES ('5', 'Alteracao', 'SISTEMA');
INSERT INTO IPAGTB033_TIPO_MOVIMENTO (CO_TIPO_MOVIMENTO, NO_TIPO_MOVIMENTO, NO_USUARIO_INCLUSAO)
VALUES ('7', 'Liquidacao', 'SISTEMA');
INSERT INTO IPAGTB033_TIPO_MOVIMENTO (CO_TIPO_MOVIMENTO, NO_TIPO_MOVIMENTO, NO_USUARIO_INCLUSAO)
VALUES ('9', 'Exclusao', 'SISTEMA');

INSERT INTO IPAGTB034_TIPO_INSCRICAO (CO_TIPO_INSCRICAO, NO_TIPO_INSCRICAO, NO_USUARIO_INCLUSAO)
VALUES ('0', 'Isento / Nao Informado', 'SISTEMA');
INSERT INTO IPAGTB034_TIPO_INSCRICAO (CO_TIPO_INSCRICAO, NO_TIPO_INSCRICAO, NO_USUARIO_INCLUSAO)
VALUES ('1', 'CPF - Cadastro de Pessoa Fisica', 'SISTEMA');
INSERT INTO IPAGTB034_TIPO_INSCRICAO (CO_TIPO_INSCRICAO, NO_TIPO_INSCRICAO, NO_USUARIO_INCLUSAO)
VALUES ('2', 'CNPJ - Cadastro Nacional de Pessoa Juridica', 'SISTEMA');
INSERT INTO IPAGTB034_TIPO_INSCRICAO (CO_TIPO_INSCRICAO, NO_TIPO_INSCRICAO, NO_USUARIO_INCLUSAO)
VALUES ('3', 'PIS / PASEP', 'SISTEMA');
INSERT INTO IPAGTB034_TIPO_INSCRICAO (CO_TIPO_INSCRICAO, NO_TIPO_INSCRICAO, NO_USUARIO_INCLUSAO)
VALUES ('9', 'Outros', 'SISTEMA');

INSERT INTO IPAGTB035_TIPO_MOEDA (CO_TIPO_MOEDA, NO_TIPO_MOEDA, NO_USUARIO_INCLUSAO)
VALUES ('BRL', 'Real Brasileiro', 'SISTEMA');
INSERT INTO IPAGTB035_TIPO_MOEDA (CO_TIPO_MOEDA, NO_TIPO_MOEDA, NO_USUARIO_INCLUSAO)
VALUES ('USD', 'Dolar Americano', 'SISTEMA');
INSERT INTO IPAGTB035_TIPO_MOEDA (CO_TIPO_MOEDA, NO_TIPO_MOEDA, NO_USUARIO_INCLUSAO)
VALUES ('EUR', 'Euro', 'SISTEMA');
INSERT INTO IPAGTB035_TIPO_MOEDA (CO_TIPO_MOEDA, NO_TIPO_MOEDA, NO_USUARIO_INCLUSAO)
VALUES ('BTN', 'BTN - BÃ´nus do Tesouro Nacional', 'SISTEMA');
INSERT INTO IPAGTB035_TIPO_MOEDA (CO_TIPO_MOEDA, NO_TIPO_MOEDA, NO_USUARIO_INCLUSAO)
VALUES ('OTN', 'OTN - Obrigacao do Tesouro Nacional', 'SISTEMA');
INSERT INTO IPAGTB035_TIPO_MOEDA (CO_TIPO_MOEDA, NO_TIPO_MOEDA, NO_USUARIO_INCLUSAO)
VALUES ('UFM', 'UFM - Unidade Fiscal Municipal', 'SISTEMA');
INSERT INTO IPAGTB035_TIPO_MOEDA (CO_TIPO_MOEDA, NO_TIPO_MOEDA, NO_USUARIO_INCLUSAO)
VALUES ('UFR', 'UFR - Unidade Fiscal de Referencia', 'SISTEMA');

INSERT INTO IPAGTB036_CAMARA_CENTRAL (NU_CAMARA_CENTRALIZADORA, NO_CAMARA_CENTRALIZADORA, NO_USUARIO_INCLUSAO)
VALUES ('000', 'Credito em Conta Corrente / TED no mesmo banco', 'SISTEMA');
INSERT INTO IPAGTB036_CAMARA_CENTRAL (NU_CAMARA_CENTRALIZADORA, NO_CAMARA_CENTRALIZADORA, NO_USUARIO_INCLUSAO)
VALUES ('018', 'TED - Transferencia Eletronica Disponivel (STR)', 'SISTEMA');
INSERT INTO IPAGTB036_CAMARA_CENTRAL (NU_CAMARA_CENTRALIZADORA, NO_CAMARA_CENTRALIZADORA, NO_USUARIO_INCLUSAO)
VALUES ('700', 'DOC - Documento de Ordem de Credito (Compensacao)', 'SISTEMA');
INSERT INTO IPAGTB036_CAMARA_CENTRAL (NU_CAMARA_CENTRALIZADORA, NO_CAMARA_CENTRALIZADORA, NO_USUARIO_INCLUSAO)
VALUES ('988', 'PIX - Sistema de Pagamento Instantaneo do Banco Central', 'SISTEMA');

COMMIT;


-- =============================================================================
-- SECAO 3: ENTIDADE RAIZ
-- =============================================================================

-- ----------------------------------------------------------------------------
-- IPAGTB001_ARQUIVO - Entidade raiz de todo arquivo CNAB240
-- ----------------------------------------------------------------------------
CREATE SEQUENCE IPAGTB001_ARQUIVO_SQ START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE IPAGTB001_ARQUIVO (
    ID_ARQUIVO             NUMBER          DEFAULT ON NULL IPAGTB001_ARQUIVO_SQ.NEXTVAL,
    NO_NOME_ARQUIVO        VARCHAR2(200)   NOT NULL,
    TE_CAMINHO_ARQUIVO     VARCHAR2(500)   NOT NULL,
    CO_REMESSA_RETORNO     CHAR(1)         NOT NULL,
    DH_GERACAO_ARQUIVO     DATE,
    NU_SEQUENCIAL_ARQUIVO  NUMBER(6)       NOT NULL,
    NU_BANCO_COMPENSACAO   NUMBER(3)       NOT NULL,
    IN_PROCESSADO          CHAR(1)         DEFAULT 'N' NOT NULL,
    NU_TAMANHO_BYTES       NUMBER(15),
    DH_CARGA              DATE,
    DH_INCLUSAO            DATE            DEFAULT SYSDATE NOT NULL,
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

CREATE INDEX IPAGTB001_ARQUIVO_IDX01 ON IPAGTB001_ARQUIVO (NU_BANCO_COMPENSACAO);
CREATE INDEX IPAGTB001_ARQUIVO_IDX02 ON IPAGTB001_ARQUIVO (DH_GERACAO_ARQUIVO);
CREATE INDEX IPAGTB001_ARQUIVO_IDX03 ON IPAGTB001_ARQUIVO (IN_PROCESSADO);

COMMENT ON TABLE IPAGTB001_ARQUIVO IS
  'Entidade raiz do modelo CNAB240. Representa um arquivo fisico recebido ou gerado no padrao '
  'FEBRABAN 240 posicoes. E o ponto de entrada da hierarquia Arquivo > Lote > Detalhe > Segmento. '
  'Cada registro corresponde a um arquivo distinto, identificado pelo nome fisico, banco e data.';
COMMENT ON COLUMN IPAGTB001_ARQUIVO.ID_ARQUIVO            IS 'Identificador surrogate gerado por sequence Oracle. Chave primaria interna sem significado de negocio.';
COMMENT ON COLUMN IPAGTB001_ARQUIVO.NO_NOME_ARQUIVO       IS 'Nome fisico do arquivo CNAB240, incluindo extensao. Exemplo: PAGAMENTOS_20260518.REM';
COMMENT ON COLUMN IPAGTB001_ARQUIVO.TE_CAMINHO_ARQUIVO    IS 'Caminho completo no sistema de arquivos onde o arquivo foi recebido ou gerado. Exemplo: /files/cnab/entrada/2026/05/';
COMMENT ON COLUMN IPAGTB001_ARQUIVO.CO_REMESSA_RETORNO    IS 'Indica se o arquivo e de Remessa (1) ou Retorno (2). Campo G015 do CNAB240. Remessa = empresa para banco; Retorno = banco para empresa.';
COMMENT ON COLUMN IPAGTB001_ARQUIVO.DH_GERACAO_ARQUIVO    IS 'Data e hora de geracao do arquivo conforme campos G016 (DDMMAAAA) e G017 (HHMMSS) do Header do Arquivo.';
COMMENT ON COLUMN IPAGTB001_ARQUIVO.NU_SEQUENCIAL_ARQUIVO IS 'Numero sequencial do arquivo no dia, gerado pelo emissor. Campo G018 do CNAB240. Ate 6 digitos.';
COMMENT ON COLUMN IPAGTB001_ARQUIVO.NU_BANCO_COMPENSACAO  IS 'Codigo do banco na camara de compensacao, conforme tabela FEBRABAN. Campo G001 do CNAB240. Exemplo: 341=Itau, 033=Santander.';
COMMENT ON COLUMN IPAGTB001_ARQUIVO.IN_PROCESSADO         IS 'Indicador se o arquivo ja foi processado pelo sistema. S=Sim, N=Nao. Permite controle de reprocessamento.';
COMMENT ON COLUMN IPAGTB001_ARQUIVO.NU_TAMANHO_BYTES      IS 'Tamanho fisico do arquivo em bytes no momento da carga. Util para auditoria e validacao de integridade.';
COMMENT ON COLUMN IPAGTB001_ARQUIVO.DH_CARGA              IS 'Data e hora em que o arquivo foi carregado no banco de dados. Difere da data de geracao do arquivo.';
COMMENT ON COLUMN IPAGTB001_ARQUIVO.DH_INCLUSAO           IS 'Data e hora de inclusao do registro.';
COMMENT ON COLUMN IPAGTB001_ARQUIVO.DH_ALTERACAO          IS 'Data e hora da ultima alteracao.';
COMMENT ON COLUMN IPAGTB001_ARQUIVO.NO_USUARIO_INCLUSAO   IS 'Login do usuario ou processo que incluiu o registro.';
COMMENT ON COLUMN IPAGTB001_ARQUIVO.NO_USUARIO_ALTERACAO  IS 'Login do usuario ou processo que realizou a ultima alteracao.';


-- ----------------------------------------------------------------------------
-- IPAGTB002_HEADER_ARQUIVO - Registro tipo 0, 1:1 com IPAGTB001
-- ----------------------------------------------------------------------------
CREATE SEQUENCE IPAGTB002_HEADER_ARQUIVO_SQ START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE IPAGTB002_HEADER_ARQUIVO (
    ID_HEADER_ARQUIVO          NUMBER        DEFAULT ON NULL IPAGTB002_HEADER_ARQUIVO_SQ.NEXTVAL,
    ID_ARQUIVO                 NUMBER        NOT NULL,
    -- G001: posicoes 1-3
    NU_BANCO_COMPENSACAO       NUMBER(3)     NOT NULL,
    -- G005: posicao 18
    CO_TIPO_INSCRICAO_EMPRESA  CHAR(1)       NOT NULL,
    -- G006: posicoes 19-32
    NU_INSCRICAO_EMPRESA       VARCHAR2(14)  NOT NULL,
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
    DH_INCLUSAO                DATE          DEFAULT SYSDATE NOT NULL,
    DH_ALTERACAO               DATE,
    NO_USUARIO_INCLUSAO        VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO       VARCHAR2(60),
    ID_TIPO_INSCRICAO          NUMBER,
    CONSTRAINT IPAGTB002_HEADER_ARQUIVO_PK   PRIMARY KEY (ID_HEADER_ARQUIVO),
    CONSTRAINT IPAGTB002_HEADER_ARQUIVO_UK01 UNIQUE (ID_ARQUIVO),
    CONSTRAINT IPAGTB001_IPAGTB002_FK01
        FOREIGN KEY (ID_ARQUIVO) REFERENCES IPAGTB001_ARQUIVO (ID_ARQUIVO),
    CONSTRAINT IPAGTB034_IPAGTB002_FK01
        FOREIGN KEY (ID_TIPO_INSCRICAO) REFERENCES IPAGTB034_TIPO_INSCRICAO (ID_TIPO_INSCRICAO),
    CONSTRAINT IPAGTB002_HEADER_ARQUIVO_CO_TIPO_INSC_CK01
        CHECK (CO_TIPO_INSCRICAO_EMPRESA IN ('0','1','2','3','9')),
    CONSTRAINT IPAGTB002_HEADER_ARQUIVO_CO_REMESSA_CK01
        CHECK (CO_REMESSA_RETORNO IN ('1','2'))
);

COMMENT ON TABLE IPAGTB002_HEADER_ARQUIVO IS
  'Armazena o registro Header de Arquivo (Tipo 0) do CNAB240. Existe exatamente um registro '
  'por arquivo fisico. Contem dados de identificacao do banco, empresa, conta e metadados do arquivo. '
  'Relacionamento 1:1 com IPAGTB001_ARQUIVO. Campos mapeados ao layout FEBRABAN posicoes 1-240.';
COMMENT ON COLUMN IPAGTB002_HEADER_ARQUIVO.ID_HEADER_ARQUIVO          IS 'Identificador surrogate gerado por sequence. Chave primaria interna.';
COMMENT ON COLUMN IPAGTB002_HEADER_ARQUIVO.ID_ARQUIVO                 IS 'Chave estrangeira para IPAGTB001_ARQUIVO. Associa o header ao arquivo pai.';
COMMENT ON COLUMN IPAGTB002_HEADER_ARQUIVO.NU_BANCO_COMPENSACAO       IS 'Codigo do banco na camara de compensacao. Campo G001. Posicoes 1-3. Exemplo: 341=Itau.';
COMMENT ON COLUMN IPAGTB002_HEADER_ARQUIVO.CO_TIPO_INSCRICAO_EMPRESA  IS 'Tipo de inscricao da empresa (pagador/beneficiario principal). Campo G005. Posicao 18. 1=CPF, 2=CNPJ.';
COMMENT ON COLUMN IPAGTB002_HEADER_ARQUIVO.NU_INSCRICAO_EMPRESA       IS 'Numero de inscricao (CPF/CNPJ) da empresa. Campo G006. Posicoes 19-32. Armazenado sem mascara.';
COMMENT ON COLUMN IPAGTB002_HEADER_ARQUIVO.CO_CONVENIO_BANCO          IS 'Codigo do convenio firmado com o banco para prestacao do servico. Campo G007. Posicoes 33-52.';
COMMENT ON COLUMN IPAGTB002_HEADER_ARQUIVO.NU_AGENCIA_EMPRESA         IS 'Numero da agencia bancaria da empresa. Campo G008. Posicoes 53-57.';
COMMENT ON COLUMN IPAGTB002_HEADER_ARQUIVO.CO_DV_AGENCIA_EMPRESA      IS 'Digito verificador da agencia. Campo G009. Posicao 58.';
COMMENT ON COLUMN IPAGTB002_HEADER_ARQUIVO.NU_CONTA_CORRENTE_EMPRESA  IS 'Numero da conta corrente da empresa. Campo G010. Posicoes 59-70.';
COMMENT ON COLUMN IPAGTB002_HEADER_ARQUIVO.CO_DV_CONTA_EMPRESA        IS 'Digito verificador da conta corrente. Campo G011. Posicao 71.';
COMMENT ON COLUMN IPAGTB002_HEADER_ARQUIVO.CO_DV_AGENCIA_CONTA        IS 'Digito verificador do conjunto agencia/conta. Campo G012. Posicao 72.';
COMMENT ON COLUMN IPAGTB002_HEADER_ARQUIVO.NO_EMPRESA                 IS 'Nome da empresa (pagador/beneficiario). Campo G013. Posicoes 73-102.';
COMMENT ON COLUMN IPAGTB002_HEADER_ARQUIVO.NO_BANCO                   IS 'Nome do banco conforme tabela FEBRABAN. Campo G014. Posicoes 103-132.';
COMMENT ON COLUMN IPAGTB002_HEADER_ARQUIVO.CO_REMESSA_RETORNO         IS 'Indica se e Remessa (1) ou Retorno (2). Campo G015. Posicao 143.';
COMMENT ON COLUMN IPAGTB002_HEADER_ARQUIVO.DH_GERACAO_ARQUIVO         IS 'Data e hora de geracao do arquivo, formada pela concatenacao dos campos G016 (posicoes 144-151 DDMMAAAA) e G017 (posicoes 152-157 HHMMSS).';
COMMENT ON COLUMN IPAGTB002_HEADER_ARQUIVO.NU_SEQUENCIAL_ARQUIVO      IS 'Numero sequencial do arquivo no dia. Campo G018. Posicoes 158-163.';
COMMENT ON COLUMN IPAGTB002_HEADER_ARQUIVO.NU_VERSAO_LAYOUT_ARQUIVO   IS 'Numero da versao do layout do arquivo. Campo G019. Posicoes 164-166. Valor padrao: 103 (v10.3).';
COMMENT ON COLUMN IPAGTB002_HEADER_ARQUIVO.NU_DENSIDADE_GRAVACAO      IS 'Densidade de gravacao do arquivo em bpi. Campo G020. Posicoes 167-171. Atualmente em desuso.';
COMMENT ON COLUMN IPAGTB002_HEADER_ARQUIVO.TE_RESERVADO_BANCO         IS 'Campo de uso reservado pelo banco. Campo G021. Posicoes 172-191.';
COMMENT ON COLUMN IPAGTB002_HEADER_ARQUIVO.TE_RESERVADO_EMPRESA       IS 'Campo de uso reservado pela empresa. Campo G022. Posicoes 192-211.';
COMMENT ON COLUMN IPAGTB002_HEADER_ARQUIVO.DH_INCLUSAO                IS 'Data e hora de inclusao do registro.';
COMMENT ON COLUMN IPAGTB002_HEADER_ARQUIVO.DH_ALTERACAO               IS 'Data e hora da ultima alteracao.';
COMMENT ON COLUMN IPAGTB002_HEADER_ARQUIVO.NO_USUARIO_INCLUSAO        IS 'Login do usuario ou processo que incluiu.';
COMMENT ON COLUMN IPAGTB002_HEADER_ARQUIVO.NO_USUARIO_ALTERACAO       IS 'Login do usuario ou processo que alterou.';


-- ----------------------------------------------------------------------------
-- IPAGTB003_TRAILER_ARQUIVO - Registro tipo 9, 1:1 com IPAGTB001
-- ----------------------------------------------------------------------------
CREATE SEQUENCE IPAGTB003_TRAILER_ARQUIVO_SQ START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE IPAGTB003_TRAILER_ARQUIVO (
    ID_TRAILER_ARQUIVO         NUMBER        DEFAULT ON NULL IPAGTB003_TRAILER_ARQUIVO_SQ.NEXTVAL,
    ID_ARQUIVO                 NUMBER        NOT NULL,
    -- G001: posicoes 1-3
    NU_BANCO_COMPENSACAO       NUMBER(3)     NOT NULL,
    -- G049: posicoes 18-23
    QT_LOTE_ARQUIVO           NUMBER(6)     NOT NULL,
    -- G056: posicoes 24-29
    QT_REGISTRO_ARQUIVO       NUMBER(6)     NOT NULL,
    -- G037: posicoes 30-35 (Qtde de contas para conciliacao)
    QT_CONTAS_CONCILIACAO      NUMBER(6),
    DH_INCLUSAO                DATE          DEFAULT SYSDATE NOT NULL,
    DH_ALTERACAO               DATE,
    NO_USUARIO_INCLUSAO        VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO       VARCHAR2(60),
    CONSTRAINT IPAGTB003_TRAILER_ARQUIVO_PK   PRIMARY KEY (ID_TRAILER_ARQUIVO),
    CONSTRAINT IPAGTB003_TRAILER_ARQUIVO_UK01 UNIQUE (ID_ARQUIVO),
    CONSTRAINT IPAGTB001_IPAGTB003_FK01
        FOREIGN KEY (ID_ARQUIVO) REFERENCES IPAGTB001_ARQUIVO (ID_ARQUIVO)
);

COMMENT ON TABLE IPAGTB003_TRAILER_ARQUIVO IS
  'Armazena o registro Trailer de Arquivo (Tipo 9) do CNAB240. Existe exatamente um por arquivo. '
  'Contem totalizadores de controle: quantidade de lotes e quantidade total de registros do arquivo. '
  'Relacionamento 1:1 com IPAGTB001_ARQUIVO.';
COMMENT ON COLUMN IPAGTB003_TRAILER_ARQUIVO.ID_TRAILER_ARQUIVO       IS 'Identificador surrogate gerado por sequence.';
COMMENT ON COLUMN IPAGTB003_TRAILER_ARQUIVO.ID_ARQUIVO               IS 'Chave estrangeira para IPAGTB001_ARQUIVO.';
COMMENT ON COLUMN IPAGTB003_TRAILER_ARQUIVO.NU_BANCO_COMPENSACAO     IS 'Codigo do banco na camara de compensacao. Campo G001. Posicoes 1-3.';
COMMENT ON COLUMN IPAGTB003_TRAILER_ARQUIVO.QT_LOTE_ARQUIVO         IS 'Quantidade total de lotes contidos no arquivo. Campo G049. Posicoes 18-23. Usado para validacao de integridade.';
COMMENT ON COLUMN IPAGTB003_TRAILER_ARQUIVO.QT_REGISTRO_ARQUIVO     IS 'Quantidade total de registros (linhas) do arquivo, incluindo header e trailer. Campo G056. Posicoes 24-29.';
COMMENT ON COLUMN IPAGTB003_TRAILER_ARQUIVO.QT_CONTAS_CONCILIACAO    IS 'Quantidade de contas para conciliacao bancaria. Campo G037. Posicoes 30-35. Uso especifico do servico de extrato.';
COMMENT ON COLUMN IPAGTB003_TRAILER_ARQUIVO.DH_INCLUSAO              IS 'Data e hora de inclusao.';
COMMENT ON COLUMN IPAGTB003_TRAILER_ARQUIVO.DH_ALTERACAO             IS 'Data e hora da ultima alteracao.';
COMMENT ON COLUMN IPAGTB003_TRAILER_ARQUIVO.NO_USUARIO_INCLUSAO      IS 'Login do usuario ou processo que incluiu.';
COMMENT ON COLUMN IPAGTB003_TRAILER_ARQUIVO.NO_USUARIO_ALTERACAO     IS 'Login do usuario ou processo que alterou.';


-- =============================================================================
-- SECAO 4: LOTE
-- =============================================================================

-- ----------------------------------------------------------------------------
-- IPAGTB004_LOTE - Agrupador de servico/produto, 1:N com IPAGTB001
-- ----------------------------------------------------------------------------
CREATE SEQUENCE IPAGTB004_LOTE_SQ START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE IPAGTB004_LOTE (
    ID_LOTE                    NUMBER        DEFAULT ON NULL IPAGTB004_LOTE_SQ.NEXTVAL,
    ID_ARQUIVO                 NUMBER        NOT NULL,
    -- G002: numero do lote dentro do arquivo
    NU_NUMERO_LOTE             NUMBER(4)     NOT NULL,
    -- G028: posicao 9 do header lote
    CO_TIPO_OPERACAO           CHAR(1)       NOT NULL,
    -- G025: posicoes 10-11
    CO_TIPO_SERVICO            CHAR(2)       NOT NULL,
    -- G029: posicoes 12-13
    NU_FORMA_LANCAMENTO        NUMBER(2),
    -- G030: posicoes 14-16
    NU_VERSAO_LAYOUT_LOTE      NUMBER(3),
    DH_INCLUSAO                DATE          DEFAULT SYSDATE NOT NULL,
    DH_ALTERACAO               DATE,
    NO_USUARIO_INCLUSAO        VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO       VARCHAR2(60),
    ID_TIPO_SERVICO            NUMBER,
    ID_TIPO_OPERACAO           NUMBER,
    CONSTRAINT IPAGTB004_LOTE_PK   PRIMARY KEY (ID_LOTE),
    CONSTRAINT IPAGTB004_LOTE_UK01 UNIQUE (ID_ARQUIVO, NU_NUMERO_LOTE),
    CONSTRAINT IPAGTB001_IPAGTB004_FK01
        FOREIGN KEY (ID_ARQUIVO) REFERENCES IPAGTB001_ARQUIVO (ID_ARQUIVO),
    CONSTRAINT IPAGTB031_IPAGTB004_FK01
        FOREIGN KEY (ID_TIPO_SERVICO) REFERENCES IPAGTB031_TIPO_SERVICO (ID_TIPO_SERVICO),
    CONSTRAINT IPAGTB032_IPAGTB004_FK01
        FOREIGN KEY (ID_TIPO_OPERACAO) REFERENCES IPAGTB032_TIPO_OPERACAO (ID_TIPO_OPERACAO),
    CONSTRAINT IPAGTB004_LOTE_CO_TIPO_OPERACAO_CK01
        CHECK (CO_TIPO_OPERACAO IN ('C','D','E','G','I','R','T'))
);

CREATE INDEX IPAGTB004_LOTE_IDX01 ON IPAGTB004_LOTE (ID_ARQUIVO);
CREATE INDEX IPAGTB004_LOTE_IDX02 ON IPAGTB004_LOTE (CO_TIPO_SERVICO);

COMMENT ON TABLE IPAGTB004_LOTE IS
  'Representa um Lote de Servico/Produto dentro do arquivo CNAB240. Um arquivo pode ter multiplos lotes. '
  'Cada lote contem exclusivamente um tipo de servico. Relacionamento N:1 com IPAGTB001_ARQUIVO '
  'e 1:1 com IPAGTB005_HEADER_LOTE e IPAGTB006_TRAILER_LOTE.';
COMMENT ON COLUMN IPAGTB004_LOTE.ID_LOTE               IS 'Identificador surrogate gerado por sequence.';
COMMENT ON COLUMN IPAGTB004_LOTE.ID_ARQUIVO             IS 'Chave estrangeira para IPAGTB001_ARQUIVO. Identifica o arquivo a que o lote pertence.';
COMMENT ON COLUMN IPAGTB004_LOTE.NU_NUMERO_LOTE         IS 'Numero sequencial do lote dentro do arquivo. Campo G002. Valor entre 0001 e 9998. Unico por arquivo.';
COMMENT ON COLUMN IPAGTB004_LOTE.CO_TIPO_OPERACAO       IS 'Tipo da operacao do lote. Campo G028. Posicao 9 do Header Lote. C=Credito, D=Debito, E=Extrato.';
COMMENT ON COLUMN IPAGTB004_LOTE.CO_TIPO_SERVICO        IS 'Tipo de servico/produto do lote. Campo G025. Posicoes 10-11. Exemplo: 20=Pag.Fornecedor, 01=Cobranca.';
COMMENT ON COLUMN IPAGTB004_LOTE.NU_FORMA_LANCAMENTO    IS 'Forma de lancamento dos pagamentos no lote. Campo G029. Posicoes 12-13.';
COMMENT ON COLUMN IPAGTB004_LOTE.NU_VERSAO_LAYOUT_LOTE  IS 'Versao do layout do lote conforme FEBRABAN. Campo G030. Posicoes 14-16.';
COMMENT ON COLUMN IPAGTB004_LOTE.DH_INCLUSAO            IS 'Data e hora de inclusao.';
COMMENT ON COLUMN IPAGTB004_LOTE.DH_ALTERACAO           IS 'Data e hora da ultima alteracao.';
COMMENT ON COLUMN IPAGTB004_LOTE.NO_USUARIO_INCLUSAO    IS 'Login do usuario ou processo que incluiu.';
COMMENT ON COLUMN IPAGTB004_LOTE.NO_USUARIO_ALTERACAO   IS 'Login do usuario ou processo que alterou.';


-- ----------------------------------------------------------------------------
-- IPAGTB005_HEADER_LOTE - Registro tipo 1, 1:1 com IPAGTB004
-- ----------------------------------------------------------------------------
CREATE SEQUENCE IPAGTB005_HEADER_LOTE_SQ START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE IPAGTB005_HEADER_LOTE (
    ID_HEADER_LOTE             NUMBER        DEFAULT ON NULL IPAGTB005_HEADER_LOTE_SQ.NEXTVAL,
    ID_LOTE                    NUMBER        NOT NULL,
    -- G001
    NU_BANCO_COMPENSACAO       NUMBER(3)     NOT NULL,
    -- Empresa
    CO_TIPO_INSCRICAO_EMPRESA  CHAR(1)       NOT NULL,
    NU_INSCRICAO_EMPRESA       VARCHAR2(14)  NOT NULL,
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
    DH_INCLUSAO                DATE          DEFAULT SYSDATE NOT NULL,
    DH_ALTERACAO               DATE,
    NO_USUARIO_INCLUSAO        VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO       VARCHAR2(60),
    ID_TIPO_INSCRICAO          NUMBER,
    CONSTRAINT IPAGTB005_HEADER_LOTE_PK   PRIMARY KEY (ID_HEADER_LOTE),
    CONSTRAINT IPAGTB005_HEADER_LOTE_UK01 UNIQUE (ID_LOTE),
    CONSTRAINT IPAGTB004_IPAGTB005_FK01
        FOREIGN KEY (ID_LOTE) REFERENCES IPAGTB004_LOTE (ID_LOTE),
    CONSTRAINT IPAGTB034_IPAGTB005_FK01
        FOREIGN KEY (ID_TIPO_INSCRICAO) REFERENCES IPAGTB034_TIPO_INSCRICAO (ID_TIPO_INSCRICAO),
    CONSTRAINT IPAGTB005_HEADER_LOTE_CO_TIPO_INSC_CK01
        CHECK (CO_TIPO_INSCRICAO_EMPRESA IN ('0','1','2','3','9'))
);

COMMENT ON TABLE IPAGTB005_HEADER_LOTE IS
  'Armazena o registro Header de Lote (Tipo 1) do CNAB240. Existe exatamente um por lote. '
  'Contem dados da empresa, endereco, convenio e metadados do lote. Relacionamento 1:1 com IPAGTB004_LOTE. '
  'Campos mapeados ao layout do Header Lote do servico de Pagamentos (posicoes 1-240).';
COMMENT ON COLUMN IPAGTB005_HEADER_LOTE.ID_HEADER_LOTE             IS 'Identificador surrogate gerado por sequence.';
COMMENT ON COLUMN IPAGTB005_HEADER_LOTE.ID_LOTE                    IS 'Chave estrangeira para IPAGTB004_LOTE. Relacionamento 1:1.';
COMMENT ON COLUMN IPAGTB005_HEADER_LOTE.NU_BANCO_COMPENSACAO       IS 'Codigo do banco na camara de compensacao. Campo G001. Posicoes 1-3.';
COMMENT ON COLUMN IPAGTB005_HEADER_LOTE.CO_TIPO_INSCRICAO_EMPRESA  IS 'Tipo de inscricao da empresa. Campo G005. Posicao 18. 1=CPF, 2=CNPJ.';
COMMENT ON COLUMN IPAGTB005_HEADER_LOTE.NU_INSCRICAO_EMPRESA       IS 'Numero CPF/CNPJ da empresa. Campo G006. Posicoes 19-32.';
COMMENT ON COLUMN IPAGTB005_HEADER_LOTE.CO_CONVENIO_BANCO          IS 'Codigo do convenio firmado com o banco. Campo G007. Posicoes 33-52.';
COMMENT ON COLUMN IPAGTB005_HEADER_LOTE.NU_AGENCIA_EMPRESA         IS 'Agencia bancaria da empresa. Campo G008. Posicoes 53-57.';
COMMENT ON COLUMN IPAGTB005_HEADER_LOTE.CO_DV_AGENCIA_EMPRESA      IS 'DV da agencia. Campo G009. Posicao 58.';
COMMENT ON COLUMN IPAGTB005_HEADER_LOTE.NU_CONTA_CORRENTE_EMPRESA  IS 'Numero da conta corrente da empresa. Campo G010. Posicoes 59-70.';
COMMENT ON COLUMN IPAGTB005_HEADER_LOTE.CO_DV_CONTA_EMPRESA        IS 'DV da conta corrente. Campo G011. Posicao 71.';
COMMENT ON COLUMN IPAGTB005_HEADER_LOTE.CO_DV_AGENCIA_CONTA        IS 'DV do conjunto agencia/conta. Campo G012. Posicao 72.';
COMMENT ON COLUMN IPAGTB005_HEADER_LOTE.NO_EMPRESA                 IS 'Nome da empresa. Campo G013. Posicoes 73-102.';
COMMENT ON COLUMN IPAGTB005_HEADER_LOTE.TE_MENSAGEM_LOTE           IS 'Mensagem ou finalidade do lote informada pela empresa. Campo G031. Posicoes 103-142.';
COMMENT ON COLUMN IPAGTB005_HEADER_LOTE.NO_LOGRADOURO_EMPRESA      IS 'Logradouro do endereco da empresa (rua, av, pca). Campo G032. Posicoes 143-172.';
COMMENT ON COLUMN IPAGTB005_HEADER_LOTE.NU_LOCAL_EMPRESA           IS 'Numero do local no logradouro. Campo G032. Posicoes 173-177.';
COMMENT ON COLUMN IPAGTB005_HEADER_LOTE.TE_COMPLEMENTO_EMPRESA     IS 'Complemento do endereco (apto, sala, bloco). Campo G032. Posicoes 178-192.';
COMMENT ON COLUMN IPAGTB005_HEADER_LOTE.NO_CIDADE_EMPRESA          IS 'Nome da cidade da empresa. Campo G033. Posicoes 193-212.';
COMMENT ON COLUMN IPAGTB005_HEADER_LOTE.NU_CEP_EMPRESA             IS 'CEP sem complemento. Campo G034. Posicoes 213-217.';
COMMENT ON COLUMN IPAGTB005_HEADER_LOTE.CO_COMPLEMENTO_CEP         IS 'Complemento do CEP (sufixo de 3 digitos). Campo G035. Posicoes 218-220.';
COMMENT ON COLUMN IPAGTB005_HEADER_LOTE.SG_ESTADO_EMPRESA          IS 'Sigla UF da empresa. Campo G036. Posicoes 221-222.';
COMMENT ON COLUMN IPAGTB005_HEADER_LOTE.NU_INDICATIVO_FORMA_PAGTO  IS 'Indicativo da forma de pagamento do servico. Campo P014. Posicoes 223-224.';
COMMENT ON COLUMN IPAGTB005_HEADER_LOTE.TE_OCORRENCIA             IS 'Codigos de ocorrencias de retorno do banco. Campo G059. Posicoes 231-240. Preenchido apenas em arquivo de retorno.';
COMMENT ON COLUMN IPAGTB005_HEADER_LOTE.DH_INCLUSAO                IS 'Data e hora de inclusao.';
COMMENT ON COLUMN IPAGTB005_HEADER_LOTE.DH_ALTERACAO               IS 'Data e hora da ultima alteracao.';
COMMENT ON COLUMN IPAGTB005_HEADER_LOTE.NO_USUARIO_INCLUSAO        IS 'Login do usuario ou processo que incluiu.';
COMMENT ON COLUMN IPAGTB005_HEADER_LOTE.NO_USUARIO_ALTERACAO       IS 'Login do usuario ou processo que alterou.';


-- ----------------------------------------------------------------------------
-- IPAGTB006_TRAILER_LOTE - Registro tipo 5, 1:1 com IPAGTB004
-- ----------------------------------------------------------------------------
CREATE SEQUENCE IPAGTB006_TRAILER_LOTE_SQ START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE IPAGTB006_TRAILER_LOTE (
    ID_TRAILER_LOTE            NUMBER          DEFAULT ON NULL IPAGTB006_TRAILER_LOTE_SQ.NEXTVAL,
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
    DH_INCLUSAO                DATE            DEFAULT SYSDATE NOT NULL,
    DH_ALTERACAO               DATE,
    NO_USUARIO_INCLUSAO        VARCHAR2(60)    NOT NULL,
    NO_USUARIO_ALTERACAO       VARCHAR2(60),
    CONSTRAINT IPAGTB006_TRAILER_LOTE_PK   PRIMARY KEY (ID_TRAILER_LOTE),
    CONSTRAINT IPAGTB006_TRAILER_LOTE_UK01 UNIQUE (ID_LOTE),
    CONSTRAINT IPAGTB004_IPAGTB006_FK01
        FOREIGN KEY (ID_LOTE) REFERENCES IPAGTB004_LOTE (ID_LOTE)
);

COMMENT ON TABLE IPAGTB006_TRAILER_LOTE IS
  'Armazena o registro Trailer de Lote (Tipo 5) do CNAB240. Existe exatamente um por lote. '
  'Contem totalizadores do lote: quantidade de registros, somatoria de valores e numero de aviso de debito. '
  'Relacionamento 1:1 com IPAGTB004_LOTE.';
COMMENT ON COLUMN IPAGTB006_TRAILER_LOTE.ID_TRAILER_LOTE         IS 'Identificador surrogate gerado por sequence.';
COMMENT ON COLUMN IPAGTB006_TRAILER_LOTE.ID_LOTE                 IS 'Chave estrangeira para IPAGTB004_LOTE.';
COMMENT ON COLUMN IPAGTB006_TRAILER_LOTE.NU_BANCO_COMPENSACAO    IS 'Codigo do banco na camara de compensacao. Campo G001.';
COMMENT ON COLUMN IPAGTB006_TRAILER_LOTE.QT_REGISTRO_LOTE       IS 'Quantidade total de registros do lote (incluindo header e trailer). Campo G057. Posicoes 18-23.';
COMMENT ON COLUMN IPAGTB006_TRAILER_LOTE.NU_SOMATORIA_VALOR    IS 'Somatoria dos valores de pagamento do lote, com 2 casas decimais. Posicoes 24-41. Usado para conferencia de integridade.';
COMMENT ON COLUMN IPAGTB006_TRAILER_LOTE.NU_SOMATORIA_QTDE_MOEDA IS 'Somatoria das quantidades de moeda do lote, com 5 casas decimais. Campo G058. Posicoes 42-59.';
COMMENT ON COLUMN IPAGTB006_TRAILER_LOTE.NU_NUMERO_AVISO_DEBITO  IS 'Numero do aviso de debito bancario. Campo G066. Posicoes 60-65.';
COMMENT ON COLUMN IPAGTB006_TRAILER_LOTE.TE_OCORRENCIA          IS 'Codigos de ocorrencias de retorno. Campo G059. Posicoes 231-240.';
COMMENT ON COLUMN IPAGTB006_TRAILER_LOTE.DH_INCLUSAO             IS 'Data e hora de inclusao.';
COMMENT ON COLUMN IPAGTB006_TRAILER_LOTE.DH_ALTERACAO            IS 'Data e hora da ultima alteracao.';
COMMENT ON COLUMN IPAGTB006_TRAILER_LOTE.NO_USUARIO_INCLUSAO     IS 'Login do usuario ou processo que incluiu.';
COMMENT ON COLUMN IPAGTB006_TRAILER_LOTE.NO_USUARIO_ALTERACAO    IS 'Login do usuario ou processo que alterou.';


-- =============================================================================
-- SECAO 5: DETALHE (agrupador de segmentos de um mesmo registro)
-- =============================================================================

-- ----------------------------------------------------------------------------
-- IPAGTB007_DETALHE_REG - Registro tipo 3, 1:N com IPAGTB004
-- ----------------------------------------------------------------------------
CREATE SEQUENCE IPAGTB007_DETALHE_REG_SQ START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE IPAGTB007_DETALHE_REG (
    ID_DETALHE_REG             NUMBER        DEFAULT ON NULL IPAGTB007_DETALHE_REG_SQ.NEXTVAL,
    ID_LOTE                    NUMBER        NOT NULL,
    -- G038: posicoes 9-13 (numero sequencial do registro no lote)
    NU_SEQUENCIAL_REGISTRO     NUMBER(5)     NOT NULL,
    -- G039: posicao 14 (segmento principal do registro: A, B, J, N, O, P, etc.)
    CO_SEGMENTO_PRINCIPAL      CHAR(1)       NOT NULL,
    -- G060: posicao 15
    CO_TIPO_MOVIMENTO          CHAR(1)       NOT NULL,
    -- G061: posicoes 16-17
    NU_CODIGO_INSTRUCAO_MOV    NUMBER(2),
    DH_INCLUSAO                DATE          DEFAULT SYSDATE NOT NULL,
    DH_ALTERACAO               DATE,
    NO_USUARIO_INCLUSAO        VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO       VARCHAR2(60),
    ID_TIPO_MOVIMENTO          NUMBER,
    CONSTRAINT IPAGTB007_DETALHE_REG_PK   PRIMARY KEY (ID_DETALHE_REG),
    CONSTRAINT IPAGTB007_DETALHE_REG_UK01 UNIQUE (ID_LOTE, NU_SEQUENCIAL_REGISTRO),
    CONSTRAINT IPAGTB004_IPAGTB007_FK01
        FOREIGN KEY (ID_LOTE) REFERENCES IPAGTB004_LOTE (ID_LOTE),
    CONSTRAINT IPAGTB033_IPAGTB007_FK01
        FOREIGN KEY (ID_TIPO_MOVIMENTO) REFERENCES IPAGTB033_TIPO_MOVIMENTO (ID_TIPO_MOVIMENTO)
);

CREATE INDEX IPAGTB007_DETALHE_REG_IDX01 ON IPAGTB007_DETALHE_REG (ID_LOTE);
CREATE INDEX IPAGTB007_DETALHE_REG_IDX02 ON IPAGTB007_DETALHE_REG (CO_SEGMENTO_PRINCIPAL);

COMMENT ON TABLE IPAGTB007_DETALHE_REG IS
  'Agrupa os segmentos de um mesmo registro de detalhe CNAB240 (Tipo 3). Um registro de detalhe '
  'pode conter um ou mais segmentos (ex: A+B, J+J52, N+W). Esta tabela e o pai de todas as tabelas '
  'de segmentos. Relacionamento N:1 com IPAGTB004_LOTE e 1:0..1 com cada tabela de segmento.';
COMMENT ON COLUMN IPAGTB007_DETALHE_REG.ID_DETALHE_REG          IS 'Identificador surrogate gerado por sequence. Chave primaria interna.';
COMMENT ON COLUMN IPAGTB007_DETALHE_REG.ID_LOTE                 IS 'Chave estrangeira para IPAGTB004_LOTE. Identifica o lote ao qual o detalhe pertence.';
COMMENT ON COLUMN IPAGTB007_DETALHE_REG.NU_SEQUENCIAL_REGISTRO  IS 'Numero sequencial do registro de detalhe dentro do lote. Campo G038. Posicoes 9-13.';
COMMENT ON COLUMN IPAGTB007_DETALHE_REG.CO_SEGMENTO_PRINCIPAL   IS 'Codigo do segmento principal do registro. Campo G039. Posicao 14. Exemplos: A, B, J, N, O, P, Q.';
COMMENT ON COLUMN IPAGTB007_DETALHE_REG.CO_TIPO_MOVIMENTO       IS 'Tipo do movimento/instrucao. Campo G060. Posicao 15. 0=Inclusao, 5=Alteracao, 9=Exclusao.';
COMMENT ON COLUMN IPAGTB007_DETALHE_REG.NU_CODIGO_INSTRUCAO_MOV IS 'Codigo da instrucao para o movimento. Campo G061. Posicoes 16-17. Especifica a operacao detalhada.';
COMMENT ON COLUMN IPAGTB007_DETALHE_REG.DH_INCLUSAO             IS 'Data e hora de inclusao.';
COMMENT ON COLUMN IPAGTB007_DETALHE_REG.DH_ALTERACAO            IS 'Data e hora da ultima alteracao.';
COMMENT ON COLUMN IPAGTB007_DETALHE_REG.NO_USUARIO_INCLUSAO     IS 'Login do usuario ou processo que incluiu.';
COMMENT ON COLUMN IPAGTB007_DETALHE_REG.NO_USUARIO_ALTERACAO    IS 'Login do usuario ou processo que alterou.';

-- =============================================================================
-- SECAO 6: SEGMENTOS DE PAGAMENTO (Credito/Debito/TED/DOC/PIX)
-- =============================================================================

-- ----------------------------------------------------------------------------
-- IPAGTB010_DET_PAGAMENTO - Segmento A (Obrigatorio - Remessa/Retorno)
--   Pagamento por Credito CC, DOC, TED, PIX
--   Ref: pagina 25 do Layout CNAB240 V10.9
-- ----------------------------------------------------------------------------
CREATE SEQUENCE IPAGTB010_DET_PAGAMENTO_SQ START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE IPAGTB010_DET_PAGAMENTO (
    ID_SEG_A                   NUMBER          DEFAULT ON NULL IPAGTB010_DET_PAGAMENTO_SQ.NEXTVAL,
    ID_DETALHE_REG             NUMBER          NOT NULL,
    NU_CAMARA_CENTRALIZADORA   NUMBER(3)       NOT NULL,
    NU_BANCO_FAVORECIDO        NUMBER(3),
    NU_AGENCIA_FAVORECIDO      NUMBER(5),
    CO_DV_AGENCIA_FAVORECIDO   CHAR(1),
    NU_CONTA_CORRENTE_FAVO     VARCHAR2(12),
    CO_DV_CONTA_FAVORECIDO     CHAR(1),
    CO_DV_AGENCIA_CONTA_FAVO   CHAR(1),
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
    DH_INCLUSAO                DATE            DEFAULT SYSDATE NOT NULL,
    DH_ALTERACAO               DATE,
    NO_USUARIO_INCLUSAO        VARCHAR2(60)    NOT NULL,
    NO_USUARIO_ALTERACAO       VARCHAR2(60),
    ID_TIPO_MOEDA              NUMBER,
    ID_CAMARA_CENTRALIZADORA   NUMBER,
    CONSTRAINT IPAGTB010_DET_PAGAMENTO_PK   PRIMARY KEY (ID_SEG_A),
    CONSTRAINT IPAGTB010_DET_PAGAMENTO_UK01 UNIQUE (ID_DETALHE_REG),
    CONSTRAINT IPAGTB007_IPAGTB010_FK01
        FOREIGN KEY (ID_DETALHE_REG) REFERENCES IPAGTB007_DETALHE_REG (ID_DETALHE_REG),
    CONSTRAINT IPAGTB035_IPAGTB010_FK01
        FOREIGN KEY (ID_TIPO_MOEDA) REFERENCES IPAGTB035_TIPO_MOEDA (ID_TIPO_MOEDA),
    CONSTRAINT IPAGTB036_IPAGTB010_FK01
        FOREIGN KEY (ID_CAMARA_CENTRALIZADORA) REFERENCES IPAGTB036_CAMARA_CENTRAL (ID_CAMARA_CENTRALIZADORA)
);
CREATE INDEX IPAGTB010_DET_PAGAMENTO_IDX01 ON IPAGTB010_DET_PAGAMENTO (DH_PAGAMENTO);
CREATE INDEX IPAGTB010_DET_PAGAMENTO_IDX02 ON IPAGTB010_DET_PAGAMENTO (NU_BANCO_FAVORECIDO, NU_AGENCIA_FAVORECIDO);

COMMENT ON TABLE IPAGTB010_DET_PAGAMENTO IS 'Segmento A do CNAB240. Obrigatorio nos servicos de Pagamento (Credito CC, DOC, TED, PIX) e Debito em Conta. Contem dados do favorecido (banco, agencia, conta) e do pagamento (valor, data, finalidade). Relacionamento 0:1 com IPAGTB007_DETALHE_REG. Layout ref: pagina 25.';
COMMENT ON COLUMN IPAGTB010_DET_PAGAMENTO.ID_SEG_A                   IS 'Identificador surrogate gerado por sequence.';
COMMENT ON COLUMN IPAGTB010_DET_PAGAMENTO.ID_DETALHE_REG             IS 'Chave estrangeira para IPAGTB007_DETALHE_REG. Unico por detalhe (0:1).';
COMMENT ON COLUMN IPAGTB010_DET_PAGAMENTO.NU_CAMARA_CENTRALIZADORA   IS 'Codigo da camara centralizadora de liquidacao. Campo P001. Posicoes 18-20. Ex: 000=CC, 018=TED, 988=PIX.';
COMMENT ON COLUMN IPAGTB010_DET_PAGAMENTO.NU_BANCO_FAVORECIDO        IS 'Codigo do banco do favorecido. Campo P002. Posicoes 21-23.';
COMMENT ON COLUMN IPAGTB010_DET_PAGAMENTO.NU_AGENCIA_FAVORECIDO      IS 'Agencia do favorecido. Campo G008. Posicoes 24-28.';
COMMENT ON COLUMN IPAGTB010_DET_PAGAMENTO.CO_DV_AGENCIA_FAVORECIDO   IS 'DV da agencia do favorecido. Campo G009. Posicao 29.';
COMMENT ON COLUMN IPAGTB010_DET_PAGAMENTO.NU_CONTA_CORRENTE_FAVO     IS 'Conta corrente do favorecido. Campo G010. Posicoes 30-41.';
COMMENT ON COLUMN IPAGTB010_DET_PAGAMENTO.CO_DV_CONTA_FAVORECIDO     IS 'DV da conta do favorecido. Campo G011. Posicao 42.';
COMMENT ON COLUMN IPAGTB010_DET_PAGAMENTO.CO_DV_AGENCIA_CONTA_FAVO   IS 'DV conjunto agencia/conta do favorecido. Campo G012. Posicao 43.';
COMMENT ON COLUMN IPAGTB010_DET_PAGAMENTO.NO_FAVORECIDO              IS 'Nome do favorecido. Campo G013. Posicoes 44-73.';
COMMENT ON COLUMN IPAGTB010_DET_PAGAMENTO.NU_DOCUMENTO_EMPRESA       IS 'Numero do documento da empresa (seu numero). Campo G064. Posicoes 74-93.';
COMMENT ON COLUMN IPAGTB010_DET_PAGAMENTO.DH_PAGAMENTO               IS 'Data do pagamento convertida de DDMMAAAA. Campo P009. Posicoes 94-101.';
COMMENT ON COLUMN IPAGTB010_DET_PAGAMENTO.CO_TIPO_MOEDA              IS 'Tipo da moeda. Campo G040. Posicoes 102-104. Exemplo: BRL.';
COMMENT ON COLUMN IPAGTB010_DET_PAGAMENTO.NU_QUANTIDADE_MOEDA        IS 'Quantidade de moeda com 5 decimais. Campo G041. Posicoes 105-119.';
COMMENT ON COLUMN IPAGTB010_DET_PAGAMENTO.NU_VALOR_PAGAMENTO         IS 'Valor do pagamento com 2 decimais. Campo P010. Posicoes 120-134.';
COMMENT ON COLUMN IPAGTB010_DET_PAGAMENTO.NU_DOCUMENTO_BANCO         IS 'Numero do documento do banco (nosso numero). Campo G043. Posicoes 135-154.';
COMMENT ON COLUMN IPAGTB010_DET_PAGAMENTO.DH_DATA_REAL_EFETIVACAO    IS 'Data real de efetivacao convertida de DDMMAAAA. Campo P003. Posicoes 155-162. Preenchida no retorno.';
COMMENT ON COLUMN IPAGTB010_DET_PAGAMENTO.NU_VALOR_REAL_EFETIVACAO   IS 'Valor real da efetivacao. Campo P004. Posicoes 163-177. Preenchido no retorno.';
COMMENT ON COLUMN IPAGTB010_DET_PAGAMENTO.TE_OUTRAS_INFORMACOES      IS 'Informacoes complementares (deposito judicial, SIAPE, PIX). Campo G031. Posicoes 178-217.';
COMMENT ON COLUMN IPAGTB010_DET_PAGAMENTO.CO_FINALIDADE_DOC          IS 'Codigo de finalidade do DOC. Campo P005. Posicoes 218-219.';
COMMENT ON COLUMN IPAGTB010_DET_PAGAMENTO.CO_FINALIDADE_TED          IS 'Codigo de finalidade da TED. Campo P011. Posicoes 220-224.';
COMMENT ON COLUMN IPAGTB010_DET_PAGAMENTO.CO_FINALIDADE_COMPLEMENTAR IS 'Complemento de finalidade do pagamento. Campo P013. Posicoes 225-226.';
COMMENT ON COLUMN IPAGTB010_DET_PAGAMENTO.IN_AVISO_FAVORECIDO        IS 'Indicador de aviso ao favorecido. Campo P006. Posicao 230.';
COMMENT ON COLUMN IPAGTB010_DET_PAGAMENTO.TE_OCORRENCIA             IS 'Codigos de ocorrencias de retorno. Campo G059. Posicoes 231-240.';
COMMENT ON COLUMN IPAGTB010_DET_PAGAMENTO.DH_INCLUSAO                IS 'Data e hora de inclusao.';
COMMENT ON COLUMN IPAGTB010_DET_PAGAMENTO.DH_ALTERACAO               IS 'Data e hora da ultima alteracao.';
COMMENT ON COLUMN IPAGTB010_DET_PAGAMENTO.NO_USUARIO_INCLUSAO        IS 'Login do usuario que incluiu.';
COMMENT ON COLUMN IPAGTB010_DET_PAGAMENTO.NO_USUARIO_ALTERACAO       IS 'Login do usuario que alterou.';

-- ----------------------------------------------------------------------------
-- IPAGTB011_DET_INFO_FAVORECIDO - Segmento B (Complementar - PIX/Endereco)
--   Ref: pagina 26 do Layout CNAB240 V10.9
-- ----------------------------------------------------------------------------
CREATE SEQUENCE IPAGTB011_DET_INFO_FAVORECIDO_SQ START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE IPAGTB011_DET_INFO_FAVORECIDO (
    ID_SEG_B                    NUMBER         DEFAULT ON NULL IPAGTB011_DET_INFO_FAVORECIDO_SQ.NEXTVAL,
    ID_DETALHE_REG              NUMBER         NOT NULL,
    CO_IDENTIFICACAO_FAVORECIDO VARCHAR2(3),
    CO_TIPO_INSCRICAO_FAVO      CHAR(1),
    NU_INSCRICAO_FAVORECIDO     VARCHAR2(14),
    TE_INFORMACAO_10            VARCHAR2(35),
    TE_INFORMACAO_11            VARCHAR2(60),
    TE_INFORMACAO_12            VARCHAR2(99),
    NU_CODIGO_UG_CENTRALIZADORA NUMBER(6),
    NU_CODIGO_ISPB              NUMBER(8),
    DH_INCLUSAO                 DATE           DEFAULT SYSDATE NOT NULL,
    DH_ALTERACAO                DATE,
    NO_USUARIO_INCLUSAO         VARCHAR2(60)   NOT NULL,
    NO_USUARIO_ALTERACAO        VARCHAR2(60),
    ID_TIPO_INSCRICAO           NUMBER,
    CONSTRAINT IPAGTB011_DET_INFO_FAVORECIDO_PK   PRIMARY KEY (ID_SEG_B),
    CONSTRAINT IPAGTB011_DET_INFO_FAVORECIDO_UK01 UNIQUE (ID_DETALHE_REG),
    CONSTRAINT IPAGTB007_IPAGTB011_FK01
        FOREIGN KEY (ID_DETALHE_REG) REFERENCES IPAGTB007_DETALHE_REG (ID_DETALHE_REG),
    CONSTRAINT IPAGTB034_IPAGTB011_FK01
        FOREIGN KEY (ID_TIPO_INSCRICAO) REFERENCES IPAGTB034_TIPO_INSCRICAO (ID_TIPO_INSCRICAO)
);

COMMENT ON TABLE IPAGTB011_DET_INFO_FAVORECIDO IS 'Segmento B do CNAB240. Complementar ao Segmento A. Contem dados adicionais do favorecido: inscricao e informacoes complementares variaveis (endereco para DOC/TED ou chave PIX). Layout ref: pagina 26.';
COMMENT ON COLUMN IPAGTB011_DET_INFO_FAVORECIDO.ID_SEG_B                    IS 'Identificador surrogate gerado por sequence.';
COMMENT ON COLUMN IPAGTB011_DET_INFO_FAVORECIDO.ID_DETALHE_REG              IS 'Chave estrangeira para IPAGTB007_DETALHE_REG.';
COMMENT ON COLUMN IPAGTB011_DET_INFO_FAVORECIDO.CO_IDENTIFICACAO_FAVORECIDO IS 'Forma de iniciacao PIX. Campo G100. Posicoes 15-17. Ex: 01=CPF/CNPJ, 02=Celular, 04=Chave Aleatoria.';
COMMENT ON COLUMN IPAGTB011_DET_INFO_FAVORECIDO.CO_TIPO_INSCRICAO_FAVO      IS 'Tipo de inscricao do favorecido. Campo G005. Posicao 18.';
COMMENT ON COLUMN IPAGTB011_DET_INFO_FAVORECIDO.NU_INSCRICAO_FAVORECIDO     IS 'CPF/CNPJ do favorecido. Campo G006. Posicoes 19-32.';
COMMENT ON COLUMN IPAGTB011_DET_INFO_FAVORECIDO.TE_INFORMACAO_10            IS 'Dados complementares 1 (35 chars). Campo G101. Posicoes 33-67. Para endereco: logradouro; para PIX: chave.';
COMMENT ON COLUMN IPAGTB011_DET_INFO_FAVORECIDO.TE_INFORMACAO_11            IS 'Dados complementares 2 (60 chars). Campo G101. Posicoes 68-127.';
COMMENT ON COLUMN IPAGTB011_DET_INFO_FAVORECIDO.TE_INFORMACAO_12            IS 'Dados complementares 3 (99 chars). Campo G101. Posicoes 128-226. Para endereco: cidade/CEP/estado.';
COMMENT ON COLUMN IPAGTB011_DET_INFO_FAVORECIDO.NU_CODIGO_UG_CENTRALIZADORA IS 'Codigo Unidade Gestora Centralizadora. Campo P012. Posicoes 227-232. Uso exclusivo SIAPE.';
COMMENT ON COLUMN IPAGTB011_DET_INFO_FAVORECIDO.NU_CODIGO_ISPB              IS 'Codigo ISPB do banco do favorecido. Campo P015. Posicoes 233-240.';
COMMENT ON COLUMN IPAGTB011_DET_INFO_FAVORECIDO.DH_INCLUSAO                 IS 'Data e hora de inclusao.';
COMMENT ON COLUMN IPAGTB011_DET_INFO_FAVORECIDO.DH_ALTERACAO                IS 'Data e hora da ultima alteracao.';
COMMENT ON COLUMN IPAGTB011_DET_INFO_FAVORECIDO.NO_USUARIO_INCLUSAO         IS 'Login do usuario que incluiu.';
COMMENT ON COLUMN IPAGTB011_DET_INFO_FAVORECIDO.NO_USUARIO_ALTERACAO        IS 'Login do usuario que alterou.';

-- ----------------------------------------------------------------------------
-- IPAGTB012_DET_COMPLEMENTAR - Segmento C (Opcional - Deducoes e conta substituta)
--   Ref: pagina 27 do Layout CNAB240 V10.9
-- ----------------------------------------------------------------------------
CREATE SEQUENCE IPAGTB012_DET_COMPLEMENTAR_SQ START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE IPAGTB012_DET_COMPLEMENTAR (
    ID_SEG_C                   NUMBER          DEFAULT ON NULL IPAGTB012_DET_COMPLEMENTAR_SQ.NEXTVAL,
    ID_DETALHE_REG             NUMBER          NOT NULL,
    NU_VALOR_IR                NUMBER(15,2),
    NU_VALOR_ISS               NUMBER(15,2),
    NU_VALOR_IOF               NUMBER(15,2),
    NU_VALOR_OUTRAS_DEDUCOES   NUMBER(15,2),
    NU_VALOR_OUTROS_ACRESCIMOS NUMBER(15,2),
    NU_AGENCIA_SUBSTITUTA      NUMBER(5),
    CO_DV_AGENCIA_SUBSTITUTA   CHAR(1),
    NU_CONTA_CORRENTE_SUBST    VARCHAR2(12),
    CO_DV_CONTA_SUBSTITUTA     CHAR(1),
    CO_DV_AGCONTA_SUBSTITUTA   CHAR(1),
    NU_VALOR_INSS              NUMBER(15,2),
    NU_CONTA_PAGAMENTO_CREDIT  VARCHAR2(20),
    DH_INCLUSAO                DATE            DEFAULT SYSDATE NOT NULL,
    DH_ALTERACAO               DATE,
    NO_USUARIO_INCLUSAO        VARCHAR2(60)    NOT NULL,
    NO_USUARIO_ALTERACAO       VARCHAR2(60),
    CONSTRAINT IPAGTB012_DET_COMPLEMENTAR_PK   PRIMARY KEY (ID_SEG_C),
    CONSTRAINT IPAGTB012_DET_COMPLEMENTAR_UK01 UNIQUE (ID_DETALHE_REG),
    CONSTRAINT IPAGTB007_IPAGTB012_FK01
        FOREIGN KEY (ID_DETALHE_REG) REFERENCES IPAGTB007_DETALHE_REG (ID_DETALHE_REG)
);

COMMENT ON TABLE IPAGTB012_DET_COMPLEMENTAR IS 'Segmento C do CNAB240. Opcional nos pagamentos. Contem valores de deducoes (IR, ISS, IOF, INSS) e dados de conta substituta quando a agencia original foi fechada ou fundida. Layout ref: pagina 27.';
COMMENT ON COLUMN IPAGTB012_DET_COMPLEMENTAR.ID_SEG_C                    IS 'Identificador surrogate gerado por sequence.';
COMMENT ON COLUMN IPAGTB012_DET_COMPLEMENTAR.ID_DETALHE_REG              IS 'Chave estrangeira para IPAGTB007_DETALHE_REG.';
COMMENT ON COLUMN IPAGTB012_DET_COMPLEMENTAR.NU_VALOR_IR                 IS 'Valor do IR a deduzir. Campo G050. Posicoes 18-32.';
COMMENT ON COLUMN IPAGTB012_DET_COMPLEMENTAR.NU_VALOR_ISS                IS 'Valor do ISS a deduzir. Campo G051. Posicoes 33-47.';
COMMENT ON COLUMN IPAGTB012_DET_COMPLEMENTAR.NU_VALOR_IOF                IS 'Valor do IOF a deduzir. Campo G052. Posicoes 48-62.';
COMMENT ON COLUMN IPAGTB012_DET_COMPLEMENTAR.NU_VALOR_OUTRAS_DEDUCOES    IS 'Valor de outras deducoes. Campo G053. Posicoes 63-77.';
COMMENT ON COLUMN IPAGTB012_DET_COMPLEMENTAR.NU_VALOR_OUTROS_ACRESCIMOS  IS 'Valor de outros acrescimos. Campo G054. Posicoes 78-92.';
COMMENT ON COLUMN IPAGTB012_DET_COMPLEMENTAR.NU_AGENCIA_SUBSTITUTA       IS 'Agencia substituta quando a original foi encerrada. Campo G008. Posicoes 93-97.';
COMMENT ON COLUMN IPAGTB012_DET_COMPLEMENTAR.CO_DV_AGENCIA_SUBSTITUTA    IS 'DV da agencia substituta. Campo G009. Posicao 98.';
COMMENT ON COLUMN IPAGTB012_DET_COMPLEMENTAR.NU_CONTA_CORRENTE_SUBST     IS 'Conta substituta. Campo G010. Posicoes 99-110.';
COMMENT ON COLUMN IPAGTB012_DET_COMPLEMENTAR.CO_DV_CONTA_SUBSTITUTA      IS 'DV da conta substituta. Campo G011. Posicao 111.';
COMMENT ON COLUMN IPAGTB012_DET_COMPLEMENTAR.CO_DV_AGCONTA_SUBSTITUTA    IS 'DV conjunto agencia/conta substituta. Campo G012. Posicao 112.';
COMMENT ON COLUMN IPAGTB012_DET_COMPLEMENTAR.NU_VALOR_INSS               IS 'Valor do INSS a deduzir. Campo G055. Posicoes 113-127.';
COMMENT ON COLUMN IPAGTB012_DET_COMPLEMENTAR.NU_CONTA_PAGAMENTO_CREDIT   IS 'Numero da conta de pagamento creditada. Campo P016. Posicoes 128-147.';
COMMENT ON COLUMN IPAGTB012_DET_COMPLEMENTAR.DH_INCLUSAO                 IS 'Data e hora de inclusao.';
COMMENT ON COLUMN IPAGTB012_DET_COMPLEMENTAR.DH_ALTERACAO                IS 'Data e hora da ultima alteracao.';
COMMENT ON COLUMN IPAGTB012_DET_COMPLEMENTAR.NO_USUARIO_INCLUSAO         IS 'Login do usuario que incluiu.';
COMMENT ON COLUMN IPAGTB012_DET_COMPLEMENTAR.NO_USUARIO_ALTERACAO        IS 'Login do usuario que alterou.';

-- =============================================================================
-- SECAO 7: SEGMENTOS DE PAGAMENTO DE TITULOS E QR CODE PIX
-- =============================================================================

-- ----------------------------------------------------------------------------
-- IPAGTB013_DET_TITULO_COBRANCA - Segmento J (Obrigatorio - Pagamento Titulos/Boleto)
--   Ref: pagina 30 do Layout CNAB240 V10.9
-- ----------------------------------------------------------------------------
CREATE SEQUENCE IPAGTB013_DET_TITULO_COBRANCA_SQ START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE IPAGTB013_DET_TITULO_COBRANCA (
    ID_SEG_J                     NUMBER        DEFAULT ON NULL IPAGTB013_DET_TITULO_COBRANCA_SQ.NEXTVAL,
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
    DH_INCLUSAO                  DATE          DEFAULT SYSDATE NOT NULL,
    DH_ALTERACAO                 DATE,
    NO_USUARIO_INCLUSAO          VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO         VARCHAR2(60),
    CONSTRAINT IPAGTB013_DET_TITULO_COBRANCA_PK   PRIMARY KEY (ID_SEG_J),
    CONSTRAINT IPAGTB013_DET_TITULO_COBRANCA_UK01 UNIQUE (ID_DETALHE_REG),
    CONSTRAINT IPAGTB007_IPAGTB013_FK01
        FOREIGN KEY (ID_DETALHE_REG) REFERENCES IPAGTB007_DETALHE_REG (ID_DETALHE_REG)
);
CREATE INDEX IPAGTB013_DET_TITULO_COBRANCA_IDX01 ON IPAGTB013_DET_TITULO_COBRANCA (DH_PAGAMENTO);
CREATE INDEX IPAGTB013_DET_TITULO_COBRANCA_IDX02 ON IPAGTB013_DET_TITULO_COBRANCA (NU_CODIGO_BARRAS);

COMMENT ON TABLE IPAGTB013_DET_TITULO_COBRANCA IS 'Segmento J do CNAB240. Obrigatorio no pagamento de Titulos de Cobranca e QR Code Pix. Contem codigo de barras, nome do beneficiario, vencimento e valores. Layout ref: pagina 30.';
COMMENT ON COLUMN IPAGTB013_DET_TITULO_COBRANCA.ID_SEG_J                     IS 'Identificador surrogate gerado por sequence.';
COMMENT ON COLUMN IPAGTB013_DET_TITULO_COBRANCA.ID_DETALHE_REG               IS 'Chave estrangeira para IPAGTB007_DETALHE_REG.';
COMMENT ON COLUMN IPAGTB013_DET_TITULO_COBRANCA.NU_CODIGO_BARRAS             IS 'Codigo de barras do titulo/boleto. Campo G063. Posicoes 18-61. 44 digitos numericos.';
COMMENT ON COLUMN IPAGTB013_DET_TITULO_COBRANCA.NO_BENEFICIARIO              IS 'Nome do beneficiario (cedente). Campo G013. Posicoes 62-91.';
COMMENT ON COLUMN IPAGTB013_DET_TITULO_COBRANCA.DH_VENCIMENTO                IS 'Data de vencimento nominal do titulo. Campo G044. Posicoes 92-99 (DDMMAAAA).';
COMMENT ON COLUMN IPAGTB013_DET_TITULO_COBRANCA.NU_VALOR_TITULO              IS 'Valor nominal do titulo. Campo G042. Posicoes 100-114.';
COMMENT ON COLUMN IPAGTB013_DET_TITULO_COBRANCA.NU_VALOR_DESCONTO_ABATIMENTO IS 'Valor de desconto mais abatimento. Campo L002. Posicoes 115-129.';
COMMENT ON COLUMN IPAGTB013_DET_TITULO_COBRANCA.NU_VALOR_MORA_MULTA          IS 'Valor de mora mais multa. Campo L003. Posicoes 130-144.';
COMMENT ON COLUMN IPAGTB013_DET_TITULO_COBRANCA.DH_PAGAMENTO                 IS 'Data do pagamento. Campo P009. Posicoes 145-152 (DDMMAAAA).';
COMMENT ON COLUMN IPAGTB013_DET_TITULO_COBRANCA.NU_VALOR_PAGAMENTO           IS 'Valor total do pagamento. Campo P010. Posicoes 153-167.';
COMMENT ON COLUMN IPAGTB013_DET_TITULO_COBRANCA.NU_QUANTIDADE_MOEDA          IS 'Quantidade de moeda para titulos indexados. Campo G041. Posicoes 168-182.';
COMMENT ON COLUMN IPAGTB013_DET_TITULO_COBRANCA.NU_DOCUMENTO_EMPRESA         IS 'Numero do documento da empresa. Campo G064. Posicoes 183-202.';
COMMENT ON COLUMN IPAGTB013_DET_TITULO_COBRANCA.NU_DOCUMENTO_BANCO           IS 'Numero do documento do banco. Campo G043. Posicoes 203-222.';
COMMENT ON COLUMN IPAGTB013_DET_TITULO_COBRANCA.CO_CODIGO_MOEDA              IS 'Codigo da moeda. Campo G065. Posicoes 223-224.';
COMMENT ON COLUMN IPAGTB013_DET_TITULO_COBRANCA.TE_OCORRENCIA               IS 'Codigos de ocorrencias de retorno. Campo G059. Posicoes 231-240.';
COMMENT ON COLUMN IPAGTB013_DET_TITULO_COBRANCA.DH_INCLUSAO                  IS 'Data e hora de inclusao.';
COMMENT ON COLUMN IPAGTB013_DET_TITULO_COBRANCA.DH_ALTERACAO                 IS 'Data e hora da ultima alteracao.';
COMMENT ON COLUMN IPAGTB013_DET_TITULO_COBRANCA.NO_USUARIO_INCLUSAO          IS 'Login do usuario que incluiu.';
COMMENT ON COLUMN IPAGTB013_DET_TITULO_COBRANCA.NO_USUARIO_ALTERACAO         IS 'Login do usuario que alterou.';

-- ----------------------------------------------------------------------------
-- IPAGTB014_DET_PARTES_TITULO - Segmento J-52 (Pagador/Beneficiario/Sacador)
--   Ref: pagina 31 do Layout CNAB240 V10.9
-- ----------------------------------------------------------------------------
CREATE SEQUENCE IPAGTB014_DET_PARTES_TITULO_SQ START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE IPAGTB014_DET_PARTES_TITULO (
    ID_SEG_J52                 NUMBER        DEFAULT ON NULL IPAGTB014_DET_PARTES_TITULO_SQ.NEXTVAL,
    ID_DETALHE_REG             NUMBER        NOT NULL,
    CO_IDENTIFICACAO_REG       VARCHAR2(2)   DEFAULT '52' NOT NULL,
    CO_TIPO_INSCRICAO_PAGADOR  CHAR(1),
    NU_INSCRICAO_PAGADOR       VARCHAR2(15),
    NO_PAGADOR                 VARCHAR2(40),
    CO_TIPO_INSCRICAO_BENEF    CHAR(1),
    NU_INSCRICAO_BENEFICIARIO  VARCHAR2(15),
    NO_BENEFICIARIO            VARCHAR2(40),
    CO_TIPO_INSCRICAO_SACADOR  CHAR(1),
    NU_INSCRICAO_SACADOR       VARCHAR2(15),
    NO_SACADOR                 VARCHAR2(40),
    DH_INCLUSAO                DATE          DEFAULT SYSDATE NOT NULL,
    DH_ALTERACAO               DATE,
    NO_USUARIO_INCLUSAO        VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO       VARCHAR2(60),
    ID_TIPO_INSCRICAO_PAGADOR  NUMBER,
    ID_TIPO_INSCRICAO_BENEF    NUMBER,
    ID_TIPO_INSCRICAO_SACADOR  NUMBER,
    CONSTRAINT IPAGTB014_DET_PARTES_TITULO_PK   PRIMARY KEY (ID_SEG_J52),
    CONSTRAINT IPAGTB014_DET_PARTES_TITULO_UK01 UNIQUE (ID_DETALHE_REG),
    CONSTRAINT IPAGTB007_IPAGTB014_FK01
        FOREIGN KEY (ID_DETALHE_REG) REFERENCES IPAGTB007_DETALHE_REG (ID_DETALHE_REG),
    CONSTRAINT IPAGTB034_IPAGTB014_FK01
        FOREIGN KEY (ID_TIPO_INSCRICAO_PAGADOR) REFERENCES IPAGTB034_TIPO_INSCRICAO (ID_TIPO_INSCRICAO),
    CONSTRAINT IPAGTB034_IPAGTB014_FK02
        FOREIGN KEY (ID_TIPO_INSCRICAO_BENEF) REFERENCES IPAGTB034_TIPO_INSCRICAO (ID_TIPO_INSCRICAO),
    CONSTRAINT IPAGTB034_IPAGTB014_FK03
        FOREIGN KEY (ID_TIPO_INSCRICAO_SACADOR) REFERENCES IPAGTB034_TIPO_INSCRICAO (ID_TIPO_INSCRICAO)
);

COMMENT ON TABLE IPAGTB014_DET_PARTES_TITULO IS 'Segmento J-52 do CNAB240. Obrigatorio no pagamento de titulos. Contem identificacao do Pagador, Beneficiario e Sacador/Avalista (beneficiario original do titulo). Campo G067=52 nas posicoes 18-19. Layout ref: pagina 31.';
COMMENT ON COLUMN IPAGTB014_DET_PARTES_TITULO.ID_SEG_J52                IS 'Identificador surrogate gerado por sequence.';
COMMENT ON COLUMN IPAGTB014_DET_PARTES_TITULO.ID_DETALHE_REG            IS 'Chave estrangeira para IPAGTB007_DETALHE_REG.';
COMMENT ON COLUMN IPAGTB014_DET_PARTES_TITULO.CO_IDENTIFICACAO_REG      IS 'Identificacao do registro opcional. Campo G067. Posicoes 18-19. Valor fixo 52.';
COMMENT ON COLUMN IPAGTB014_DET_PARTES_TITULO.CO_TIPO_INSCRICAO_PAGADOR IS 'Tipo de inscricao do pagador. Campo G005. Posicao 20.';
COMMENT ON COLUMN IPAGTB014_DET_PARTES_TITULO.NU_INSCRICAO_PAGADOR      IS 'CPF/CNPJ do pagador. Campo G006. Posicoes 21-35.';
COMMENT ON COLUMN IPAGTB014_DET_PARTES_TITULO.NO_PAGADOR                IS 'Nome do pagador. Campo G013. Posicoes 36-75.';
COMMENT ON COLUMN IPAGTB014_DET_PARTES_TITULO.CO_TIPO_INSCRICAO_BENEF   IS 'Tipo de inscricao do beneficiario. Campo G005. Posicao 76.';
COMMENT ON COLUMN IPAGTB014_DET_PARTES_TITULO.NU_INSCRICAO_BENEFICIARIO IS 'CPF/CNPJ do beneficiario. Campo G006. Posicoes 77-91.';
COMMENT ON COLUMN IPAGTB014_DET_PARTES_TITULO.NO_BENEFICIARIO           IS 'Nome do beneficiario (cedente). Campo G013. Posicoes 92-131.';
COMMENT ON COLUMN IPAGTB014_DET_PARTES_TITULO.CO_TIPO_INSCRICAO_SACADOR IS 'Tipo de inscricao do sacador/avalista. Campo G005. Posicao 132.';
COMMENT ON COLUMN IPAGTB014_DET_PARTES_TITULO.NU_INSCRICAO_SACADOR      IS 'CPF/CNPJ do sacador/avalista. Campo G006. Posicoes 133-147.';
COMMENT ON COLUMN IPAGTB014_DET_PARTES_TITULO.NO_SACADOR                IS 'Nome do sacador/avalista (beneficiario original do titulo). Campo G013. Posicoes 148-187.';
COMMENT ON COLUMN IPAGTB014_DET_PARTES_TITULO.DH_INCLUSAO               IS 'Data e hora de inclusao.';
COMMENT ON COLUMN IPAGTB014_DET_PARTES_TITULO.DH_ALTERACAO              IS 'Data e hora da ultima alteracao.';
COMMENT ON COLUMN IPAGTB014_DET_PARTES_TITULO.NO_USUARIO_INCLUSAO       IS 'Login do usuario que incluiu.';
COMMENT ON COLUMN IPAGTB014_DET_PARTES_TITULO.NO_USUARIO_ALTERACAO      IS 'Login do usuario que alterou.';

-- ----------------------------------------------------------------------------
-- IPAGTB015_DET_PIX_QR_CODE - Segmento J-52 PIX (Chave/TXID QR Code)
--   Ref: pagina 32 do Layout CNAB240 V10.9
-- ----------------------------------------------------------------------------
CREATE SEQUENCE IPAGTB015_DET_PIX_QR_CODE_SQ START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE IPAGTB015_DET_PIX_QR_CODE (
    ID_SEG_J52_PIX             NUMBER        DEFAULT ON NULL IPAGTB015_DET_PIX_QR_CODE_SQ.NEXTVAL,
    ID_DETALHE_REG             NUMBER        NOT NULL,
    CO_IDENTIFICACAO_REG       VARCHAR2(2)   DEFAULT '52' NOT NULL,
    CO_TIPO_INSCRICAO_DEVEDOR  CHAR(1),
    NU_INSCRICAO_DEVEDOR       VARCHAR2(15),
    NO_DEVEDOR                 VARCHAR2(40),
    CO_TIPO_INSCRICAO_FAVO     CHAR(1),
    NU_INSCRICAO_FAVORECIDO    VARCHAR2(15),
    NO_FAVORECIDO              VARCHAR2(40),
    TE_CHAVE_PAGAMENTO_PIX     VARCHAR2(79),
    CO_TXID_QRCODE             VARCHAR2(30),
    DH_INCLUSAO                DATE          DEFAULT SYSDATE NOT NULL,
    DH_ALTERACAO               DATE,
    NO_USUARIO_INCLUSAO        VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO       VARCHAR2(60),
    ID_TIPO_INSCRICAO_DEVEDOR  NUMBER,
    ID_TIPO_INSCRICAO_FAVO     NUMBER,
    CONSTRAINT IPAGTB015_DET_PIX_QR_CODE_PK   PRIMARY KEY (ID_SEG_J52_PIX),
    CONSTRAINT IPAGTB015_DET_PIX_QR_CODE_UK01 UNIQUE (ID_DETALHE_REG),
    CONSTRAINT IPAGTB007_IPAGTB015_FK01
        FOREIGN KEY (ID_DETALHE_REG) REFERENCES IPAGTB007_DETALHE_REG (ID_DETALHE_REG),
    CONSTRAINT IPAGTB034_IPAGTB015_FK01
        FOREIGN KEY (ID_TIPO_INSCRICAO_DEVEDOR) REFERENCES IPAGTB034_TIPO_INSCRICAO (ID_TIPO_INSCRICAO),
    CONSTRAINT IPAGTB034_IPAGTB015_FK02
        FOREIGN KEY (ID_TIPO_INSCRICAO_FAVO) REFERENCES IPAGTB034_TIPO_INSCRICAO (ID_TIPO_INSCRICAO)
);

COMMENT ON TABLE IPAGTB015_DET_PIX_QR_CODE IS 'Segmento J-52 PIX do CNAB240. Variante do J-52 para pagamentos via QR Code. Contem identificacao do devedor, favorecido e a chave de enderecamento PIX (CPF, CNPJ, email, celular ou chave aleatoria) mais o TXID. Layout ref: pagina 32.';
COMMENT ON COLUMN IPAGTB015_DET_PIX_QR_CODE.ID_SEG_J52_PIX            IS 'Identificador surrogate gerado por sequence.';
COMMENT ON COLUMN IPAGTB015_DET_PIX_QR_CODE.ID_DETALHE_REG            IS 'Chave estrangeira para IPAGTB007_DETALHE_REG.';
COMMENT ON COLUMN IPAGTB015_DET_PIX_QR_CODE.CO_IDENTIFICACAO_REG      IS 'Identificacao do registro opcional. Campo G067. Valor fixo 52. Posicoes 18-19.';
COMMENT ON COLUMN IPAGTB015_DET_PIX_QR_CODE.CO_TIPO_INSCRICAO_DEVEDOR IS 'Tipo de inscricao do devedor. Campo G005. Posicao 20.';
COMMENT ON COLUMN IPAGTB015_DET_PIX_QR_CODE.NU_INSCRICAO_DEVEDOR      IS 'CPF/CNPJ do devedor. Campo G006. Posicoes 21-35.';
COMMENT ON COLUMN IPAGTB015_DET_PIX_QR_CODE.NO_DEVEDOR                IS 'Nome do devedor. Campo G013. Posicoes 36-75.';
COMMENT ON COLUMN IPAGTB015_DET_PIX_QR_CODE.CO_TIPO_INSCRICAO_FAVO    IS 'Tipo de inscricao do favorecido. Campo G005. Posicao 76.';
COMMENT ON COLUMN IPAGTB015_DET_PIX_QR_CODE.NU_INSCRICAO_FAVORECIDO   IS 'CPF/CNPJ do favorecido. Campo G006. Posicoes 77-91.';
COMMENT ON COLUMN IPAGTB015_DET_PIX_QR_CODE.NO_FAVORECIDO             IS 'Nome do favorecido. Campo G013. Posicoes 92-131.';
COMMENT ON COLUMN IPAGTB015_DET_PIX_QR_CODE.TE_CHAVE_PAGAMENTO_PIX    IS 'Chave de enderecamento PIX (URL, CPF, CNPJ, celular, email ou chave aleatoria). Campo G102. Posicoes 132-210.';
COMMENT ON COLUMN IPAGTB015_DET_PIX_QR_CODE.CO_TXID_QRCODE            IS 'TXID do QR Code PIX. Campo G102. Posicoes 211-240.';
COMMENT ON COLUMN IPAGTB015_DET_PIX_QR_CODE.DH_INCLUSAO               IS 'Data e hora de inclusao.';
COMMENT ON COLUMN IPAGTB015_DET_PIX_QR_CODE.DH_ALTERACAO              IS 'Data e hora da ultima alteracao.';
COMMENT ON COLUMN IPAGTB015_DET_PIX_QR_CODE.NO_USUARIO_INCLUSAO       IS 'Login do usuario que incluiu.';
COMMENT ON COLUMN IPAGTB015_DET_PIX_QR_CODE.NO_USUARIO_ALTERACAO      IS 'Login do usuario que alterou.';

-- =============================================================================
-- SECAO 8: SEGMENTOS DE TRIBUTOS (N, O, W, Z)
-- =============================================================================

-- ----------------------------------------------------------------------------
-- IPAGTB016_DET_TRIBUTO_SEM_CB - Segmento N (Tributos sem Codigo de Barras)
--   Ref: pagina 36 do Layout CNAB240 V10.9
-- ----------------------------------------------------------------------------
CREATE SEQUENCE IPAGTB016_DET_TRIBUTO_SEM_CB_SQ START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE IPAGTB016_DET_TRIBUTO_SEM_CB (
    ID_SEG_N                     NUMBER        DEFAULT ON NULL IPAGTB016_DET_TRIBUTO_SEM_CB_SQ.NEXTVAL,
    ID_DETALHE_REG               NUMBER        NOT NULL,
    NU_DOCUMENTO_EMPRESA         VARCHAR2(20),
    NU_DOCUMENTO_BANCO           VARCHAR2(20),
    NO_CONTRIBUINTE              VARCHAR2(30),
    DH_PAGAMENTO                 DATE          NOT NULL,
    NU_VALOR_TOTAL_PAGAMENTO     NUMBER(15,2)  NOT NULL,
    -- Informacoes complementares variaveis por tipo de tributo (posicoes 111-230)
    CO_RECEITA_TRIBUTO           VARCHAR2(6),
    CO_TIPO_IDENTIFICACAO_CONT   VARCHAR2(2),
    NU_IDENTIFICACAO_CONTRIB     VARCHAR2(14),
    CO_IDENTIFICACAO_TRIBUTO     VARCHAR2(2),
    TE_PERIODO_APURACAO          VARCHAR2(8),
    NU_REFERENCIA_TRIBUTO        VARCHAR2(17),
    NU_VALOR_PRINCIPAL           NUMBER(15,2),
    NU_VALOR_MULTA               NUMBER(15,2),
    NU_VALOR_JUROS_ENCARGOS      NUMBER(15,2),
    DH_VENCIMENTO                DATE,
    TE_INFORMACOES_LIVRES        VARCHAR2(120),
    TE_OCORRENCIA               CHAR(10),
    DH_INCLUSAO                  DATE          DEFAULT SYSDATE NOT NULL,
    DH_ALTERACAO                 DATE,
    NO_USUARIO_INCLUSAO          VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO         VARCHAR2(60),
    CONSTRAINT IPAGTB016_DET_TRIBUTO_SEM_CB_PK   PRIMARY KEY (ID_SEG_N),
    CONSTRAINT IPAGTB016_DET_TRIBUTO_SEM_CB_UK01 UNIQUE (ID_DETALHE_REG),
    CONSTRAINT IPAGTB007_IPAGTB016_FK01
        FOREIGN KEY (ID_DETALHE_REG) REFERENCES IPAGTB007_DETALHE_REG (ID_DETALHE_REG)
);
CREATE INDEX IPAGTB016_DET_TRIBUTO_SEM_CB_IDX01 ON IPAGTB016_DET_TRIBUTO_SEM_CB (DH_PAGAMENTO);

COMMENT ON TABLE IPAGTB016_DET_TRIBUTO_SEM_CB IS 'Segmento N do CNAB240. Obrigatorio no pagamento de Tributos e Impostos sem Codigo de Barras. Cobre GPS, DARF, DARF Simples, GARE-SP, IPVA, DPVAT, Licenciamento e DARJ. As informacoes complementares (posicoes 111-230) variam conforme o tipo de tributo. Layout ref: pagina 36.';
COMMENT ON COLUMN IPAGTB016_DET_TRIBUTO_SEM_CB.ID_SEG_N                     IS 'Identificador surrogate gerado por sequence.';
COMMENT ON COLUMN IPAGTB016_DET_TRIBUTO_SEM_CB.ID_DETALHE_REG               IS 'Chave estrangeira para IPAGTB007_DETALHE_REG.';
COMMENT ON COLUMN IPAGTB016_DET_TRIBUTO_SEM_CB.NU_DOCUMENTO_EMPRESA         IS 'Numero do documento da empresa. Campo G064. Posicoes 18-37.';
COMMENT ON COLUMN IPAGTB016_DET_TRIBUTO_SEM_CB.NU_DOCUMENTO_BANCO           IS 'Numero do documento do banco. Campo G043. Posicoes 38-57.';
COMMENT ON COLUMN IPAGTB016_DET_TRIBUTO_SEM_CB.NO_CONTRIBUINTE              IS 'Nome do contribuinte. Campo G013. Posicoes 58-87.';
COMMENT ON COLUMN IPAGTB016_DET_TRIBUTO_SEM_CB.DH_PAGAMENTO                 IS 'Data do pagamento do tributo. Campo P009. Posicoes 88-95 (DDMMAAAA).';
COMMENT ON COLUMN IPAGTB016_DET_TRIBUTO_SEM_CB.NU_VALOR_TOTAL_PAGAMENTO     IS 'Valor total do pagamento do tributo. Campo P010. Posicoes 96-110.';
COMMENT ON COLUMN IPAGTB016_DET_TRIBUTO_SEM_CB.CO_RECEITA_TRIBUTO           IS 'Codigo da receita do tributo. Campo N002. Posicoes 111-116. Ex: 6106 para DARF Simples.';
COMMENT ON COLUMN IPAGTB016_DET_TRIBUTO_SEM_CB.CO_TIPO_IDENTIFICACAO_CONT   IS 'Tipo de identificacao do contribuinte. Campo N003. Posicoes 117-118.';
COMMENT ON COLUMN IPAGTB016_DET_TRIBUTO_SEM_CB.NU_IDENTIFICACAO_CONTRIB     IS 'Numero de identificacao do contribuinte (CPF/CNPJ/RENAVAM). Campo N004. Posicoes 119-132.';
COMMENT ON COLUMN IPAGTB016_DET_TRIBUTO_SEM_CB.CO_IDENTIFICACAO_TRIBUTO     IS 'Codigo de identificacao do tributo (ex: codigo da acao judicial). Campo N005. Posicoes 133-134.';
COMMENT ON COLUMN IPAGTB016_DET_TRIBUTO_SEM_CB.TE_PERIODO_APURACAO          IS 'Periodo de apuracao do tributo (DDMMAAAA ou MMAAAA). Campo N006/N008. Posicoes 135-142.';
COMMENT ON COLUMN IPAGTB016_DET_TRIBUTO_SEM_CB.NU_REFERENCIA_TRIBUTO        IS 'Numero de referencia do tributo (ex: numero DARF). Campo N009. Posicoes 143-159.';
COMMENT ON COLUMN IPAGTB016_DET_TRIBUTO_SEM_CB.NU_VALOR_PRINCIPAL           IS 'Valor principal do tributo. Campo G042. Posicoes 160-174.';
COMMENT ON COLUMN IPAGTB016_DET_TRIBUTO_SEM_CB.NU_VALOR_MULTA               IS 'Valor da multa do tributo. Campo G048. Posicoes 175-189.';
COMMENT ON COLUMN IPAGTB016_DET_TRIBUTO_SEM_CB.NU_VALOR_JUROS_ENCARGOS      IS 'Valor dos juros e encargos. Campo G047. Posicoes 190-204.';
COMMENT ON COLUMN IPAGTB016_DET_TRIBUTO_SEM_CB.DH_VENCIMENTO                IS 'Data de vencimento do tributo. Campo G044. Posicoes 205-212 (DDMMAAAA).';
COMMENT ON COLUMN IPAGTB016_DET_TRIBUTO_SEM_CB.TE_INFORMACOES_LIVRES        IS 'Demais informacoes complementares especificas do tributo, nao mapeadas em colunas separadas. Posicoes 111-230 (trecho remanescente).';
COMMENT ON COLUMN IPAGTB016_DET_TRIBUTO_SEM_CB.TE_OCORRENCIA               IS 'Codigos de ocorrencias de retorno. Campo G059. Posicoes 231-240.';
COMMENT ON COLUMN IPAGTB016_DET_TRIBUTO_SEM_CB.DH_INCLUSAO                  IS 'Data e hora de inclusao.';
COMMENT ON COLUMN IPAGTB016_DET_TRIBUTO_SEM_CB.DH_ALTERACAO                 IS 'Data e hora da ultima alteracao.';
COMMENT ON COLUMN IPAGTB016_DET_TRIBUTO_SEM_CB.NO_USUARIO_INCLUSAO          IS 'Login do usuario que incluiu.';
COMMENT ON COLUMN IPAGTB016_DET_TRIBUTO_SEM_CB.NO_USUARIO_ALTERACAO         IS 'Login do usuario que alterou.';

-- ----------------------------------------------------------------------------
-- IPAGTB017_DET_TRIBUTO_COM_CB - Segmento O (Tributos com Codigo de Barras)
--   Ref: pagina 35 do Layout CNAB240 V10.9
-- ----------------------------------------------------------------------------
CREATE SEQUENCE IPAGTB017_DET_TRIBUTO_COM_CB_SQ START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE IPAGTB017_DET_TRIBUTO_COM_CB (
    ID_SEG_O                   NUMBER        DEFAULT ON NULL IPAGTB017_DET_TRIBUTO_COM_CB_SQ.NEXTVAL,
    ID_DETALHE_REG             NUMBER        NOT NULL,
    NU_CODIGO_BARRAS           VARCHAR2(44)  NOT NULL,
    NO_CONCESSIONARIA          VARCHAR2(30),
    DH_VENCIMENTO              DATE,
    DH_PAGAMENTO               DATE          NOT NULL,
    NU_VALOR_PAGAMENTO         NUMBER(15,2)  NOT NULL,
    NU_DOCUMENTO_EMPRESA       VARCHAR2(20),
    NU_DOCUMENTO_BANCO         VARCHAR2(20),
    TE_OCORRENCIA             CHAR(10),
    DH_INCLUSAO                DATE          DEFAULT SYSDATE NOT NULL,
    DH_ALTERACAO               DATE,
    NO_USUARIO_INCLUSAO        VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO       VARCHAR2(60),
    CONSTRAINT IPAGTB017_DET_TRIBUTO_COM_CB_PK   PRIMARY KEY (ID_SEG_O),
    CONSTRAINT IPAGTB017_DET_TRIBUTO_COM_CB_UK01 UNIQUE (ID_DETALHE_REG),
    CONSTRAINT IPAGTB007_IPAGTB017_FK01
        FOREIGN KEY (ID_DETALHE_REG) REFERENCES IPAGTB007_DETALHE_REG (ID_DETALHE_REG)
);
CREATE INDEX IPAGTB017_DET_TRIBUTO_COM_CB_IDX01 ON IPAGTB017_DET_TRIBUTO_COM_CB (DH_PAGAMENTO);

COMMENT ON TABLE IPAGTB017_DET_TRIBUTO_COM_CB IS 'Segmento O do CNAB240. Obrigatorio no pagamento de Contas e Tributos com Codigo de Barras (concessionarias, impostos estaduais, FGTS). Contem codigo de barras, nome do orgao, vencimento e valor. Layout ref: pagina 35.';
COMMENT ON COLUMN IPAGTB017_DET_TRIBUTO_COM_CB.ID_SEG_O                   IS 'Identificador surrogate gerado por sequence.';
COMMENT ON COLUMN IPAGTB017_DET_TRIBUTO_COM_CB.ID_DETALHE_REG             IS 'Chave estrangeira para IPAGTB007_DETALHE_REG.';
COMMENT ON COLUMN IPAGTB017_DET_TRIBUTO_COM_CB.NU_CODIGO_BARRAS           IS 'Codigo de barras do tributo/conta. Campo N001. Posicoes 18-61. 44 caracteres alfanumericos.';
COMMENT ON COLUMN IPAGTB017_DET_TRIBUTO_COM_CB.NO_CONCESSIONARIA          IS 'Nome da concessionaria ou orgao publico. Campo G013. Posicoes 62-91.';
COMMENT ON COLUMN IPAGTB017_DET_TRIBUTO_COM_CB.DH_VENCIMENTO              IS 'Data de vencimento nominal. Campo G044. Posicoes 92-99 (DDMMAAAA).';
COMMENT ON COLUMN IPAGTB017_DET_TRIBUTO_COM_CB.DH_PAGAMENTO               IS 'Data do pagamento. Campo P009. Posicoes 100-107 (DDMMAAAA).';
COMMENT ON COLUMN IPAGTB017_DET_TRIBUTO_COM_CB.NU_VALOR_PAGAMENTO         IS 'Valor do pagamento com 2 decimais. Campo P004. Posicoes 108-122.';
COMMENT ON COLUMN IPAGTB017_DET_TRIBUTO_COM_CB.NU_DOCUMENTO_EMPRESA       IS 'Numero do documento da empresa. Campo G064. Posicoes 123-142.';
COMMENT ON COLUMN IPAGTB017_DET_TRIBUTO_COM_CB.NU_DOCUMENTO_BANCO         IS 'Numero do documento do banco. Campo G043. Posicoes 143-162.';
COMMENT ON COLUMN IPAGTB017_DET_TRIBUTO_COM_CB.TE_OCORRENCIA             IS 'Codigos de ocorrencias de retorno. Campo G059. Posicoes 231-240.';
COMMENT ON COLUMN IPAGTB017_DET_TRIBUTO_COM_CB.DH_INCLUSAO                IS 'Data e hora de inclusao.';
COMMENT ON COLUMN IPAGTB017_DET_TRIBUTO_COM_CB.DH_ALTERACAO               IS 'Data e hora da ultima alteracao.';
COMMENT ON COLUMN IPAGTB017_DET_TRIBUTO_COM_CB.NO_USUARIO_INCLUSAO        IS 'Login do usuario que incluiu.';
COMMENT ON COLUMN IPAGTB017_DET_TRIBUTO_COM_CB.NO_USUARIO_ALTERACAO       IS 'Login do usuario que alterou.';

-- ----------------------------------------------------------------------------
-- IPAGTB018_DET_COMPL_TRIBUTO - Segmento W (Informacoes Complementares de Tributo)
--   Ref: pagina 45 do Layout CNAB240 V10.9
-- ----------------------------------------------------------------------------
CREATE SEQUENCE IPAGTB018_DET_COMPL_TRIBUTO_SQ START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE IPAGTB018_DET_COMPL_TRIBUTO (
    ID_SEG_W                     NUMBER        DEFAULT ON NULL IPAGTB018_DET_COMPL_TRIBUTO_SQ.NEXTVAL,
    ID_DETALHE_REG               NUMBER        NOT NULL,
    NU_COMPLEMENTO_REGISTRO      NUMBER(1),
    CO_IDENTIFICACAO_INFORMACOES CHAR(1),
    TE_INFORMACAO_COMPLEMENT_1   VARCHAR2(80),
    TE_INFORMACAO_COMPLEMENT_2   VARCHAR2(80),
    CO_IDENTIFICADOR_TRIBUTO     VARCHAR2(2),
    TE_INFORMACAO_TRIBUTO        VARCHAR2(48),
    TE_OCORRENCIA               CHAR(10),
    DH_INCLUSAO                  DATE          DEFAULT SYSDATE NOT NULL,
    DH_ALTERACAO                 DATE,
    NO_USUARIO_INCLUSAO          VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO         VARCHAR2(60),
    CONSTRAINT IPAGTB018_DET_COMPL_TRIBUTO_PK   PRIMARY KEY (ID_SEG_W),
    CONSTRAINT IPAGTB018_DET_COMPL_TRIBUTO_UK01 UNIQUE (ID_DETALHE_REG),
    CONSTRAINT IPAGTB007_IPAGTB018_FK01
        FOREIGN KEY (ID_DETALHE_REG) REFERENCES IPAGTB007_DETALHE_REG (ID_DETALHE_REG)
);

COMMENT ON TABLE IPAGTB018_DET_COMPL_TRIBUTO IS 'Segmento W do CNAB240. Opcional no pagamento de tributos. Fornece informacoes complementares obrigatorias para FGTS (convenios 0181 e 0182) quando usado em conjunto com o Segmento O. Tambem usado para outros tributos que necessitem de campos adicionais. Layout ref: pagina 45.';
COMMENT ON COLUMN IPAGTB018_DET_COMPL_TRIBUTO.ID_SEG_W                     IS 'Identificador surrogate gerado por sequence.';
COMMENT ON COLUMN IPAGTB018_DET_COMPL_TRIBUTO.ID_DETALHE_REG               IS 'Chave estrangeira para IPAGTB007_DETALHE_REG.';
COMMENT ON COLUMN IPAGTB018_DET_COMPL_TRIBUTO.NU_COMPLEMENTO_REGISTRO      IS 'Numero sequencial do registro complementar W. Campo N023. Posicao 15.';
COMMENT ON COLUMN IPAGTB018_DET_COMPL_TRIBUTO.CO_IDENTIFICACAO_INFORMACOES IS 'Identificacao do uso das informacoes 1 e 2. Campo N024. Posicao 16.';
COMMENT ON COLUMN IPAGTB018_DET_COMPL_TRIBUTO.TE_INFORMACAO_COMPLEMENT_1   IS 'Informacao complementar 1 (80 chars). Campo N025. Posicoes 17-96. Para FGTS: codigo conectividade social.';
COMMENT ON COLUMN IPAGTB018_DET_COMPL_TRIBUTO.TE_INFORMACAO_COMPLEMENT_2   IS 'Informacao complementar 2 (80 chars). Campo N025. Posicoes 97-176.';
COMMENT ON COLUMN IPAGTB018_DET_COMPL_TRIBUTO.CO_IDENTIFICADOR_TRIBUTO     IS 'Identificador do tipo de tributo nas informacoes do campo 3. Campo N027. Posicoes 177-178.';
COMMENT ON COLUMN IPAGTB018_DET_COMPL_TRIBUTO.TE_INFORMACAO_TRIBUTO        IS 'Dados especificos do tributo (ex: lacre FGTS, digito lacre). Campo N026. Posicoes 179-228.';
COMMENT ON COLUMN IPAGTB018_DET_COMPL_TRIBUTO.TE_OCORRENCIA               IS 'Codigos de ocorrencias de retorno. Campo G059. Posicoes 231-240.';
COMMENT ON COLUMN IPAGTB018_DET_COMPL_TRIBUTO.DH_INCLUSAO                  IS 'Data e hora de inclusao.';
COMMENT ON COLUMN IPAGTB018_DET_COMPL_TRIBUTO.DH_ALTERACAO                 IS 'Data e hora da ultima alteracao.';
COMMENT ON COLUMN IPAGTB018_DET_COMPL_TRIBUTO.NO_USUARIO_INCLUSAO          IS 'Login do usuario que incluiu.';
COMMENT ON COLUMN IPAGTB018_DET_COMPL_TRIBUTO.NO_USUARIO_ALTERACAO         IS 'Login do usuario que alterou.';

-- ----------------------------------------------------------------------------
-- IPAGTB019_DET_IDENT_TRIBUTO - Segmento Z (Autenticacao do Pagamento - Retorno)
--   Ref: pagina 47 do Layout CNAB240 V10.9
-- ----------------------------------------------------------------------------
CREATE SEQUENCE IPAGTB019_DET_IDENT_TRIBUTO_SQ START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE IPAGTB019_DET_IDENT_TRIBUTO (
    ID_SEG_Z                   NUMBER        DEFAULT ON NULL IPAGTB019_DET_IDENT_TRIBUTO_SQ.NEXTVAL,
    ID_DETALHE_REG             NUMBER        NOT NULL,
    TE_AUTENTICACAO_LEGISLACAO VARCHAR2(64),
    TE_AUTENTICACAO_BANCARIA   VARCHAR2(25),
    TE_OCORRENCIA             CHAR(10),
    DH_INCLUSAO                DATE          DEFAULT SYSDATE NOT NULL,
    DH_ALTERACAO               DATE,
    NO_USUARIO_INCLUSAO        VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO       VARCHAR2(60),
    CONSTRAINT IPAGTB019_DET_IDENT_TRIBUTO_PK   PRIMARY KEY (ID_SEG_Z),
    CONSTRAINT IPAGTB019_DET_IDENT_TRIBUTO_UK01 UNIQUE (ID_DETALHE_REG),
    CONSTRAINT IPAGTB007_IPAGTB019_FK01
        FOREIGN KEY (ID_DETALHE_REG) REFERENCES IPAGTB007_DETALHE_REG (ID_DETALHE_REG)
);

COMMENT ON TABLE IPAGTB019_DET_IDENT_TRIBUTO IS 'Segmento Z do CNAB240. Opcional nos retornos. Fornece autenticacao do pagamento conforme legislacao e protocolo bancario. Pode ser usado para qualquer forma de lancamento. Deve ser unico por pagamento. Layout ref: pagina 47.';
COMMENT ON COLUMN IPAGTB019_DET_IDENT_TRIBUTO.ID_SEG_Z                    IS 'Identificador surrogate gerado por sequence.';
COMMENT ON COLUMN IPAGTB019_DET_IDENT_TRIBUTO.ID_DETALHE_REG              IS 'Chave estrangeira para IPAGTB007_DETALHE_REG.';
COMMENT ON COLUMN IPAGTB019_DET_IDENT_TRIBUTO.TE_AUTENTICACAO_LEGISLACAO  IS 'Autenticacao gerada para atender legislacao fiscal/tributaria. Campo Z001. Posicoes 15-78. 64 caracteres alfanumericos.';
COMMENT ON COLUMN IPAGTB019_DET_IDENT_TRIBUTO.TE_AUTENTICACAO_BANCARIA    IS 'Autenticacao bancaria ou protocolo de liquidacao. Campo Z002. Posicoes 79-103. 25 caracteres.';
COMMENT ON COLUMN IPAGTB019_DET_IDENT_TRIBUTO.TE_OCORRENCIA              IS 'Codigos de ocorrencias de retorno. Campo G059. Posicoes 231-240.';
COMMENT ON COLUMN IPAGTB019_DET_IDENT_TRIBUTO.DH_INCLUSAO                 IS 'Data e hora de inclusao.';
COMMENT ON COLUMN IPAGTB019_DET_IDENT_TRIBUTO.DH_ALTERACAO                IS 'Data e hora da ultima alteracao.';
COMMENT ON COLUMN IPAGTB019_DET_IDENT_TRIBUTO.NO_USUARIO_INCLUSAO         IS 'Login do usuario que incluiu.';
COMMENT ON COLUMN IPAGTB019_DET_IDENT_TRIBUTO.NO_USUARIO_ALTERACAO        IS 'Login do usuario que alterou.';

-- =============================================================================
-- SECAO 9: SEGMENTOS DE COBRANCA - REMESSA (P, Q, R, S)
-- =============================================================================

-- ----------------------------------------------------------------------------
-- IPAGTB020_DET_DADOS_TITULO - Segmento P (Obrigatorio - Cobranca Remessa - Titulo)
-- ----------------------------------------------------------------------------
CREATE SEQUENCE IPAGTB020_DET_DADOS_TITULO_SQ START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE IPAGTB020_DET_DADOS_TITULO (
    ID_SEG_P                   NUMBER        DEFAULT ON NULL IPAGTB020_DET_DADOS_TITULO_SQ.NEXTVAL,
    ID_DETALHE_REG             NUMBER        NOT NULL,
    -- Conta do beneficiario
    NU_AGENCIA_BENEFICIARIO    NUMBER(5),
    CO_DV_AGENCIA_BENEF        CHAR(1),
    NU_CONTA_BENEFICIARIO      VARCHAR2(12),
    CO_DV_CONTA_BENEF          CHAR(1),
    CO_DV_AGENCIA_CONTA_BENEF  CHAR(1),
    -- Dados do titulo
    NU_NOSSO_NUMERO            VARCHAR2(20),
    CO_CARTEIRA                VARCHAR2(3),
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
    -- Instrucoes de cobranca
    CO_INSTRUCAO_1             VARCHAR2(2),
    CO_INSTRUCAO_2             VARCHAR2(2),
    NU_VALOR_MORA_DIA          NUMBER(15,2),
    DH_LIMITE_DESCONTO         DATE,
    NU_VALOR_DESCONTO          NUMBER(15,2),
    NU_VALOR_IOF               NUMBER(15,2),
    NU_VALOR_ABATIMENTO        NUMBER(15,2),
    -- Sacado (devedor)
    CO_TIPO_INSCRICAO_SACADO   CHAR(1),
    NU_INSCRICAO_SACADO        VARCHAR2(15),
    NO_SACADO                  VARCHAR2(40),
    NU_LOGRADOURO_NUMERO       NUMBER(5),
    NO_COMPLEMENTO_ENDERECO    VARCHAR2(15),
    NO_CEP_SACADO              NUMBER(5),
    CO_COMPLEMENTO_CEP_SACADO  CHAR(3),
    NO_LOGRADOURO_SACADO       VARCHAR2(40),
    NO_CIDADE_SACADO           VARCHAR2(15),
    SG_UF_SACADO               CHAR(2),
    -- Mensagem e ocorrencias
    TE_MENSAGEM_SACADO         VARCHAR2(40),
    TE_OCORRENCIA             CHAR(10),
    DH_INCLUSAO                DATE          DEFAULT SYSDATE NOT NULL,
    DH_ALTERACAO               DATE,
    NO_USUARIO_INCLUSAO        VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO       VARCHAR2(60),
    ID_TIPO_INSCRICAO_SACADO   NUMBER,
    CONSTRAINT IPAGTB020_DET_DADOS_TITULO_PK   PRIMARY KEY (ID_SEG_P),
    CONSTRAINT IPAGTB020_DET_DADOS_TITULO_UK01 UNIQUE (ID_DETALHE_REG),
    CONSTRAINT IPAGTB007_IPAGTB020_FK01
        FOREIGN KEY (ID_DETALHE_REG) REFERENCES IPAGTB007_DETALHE_REG (ID_DETALHE_REG),
    CONSTRAINT IPAGTB034_IPAGTB020_FK01
        FOREIGN KEY (ID_TIPO_INSCRICAO_SACADO) REFERENCES IPAGTB034_TIPO_INSCRICAO (ID_TIPO_INSCRICAO)
);
CREATE INDEX IPAGTB020_DET_DADOS_TITULO_IDX01 ON IPAGTB020_DET_DADOS_TITULO (DH_VENCIMENTO);
CREATE INDEX IPAGTB020_DET_DADOS_TITULO_IDX02 ON IPAGTB020_DET_DADOS_TITULO (NU_NOSSO_NUMERO);

COMMENT ON TABLE IPAGTB020_DET_DADOS_TITULO IS 'Segmento P do CNAB240. Obrigatorio na Cobranca Remessa (titulos em cobranca). Contem dados do titulo: nosso numero, carteira, valor nominal, vencimento, instrucoes de cobranca e dados do sacado (devedor). Registro enviado do beneficiario ao banco.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.ID_SEG_P                   IS 'Identificador surrogate gerado por sequence.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.ID_DETALHE_REG             IS 'Chave estrangeira para IPAGTB007_DETALHE_REG.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.NU_AGENCIA_BENEFICIARIO    IS 'Agencia da conta do beneficiario (cedente). Campo G008.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.CO_DV_AGENCIA_BENEF        IS 'DV da agencia do beneficiario. Campo G009.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.NU_CONTA_BENEFICIARIO      IS 'Conta corrente do beneficiario. Campo G010.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.CO_DV_CONTA_BENEF          IS 'DV da conta do beneficiario. Campo G011.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.CO_DV_AGENCIA_CONTA_BENEF  IS 'DV conjunto agencia/conta do beneficiario. Campo G012.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.NU_NOSSO_NUMERO            IS 'Nosso numero do titulo - identificacao no banco do beneficiario. Campo C004.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.CO_CARTEIRA                IS 'Codigo da carteira de cobranca. Campo C005. Exemplos: 01=Simples, 02=Vinculada.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.CO_FORMA_CADASTRAMENTO     IS 'Forma de cadastramento do titulo (com ou sem registro). Campo C006.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.CO_TIPO_DOCUMENTO          IS 'Tipo do documento de cobranca. Campo C007.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.CO_EMISSAO_BLOQUETO        IS 'Identificacao de emissao do bloqueto. Campo C008.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.CO_DISTRIBUICAO_BLOQUETO   IS 'Identificacao da distribuicao do bloqueto. Campo C009.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.NU_NUMERO_DOCUMENTO        IS 'Numero do documento (seu numero). Campo G064.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.DH_VENCIMENTO              IS 'Data de vencimento do titulo convertida de DDMMAAAA. Campo G044.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.NU_VALOR_NOMINAL           IS 'Valor nominal do titulo. Campo G042.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.NU_AGENCIA_COBRADORA       IS 'Agencia cobradora (praÃ§a de pagamento). Campo G008.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.CO_DV_AGENCIA_COBRADORA    IS 'DV da agencia cobradora. Campo G009.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.CO_ESPECIE_TITULO          IS 'Especie do titulo. Campo C010. Ex: 01=Duplicata Mercantil, 02=Nota Promissoria.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.IN_ACEITE                  IS 'Indicador de aceite do titulo. Campo C011. A=Aceite, N=Sem Aceite.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.DH_EMISSAO_TITULO          IS 'Data de emissao do titulo. Campo G045 (DDMMAAAA).';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.CO_INSTRUCAO_1             IS 'Codigo da instrucao 1 para o banco. Campo C012. Ex: 01=Protestar.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.CO_INSTRUCAO_2             IS 'Codigo da instrucao 2 para o banco. Campo C012.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.NU_VALOR_MORA_DIA          IS 'Valor de mora por dia de atraso. Campo G046.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.DH_LIMITE_DESCONTO         IS 'Data limite para concessao de desconto. Campo G044.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.NU_VALOR_DESCONTO          IS 'Valor do desconto. Campo G046.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.NU_VALOR_IOF               IS 'Valor do IOF. Campo G052.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.NU_VALOR_ABATIMENTO        IS 'Valor do abatimento concedido pelo beneficiario. Campo G046.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.CO_TIPO_INSCRICAO_SACADO   IS 'Tipo de inscricao do sacado (devedor). Campo G005.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.NU_INSCRICAO_SACADO        IS 'CPF/CNPJ do sacado. Campo G006.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.NO_SACADO                  IS 'Nome do sacado (devedor). Campo G013.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.NU_LOGRADOURO_NUMERO       IS 'Numero do logradouro do sacado. Campo G032.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.NO_COMPLEMENTO_ENDERECO    IS 'Complemento do endereco do sacado. Campo G032.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.NO_CEP_SACADO              IS 'CEP do sacado. Campo G034.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.CO_COMPLEMENTO_CEP_SACADO  IS 'Complemento do CEP do sacado. Campo G035.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.NO_LOGRADOURO_SACADO       IS 'Logradouro do sacado. Campo G032.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.NO_CIDADE_SACADO           IS 'Cidade do sacado. Campo G033.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.SG_UF_SACADO               IS 'UF do sacado. Campo G036.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.TE_MENSAGEM_SACADO         IS 'Mensagem ao sacado impressa no bloqueto. Campo C013.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.TE_OCORRENCIA             IS 'Codigos de ocorrencias de retorno. Campo G059. Posicoes 231-240.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.DH_INCLUSAO                IS 'Data e hora de inclusao.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.DH_ALTERACAO               IS 'Data e hora da ultima alteracao.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.NO_USUARIO_INCLUSAO        IS 'Login do usuario que incluiu.';
COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.NO_USUARIO_ALTERACAO       IS 'Login do usuario que alterou.';

-- ----------------------------------------------------------------------------
-- IPAGTB021_DET_DADOS_SACADO - Segmento Q (Obrigatorio - Cobranca Remessa - Sacador/Pagador)
-- ----------------------------------------------------------------------------
CREATE SEQUENCE IPAGTB021_DET_DADOS_SACADO_SQ START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE IPAGTB021_DET_DADOS_SACADO (
    ID_SEG_Q                   NUMBER        DEFAULT ON NULL IPAGTB021_DET_DADOS_SACADO_SQ.NEXTVAL,
    ID_DETALHE_REG             NUMBER        NOT NULL,
    CO_TIPO_INSCRICAO_SACADO   CHAR(1),
    NU_INSCRICAO_SACADO        VARCHAR2(15),
    NO_SACADO                  VARCHAR2(40),
    NO_LOGRADOURO_SACADO       VARCHAR2(40),
    NU_LOCAL_SACADO            NUMBER(5),
    NO_COMPLEMENTO_SACADO      VARCHAR2(15),
    NO_CIDADE_SACADO           VARCHAR2(15),
    NO_CEP_SACADO              NUMBER(5),
    CO_COMPLEMENTO_CEP_SACADO  CHAR(3),
    SG_UF_SACADO               CHAR(2),
    CO_TIPO_INSCRICAO_SACADOR  CHAR(1),
    NU_INSCRICAO_SACADOR       VARCHAR2(15),
    NO_SACADOR_AVALISTA        VARCHAR2(40),
    NU_AGENCIA_CORRESPONDENTE  NUMBER(5),
    NU_NOSSO_NUMERO_CORRESP    VARCHAR2(20),
    TE_OCORRENCIA             CHAR(10),
    DH_INCLUSAO                DATE          DEFAULT SYSDATE NOT NULL,
    DH_ALTERACAO               DATE,
    NO_USUARIO_INCLUSAO        VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO       VARCHAR2(60),
    ID_TIPO_INSCRICAO_SACADO   NUMBER,
    ID_TIPO_INSCRICAO_SACADOR  NUMBER,
    CONSTRAINT IPAGTB021_DET_DADOS_SACADO_PK   PRIMARY KEY (ID_SEG_Q),
    CONSTRAINT IPAGTB021_DET_DADOS_SACADO_UK01 UNIQUE (ID_DETALHE_REG),
    CONSTRAINT IPAGTB007_IPAGTB021_FK01
        FOREIGN KEY (ID_DETALHE_REG) REFERENCES IPAGTB007_DETALHE_REG (ID_DETALHE_REG),
    CONSTRAINT IPAGTB034_IPAGTB021_FK01
        FOREIGN KEY (ID_TIPO_INSCRICAO_SACADO) REFERENCES IPAGTB034_TIPO_INSCRICAO (ID_TIPO_INSCRICAO),
    CONSTRAINT IPAGTB034_IPAGTB021_FK02
        FOREIGN KEY (ID_TIPO_INSCRICAO_SACADOR) REFERENCES IPAGTB034_TIPO_INSCRICAO (ID_TIPO_INSCRICAO)
);

COMMENT ON TABLE IPAGTB021_DET_DADOS_SACADO IS 'Segmento Q do CNAB240. Obrigatorio na Cobranca Remessa. Contem dados complementares do sacado (endereco completo), sacador/avalista e banco correspondente para cobranca em outras pracas.';
COMMENT ON COLUMN IPAGTB021_DET_DADOS_SACADO.ID_SEG_Q                   IS 'Identificador surrogate gerado por sequence.';
COMMENT ON COLUMN IPAGTB021_DET_DADOS_SACADO.ID_DETALHE_REG             IS 'Chave estrangeira para IPAGTB007_DETALHE_REG.';
COMMENT ON COLUMN IPAGTB021_DET_DADOS_SACADO.CO_TIPO_INSCRICAO_SACADO   IS 'Tipo de inscricao do sacado. Campo G005.';
COMMENT ON COLUMN IPAGTB021_DET_DADOS_SACADO.NU_INSCRICAO_SACADO        IS 'CPF/CNPJ do sacado. Campo G006.';
COMMENT ON COLUMN IPAGTB021_DET_DADOS_SACADO.NO_SACADO                  IS 'Nome do sacado (devedor). Campo G013.';
COMMENT ON COLUMN IPAGTB021_DET_DADOS_SACADO.NO_LOGRADOURO_SACADO       IS 'Logradouro do sacado. Campo G032.';
COMMENT ON COLUMN IPAGTB021_DET_DADOS_SACADO.NU_LOCAL_SACADO            IS 'Numero do local do sacado. Campo G032.';
COMMENT ON COLUMN IPAGTB021_DET_DADOS_SACADO.NO_COMPLEMENTO_SACADO      IS 'Complemento do endereco do sacado. Campo G032.';
COMMENT ON COLUMN IPAGTB021_DET_DADOS_SACADO.NO_CIDADE_SACADO           IS 'Cidade do sacado. Campo G033.';
COMMENT ON COLUMN IPAGTB021_DET_DADOS_SACADO.NO_CEP_SACADO              IS 'CEP do sacado. Campo G034.';
COMMENT ON COLUMN IPAGTB021_DET_DADOS_SACADO.CO_COMPLEMENTO_CEP_SACADO  IS 'Complemento do CEP do sacado. Campo G035.';
COMMENT ON COLUMN IPAGTB021_DET_DADOS_SACADO.SG_UF_SACADO               IS 'UF do sacado. Campo G036.';
COMMENT ON COLUMN IPAGTB021_DET_DADOS_SACADO.CO_TIPO_INSCRICAO_SACADOR  IS 'Tipo de inscricao do sacador/avalista. Campo G005.';
COMMENT ON COLUMN IPAGTB021_DET_DADOS_SACADO.NU_INSCRICAO_SACADOR       IS 'CPF/CNPJ do sacador/avalista. Campo G006.';
COMMENT ON COLUMN IPAGTB021_DET_DADOS_SACADO.NO_SACADOR_AVALISTA        IS 'Nome do sacador ou avalista do titulo. Campo G013.';
COMMENT ON COLUMN IPAGTB021_DET_DADOS_SACADO.NU_AGENCIA_CORRESPONDENTE  IS 'Agencia do banco correspondente para cobranca em outra praca. Campo G008.';
COMMENT ON COLUMN IPAGTB021_DET_DADOS_SACADO.NU_NOSSO_NUMERO_CORRESP    IS 'Nosso numero no banco correspondente. Campo C004.';
COMMENT ON COLUMN IPAGTB021_DET_DADOS_SACADO.TE_OCORRENCIA             IS 'Codigos de ocorrencias de retorno. Campo G059. Posicoes 231-240.';
COMMENT ON COLUMN IPAGTB021_DET_DADOS_SACADO.DH_INCLUSAO                IS 'Data e hora de inclusao.';
COMMENT ON COLUMN IPAGTB021_DET_DADOS_SACADO.DH_ALTERACAO               IS 'Data e hora da ultima alteracao.';
COMMENT ON COLUMN IPAGTB021_DET_DADOS_SACADO.NO_USUARIO_INCLUSAO        IS 'Login do usuario que incluiu.';
COMMENT ON COLUMN IPAGTB021_DET_DADOS_SACADO.NO_USUARIO_ALTERACAO       IS 'Login do usuario que alterou.';

-- ----------------------------------------------------------------------------
-- IPAGTB022_DET_DESCONTO_TITULO - Segmento R (Opcional - Cobranca Remessa - Descontos/Penalidades)
-- ----------------------------------------------------------------------------
CREATE SEQUENCE IPAGTB022_DET_DESCONTO_TITULO_SQ START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE IPAGTB022_DET_DESCONTO_TITULO (
    ID_SEG_R                   NUMBER        DEFAULT ON NULL IPAGTB022_DET_DESCONTO_TITULO_SQ.NEXTVAL,
    ID_DETALHE_REG             NUMBER        NOT NULL,
    CO_TIPO_DESCONTO_2         CHAR(1),
    DH_DATA_DESCONTO_2         DATE,
    NU_VALOR_DESCONTO_2        NUMBER(15,2),
    CO_TIPO_DESCONTO_3         CHAR(1),
    DH_DATA_DESCONTO_3         DATE,
    NU_VALOR_DESCONTO_3        NUMBER(15,2),
    CO_TIPO_MULTA              CHAR(1),
    DH_DATA_MULTA              DATE,
    NU_VALOR_MULTA_PERCENT     NUMBER(15,2),
    TE_INFORMACAO_SACADO       VARCHAR2(40),
    TE_MENSAGEM_3              VARCHAR2(40),
    CO_TIPO_JUROS_MORA         CHAR(1),
    DH_DATA_JUROS              DATE,
    NU_VALOR_JUROS_MORA        NUMBER(15,5),
    TE_OCORRENCIA             CHAR(10),
    DH_INCLUSAO                DATE          DEFAULT SYSDATE NOT NULL,
    DH_ALTERACAO               DATE,
    NO_USUARIO_INCLUSAO        VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO       VARCHAR2(60),
    CONSTRAINT IPAGTB022_DET_DESCONTO_TITULO_PK   PRIMARY KEY (ID_SEG_R),
    CONSTRAINT IPAGTB022_DET_DESCONTO_TITULO_UK01 UNIQUE (ID_DETALHE_REG),
    CONSTRAINT IPAGTB007_IPAGTB022_FK01
        FOREIGN KEY (ID_DETALHE_REG) REFERENCES IPAGTB007_DETALHE_REG (ID_DETALHE_REG)
);

COMMENT ON TABLE IPAGTB022_DET_DESCONTO_TITULO IS 'Segmento R do CNAB240. Opcional na Cobranca Remessa. Contem descontos adicionais (2 e 3), tipo e valor de multa, tipo e valor de juros de mora e mensagem adicional ao sacado. Complementa as instrucoes do Segmento P.';
COMMENT ON COLUMN IPAGTB022_DET_DESCONTO_TITULO.ID_SEG_R                   IS 'Identificador surrogate gerado por sequence.';
COMMENT ON COLUMN IPAGTB022_DET_DESCONTO_TITULO.ID_DETALHE_REG             IS 'Chave estrangeira para IPAGTB007_DETALHE_REG.';
COMMENT ON COLUMN IPAGTB022_DET_DESCONTO_TITULO.CO_TIPO_DESCONTO_2         IS 'Tipo do segundo desconto. Campo C014. 0=Sem desconto, 1=Valor fixo, 2=Percentual.';
COMMENT ON COLUMN IPAGTB022_DET_DESCONTO_TITULO.DH_DATA_DESCONTO_2         IS 'Data limite para o segundo desconto.';
COMMENT ON COLUMN IPAGTB022_DET_DESCONTO_TITULO.NU_VALOR_DESCONTO_2        IS 'Valor ou percentual do segundo desconto.';
COMMENT ON COLUMN IPAGTB022_DET_DESCONTO_TITULO.CO_TIPO_DESCONTO_3         IS 'Tipo do terceiro desconto.';
COMMENT ON COLUMN IPAGTB022_DET_DESCONTO_TITULO.DH_DATA_DESCONTO_3         IS 'Data limite para o terceiro desconto.';
COMMENT ON COLUMN IPAGTB022_DET_DESCONTO_TITULO.NU_VALOR_DESCONTO_3        IS 'Valor ou percentual do terceiro desconto.';
COMMENT ON COLUMN IPAGTB022_DET_DESCONTO_TITULO.CO_TIPO_MULTA              IS 'Tipo de multa. Campo C015. 0=Sem, 1=Valor fixo, 2=Percentual.';
COMMENT ON COLUMN IPAGTB022_DET_DESCONTO_TITULO.DH_DATA_MULTA              IS 'Data a partir da qual a multa e aplicada.';
COMMENT ON COLUMN IPAGTB022_DET_DESCONTO_TITULO.NU_VALOR_MULTA_PERCENT     IS 'Valor ou percentual da multa.';
COMMENT ON COLUMN IPAGTB022_DET_DESCONTO_TITULO.TE_INFORMACAO_SACADO       IS 'Informacao adicional ao sacado. Campo C016.';
COMMENT ON COLUMN IPAGTB022_DET_DESCONTO_TITULO.TE_MENSAGEM_3              IS 'Mensagem 3 para impressao no bloqueto. Campo C017.';
COMMENT ON COLUMN IPAGTB022_DET_DESCONTO_TITULO.CO_TIPO_JUROS_MORA         IS 'Tipo de juros de mora. Campo G046. 0=Sem, 1=Valor/dia, 2=Taxa mensal.';
COMMENT ON COLUMN IPAGTB022_DET_DESCONTO_TITULO.DH_DATA_JUROS              IS 'Data a partir da qual os juros sao cobrados.';
COMMENT ON COLUMN IPAGTB022_DET_DESCONTO_TITULO.NU_VALOR_JUROS_MORA        IS 'Valor ou percentual de juros de mora por dia.';
COMMENT ON COLUMN IPAGTB022_DET_DESCONTO_TITULO.TE_OCORRENCIA             IS 'Codigos de ocorrencias de retorno. Campo G059.';
COMMENT ON COLUMN IPAGTB022_DET_DESCONTO_TITULO.DH_INCLUSAO                IS 'Data e hora de inclusao.';
COMMENT ON COLUMN IPAGTB022_DET_DESCONTO_TITULO.DH_ALTERACAO               IS 'Data e hora da ultima alteracao.';
COMMENT ON COLUMN IPAGTB022_DET_DESCONTO_TITULO.NO_USUARIO_INCLUSAO        IS 'Login do usuario que incluiu.';
COMMENT ON COLUMN IPAGTB022_DET_DESCONTO_TITULO.NO_USUARIO_ALTERACAO       IS 'Login do usuario que alterou.';

-- =============================================================================
-- SECAO 10: SEGMENTOS DE COBRANCA - RETORNO (T, U)
-- =============================================================================

-- ----------------------------------------------------------------------------
-- IPAGTB023_DET_RETORNO_TITULO - Segmento T (Obrigatorio - Cobranca Retorno - Titulo)
-- ----------------------------------------------------------------------------
CREATE SEQUENCE IPAGTB023_DET_RETORNO_TITULO_SQ START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE IPAGTB023_DET_RETORNO_TITULO (
    ID_SEG_T                   NUMBER        DEFAULT ON NULL IPAGTB023_DET_RETORNO_TITULO_SQ.NEXTVAL,
    ID_DETALHE_REG             NUMBER        NOT NULL,
    NU_AGENCIA_BENEFICIARIO    NUMBER(5),
    CO_DV_AGENCIA_BENEF        CHAR(1),
    NU_CONTA_BENEFICIARIO      VARCHAR2(12),
    CO_DV_CONTA_BENEF          CHAR(1),
    CO_DV_AGENCIA_CONTA_BENEF  CHAR(1),
    NU_NOSSO_NUMERO            VARCHAR2(20),
    CO_CARTEIRA                VARCHAR2(3),
    NU_NUMERO_DOCUMENTO        VARCHAR2(15),
    DH_VENCIMENTO              DATE,
    NU_VALOR_NOMINAL           NUMBER(15,2),
    NU_BANCO_COBRADOR          NUMBER(3),
    NU_AGENCIA_COBRADORA       NUMBER(5),
    CO_DV_AGENCIA_COBRADORA    CHAR(1),
    CO_TIPO_INSCRICAO_SACADO   CHAR(1),
    NU_INSCRICAO_SACADO        VARCHAR2(15),
    NO_SACADO                  VARCHAR2(40),
    NU_NUMERO_CONTRATO         VARCHAR2(10),
    NU_VALOR_DESCONTO_DADO     NUMBER(15,2),
    NU_VALOR_ABATIMENTO        NUMBER(15,2),
    TE_OCORRENCIA             CHAR(10),
    DH_INCLUSAO                DATE          DEFAULT SYSDATE NOT NULL,
    DH_ALTERACAO               DATE,
    NO_USUARIO_INCLUSAO        VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO       VARCHAR2(60),
    ID_TIPO_INSCRICAO_SACADO   NUMBER,
    CONSTRAINT IPAGTB023_DET_RETORNO_TITULO_PK   PRIMARY KEY (ID_SEG_T),
    CONSTRAINT IPAGTB023_DET_RETORNO_TITULO_UK01 UNIQUE (ID_DETALHE_REG),
    CONSTRAINT IPAGTB007_IPAGTB023_FK01
        FOREIGN KEY (ID_DETALHE_REG) REFERENCES IPAGTB007_DETALHE_REG (ID_DETALHE_REG),
    CONSTRAINT IPAGTB034_IPAGTB023_FK01
        FOREIGN KEY (ID_TIPO_INSCRICAO_SACADO) REFERENCES IPAGTB034_TIPO_INSCRICAO (ID_TIPO_INSCRICAO)
);
CREATE INDEX IPAGTB023_DET_RETORNO_TITULO_IDX01 ON IPAGTB023_DET_RETORNO_TITULO (DH_VENCIMENTO);
CREATE INDEX IPAGTB023_DET_RETORNO_TITULO_IDX02 ON IPAGTB023_DET_RETORNO_TITULO (NU_NOSSO_NUMERO);

COMMENT ON TABLE IPAGTB023_DET_RETORNO_TITULO IS 'Segmento T do CNAB240. Obrigatorio no retorno da Cobranca. Contem confirmacao dos dados do titulo: nosso numero, carteira, sacado, vencimento e valores. Enviado pelo banco ao beneficiario confirmando movimentacoes dos titulos.';
COMMENT ON COLUMN IPAGTB023_DET_RETORNO_TITULO.ID_SEG_T                   IS 'Identificador surrogate gerado por sequence.';
COMMENT ON COLUMN IPAGTB023_DET_RETORNO_TITULO.ID_DETALHE_REG             IS 'Chave estrangeira para IPAGTB007_DETALHE_REG.';
COMMENT ON COLUMN IPAGTB023_DET_RETORNO_TITULO.NU_AGENCIA_BENEFICIARIO    IS 'Agencia do beneficiario (cedente). Campo G008.';
COMMENT ON COLUMN IPAGTB023_DET_RETORNO_TITULO.CO_DV_AGENCIA_BENEF        IS 'DV da agencia do beneficiario. Campo G009.';
COMMENT ON COLUMN IPAGTB023_DET_RETORNO_TITULO.NU_CONTA_BENEFICIARIO      IS 'Conta corrente do beneficiario. Campo G010.';
COMMENT ON COLUMN IPAGTB023_DET_RETORNO_TITULO.CO_DV_CONTA_BENEF          IS 'DV da conta do beneficiario. Campo G011.';
COMMENT ON COLUMN IPAGTB023_DET_RETORNO_TITULO.CO_DV_AGENCIA_CONTA_BENEF  IS 'DV conjunto agencia/conta do beneficiario. Campo G012.';
COMMENT ON COLUMN IPAGTB023_DET_RETORNO_TITULO.NU_NOSSO_NUMERO            IS 'Nosso numero do titulo no banco. Campo C004.';
COMMENT ON COLUMN IPAGTB023_DET_RETORNO_TITULO.CO_CARTEIRA                IS 'Carteira de cobranca. Campo C005.';
COMMENT ON COLUMN IPAGTB023_DET_RETORNO_TITULO.NU_NUMERO_DOCUMENTO        IS 'Numero do documento da empresa. Campo G064.';
COMMENT ON COLUMN IPAGTB023_DET_RETORNO_TITULO.DH_VENCIMENTO              IS 'Data de vencimento. Campo G044.';
COMMENT ON COLUMN IPAGTB023_DET_RETORNO_TITULO.NU_VALOR_NOMINAL           IS 'Valor nominal do titulo. Campo G042.';
COMMENT ON COLUMN IPAGTB023_DET_RETORNO_TITULO.NU_BANCO_COBRADOR          IS 'Codigo do banco cobrador. Campo G001.';
COMMENT ON COLUMN IPAGTB023_DET_RETORNO_TITULO.NU_AGENCIA_COBRADORA       IS 'Agencia cobradora. Campo G008.';
COMMENT ON COLUMN IPAGTB023_DET_RETORNO_TITULO.CO_DV_AGENCIA_COBRADORA    IS 'DV da agencia cobradora. Campo G009.';
COMMENT ON COLUMN IPAGTB023_DET_RETORNO_TITULO.CO_TIPO_INSCRICAO_SACADO   IS 'Tipo de inscricao do sacado. Campo G005.';
COMMENT ON COLUMN IPAGTB023_DET_RETORNO_TITULO.NU_INSCRICAO_SACADO        IS 'CPF/CNPJ do sacado. Campo G006.';
COMMENT ON COLUMN IPAGTB023_DET_RETORNO_TITULO.NO_SACADO                  IS 'Nome do sacado (devedor). Campo G013.';
COMMENT ON COLUMN IPAGTB023_DET_RETORNO_TITULO.NU_NUMERO_CONTRATO         IS 'Numero do contrato relacionado ao titulo. Campo C018.';
COMMENT ON COLUMN IPAGTB023_DET_RETORNO_TITULO.NU_VALOR_DESCONTO_DADO     IS 'Valor do desconto concedido. Campo G046.';
COMMENT ON COLUMN IPAGTB023_DET_RETORNO_TITULO.NU_VALOR_ABATIMENTO        IS 'Valor do abatimento concedido. Campo G046.';
COMMENT ON COLUMN IPAGTB023_DET_RETORNO_TITULO.TE_OCORRENCIA             IS 'Codigos de ocorrencias do retorno do banco. Campo G059. Posicoes 231-240.';
COMMENT ON COLUMN IPAGTB023_DET_RETORNO_TITULO.DH_INCLUSAO                IS 'Data e hora de inclusao.';
COMMENT ON COLUMN IPAGTB023_DET_RETORNO_TITULO.DH_ALTERACAO               IS 'Data e hora da ultima alteracao.';
COMMENT ON COLUMN IPAGTB023_DET_RETORNO_TITULO.NO_USUARIO_INCLUSAO        IS 'Login do usuario que incluiu.';
COMMENT ON COLUMN IPAGTB023_DET_RETORNO_TITULO.NO_USUARIO_ALTERACAO       IS 'Login do usuario que alterou.';

-- ----------------------------------------------------------------------------
-- IPAGTB024_DET_COMPL_RETORNO - Segmento U (Obrigatorio - Cobranca Retorno - Valores)
-- ----------------------------------------------------------------------------
CREATE SEQUENCE IPAGTB024_DET_COMPL_RETORNO_SQ START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE IPAGTB024_DET_COMPL_RETORNO (
    ID_SEG_U                   NUMBER        DEFAULT ON NULL IPAGTB024_DET_COMPL_RETORNO_SQ.NEXTVAL,
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
    CO_OCORRENCIA_SACADO_1     VARCHAR2(2),
    CO_OCORRENCIA_SACADO_2     VARCHAR2(2),
    CO_OCORRENCIA_SACADO_3     VARCHAR2(2),
    NU_CODIGO_BANCO_PAGADOR    NUMBER(3),
    NU_AGENCIA_PAGADORA        NUMBER(5),
    CO_DV_AGENCIA_PAGADORA     CHAR(1),
    NU_CONTA_PAGADORA          VARCHAR2(12),
    CO_DV_CONTA_PAGADORA       CHAR(1),
    CO_DV_AGENCIA_CONTA_PAG    CHAR(1),
    NU_VALOR_TARIFAS           NUMBER(15,2),
    TE_OCORRENCIA             CHAR(10),
    DH_INCLUSAO                DATE          DEFAULT SYSDATE NOT NULL,
    DH_ALTERACAO               DATE,
    NO_USUARIO_INCLUSAO        VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO       VARCHAR2(60),
    CONSTRAINT IPAGTB024_DET_COMPL_RETORNO_PK   PRIMARY KEY (ID_SEG_U),
    CONSTRAINT IPAGTB024_DET_COMPL_RETORNO_UK01 UNIQUE (ID_DETALHE_REG),
    CONSTRAINT IPAGTB007_IPAGTB024_FK01
        FOREIGN KEY (ID_DETALHE_REG) REFERENCES IPAGTB007_DETALHE_REG (ID_DETALHE_REG)
);
CREATE INDEX IPAGTB024_DET_COMPL_RETORNO_IDX01 ON IPAGTB024_DET_COMPL_RETORNO (DH_CREDITO);

COMMENT ON TABLE IPAGTB024_DET_COMPL_RETORNO IS 'Segmento U do CNAB240. Obrigatorio no retorno da Cobranca. Contem os valores financeiros da liquidacao: acrescimos, descontos, abatimento, IOF, valor pago, valor liquido, data de ocorrencia e credito e dados do pagador. Complementa o Segmento T.';
COMMENT ON COLUMN IPAGTB024_DET_COMPL_RETORNO.ID_SEG_U                   IS 'Identificador surrogate gerado por sequence.';
COMMENT ON COLUMN IPAGTB024_DET_COMPL_RETORNO.ID_DETALHE_REG             IS 'Chave estrangeira para IPAGTB007_DETALHE_REG.';
COMMENT ON COLUMN IPAGTB024_DET_COMPL_RETORNO.NU_VALOR_ACRESCIMOS        IS 'Valor dos acrescimos (mora+multa) cobrados. Campo G046.';
COMMENT ON COLUMN IPAGTB024_DET_COMPL_RETORNO.NU_VALOR_DESCONTO          IS 'Valor do desconto concedido. Campo G046.';
COMMENT ON COLUMN IPAGTB024_DET_COMPL_RETORNO.NU_VALOR_ABATIMENTO        IS 'Valor do abatimento concedido. Campo G046.';
COMMENT ON COLUMN IPAGTB024_DET_COMPL_RETORNO.NU_VALOR_IOF               IS 'Valor do IOF recolhido. Campo G052.';
COMMENT ON COLUMN IPAGTB024_DET_COMPL_RETORNO.NU_VALOR_PAGO              IS 'Valor efetivamente pago pelo sacado. Campo G042.';
COMMENT ON COLUMN IPAGTB024_DET_COMPL_RETORNO.NU_VALOR_LIQUIDO           IS 'Valor liquido creditado ao beneficiario (pago - tarifas - deducoes). Campo G042.';
COMMENT ON COLUMN IPAGTB024_DET_COMPL_RETORNO.NU_VALOR_OUTRAS_DEDUCOES   IS 'Valor de outras deducoes sobre o credito. Campo G053.';
COMMENT ON COLUMN IPAGTB024_DET_COMPL_RETORNO.NU_VALOR_OUTROS_ACRESCIMOS IS 'Valor de outros acrescimos ao credito. Campo G054.';
COMMENT ON COLUMN IPAGTB024_DET_COMPL_RETORNO.DH_OCORRENCIA              IS 'Data da ocorrencia (pagamento, baixa, etc). Campo G045.';
COMMENT ON COLUMN IPAGTB024_DET_COMPL_RETORNO.DH_CREDITO                 IS 'Data prevista de credito na conta do beneficiario. Campo G045.';
COMMENT ON COLUMN IPAGTB024_DET_COMPL_RETORNO.CO_OCORRENCIA_SACADO_1     IS 'Codigo de ocorrencia informada pelo sacado (1). Campo C019.';
COMMENT ON COLUMN IPAGTB024_DET_COMPL_RETORNO.CO_OCORRENCIA_SACADO_2     IS 'Codigo de ocorrencia informada pelo sacado (2). Campo C019.';
COMMENT ON COLUMN IPAGTB024_DET_COMPL_RETORNO.CO_OCORRENCIA_SACADO_3     IS 'Codigo de ocorrencia informada pelo sacado (3). Campo C019.';
COMMENT ON COLUMN IPAGTB024_DET_COMPL_RETORNO.NU_CODIGO_BANCO_PAGADOR    IS 'Codigo do banco onde o pagamento foi efetuado. Campo G001.';
COMMENT ON COLUMN IPAGTB024_DET_COMPL_RETORNO.NU_AGENCIA_PAGADORA        IS 'Agencia onde o pagamento foi efetuado. Campo G008.';
COMMENT ON COLUMN IPAGTB024_DET_COMPL_RETORNO.CO_DV_AGENCIA_PAGADORA     IS 'DV da agencia pagadora. Campo G009.';
COMMENT ON COLUMN IPAGTB024_DET_COMPL_RETORNO.NU_CONTA_PAGADORA          IS 'Conta onde o pagamento foi debitado. Campo G010.';
COMMENT ON COLUMN IPAGTB024_DET_COMPL_RETORNO.CO_DV_CONTA_PAGADORA       IS 'DV da conta pagadora. Campo G011.';
COMMENT ON COLUMN IPAGTB024_DET_COMPL_RETORNO.CO_DV_AGENCIA_CONTA_PAG    IS 'DV conjunto agencia/conta pagadora. Campo G012.';
COMMENT ON COLUMN IPAGTB024_DET_COMPL_RETORNO.NU_VALOR_TARIFAS           IS 'Valor das tarifas bancarias debitadas pelo banco. Campo C020.';
COMMENT ON COLUMN IPAGTB024_DET_COMPL_RETORNO.TE_OCORRENCIA             IS 'Codigos de ocorrencias de retorno. Campo G059. Posicoes 231-240.';
COMMENT ON COLUMN IPAGTB024_DET_COMPL_RETORNO.DH_INCLUSAO                IS 'Data e hora de inclusao.';
COMMENT ON COLUMN IPAGTB024_DET_COMPL_RETORNO.DH_ALTERACAO               IS 'Data e hora da ultima alteracao.';
COMMENT ON COLUMN IPAGTB024_DET_COMPL_RETORNO.NO_USUARIO_INCLUSAO        IS 'Login do usuario que incluiu.';
COMMENT ON COLUMN IPAGTB024_DET_COMPL_RETORNO.NO_USUARIO_ALTERACAO       IS 'Login do usuario que alterou.';

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
--     |-- IPAGTB002_HEADER_ARQUIVO  (1:1)
--     |-- IPAGTB003_TRAILER_ARQUIVO (1:1)
--     |-- IPAGTB004_LOTE            (1:N)
--           |-- IPAGTB005_HEADER_LOTE     (1:1)
--           |-- IPAGTB006_TRAILER_LOTE    (1:1)
--           |-- IPAGTB007_DETALHE_REG     (1:N)
--                 |-- IPAGTB010_DET_PAGAMENTO     (0:1)
--                 |-- IPAGTB011_DET_INFO_FAVORECIDO     (0:1)
--                 |-- IPAGTB012_DET_COMPLEMENTAR     (0:1)
--                 |-- IPAGTB013_DET_TITULO_COBRANCA     (0:1)
--                 |-- IPAGTB014_DET_PARTES_TITULO   (0:1)
--                 |-- IPAGTB015_DET_PIX_QR_CODE (0:1)
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
--   * IPAGTB027_DISPATCH_LOTE    - estado atual de dispatch por lote/servico
--   * IPAGTB028_HISTORICO_DISPATCH - log imutavel de tentativas de dispatch
--   * ALTER em IPAGTB031_TIPO_SERVICO - FK para servico de destino
--   * IPAGTV001_STATUS_ARQUIVO   - view de monitoramento de arquivos
--   * IPAGTV002_DISPATCH_PENDENTE - fila de trabalho para workers
-- =============================================================================

-- =============================================================================
-- DOMINIO: IPAGTB037_SERVICO_DESTINO
-- =============================================================================
CREATE SEQUENCE IPAGTB037_SERVICO_DESTINO_SQ START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE IPAGTB037_SERVICO_DESTINO (
    ID_SERVICO_DESTINO   NUMBER        DEFAULT ON NULL IPAGTB037_SERVICO_DESTINO_SQ.NEXTVAL,
    CO_SERVICO           VARCHAR2(20)  NOT NULL,
    NO_SERVICO           VARCHAR2(100) NOT NULL,
    TE_ENDPOINT_URL      VARCHAR2(500),
    NU_MAX_TENTATIVA    NUMBER(2)     DEFAULT 3    NOT NULL,
    NU_INTERVALO_RETRY_S NUMBER(6)     DEFAULT 300  NOT NULL,
    IN_ATIVO             CHAR(1)       DEFAULT 'S'  NOT NULL,
    DH_INCLUSAO          DATE          DEFAULT SYSDATE NOT NULL,
    DH_ALTERACAO         DATE,
    NO_USUARIO_INCLUSAO  VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO VARCHAR2(60),
    CONSTRAINT IPAGTB037_SERVICO_DESTINO_PK   PRIMARY KEY (ID_SERVICO_DESTINO),
    CONSTRAINT IPAGTB037_SERVICO_DESTINO_UK01 UNIQUE (CO_SERVICO),
    CONSTRAINT IPAGTB037_SERVICO_DESTINO_IN_ATIVO_CK01
        CHECK (IN_ATIVO IN ('S','N'))
);

COMMENT ON TABLE IPAGTB037_SERVICO_DESTINO IS
    'Dominio dos servicos de destino para envio dos lotes CNAB240. '
    'Cada registro representa um microsservico consumidor (Boletos, Pagamentos, Tributos). '
    'Configuracoes de endpoint e politica de retry sao centralizadas aqui.';

COMMENT ON COLUMN IPAGTB037_SERVICO_DESTINO.ID_SERVICO_DESTINO IS
    'Identificador surrogate gerado por sequence. Chave primaria interna sem significado de negocio.';
COMMENT ON COLUMN IPAGTB037_SERVICO_DESTINO.CO_SERVICO IS
    'Codigo unico do servico de destino. Valores esperados: BOLETO, PAGAMENTO, TRIBUTO.';
COMMENT ON COLUMN IPAGTB037_SERVICO_DESTINO.NO_SERVICO IS
    'Nome legivel do servico de destino. Exemplo: Servico de Boletos Bancarios.';
COMMENT ON COLUMN IPAGTB037_SERVICO_DESTINO.TE_ENDPOINT_URL IS
    'URL do endpoint REST do servico consumidor. Preenchido pela equipe de infraestrutura.';
COMMENT ON COLUMN IPAGTB037_SERVICO_DESTINO.NU_MAX_TENTATIVA IS
    'Numero maximo de tentativas de envio antes de marcar o dispatch como erro definitivo. Padrao: 3.';
COMMENT ON COLUMN IPAGTB037_SERVICO_DESTINO.NU_INTERVALO_RETRY_S IS
    'Intervalo em segundos entre tentativas de retry. Padrao: 300 segundos (5 minutos).';
COMMENT ON COLUMN IPAGTB037_SERVICO_DESTINO.IN_ATIVO IS
    'Indicador se o servico esta ativo para receber dispatches. S=Sim, N=Nao.';
COMMENT ON COLUMN IPAGTB037_SERVICO_DESTINO.DH_INCLUSAO IS
    'Data e hora de inclusao do registro. Preenchida automaticamente via DEFAULT SYSDATE.';
COMMENT ON COLUMN IPAGTB037_SERVICO_DESTINO.DH_ALTERACAO IS
    'Data e hora da ultima alteracao do registro. Atualizada pelo sistema a cada modificacao.';
COMMENT ON COLUMN IPAGTB037_SERVICO_DESTINO.NO_USUARIO_INCLUSAO IS
    'Login do usuario ou identificador do processo que incluiu o registro.';
COMMENT ON COLUMN IPAGTB037_SERVICO_DESTINO.NO_USUARIO_ALTERACAO IS
    'Login do usuario ou identificador do processo que realizou a ultima alteracao.';

-- Dados iniciais dos tres servicos de destino
INSERT INTO IPAGTB037_SERVICO_DESTINO
    (CO_SERVICO, NO_SERVICO, NU_MAX_TENTATIVA, NU_INTERVALO_RETRY_S, IN_ATIVO,
     NO_USUARIO_INCLUSAO)
VALUES ('BOLETO',    'Servico de Boletos Bancarios',      3, 300, 'S', 'SYSTEM');

INSERT INTO IPAGTB037_SERVICO_DESTINO
    (CO_SERVICO, NO_SERVICO, NU_MAX_TENTATIVA, NU_INTERVALO_RETRY_S, IN_ATIVO,
     NO_USUARIO_INCLUSAO)
VALUES ('PAGAMENTO', 'Servico de Pagamentos e Transferencias', 3, 300, 'S', 'SYSTEM');

INSERT INTO IPAGTB037_SERVICO_DESTINO
    (CO_SERVICO, NO_SERVICO, NU_MAX_TENTATIVA, NU_INTERVALO_RETRY_S, IN_ATIVO,
     NO_USUARIO_INCLUSAO)
VALUES ('TRIBUTO',   'Servico de Pagamento de Tributos',  3, 300, 'S', 'SYSTEM');

COMMIT;

-- =============================================================================
-- ALTER IPAGTB031_TIPO_SERVICO: FK para servico de destino (coluna ja inline na CREATE TABLE)
-- =============================================================================
COMMENT ON COLUMN IPAGTB031_TIPO_SERVICO.ID_SERVICO_DESTINO IS
    'FK para IPAGTB037_SERVICO_DESTINO. Indica qual microsservico e responsavel '
    'pelo processamento dos lotes deste tipo de servico CNAB240. '
    'Tipos 01 (Cobranca) e 03 (Boleto Eletronico) -> BOLETO; '
    'Tipos 20 (Pagamento Fornecedores), 30 (Salarios), 98 (Pagamentos Diversos) -> PAGAMENTO; '
    'Tipos 22 (Tributos com CB), 23 (GPS) e demais tributos -> TRIBUTO.';

ALTER TABLE IPAGTB031_TIPO_SERVICO
    ADD CONSTRAINT IPAGTB037_IPAGTB031_FK01
        FOREIGN KEY (ID_SERVICO_DESTINO)
        REFERENCES IPAGTB037_SERVICO_DESTINO (ID_SERVICO_DESTINO);

-- Mapeamento inicial: tipos de servico -> servico de destino
-- Cobranca e Boleto -> BOLETO
UPDATE IPAGTB031_TIPO_SERVICO
   SET ID_SERVICO_DESTINO = (SELECT ID_SERVICO_DESTINO FROM IPAGTB037_SERVICO_DESTINO WHERE CO_SERVICO = 'BOLETO')
 WHERE CO_TIPO_SERVICO IN ('01','03');

-- Pagamentos, Salarios, Vendor, Compror, Debito -> PAGAMENTO
UPDATE IPAGTB031_TIPO_SERVICO
   SET ID_SERVICO_DESTINO = (SELECT ID_SERVICO_DESTINO FROM IPAGTB037_SERVICO_DESTINO WHERE CO_SERVICO = 'PAGAMENTO')
 WHERE CO_TIPO_SERVICO IN ('20','22','25','30','50','60','98');

-- Tributos (com e sem CB), GPS -> TRIBUTO
UPDATE IPAGTB031_TIPO_SERVICO
   SET ID_SERVICO_DESTINO = (SELECT ID_SERVICO_DESTINO FROM IPAGTB037_SERVICO_DESTINO WHERE CO_SERVICO = 'TRIBUTO')
 WHERE CO_TIPO_SERVICO IN ('11','16','17','90','91');

COMMIT;

-- =============================================================================
-- IPAGTB025_CONTROLE_CARGA: checkpoint de carga por arquivo
-- =============================================================================
CREATE SEQUENCE IPAGTB025_CONTROLE_CARGA_SQ START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE IPAGTB025_CONTROLE_CARGA (
    ID_CONTROLE_CARGA       NUMBER        DEFAULT ON NULL IPAGTB025_CONTROLE_CARGA_SQ.NEXTVAL,
    ID_ARQUIVO              NUMBER        NOT NULL,
    CO_STATUS_CARGA         VARCHAR2(20)  DEFAULT 'PENDENTE' NOT NULL,
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
    DH_INCLUSAO             DATE          DEFAULT SYSDATE NOT NULL,
    DH_ALTERACAO            DATE,
    NO_USUARIO_INCLUSAO     VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO    VARCHAR2(60),
    CONSTRAINT IPAGTB025_CONTROLE_CARGA_PK   PRIMARY KEY (ID_CONTROLE_CARGA),
    CONSTRAINT IPAGTB025_CONTROLE_CARGA_UK01 UNIQUE (ID_ARQUIVO),
    CONSTRAINT IPAGTB001_IPAGTB025_FK01
        FOREIGN KEY (ID_ARQUIVO) REFERENCES IPAGTB001_ARQUIVO (ID_ARQUIVO),
    CONSTRAINT IPAGTB004_IPAGTB025_FK01
        FOREIGN KEY (ID_ULTIMO_LOTE_CONCLUIDO) REFERENCES IPAGTB004_LOTE (ID_LOTE),
    CONSTRAINT IPAGTB025_CONTROLE_CARGA_CO_STATUS_CK01
        CHECK (CO_STATUS_CARGA IN ('PENDENTE','EM_ANDAMENTO','CONCLUIDO','ERRO','AGUARDANDO_RETOMADA'))
);

CREATE INDEX IPAGTB025_CONTROLE_CARGA_IDX01 ON IPAGTB025_CONTROLE_CARGA (CO_STATUS_CARGA);
CREATE INDEX IPAGTB025_CONTROLE_CARGA_IDX02 ON IPAGTB025_CONTROLE_CARGA (ID_ARQUIVO, CO_STATUS_CARGA);

COMMENT ON TABLE IPAGTB025_CONTROLE_CARGA IS
    'Registra o estado de carga de cada arquivo CNAB240 no banco de dados. '
    'Permite retomada de processamento a partir do ultimo lote concluido em caso de falha. '
    'Relacao 1:1 com IPAGTB001_ARQUIVO.';

COMMENT ON COLUMN IPAGTB025_CONTROLE_CARGA.ID_CONTROLE_CARGA IS
    'Identificador surrogate gerado por sequence. Chave primaria interna sem significado de negocio.';
COMMENT ON COLUMN IPAGTB025_CONTROLE_CARGA.ID_ARQUIVO IS
    'FK para IPAGTB001_ARQUIVO. Identifica o arquivo CNAB240 sob controle de carga.';
COMMENT ON COLUMN IPAGTB025_CONTROLE_CARGA.CO_STATUS_CARGA IS
    'Status atual do processo de carga. PENDENTE=aguardando inicio; EM_ANDAMENTO=processando; '
    'CONCLUIDO=todos os lotes carregados com sucesso; ERRO=falha nao recuperavel; '
    'AGUARDANDO_RETOMADA=interrompido, pronto para retomada a partir de ID_ULTIMO_LOTE_CONCLUIDO.';
COMMENT ON COLUMN IPAGTB025_CONTROLE_CARGA.NU_TENTATIVA IS
    'Numero de tentativas de carga realizadas, incluindo retomadas. Incrementado a cada nova tentativa.';
COMMENT ON COLUMN IPAGTB025_CONTROLE_CARGA.QT_LOTE_ESPERADO IS
    'Total de lotes esperados no arquivo, extraido do Trailer de Arquivo (campo G058). '
    'Preenchido no inicio da carga apos leitura do Trailer.';
COMMENT ON COLUMN IPAGTB025_CONTROLE_CARGA.QT_LOTE_CONCLUIDO IS
    'Quantidade de lotes ja carregados com sucesso. Incrementado conforme cada lote e concluido.';
COMMENT ON COLUMN IPAGTB025_CONTROLE_CARGA.QT_REGISTRO_ESPERADO IS
    'Total de registros esperados no arquivo conforme Trailer de Arquivo (campo G066).';
COMMENT ON COLUMN IPAGTB025_CONTROLE_CARGA.QT_REGISTRO_PROCESSADO IS
    'Quantidade de registros ja inseridos no banco. Permite calcular percentual de progresso.';
COMMENT ON COLUMN IPAGTB025_CONTROLE_CARGA.ID_ULTIMO_LOTE_CONCLUIDO IS
    'FK para IPAGTB004_LOTE. Ponto de checkpoint: ultimo lote carregado com sucesso. '
    'Em caso de retomada, o processamento reinicia a partir do lote seguinte a este.';
COMMENT ON COLUMN IPAGTB025_CONTROLE_CARGA.DH_INICIO_CARGA IS
    'Data e hora do inicio do processamento de carga do arquivo.';
COMMENT ON COLUMN IPAGTB025_CONTROLE_CARGA.DH_FIM_CARGA IS
    'Data e hora da conclusao bem-sucedida da carga. Nulo enquanto nao concluido.';
COMMENT ON COLUMN IPAGTB025_CONTROLE_CARGA.DH_ULTIMA_ATUALIZACAO IS
    'Data e hora da ultima atualizacao do status de carga. Atualizado a cada mudanca de estado.';
COMMENT ON COLUMN IPAGTB025_CONTROLE_CARGA.TE_MENSAGEM_ERRO IS
    'Mensagem de erro detalhada em caso de falha. Stack trace ou descricao do problema encontrado.';
COMMENT ON COLUMN IPAGTB025_CONTROLE_CARGA.DH_INCLUSAO IS
    'Data e hora de inclusao do registro de controle. Preenchida automaticamente via DEFAULT SYSDATE.';
COMMENT ON COLUMN IPAGTB025_CONTROLE_CARGA.DH_ALTERACAO IS
    'Data e hora da ultima alteracao do registro. Atualizada pelo sistema a cada modificacao.';
COMMENT ON COLUMN IPAGTB025_CONTROLE_CARGA.NO_USUARIO_INCLUSAO IS
    'Login do usuario ou identificador do processo que criou o registro de controle.';
COMMENT ON COLUMN IPAGTB025_CONTROLE_CARGA.NO_USUARIO_ALTERACAO IS
    'Login do usuario ou processo que realizou a ultima alteracao no registro de controle.';

-- =============================================================================
-- IPAGTB026_CTRL_CARGA_LOTE: checkpoint de carga por lote
-- =============================================================================
CREATE SEQUENCE IPAGTB026_CTRL_CARGA_LOTE_SQ START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE IPAGTB026_CTRL_CARGA_LOTE (
    ID_CTRL_CARGA_LOTE      NUMBER        DEFAULT ON NULL IPAGTB026_CTRL_CARGA_LOTE_SQ.NEXTVAL,
    ID_CONTROLE_CARGA       NUMBER        NOT NULL,
    ID_LOTE                 NUMBER        NOT NULL,
    CO_STATUS_LOTE          VARCHAR2(20)  DEFAULT 'PENDENTE' NOT NULL,
    QT_DETALHE_ESPERADO   NUMBER(8),
    QT_DETALHE_PROCESSADO NUMBER(8)     DEFAULT 0 NOT NULL,
    QT_SEGMENTO_PROCESSADO NUMBER(10)   DEFAULT 0 NOT NULL,
    DH_INICIO_LOTE          DATE,
    DH_FIM_LOTE             DATE,
    TE_MENSAGEM_ERRO        VARCHAR2(4000),
    DH_INCLUSAO             DATE          DEFAULT SYSDATE NOT NULL,
    DH_ALTERACAO            DATE,
    NO_USUARIO_INCLUSAO     VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO    VARCHAR2(60),
    CONSTRAINT IPAGTB026_CTRL_CARGA_LOTE_PK   PRIMARY KEY (ID_CTRL_CARGA_LOTE),
    CONSTRAINT IPAGTB026_CTRL_CARGA_LOTE_UK01 UNIQUE (ID_CONTROLE_CARGA, ID_LOTE),
    CONSTRAINT IPAGTB025_IPAGTB026_FK01
        FOREIGN KEY (ID_CONTROLE_CARGA) REFERENCES IPAGTB025_CONTROLE_CARGA (ID_CONTROLE_CARGA),
    CONSTRAINT IPAGTB004_IPAGTB026_FK01
        FOREIGN KEY (ID_LOTE) REFERENCES IPAGTB004_LOTE (ID_LOTE),
    CONSTRAINT IPAGTB026_CTRL_CARGA_LOTE_CO_STATUS_CK01
        CHECK (CO_STATUS_LOTE IN ('PENDENTE','EM_ANDAMENTO','CONCLUIDO','ERRO'))
);

CREATE INDEX IPAGTB026_CTRL_CARGA_LOTE_IDX01 ON IPAGTB026_CTRL_CARGA_LOTE (ID_CONTROLE_CARGA, CO_STATUS_LOTE);
CREATE INDEX IPAGTB026_CTRL_CARGA_LOTE_IDX02 ON IPAGTB026_CTRL_CARGA_LOTE (ID_LOTE);

COMMENT ON TABLE IPAGTB026_CTRL_CARGA_LOTE IS
    'Registra o estado de carga de cada lote CNAB240 individualmente. '
    'Granularidade fina do checkpoint: permite saber exatamente quais lotes foram '
    'carregados com sucesso e quais precisam ser reprocessados em caso de retomada.';

COMMENT ON COLUMN IPAGTB026_CTRL_CARGA_LOTE.ID_CTRL_CARGA_LOTE IS
    'Identificador surrogate gerado por sequence. Chave primaria interna sem significado de negocio.';
COMMENT ON COLUMN IPAGTB026_CTRL_CARGA_LOTE.ID_CONTROLE_CARGA IS
    'FK para IPAGTB025_CONTROLE_CARGA. Liga o controle do lote ao controle pai do arquivo.';
COMMENT ON COLUMN IPAGTB026_CTRL_CARGA_LOTE.ID_LOTE IS
    'FK para IPAGTB004_LOTE. Identifica o lote sendo controlado.';
COMMENT ON COLUMN IPAGTB026_CTRL_CARGA_LOTE.CO_STATUS_LOTE IS
    'Status atual da carga deste lote especifico. '
    'PENDENTE=aguardando processamento; EM_ANDAMENTO=em processamento; '
    'CONCLUIDO=todos os detalhes e segmentos carregados; ERRO=falha no processamento.';
COMMENT ON COLUMN IPAGTB026_CTRL_CARGA_LOTE.QT_DETALHE_ESPERADO IS
    'Quantidade de registros de detalhe (Tipo 3) esperados neste lote, '
    'extraida do Trailer de Lote (campo G057).';
COMMENT ON COLUMN IPAGTB026_CTRL_CARGA_LOTE.QT_DETALHE_PROCESSADO IS
    'Quantidade de registros de detalhe ja inseridos em IPAGTB007_DETALHE_REG. '
    'Incrementado a cada detalhe processado com sucesso.';
COMMENT ON COLUMN IPAGTB026_CTRL_CARGA_LOTE.QT_SEGMENTO_PROCESSADO IS
    'Total de segmentos (A, B, C, J, etc.) inseridos para este lote. '
    'Util para diagnostico e auditoria de carga.';
COMMENT ON COLUMN IPAGTB026_CTRL_CARGA_LOTE.DH_INICIO_LOTE IS
    'Data e hora do inicio do processamento deste lote.';
COMMENT ON COLUMN IPAGTB026_CTRL_CARGA_LOTE.DH_FIM_LOTE IS
    'Data e hora da conclusao do processamento deste lote. Nulo enquanto nao concluido.';
COMMENT ON COLUMN IPAGTB026_CTRL_CARGA_LOTE.TE_MENSAGEM_ERRO IS
    'Mensagem de erro detalhada caso o processamento do lote falhe. '
    'Inclui identificacao do registro que causou a falha quando possivel.';
COMMENT ON COLUMN IPAGTB026_CTRL_CARGA_LOTE.DH_INCLUSAO IS
    'Data e hora de inclusao do registro de controle do lote. Preenchida automaticamente.';
COMMENT ON COLUMN IPAGTB026_CTRL_CARGA_LOTE.DH_ALTERACAO IS
    'Data e hora da ultima alteracao do registro. Atualizada pelo sistema.';
COMMENT ON COLUMN IPAGTB026_CTRL_CARGA_LOTE.NO_USUARIO_INCLUSAO IS
    'Login do usuario ou identificador do processo que criou o registro de controle do lote.';
COMMENT ON COLUMN IPAGTB026_CTRL_CARGA_LOTE.NO_USUARIO_ALTERACAO IS
    'Login do usuario ou processo que realizou a ultima alteracao no registro de controle.';

-- =============================================================================
-- IPAGTB027_DISPATCH_LOTE: estado atual de dispatch por lote e servico
-- =============================================================================
CREATE SEQUENCE IPAGTB027_DISPATCH_LOTE_SQ START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE IPAGTB027_DISPATCH_LOTE (
    ID_DISPATCH_LOTE        NUMBER        DEFAULT ON NULL IPAGTB027_DISPATCH_LOTE_SQ.NEXTVAL,
    ID_LOTE                 NUMBER        NOT NULL,
    ID_SERVICO_DESTINO      NUMBER        NOT NULL,
    CO_STATUS_DISPATCH      VARCHAR2(20)  DEFAULT 'PENDENTE' NOT NULL,
    NU_TENTATIVA_ATUAL      NUMBER(3)     DEFAULT 0 NOT NULL,
    NU_MAX_TENTATIVA       NUMBER(3)     DEFAULT 3 NOT NULL,
    DH_PROXIMO_ENVIO        DATE,
    DH_ULTIMO_ENVIO         DATE,
    DH_CONFIRMACAO          DATE,
    NU_PROTOCOLO_EXTERNO    VARCHAR2(100),
    NU_CORRELACAO_EXTERNA   VARCHAR2(100),
    CO_HTTP_STATUS          NUMBER(3),
    TE_PAYLOAD_ENVIADO      CLOB,
    TE_RESPOSTA_SERVICO     CLOB,
    DH_INCLUSAO             DATE          DEFAULT SYSDATE NOT NULL,
    DH_ALTERACAO            DATE,
    NO_USUARIO_INCLUSAO     VARCHAR2(60)  NOT NULL,
    NO_USUARIO_ALTERACAO    VARCHAR2(60),
    CONSTRAINT IPAGTB027_DISPATCH_LOTE_PK   PRIMARY KEY (ID_DISPATCH_LOTE),
    CONSTRAINT IPAGTB027_DISPATCH_LOTE_UK01 UNIQUE (ID_LOTE, ID_SERVICO_DESTINO),
    CONSTRAINT IPAGTB004_IPAGTB027_FK01
        FOREIGN KEY (ID_LOTE) REFERENCES IPAGTB004_LOTE (ID_LOTE),
    CONSTRAINT IPAGTB037_IPAGTB027_FK01
        FOREIGN KEY (ID_SERVICO_DESTINO) REFERENCES IPAGTB037_SERVICO_DESTINO (ID_SERVICO_DESTINO),
    CONSTRAINT IPAGTB027_DISPATCH_LOTE_CO_STATUS_CK01
        CHECK (CO_STATUS_DISPATCH IN ('PENDENTE','ENVIADO','CONFIRMADO','ERRO','RETENTATIVA','CANCELADO'))
);

CREATE INDEX IPAGTB027_DISPATCH_LOTE_IDX01 ON IPAGTB027_DISPATCH_LOTE (CO_STATUS_DISPATCH, DH_PROXIMO_ENVIO);
CREATE INDEX IPAGTB027_DISPATCH_LOTE_IDX02 ON IPAGTB027_DISPATCH_LOTE (ID_SERVICO_DESTINO, CO_STATUS_DISPATCH);
CREATE INDEX IPAGTB027_DISPATCH_LOTE_IDX03 ON IPAGTB027_DISPATCH_LOTE (ID_LOTE, CO_STATUS_DISPATCH);

COMMENT ON TABLE IPAGTB027_DISPATCH_LOTE IS
    'Registra o estado atual de envio (dispatch) de cada lote para cada servico de destino. '
    'Representa a visao corrente da maquina de estados: PENDENTE->ENVIADO->CONFIRMADO ou ERRO->RETENTATIVA. '
    'Relacao N:N entre lotes e servicos de destino com estado de controle.';

COMMENT ON COLUMN IPAGTB027_DISPATCH_LOTE.ID_DISPATCH_LOTE IS
    'Identificador surrogate gerado por sequence. Chave primaria interna sem significado de negocio.';
COMMENT ON COLUMN IPAGTB027_DISPATCH_LOTE.ID_LOTE IS
    'FK para IPAGTB004_LOTE. Lote CNAB240 a ser despachado para o servico de destino.';
COMMENT ON COLUMN IPAGTB027_DISPATCH_LOTE.ID_SERVICO_DESTINO IS
    'FK para IPAGTB037_SERVICO_DESTINO. Servico que deve receber este lote (BOLETO, PAGAMENTO ou TRIBUTO).';
COMMENT ON COLUMN IPAGTB027_DISPATCH_LOTE.CO_STATUS_DISPATCH IS
    'Estado atual na maquina de estados de dispatch. '
    'PENDENTE=aguardando envio; ENVIADO=requisicao enviada, aguardando confirmacao; '
    'CONFIRMADO=processamento confirmado pelo servico; ERRO=falha definitiva apos max tentativas; '
    'RETENTATIVA=aguardando proximo envio conforme DH_PROXIMO_ENVIO; CANCELADO=cancelado manualmente.';
COMMENT ON COLUMN IPAGTB027_DISPATCH_LOTE.NU_TENTATIVA_ATUAL IS
    'Numero da tentativa de envio atual. Comeca em 0 (sem tentativa) e incrementa a cada envio.';
COMMENT ON COLUMN IPAGTB027_DISPATCH_LOTE.NU_MAX_TENTATIVA IS
    'Numero maximo de tentativas para este dispatch. Copiado de IPAGTB037_SERVICO_DESTINO no momento da criacao.';
COMMENT ON COLUMN IPAGTB027_DISPATCH_LOTE.DH_PROXIMO_ENVIO IS
    'Data e hora agendada para a proxima tentativa de envio. '
    'Calculada como DH_ULTIMO_ENVIO + NU_INTERVALO_RETRY_S segundos.';
COMMENT ON COLUMN IPAGTB027_DISPATCH_LOTE.DH_ULTIMO_ENVIO IS
    'Data e hora do ultimo envio realizado (independente de sucesso ou falha).';
COMMENT ON COLUMN IPAGTB027_DISPATCH_LOTE.DH_CONFIRMACAO IS
    'Data e hora em que o servico de destino confirmou o processamento bem-sucedido do lote.';
COMMENT ON COLUMN IPAGTB027_DISPATCH_LOTE.NU_PROTOCOLO_EXTERNO IS
    'Identificador do protocolo ou ticket gerado pelo servico de destino ao receber o lote. '
    'Usado para rastreabilidade e consulta de status no servico externo.';
COMMENT ON COLUMN IPAGTB027_DISPATCH_LOTE.NU_CORRELACAO_EXTERNA IS
    'Numero de correlacao para rastreamento fim-a-fim da mensagem entre sistemas. '
    'Pode ser um UUID gerado no envio ou fornecido pelo servico receptor.';
COMMENT ON COLUMN IPAGTB027_DISPATCH_LOTE.CO_HTTP_STATUS IS
    'Codigo HTTP da ultima resposta recebida do servico de destino. '
    'Exemplos: 200=OK, 202=Accepted, 400=BadRequest, 500=InternalServerError.';
COMMENT ON COLUMN IPAGTB027_DISPATCH_LOTE.TE_PAYLOAD_ENVIADO IS
    'Payload JSON ou XML enviado ao servico de destino na ultima tentativa. '
    'Armazenado para auditoria e diagnostico de falhas.';
COMMENT ON COLUMN IPAGTB027_DISPATCH_LOTE.TE_RESPOSTA_SERVICO IS
    'Corpo da resposta retornada pelo servico de destino na ultima tentativa. '
    'Pode conter mensagem de erro ou confirmacao de recebimento.';
COMMENT ON COLUMN IPAGTB027_DISPATCH_LOTE.DH_INCLUSAO IS
    'Data e hora de criacao do registro de dispatch. Preenchida automaticamente via DEFAULT SYSDATE.';
COMMENT ON COLUMN IPAGTB027_DISPATCH_LOTE.DH_ALTERACAO IS
    'Data e hora da ultima alteracao do estado de dispatch. Atualizada a cada transicao de estado.';
COMMENT ON COLUMN IPAGTB027_DISPATCH_LOTE.NO_USUARIO_INCLUSAO IS
    'Login do usuario ou identificador do processo que criou o registro de dispatch.';
COMMENT ON COLUMN IPAGTB027_DISPATCH_LOTE.NO_USUARIO_ALTERACAO IS
    'Login do usuario ou processo que realizou a ultima alteracao no estado de dispatch.';

-- =============================================================================
-- IPAGTB028_HISTORICO_DISPATCH: log imutavel de tentativas de dispatch
-- =============================================================================
CREATE SEQUENCE IPAGTB028_HISTORICO_DISPATCH_SQ START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE IPAGTB028_HISTORICO_DISPATCH (
    ID_HISTORICO_DISPATCH   NUMBER        DEFAULT ON NULL IPAGTB028_HISTORICO_DISPATCH_SQ.NEXTVAL,
    ID_DISPATCH_LOTE        NUMBER        NOT NULL,
    NU_NUMERO_TENTATIVA     NUMBER(3)     NOT NULL,
    CO_STATUS_RESULTADO     VARCHAR2(20)  NOT NULL,
    DH_ENVIO                DATE          NOT NULL,
    DH_RESPOSTA             DATE,
    NU_DURACAO_MS           NUMBER(10),
    CO_HTTP_STATUS          NUMBER(3),
    NU_PROTOCOLO_EXTERNO    VARCHAR2(100),
    TE_PAYLOAD_ENVIADO      CLOB,
    TE_RESPOSTA_SERVICO     CLOB,
    TE_MENSAGEM_ERRO        VARCHAR2(4000),
    NO_PROCESSO_EXECUTOR    VARCHAR2(100),
    NO_SERVIDOR_EXECUTOR    VARCHAR2(100),
    DH_INCLUSAO             DATE          DEFAULT SYSDATE NOT NULL,
    NO_USUARIO_INCLUSAO     VARCHAR2(60)  NOT NULL,
    CONSTRAINT IPAGTB028_HISTORICO_DISPATCH_PK   PRIMARY KEY (ID_HISTORICO_DISPATCH),
    CONSTRAINT IPAGTB028_HISTORICO_DISPATCH_UK01 UNIQUE (ID_DISPATCH_LOTE, NU_NUMERO_TENTATIVA),
    CONSTRAINT IPAGTB027_IPAGTB028_FK01
        FOREIGN KEY (ID_DISPATCH_LOTE) REFERENCES IPAGTB027_DISPATCH_LOTE (ID_DISPATCH_LOTE),
    CONSTRAINT IPAGTB028_HISTORICO_DISPATCH_CO_STATUS_CK01
        CHECK (CO_STATUS_RESULTADO IN ('ENVIADO','CONFIRMADO','ERRO','TIMEOUT','CANCELADO'))
);

CREATE INDEX IPAGTB028_HISTORICO_DISPATCH_IDX01 ON IPAGTB028_HISTORICO_DISPATCH (ID_DISPATCH_LOTE, NU_NUMERO_TENTATIVA);
CREATE INDEX IPAGTB028_HISTORICO_DISPATCH_IDX02 ON IPAGTB028_HISTORICO_DISPATCH (DH_ENVIO, CO_STATUS_RESULTADO);

COMMENT ON TABLE IPAGTB028_HISTORICO_DISPATCH IS
    'Log imutavel (append-only) de todas as tentativas de dispatch de lotes para servicos externos. '
    'Nunca atualizado apos insert â€” cada tentativa gera um novo registro. '
    'Permite auditoria completa do historico de envios, falhas e retentativas por lote/servico.';

COMMENT ON COLUMN IPAGTB028_HISTORICO_DISPATCH.ID_HISTORICO_DISPATCH IS
    'Identificador surrogate gerado por sequence. Chave primaria interna sem significado de negocio.';
COMMENT ON COLUMN IPAGTB028_HISTORICO_DISPATCH.ID_DISPATCH_LOTE IS
    'FK para IPAGTB027_DISPATCH_LOTE. Liga o historico ao registro de estado atual do dispatch.';
COMMENT ON COLUMN IPAGTB028_HISTORICO_DISPATCH.NU_NUMERO_TENTATIVA IS
    'Numero sequencial desta tentativa para o dispatch. '
    'Corresponde ao valor de NU_TENTATIVA_ATUAL em IPAGTB027 no momento do envio.';
COMMENT ON COLUMN IPAGTB028_HISTORICO_DISPATCH.CO_STATUS_RESULTADO IS
    'Resultado desta tentativa especifica. '
    'ENVIADO=enviado, confirmacao pendente; CONFIRMADO=confirmado pelo servico; '
    'ERRO=falha de negocio ou HTTP error; TIMEOUT=sem resposta no prazo; CANCELADO=cancelado.';
COMMENT ON COLUMN IPAGTB028_HISTORICO_DISPATCH.DH_ENVIO IS
    'Data e hora exata em que a requisicao foi enviada ao servico de destino.';
COMMENT ON COLUMN IPAGTB028_HISTORICO_DISPATCH.DH_RESPOSTA IS
    'Data e hora em que a resposta foi recebida do servico. Nulo em caso de timeout.';
COMMENT ON COLUMN IPAGTB028_HISTORICO_DISPATCH.NU_DURACAO_MS IS
    'Duracao da chamada em milissegundos (DH_RESPOSTA - DH_ENVIO). '
    'Util para monitoramento de latencia e SLA do servico de destino.';
COMMENT ON COLUMN IPAGTB028_HISTORICO_DISPATCH.CO_HTTP_STATUS IS
    'Codigo HTTP recebido do servico nesta tentativa. Nulo em caso de timeout ou erro de conectividade.';
COMMENT ON COLUMN IPAGTB028_HISTORICO_DISPATCH.NU_PROTOCOLO_EXTERNO IS
    'Identificador do protocolo gerado pelo servico de destino nesta tentativa especifica.';
COMMENT ON COLUMN IPAGTB028_HISTORICO_DISPATCH.TE_PAYLOAD_ENVIADO IS
    'Payload exato enviado nesta tentativa. Preservado para auditoria mesmo que tentativas subsequentes '
    'enviem payload diferente (ex: apos correcao de dados).';
COMMENT ON COLUMN IPAGTB028_HISTORICO_DISPATCH.TE_RESPOSTA_SERVICO IS
    'Corpo exato da resposta recebida nesta tentativa. Nulo em caso de timeout.';
COMMENT ON COLUMN IPAGTB028_HISTORICO_DISPATCH.TE_MENSAGEM_ERRO IS
    'Descricao tecnica do erro ocorrido nesta tentativa, quando aplicavel. '
    'Pode conter excecao Java, mensagem HTTP ou descricao do timeout.';
COMMENT ON COLUMN IPAGTB028_HISTORICO_DISPATCH.NO_PROCESSO_EXECUTOR IS
    'Identificador do processo ou thread que executou este dispatch. '
    'Util para diagnostico em ambientes com multiplos workers.';
COMMENT ON COLUMN IPAGTB028_HISTORICO_DISPATCH.NO_SERVIDOR_EXECUTOR IS
    'Nome ou IP do servidor que executou este dispatch. '
    'Util para diagnostico em ambientes com multiplas instancias do servico de carga.';
COMMENT ON COLUMN IPAGTB028_HISTORICO_DISPATCH.DH_INCLUSAO IS
    'Data e hora de insercao do registro historico. Imutavel apos insert (nao deve ser atualizado).';
COMMENT ON COLUMN IPAGTB028_HISTORICO_DISPATCH.NO_USUARIO_INCLUSAO IS
    'Login do usuario ou identificador do processo que gerou este registro historico. '
    'Nao ha NO_USUARIO_ALTERACAO pois este registro e imutavel.';

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
    -- Contagem de dispatches por status para cada servico
    SUM(CASE WHEN sd.CO_SERVICO = 'BOLETO'    AND dl.CO_STATUS_DISPATCH = 'CONFIRMADO' THEN 1 ELSE 0 END)
                                                 AS QT_LOTE_BOLETO_CONFIRMADO,
    SUM(CASE WHEN sd.CO_SERVICO = 'BOLETO'    AND dl.CO_STATUS_DISPATCH = 'PENDENTE'   THEN 1 ELSE 0 END)
                                                 AS QT_LOTE_BOLETO_PENDENTE,
    SUM(CASE WHEN sd.CO_SERVICO = 'BOLETO'    AND dl.CO_STATUS_DISPATCH = 'ERRO'       THEN 1 ELSE 0 END)
                                                 AS QT_LOTE_BOLETO_ERRO,
    SUM(CASE WHEN sd.CO_SERVICO = 'PAGAMENTO' AND dl.CO_STATUS_DISPATCH = 'CONFIRMADO' THEN 1 ELSE 0 END)
                                                 AS QT_LOTE_PAGAMENTO_CONFIRMADO,
    SUM(CASE WHEN sd.CO_SERVICO = 'PAGAMENTO' AND dl.CO_STATUS_DISPATCH = 'PENDENTE'   THEN 1 ELSE 0 END)
                                                 AS QT_LOTE_PAGAMENTO_PENDENTE,
    SUM(CASE WHEN sd.CO_SERVICO = 'PAGAMENTO' AND dl.CO_STATUS_DISPATCH = 'ERRO'       THEN 1 ELSE 0 END)
                                                 AS QT_LOTE_PAGAMENTO_ERRO,
    SUM(CASE WHEN sd.CO_SERVICO = 'TRIBUTO'   AND dl.CO_STATUS_DISPATCH = 'CONFIRMADO' THEN 1 ELSE 0 END)
                                                 AS QT_LOTE_TRIBUTO_CONFIRMADO,
    SUM(CASE WHEN sd.CO_SERVICO = 'TRIBUTO'   AND dl.CO_STATUS_DISPATCH = 'PENDENTE'   THEN 1 ELSE 0 END)
                                                 AS QT_LOTE_TRIBUTO_PENDENTE,
    SUM(CASE WHEN sd.CO_SERVICO = 'TRIBUTO'   AND dl.CO_STATUS_DISPATCH = 'ERRO'       THEN 1 ELSE 0 END)
                                                 AS QT_LOTE_TRIBUTO_ERRO
FROM
    IPAGTB001_ARQUIVO            arq
    LEFT JOIN IPAGTB025_CONTROLE_CARGA   cc  ON cc.ID_ARQUIVO = arq.ID_ARQUIVO
    LEFT JOIN IPAGTB004_LOTE             lt  ON lt.ID_ARQUIVO = arq.ID_ARQUIVO
    LEFT JOIN IPAGTB027_DISPATCH_LOTE    dl  ON dl.ID_LOTE    = lt.ID_LOTE
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

COMMENT ON TABLE IPAGTV001_STATUS_ARQUIVO IS
    'Visao consolidada do status de carga e dispatch de cada arquivo CNAB240. '
    'Exibe o progresso da carga e a contagem de lotes por estado para cada servico de destino '
    '(BOLETO, PAGAMENTO, TRIBUTO). Uso recomendado: painel de monitoramento operacional.';

-- =============================================================================
-- VIEW IPAGTV002_DISPATCH_PENDENTE: fila de trabalho para workers de dispatch
-- =============================================================================
CREATE OR REPLACE VIEW IPAGTV002_DISPATCH_PENDENTE AS
SELECT
    dl.ID_DISPATCH_LOTE,
    dl.ID_LOTE,
    lt.ID_ARQUIVO,
    arq.NO_NOME_ARQUIVO,
    lt.NU_SEQUENCIAL_LOTE,
    ts.CO_TIPO_SERVICO,
    ts.NO_TIPO_SERVICO,
    sd.ID_SERVICO_DESTINO,
    sd.CO_SERVICO,
    sd.NO_SERVICO,
    sd.TE_ENDPOINT_URL,
    dl.CO_STATUS_DISPATCH,
    dl.NU_TENTATIVA_ATUAL,
    dl.NU_MAX_TENTATIVA,
    dl.DH_PROXIMO_ENVIO,
    dl.DH_ULTIMO_ENVIO,
    CASE
        WHEN dl.CO_STATUS_DISPATCH = 'PENDENTE'    THEN 1
        WHEN dl.CO_STATUS_DISPATCH = 'RETENTATIVA' THEN 2
        ELSE 9
    END AS NU_PRIORIDADE_FILA
FROM
    IPAGTB027_DISPATCH_LOTE      dl
    JOIN IPAGTB004_LOTE          lt  ON lt.ID_LOTE             = dl.ID_LOTE
    JOIN IPAGTB001_ARQUIVO       arq ON arq.ID_ARQUIVO          = lt.ID_ARQUIVO
    JOIN IPAGTB031_TIPO_SERVICO  ts  ON ts.ID_TIPO_SERVICO      = lt.ID_TIPO_SERVICO
    JOIN IPAGTB037_SERVICO_DESTINO sd ON sd.ID_SERVICO_DESTINO  = dl.ID_SERVICO_DESTINO
WHERE
    dl.CO_STATUS_DISPATCH IN ('PENDENTE', 'RETENTATIVA')
    AND (dl.DH_PROXIMO_ENVIO IS NULL OR dl.DH_PROXIMO_ENVIO <= SYSDATE)
    AND dl.NU_TENTATIVA_ATUAL < dl.NU_MAX_TENTATIVA
    AND sd.IN_ATIVO = 'S'
ORDER BY
    NU_PRIORIDADE_FILA,
    dl.DH_PROXIMO_ENVIO NULLS FIRST,
    dl.ID_DISPATCH_LOTE;

COMMENT ON TABLE IPAGTV002_DISPATCH_PENDENTE IS
    'Fila de trabalho para workers de dispatch: lista os lotes prontos para envio ou retentativa. '
    'Retorna apenas dispatches PENDENTES ou em RETENTATIVA cujo DH_PROXIMO_ENVIO ja passou. '
    'Ordenada por prioridade (PENDENTE antes de RETENTATIVA) e depois por tempo de espera. '
    'Workers devem selecionar e travar registros com SELECT ... FOR UPDATE SKIP LOCKED.';

-- =============================================================================
-- RESUMO DO FLUXO OPERACIONAL
-- =============================================================================
-- 1. CARGA DO ARQUIVO
--    a. Inserir em IPAGTB001_ARQUIVO (arquivo fisico identificado)
--    b. Inserir em IPAGTB025_CONTROLE_CARGA (CO_STATUS_CARGA='PENDENTE')
--    c. Para cada lote do arquivo:
--       - Inserir em IPAGTB004_LOTE
--       - Inserir em IPAGTB026_CTRL_CARGA_LOTE (CO_STATUS_LOTE='PENDENTE')
--       - Processar Header, Trailer, Detalhes e Segmentos do lote
--       - Atualizar IPAGTB026: CO_STATUS_LOTE='CONCLUIDO'
--       - Criar IPAGTB027_DISPATCH_LOTE para o servico mapeado no tipo de servico do lote
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
--    a. Worker consulta IPAGTV002_DISPATCH_PENDENTE (SELECT FOR UPDATE SKIP LOCKED)
--    b. Envia payload ao servico (TE_ENDPOINT_URL)
--    c. Registra tentativa em IPAGTB028_HISTORICO_DISPATCH (insert imutavel)
--    d. Atualiza IPAGTB027_DISPATCH_LOTE com resultado:
--       - Sucesso: CO_STATUS_DISPATCH='CONFIRMADO', DH_CONFIRMACAO=SYSDATE
--       - Falha com tentativas restantes: CO_STATUS_DISPATCH='RETENTATIVA',
--         DH_PROXIMO_ENVIO=SYSDATE+NU_INTERVALO_RETRY_S/86400
--       - Falha definitiva (sem tentativas): CO_STATUS_DISPATCH='ERRO'
--
-- 4. MONITORAMENTO
--    Consultar IPAGTV001_STATUS_ARQUIVO para visao consolidada por arquivo.
-- =============================================================================

-- =============================================================================
-- IPAGTB029_CONTROLE_LINHA: controle de processamento por linha do arquivo
-- =============================================================================
CREATE SEQUENCE IPAGTB029_CONTROLE_LINHA_SQ START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE TABLE IPAGTB029_CONTROLE_LINHA (
    ID_CONTROLE_LINHA    NUMBER         DEFAULT ON NULL IPAGTB029_CONTROLE_LINHA_SQ.NEXTVAL,
    ID_ARQUIVO           NUMBER         NOT NULL,
    NU_NUMERO_LINHA      NUMBER(10)     NOT NULL,
    CO_TIPO_REGISTRO     CHAR(1)        NOT NULL,
    CO_SEGMENTO          CHAR(1),
    NU_LOTE_CNAB         NUMBER(4),
    TE_CONTEUDO_LINHA    VARCHAR2(240)  NOT NULL,
    CO_STATUS_LINHA      VARCHAR2(15)   DEFAULT 'PENDENTE' NOT NULL,
    NO_TABELA_DESTINO    VARCHAR2(30),
    ID_ENTIDADE_CRIADA   NUMBER,
    DH_PROCESSAMENTO     DATE,
    TE_MENSAGEM_ERRO     VARCHAR2(4000),
    DH_INCLUSAO          DATE           DEFAULT SYSDATE NOT NULL,
    DH_ALTERACAO         DATE,
    NO_USUARIO_INCLUSAO  VARCHAR2(60)   NOT NULL,
    NO_USUARIO_ALTERACAO VARCHAR2(60),
    ID_TIPO_REGISTRO     NUMBER,
    CONSTRAINT IPAGTB029_CONTROLE_LINHA_PK   PRIMARY KEY (ID_CONTROLE_LINHA),
    CONSTRAINT IPAGTB029_CONTROLE_LINHA_UK01 UNIQUE (ID_ARQUIVO, NU_NUMERO_LINHA),
    CONSTRAINT IPAGTB001_IPAGTB029_FK01
        FOREIGN KEY (ID_ARQUIVO) REFERENCES IPAGTB001_ARQUIVO (ID_ARQUIVO),
    CONSTRAINT IPAGTB030_IPAGTB029_FK01
        FOREIGN KEY (ID_TIPO_REGISTRO) REFERENCES IPAGTB030_TIPO_REGISTRO (ID_TIPO_REGISTRO),
    CONSTRAINT IPAGTB029_CONTROLE_LINHA_CO_TIPO_CK01
        CHECK (CO_TIPO_REGISTRO IN ('0','1','2','3','4','5','9')),
    CONSTRAINT IPAGTB029_CONTROLE_LINHA_CO_STATUS_CK01
        CHECK (CO_STATUS_LINHA IN ('PENDENTE','PROCESSADO','ERRO','IGNORADO'))
);

CREATE INDEX IPAGTB029_CONTROLE_LINHA_IDX01 ON IPAGTB029_CONTROLE_LINHA (ID_ARQUIVO, CO_STATUS_LINHA);
CREATE INDEX IPAGTB029_CONTROLE_LINHA_IDX02 ON IPAGTB029_CONTROLE_LINHA (ID_ARQUIVO, NU_NUMERO_LINHA, CO_STATUS_LINHA);
CREATE INDEX IPAGTB029_CONTROLE_LINHA_IDX03 ON IPAGTB029_CONTROLE_LINHA (CO_STATUS_LINHA, CO_TIPO_REGISTRO);

COMMENT ON TABLE IPAGTB029_CONTROLE_LINHA IS
    'Registra cada linha fisica (240 posicoes) de um arquivo CNAB240 e seu estado de processamento. '
    'Permite saber exatamente quais linhas foram persistidas com sucesso, quais falharam e em qual '
    'tabela Oracle cada linha resultou â€” garantindo rastreabilidade completa do arquivo bruto ao modelo.';

COMMENT ON COLUMN IPAGTB029_CONTROLE_LINHA.ID_CONTROLE_LINHA IS
    'Identificador surrogate gerado por sequence. Chave primaria interna sem significado de negocio.';
COMMENT ON COLUMN IPAGTB029_CONTROLE_LINHA.ID_ARQUIVO IS
    'FK para IPAGTB001_ARQUIVO. Identifica o arquivo CNAB240 ao qual esta linha pertence.';
COMMENT ON COLUMN IPAGTB029_CONTROLE_LINHA.NU_NUMERO_LINHA IS
    'Numero sequencial da linha no arquivo fisico, iniciando em 1. '
    'Junto com ID_ARQUIVO, identifica unicamente qualquer linha de qualquer arquivo.';
COMMENT ON COLUMN IPAGTB029_CONTROLE_LINHA.CO_TIPO_REGISTRO IS
    'Tipo de registro CNAB240 identificado na posicao 8 da linha. '
    '0=Header Arquivo, 1=Header Lote, 3=Detalhe, 5=Trailer Lote, 9=Trailer Arquivo. '
    'Campo G001 do padrao FEBRABAN CNAB240.';
COMMENT ON COLUMN IPAGTB029_CONTROLE_LINHA.CO_SEGMENTO IS
    'Codigo do segmento para registros de detalhe (CO_TIPO_REGISTRO=3), posicao 14 da linha. '
    'Exemplos: A, B, C, J, N, O, P, Q, R, T, U, W, Z. Nulo para tipos 0, 1, 5, 9. '
    'Campo G062 do padrao FEBRABAN CNAB240.';
COMMENT ON COLUMN IPAGTB029_CONTROLE_LINHA.NU_LOTE_CNAB IS
    'Numero do lote conforme informado na propria linha CNAB (posicoes 4-7). '
    'Valor 0000 para Header/Trailer de Arquivo e 9999 para Trailer de Arquivo. '
    'Permite correlacionar a linha ao lote sem depender de FK para IPAGTB004.';
COMMENT ON COLUMN IPAGTB029_CONTROLE_LINHA.TE_CONTEUDO_LINHA IS
    'Conteudo literal da linha fisica do arquivo CNAB240, exatamente 240 caracteres. '
    'Armazenado para auditoria e possibilidade de reprocessamento sem releitura do arquivo original.';
COMMENT ON COLUMN IPAGTB029_CONTROLE_LINHA.CO_STATUS_LINHA IS
    'Estado de processamento desta linha especifica. '
    'PENDENTE=ainda nao processada; PROCESSADO=parseada e persistida com sucesso na tabela destino; '
    'ERRO=falha ao processar (ver TE_MENSAGEM_ERRO); IGNORADO=linha ignorada intencionalmente '
    '(ex: linha de padding, tipo nao suportado na versao atual).';
COMMENT ON COLUMN IPAGTB029_CONTROLE_LINHA.NO_TABELA_DESTINO IS
    'Nome da tabela Oracle onde esta linha foi persistida apos processamento bem-sucedido. '
    'Exemplos: IPAGTB002_HEADER_ARQUIVO, IPAGTB010_DET_PAGAMENTO, IPAGTB004_LOTE. '
    'Nulo enquanto CO_STATUS_LINHA for PENDENTE ou ERRO.';
COMMENT ON COLUMN IPAGTB029_CONTROLE_LINHA.ID_ENTIDADE_CRIADA IS
    'PK do registro criado em NO_TABELA_DESTINO a partir desta linha. '
    'Junto com NO_TABELA_DESTINO, permite navegar diretamente do controle de linha ao dado persistido. '
    'Nulo enquanto CO_STATUS_LINHA for PENDENTE ou ERRO.';
COMMENT ON COLUMN IPAGTB029_CONTROLE_LINHA.DH_PROCESSAMENTO IS
    'Data e hora em que esta linha foi processada (com sucesso ou erro). '
    'Nulo enquanto CO_STATUS_LINHA for PENDENTE.';
COMMENT ON COLUMN IPAGTB029_CONTROLE_LINHA.TE_MENSAGEM_ERRO IS
    'Descricao tecnica da falha ao processar esta linha, quando CO_STATUS_LINHA=ERRO. '
    'Deve incluir: campo com problema, valor recebido e motivo da rejeicao.';
COMMENT ON COLUMN IPAGTB029_CONTROLE_LINHA.DH_INCLUSAO IS
    'Data e hora de inclusao do registro de controle, coincide com a leitura da linha do arquivo.';
COMMENT ON COLUMN IPAGTB029_CONTROLE_LINHA.DH_ALTERACAO IS
    'Data e hora da ultima atualizacao de status. Atualizada ao transitar de PENDENTE para outro estado.';
COMMENT ON COLUMN IPAGTB029_CONTROLE_LINHA.NO_USUARIO_INCLUSAO IS
    'Login do usuario ou identificador do processo de leitura que inseriu este registro.';
COMMENT ON COLUMN IPAGTB029_CONTROLE_LINHA.NO_USUARIO_ALTERACAO IS
    'Login do usuario ou processo que realizou a ultima alteracao no estado da linha.';

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

COMMENT ON TABLE IPAGTV003_LINHAS_ERRO IS
    'Visao de diagnostico: exibe todas as linhas de arquivos CNAB240 que estao com status ERRO '
    'ou PENDENTE (nao processadas). Permite identificar rapidamente quais linhas falharam, '
    'em qual arquivo, o conteudo bruto e a mensagem de erro. Uso recomendado: troubleshooting operacional.';


-- =============================================================================
-- CORRECOES DO MODELO: FKs para tabelas de dominio (IPAGTB030 a IPAGTB036)
-- As tabelas abaixo armazenavam o codigo de dominio como CO_ (dado bruto do CNAB).
-- Adicionamos colunas ID_ surrogate para ligacao relacional com as tabelas de dominio,
-- mantendo o CO_ original para fidelidade ao arquivo fonte.
-- =============================================================================

-- IPAGTB004_LOTE: FK para tipo de servico e tipo de operacao

COMMENT ON COLUMN IPAGTB004_LOTE.ID_TIPO_SERVICO IS
    'FK para IPAGTB031_TIPO_SERVICO. Resolve o codigo bruto CO_TIPO_SERVICO (campo G025 do CNAB240) '
    'para o registro de dominio correspondente, permitindo rastreabilidade ate o servico de destino '
    '(IPAGTB037_SERVICO_DESTINO) via IPAGTB031.ID_SERVICO_DESTINO. Preenchido apos lookup por CO_TIPO_SERVICO.';
COMMENT ON COLUMN IPAGTB004_LOTE.ID_TIPO_OPERACAO IS
    'FK para IPAGTB032_TIPO_OPERACAO. Resolve o codigo bruto CO_TIPO_OPERACAO (campo G028) '
    'para o registro de dominio, viabilizando joins e filtros relacionais por tipo de operacao. '
    'Preenchido apos lookup por CO_TIPO_OPERACAO durante a carga do lote.';

-- IPAGTB007_DETALHE_REG: FK para tipo de movimento

COMMENT ON COLUMN IPAGTB007_DETALHE_REG.ID_TIPO_MOVIMENTO IS
    'FK para IPAGTB033_TIPO_MOVIMENTO. Resolve o codigo bruto CO_TIPO_MOVIMENTO (campo G060) '
    'para o registro de dominio, identificando se o detalhe e Inclusao, Alteracao, Exclusao, etc. '
    'Preenchido apos lookup durante a carga do registro de detalhe.';

-- IPAGTB002_HEADER_ARQUIVO: FK para tipo de inscricao da empresa

COMMENT ON COLUMN IPAGTB002_HEADER_ARQUIVO.ID_TIPO_INSCRICAO IS
    'FK para IPAGTB034_TIPO_INSCRICAO. Resolve CO_TIPO_INSCRICAO_EMPRESA (campo G005, posicao 18 do CNAB240) '
    'para o registro de dominio: 1=CPF, 2=CNPJ, 3=PIS/PASEP, 9=Outros. '
    'Preenchido apos lookup durante a carga do Header de Arquivo.';

-- IPAGTB005_HEADER_LOTE: FK para tipo de inscricao da empresa no lote

COMMENT ON COLUMN IPAGTB005_HEADER_LOTE.ID_TIPO_INSCRICAO IS
    'FK para IPAGTB034_TIPO_INSCRICAO. Resolve CO_TIPO_INSCRICAO_EMPRESA (posicoes 18 do header de lote) '
    'para o registro de dominio correspondente. Permite filtros e joins por tipo de pessoa juridica/fisica '
    'da empresa pagadora em cada lote. Preenchido apos lookup durante a carga do Header de Lote.';

-- IPAGTB010_DET_PAGAMENTO: FK para tipo de moeda e camara centralizadora

COMMENT ON COLUMN IPAGTB010_DET_PAGAMENTO.ID_TIPO_MOEDA IS
    'FK para IPAGTB035_TIPO_MOEDA. Resolve CO_TIPO_MOEDA (campo G040, ex: BRL, USD) '
    'para o registro de dominio, viabilizando tratamento multimoeda e conversoes. '
    'Preenchido apos lookup pelo codigo ISO da moeda durante a carga do Segmento A.';
COMMENT ON COLUMN IPAGTB010_DET_PAGAMENTO.ID_CAMARA_CENTRALIZADORA IS
    'FK para IPAGTB036_CAMARA_CENTRAL. Resolve NU_CAMARA_CENTRALIZADORA (campo G029, '
    'ex: 0=TED/DOC, 1=COMPE, 8=PIX, 18=TED) para o registro de dominio da camara. '
    'Preenchido apos lookup pelo numero da camara durante a carga do Segmento A.';

-- IPAGTB011_DET_INFO_FAVORECIDO: FK para tipo de inscricao do favorecido

COMMENT ON COLUMN IPAGTB011_DET_INFO_FAVORECIDO.ID_TIPO_INSCRICAO IS
    'FK para IPAGTB034_TIPO_INSCRICAO. Resolve CO_TIPO_INSCRICAO_FAVO (tipo de inscricao do favorecido '
    'no Segmento B) para o registro de dominio: 1=CPF, 2=CNPJ. '
    'Preenchido apos lookup durante a carga do Segmento B.';

-- IPAGTB014_DET_PARTES_TITULO: FKs para tipos de inscricao (pagador, beneficiario, sacador)

COMMENT ON COLUMN IPAGTB014_DET_PARTES_TITULO.ID_TIPO_INSCRICAO_PAGADOR IS
    'FK para IPAGTB034_TIPO_INSCRICAO. Resolve CO_TIPO_INSCRICAO_PAGADOR (Segmento J-52) '
    'para o dominio de tipo de pessoa: 1=CPF, 2=CNPJ. Identifica o tipo de inscricao do pagador do boleto.';
COMMENT ON COLUMN IPAGTB014_DET_PARTES_TITULO.ID_TIPO_INSCRICAO_BENEF IS
    'FK para IPAGTB034_TIPO_INSCRICAO. Resolve CO_TIPO_INSCRICAO_BENEF (Segmento J-52) '
    'para o dominio de tipo de pessoa. Identifica se o beneficiario e pessoa fisica (CPF) ou juridica (CNPJ).';
COMMENT ON COLUMN IPAGTB014_DET_PARTES_TITULO.ID_TIPO_INSCRICAO_SACADOR IS
    'FK para IPAGTB034_TIPO_INSCRICAO. Resolve CO_TIPO_INSCRICAO_SACADOR (Segmento J-52) '
    'para o dominio de tipo de pessoa. Identifica o tipo de inscricao do sacador/avalista do titulo.';

-- IPAGTB015_DET_PIX_QR_CODE: FKs para tipos de inscricao (devedor e favorecido)

COMMENT ON COLUMN IPAGTB015_DET_PIX_QR_CODE.ID_TIPO_INSCRICAO_DEVEDOR IS
    'FK para IPAGTB034_TIPO_INSCRICAO. Resolve CO_TIPO_INSCRICAO_DEVEDOR (Segmento J-52 PIX) '
    'para o dominio de tipo de pessoa do devedor do QR Code Pix. 1=CPF, 2=CNPJ.';
COMMENT ON COLUMN IPAGTB015_DET_PIX_QR_CODE.ID_TIPO_INSCRICAO_FAVO IS
    'FK para IPAGTB034_TIPO_INSCRICAO. Resolve CO_TIPO_INSCRICAO_FAVO (Segmento J-52 PIX) '
    'para o dominio de tipo de pessoa do favorecido/recebedor do Pix. 1=CPF, 2=CNPJ.';

-- IPAGTB020_DET_DADOS_TITULO: FK para tipo de inscricao do sacado

COMMENT ON COLUMN IPAGTB020_DET_DADOS_TITULO.ID_TIPO_INSCRICAO_SACADO IS
    'FK para IPAGTB034_TIPO_INSCRICAO. Resolve CO_TIPO_INSCRICAO_SACADO (Segmento P de cobranca) '
    'para o registro de dominio do tipo de pessoa do sacado/devedor do titulo. 1=CPF, 2=CNPJ.';

-- IPAGTB021_DET_DADOS_SACADO: FKs para tipo de inscricao (sacado e sacador)

COMMENT ON COLUMN IPAGTB021_DET_DADOS_SACADO.ID_TIPO_INSCRICAO_SACADO IS
    'FK para IPAGTB034_TIPO_INSCRICAO. Resolve CO_TIPO_INSCRICAO_SACADO (Segmento Q de cobranca) '
    'para o tipo de pessoa do devedor principal do titulo. 1=CPF, 2=CNPJ.';
COMMENT ON COLUMN IPAGTB021_DET_DADOS_SACADO.ID_TIPO_INSCRICAO_SACADOR IS
    'FK para IPAGTB034_TIPO_INSCRICAO. Resolve CO_TIPO_INSCRICAO_SACADOR (Segmento Q de cobranca) '
    'para o tipo de pessoa do sacador/avalista. Pode ser nulo quando nao ha avalista no titulo.';

-- IPAGTB023_DET_RETORNO_TITULO: FK para tipo de inscricao do sacado (retorno de cobranca)

COMMENT ON COLUMN IPAGTB023_DET_RETORNO_TITULO.ID_TIPO_INSCRICAO_SACADO IS
    'FK para IPAGTB034_TIPO_INSCRICAO. Resolve CO_TIPO_INSCRICAO_SACADO (Segmento T de retorno cobranca) '
    'para o tipo de pessoa do devedor. Permite cruzar informacoes de retorno com o cadastro de sacados.';

-- IPAGTB029_CONTROLE_LINHA: FK para tipo de registro

COMMENT ON COLUMN IPAGTB029_CONTROLE_LINHA.ID_TIPO_REGISTRO IS
    'FK para IPAGTB030_TIPO_REGISTRO. Resolve CO_TIPO_REGISTRO (posicao 8 da linha CNAB240) para '
    'o registro de dominio correspondente: 0=Header Arquivo, 1=Header Lote, 3=Detalhe, '
    '5=Trailer Lote, 9=Trailer Arquivo. Permite filtros relacionais por tipo sem depender '
    'do codigo CHAR. Preenchido durante a leitura e classificacao de cada linha do arquivo.';





