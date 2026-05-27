# -*- coding: utf-8 -*-
"""
Gera DDL VP e Oracle para os 23 segmentos CNAB240 faltantes.
Append ao final de DDL_CNAB240_VP.sql e DDL_CNAB240_ORACLE.sql
"""
import sys, os
sys.stdout.reconfigure(encoding='utf-8')

TABLES = [
    # ===== COBRANCA COMPLEMENTO =====
    {
        'num': '040', 'name': 'DET_MENSAGEM_SACADO', 'seg': 'S',
        'desc_table': (
            'Segmento S da Cobranca (Remessa). Mensagem ou informacoes a serem impressas '
            'no boleto de cobranca. Possui dois formatos conforme CO_TIPO_IMPRESSAO: '
            'tipos 1/2 (linha unica 140 chars) ou tipo 3 (5 mensagens de 40 chars).'
        ),
        'cols': [
            ('ID_SEG_S',            'NUMBER',         None,  True,  'PK', 'Identificador surrogate gerado por sequence. Chave primaria.'),
            ('ID_DETALHE_REG',      'NUMBER',         None,  True,  'FK', 'FK para IPAGTB007_DETALHE_REG. Vincula o segmento ao registro de detalhe.'),
            ('CO_TIPO_IMPRESSAO',   'CHAR(1)',        None,  False, None, 'Tipo de impressao do boleto. Campo C040. 1=Frente, 2=Verso, 3=Corpo de instrucoes.'),
            ('NU_NUMERO_LINHA',     'NUMBER(2)',      None,  False, None, 'Numero da linha a ser impressa. Campo C041. Usado nos tipos 1 e 2.'),
            ('TE_MENSAGEM',         'VARCHAR2(140)',  None,  False, None, 'Mensagem a ser impressa no boleto. Campo C042. Usado nos tipos 1 e 2.'),
            ('CO_TIPO_FONTE',       'NUMBER(2)',      None,  False, None, 'Tipo de caracter a ser impresso. Campo C043. Usado nos tipos 1 e 2.'),
            ('TE_INFORMACAO_5',     'VARCHAR2(40)',   None,  False, None, 'Mensagem 5 do corpo de instrucoes. Campo C037. Usado no tipo 3.'),
            ('TE_INFORMACAO_6',     'VARCHAR2(40)',   None,  False, None, 'Mensagem 6 do corpo de instrucoes. Campo C037. Usado no tipo 3.'),
            ('TE_INFORMACAO_7',     'VARCHAR2(40)',   None,  False, None, 'Mensagem 7 do corpo de instrucoes. Campo C037. Usado no tipo 3.'),
            ('TE_INFORMACAO_8',     'VARCHAR2(40)',   None,  False, None, 'Mensagem 8 do corpo de instrucoes. Campo C037. Usado no tipo 3.'),
            ('TE_INFORMACAO_9',     'VARCHAR2(40)',   None,  False, None, 'Mensagem 9 do corpo de instrucoes. Campo C037. Usado no tipo 3.'),
        ],
    },
    # ===== BOLETO ELETRONICO =====
    {
        'num': '041', 'name': 'DET_BOLETO_ELETRONICO', 'seg': 'G',
        'desc_table': (
            'Segmento G do Boleto de Pagamento Eletronico (Retorno). Dados do titulo capturado '
            'em carteira pelo banco: codigo de barras, beneficiario, vencimento, valor nominal, '
            'moeda, carteira, especie, juros e desconto.'
        ),
        'cols': [
            ('ID_SEG_G',                    'NUMBER',        None,  True,  'PK', 'Identificador surrogate gerado por sequence.'),
            ('ID_DETALHE_REG',              'NUMBER',        None,  True,  'FK', 'FK para IPAGTB007_DETALHE_REG.'),
            ('TE_CODIGO_BARRAS',            'VARCHAR2(44)',  None,  False, None, 'Codigo de barras do titulo. Campo G063.'),
            ('CO_TIPO_INSCRICAO_BENEFICIARIO','CHAR(1)',     None,  False, None, 'Tipo de inscricao do beneficiario. Campo G005. 1=CPF, 2=CNPJ.'),
            ('NU_INSCRICAO_BENEFICIARIO',   'VARCHAR2(15)', None,  False, None, '[DADO_PESSOAL] Numero de inscricao (CPF/CNPJ) do beneficiario. Campo G006.'),
            ('NO_BENEFICIARIO',             'VARCHAR2(30)',  None,  False, None, 'Nome do beneficiario do titulo. Campo G013.'),
            ('DH_VENCIMENTO',               'DATE',          None,  False, None, 'Data de vencimento do titulo. Campo C012.'),
            ('NU_VALOR_NOMINAL',            'NUMBER(15,2)',  None,  False, None, 'Valor nominal do titulo. Campo G070.'),
            ('QT_MOEDA',                    'NUMBER(15,5)',  None,  False, None, 'Quantidade da moeda. Campo G041.'),
            ('CO_MOEDA',                    'NUMBER(2)',     None,  False, None, 'Codigo da moeda. Campo G065.'),
            ('NU_DOCUMENTO_COBRANCA',       'VARCHAR2(15)',  None,  False, None, 'Numero do documento de cobranca. Campo C011.'),
            ('NU_AGENCIA_COBRADORA',        'NUMBER(5)',     None,  False, None, 'Agencia encarregada da cobranca. Campo C014.'),
            ('CO_DV_AGENCIA_COBRADORA',     'CHAR(1)',       None,  False, None, 'Digito verificador da agencia cobradora. Campo G009.'),
            ('TE_PRACA',                    'VARCHAR2(10)',  None,  False, None, 'Praca cobradora. Campo B001.'),
            ('CO_CARTEIRA',                 'CHAR(1)',       None,  False, None, 'Codigo da carteira. Campo C006.'),
            ('CO_ESPECIE_TITULO',           'NUMBER(2)',     None,  False, None, 'Especie do titulo. Campo C015.'),
            ('DH_EMISSAO_TITULO',           'DATE',          None,  False, None, 'Data de emissao do titulo. Campo G071.'),
            ('NU_JUROS_MORA',               'NUMBER(15,2)',  None,  False, None, 'Juros de mora por dia. Campo C020.'),
            ('CO_DESCONTO_1',               'CHAR(1)',       None,  False, None, 'Codigo do desconto 1. Campo C021.'),
            ('DH_DESCONTO_1',               'DATE',          None,  False, None, 'Data do desconto 1. Campo C022.'),
            ('NU_VALOR_DESCONTO_1',         'NUMBER(15,2)',  None,  False, None, 'Valor ou percentual do desconto 1. Campo C023.'),
            ('CO_PROTESTO',                 'CHAR(1)',       None,  False, None, 'Codigo para protesto. Campo C026.'),
            ('NU_PRAZO_PROTESTO',           'NUMBER(2)',     None,  False, None, 'Numero de dias para protesto. Campo C027.'),
            ('DH_LIMITE_PAGAMENTO',         'DATE',          None,  False, None, 'Data limite para pagamento do titulo. Campo C075.'),
        ],
    },
    {
        'num': '042', 'name': 'DET_COMPLEMENTO_BOLETO', 'seg': 'H (Boleto)',
        'desc_table': (
            'Segmento H do Boleto de Pagamento Eletronico (Retorno). Dados complementares: '
            'sacador/avalista, descontos 2 e 3, multa, abatimento e mensagens ao pagador.'
        ),
        'cols': [
            ('ID_SEG_H_BOLETO',             'NUMBER',        None,  True,  'PK', 'Identificador surrogate gerado por sequence.'),
            ('ID_DETALHE_REG',              'NUMBER',        None,  True,  'FK', 'FK para IPAGTB007_DETALHE_REG.'),
            ('CO_TIPO_INSCRICAO_SACADOR',   'CHAR(1)',       None,  False, None, 'Tipo de inscricao do sacador/avalista. Campo G005.'),
            ('NU_INSCRICAO_SACADOR',        'VARCHAR2(15)',  None,  False, None, '[DADO_PESSOAL] Numero de inscricao do sacador/avalista. Campo G006.'),
            ('NO_SACADOR_AVALISTA',         'VARCHAR2(40)',  None,  False, None, 'Nome do sacador/avalista. Campo G013.'),
            ('CO_DESCONTO_2',               'CHAR(1)',       None,  False, None, 'Codigo do desconto 2. Campo C021.'),
            ('DH_DESCONTO_2',               'DATE',          None,  False, None, 'Data do desconto 2. Campo C022.'),
            ('NU_VALOR_DESCONTO_2',         'NUMBER(15,2)',  None,  False, None, 'Valor/percentual do desconto 2. Campo C023.'),
            ('CO_DESCONTO_3',               'CHAR(1)',       None,  False, None, 'Codigo do desconto 3. Campo C021.'),
            ('DH_DESCONTO_3',               'DATE',          None,  False, None, 'Data do desconto 3. Campo C022.'),
            ('NU_VALOR_DESCONTO_3',         'NUMBER(15,2)',  None,  False, None, 'Valor/percentual do desconto 3. Campo C023.'),
            ('CO_MULTA',                    'CHAR(1)',       None,  False, None, 'Codigo da multa. Campo G073.'),
            ('DH_MULTA',                    'DATE',          None,  False, None, 'Data da multa. Campo G074.'),
            ('NU_VALOR_MULTA',              'NUMBER(15,2)',  None,  False, None, 'Valor/percentual da multa. Campo G075.'),
            ('NU_VALOR_ABATIMENTO',         'NUMBER(15,2)',  None,  False, None, 'Valor do abatimento. Campo G045.'),
            ('TE_INFORMACAO_1',             'VARCHAR2(40)',  None,  False, None, 'Mensagem 1 ao pagador. Campo C073.'),
            ('TE_INFORMACAO_2',             'VARCHAR2(40)',  None,  False, None, 'Mensagem 2 ao pagador. Campo C073.'),
        ],
    },
    # ===== EXTRATO =====
    {
        'num': '043', 'name': 'DET_EXTRATO_CONCILIACAO', 'seg': 'E',
        'desc_table': (
            'Segmento E do Extrato de Conta Corrente para Conciliacao Bancaria (Retorno). '
            'Dados do lancamento contabil: empresa, conta corrente, natureza, valor, '
            'tipo (debito/credito), categoria, historico e documento.'
        ),
        'cols': [
            ('ID_SEG_E',                    'NUMBER',        None,  True,  'PK', 'Identificador surrogate gerado por sequence.'),
            ('ID_DETALHE_REG',              'NUMBER',        None,  True,  'FK', 'FK para IPAGTB007_DETALHE_REG.'),
            ('CO_TIPO_INSCRICAO_EMPRESA',   'CHAR(1)',       None,  False, None, 'Tipo de inscricao da empresa. Campo G005.'),
            ('NU_INSCRICAO_EMPRESA',        'VARCHAR2(14)',  None,  False, None, '[DADO_PESSOAL] Numero de inscricao (CPF/CNPJ) da empresa. Campo G006.'),
            ('CO_CONVENIO',                 'VARCHAR2(20)',  None,  False, None, 'Codigo do convenio no banco. Campo G007.'),
            ('NU_AGENCIA',                  'NUMBER(5)',     None,  False, None, 'Agencia mantenedora da conta. Campo G008.'),
            ('CO_DV_AGENCIA',               'CHAR(1)',       None,  False, None, 'Digito verificador da agencia. Campo G009.'),
            ('NU_CONTA_CORRENTE',           'VARCHAR2(12)',  None,  False, None, 'Numero da conta corrente. Campo G010.'),
            ('CO_DV_CONTA',                 'CHAR(1)',       None,  False, None, 'Digito verificador da conta. Campo G011.'),
            ('CO_DV_AGENCIA_CONTA',         'CHAR(1)',       None,  False, None, 'Digito verificador da agencia/conta. Campo G012.'),
            ('NO_EMPRESA',                  'VARCHAR2(30)',  None,  False, None, 'Nome da empresa. Campo G013.'),
            ('CO_NATUREZA_LANCAMENTO',      'VARCHAR2(3)',   None,  False, None, 'Natureza do lancamento. Campo G084.'),
            ('CO_TIPO_COMPLEMENTO',         'NUMBER(2)',     None,  False, None, 'Tipo do complemento do lancamento. Campo G085.'),
            ('TE_COMPLEMENTO_LANCAMENTO',   'VARCHAR2(20)',  None,  False, None, 'Complemento do lancamento. Campo G086.'),
            ('CO_ISENCAO_CPMF',             'CHAR(1)',       None,  False, None, 'Identificacao de isencao do CPMF. Campo G087.'),
            ('DH_CONTABIL',                 'DATE',          None,  False, None, 'Data contabil do lancamento. Campo G088.'),
            ('DH_LANCAMENTO',               'DATE',          None,  False, None, 'Data do lancamento. Campo G089.'),
            ('NU_VALOR_LANCAMENTO',         'NUMBER(18,2)',  None,  False, None, 'Valor do lancamento. Campo G090.'),
            ('CO_TIPO_LANCAMENTO',          'CHAR(1)',       None,  False, None, 'Tipo do lancamento: D=Debito, C=Credito. Campo G091.'),
            ('CO_CATEGORIA_LANCAMENTO',     'NUMBER(3)',     None,  False, None, 'Categoria do lancamento. Campo G092.'),
            ('CO_HISTORICO_BANCO',          'VARCHAR2(4)',   None,  False, None, 'Codigo historico do lancamento no banco. Campo G093.'),
            ('TE_HISTORICO',                'VARCHAR2(25)',  None,  False, None, 'Descricao do historico do lancamento no banco. Campo G094.'),
            ('TE_NUMERO_DOCUMENTO',         'VARCHAR2(39)',  None,  False, None, 'Numero do documento ou complemento. Campo G095.'),
        ],
    },
    {
        'num': '044', 'name': 'DET_EXTRATO_GESTAO_CAIXA', 'seg': 'F',
        'desc_table': (
            'Segmento F do Extrato para Gestao de Caixa (Retorno). Similar ao Seg E mas inclui '
            'horario da transacao e campo de historico com 5 caracteres. Dados do lancamento '
            'para gestao de fluxo de caixa.'
        ),
        'cols': [
            ('ID_SEG_F',                    'NUMBER',        None,  True,  'PK', 'Identificador surrogate gerado por sequence.'),
            ('ID_DETALHE_REG',              'NUMBER',        None,  True,  'FK', 'FK para IPAGTB007_DETALHE_REG.'),
            ('TE_HORARIO_TRANSACAO',        'VARCHAR2(6)',   None,  False, None, 'Horario da transacao no formato HHMMSS. Campo F006.'),
            ('CO_NATUREZA_LANCAMENTO',      'VARCHAR2(3)',   None,  False, None, 'Natureza do lancamento. Campo G084.'),
            ('CO_TIPO_COMPLEMENTO',         'NUMBER(2)',     None,  False, None, 'Tipo do complemento do lancamento. Campo G085.'),
            ('TE_COMPLEMENTO_LANCAMENTO',   'VARCHAR2(20)',  None,  False, None, 'Complemento do lancamento. Campo G086.'),
            ('CO_ISENCAO_CPMF',             'CHAR(1)',       None,  False, None, 'Identificacao de isencao do CPMF. Campo G087.'),
            ('DH_CONTABIL',                 'DATE',          None,  False, None, 'Data contabil do lancamento. Campo G088.'),
            ('DH_LANCAMENTO',               'DATE',          None,  False, None, 'Data do lancamento. Campo G089.'),
            ('NU_VALOR_LANCAMENTO',         'NUMBER(18,2)',  None,  False, None, 'Valor do lancamento. Campo G090.'),
            ('CO_TIPO_LANCAMENTO',          'CHAR(1)',       None,  False, None, 'Tipo do lancamento: D=Debito, C=Credito. Campo G091.'),
            ('CO_CATEGORIA_LANCAMENTO',     'NUMBER(3)',     None,  False, None, 'Categoria do lancamento. Campo G092.'),
            ('CO_HISTORICO_BANCO',          'VARCHAR2(5)',   None,  False, None, 'Codigo historico do lancamento no banco. Campo G093. 5 chars neste extrato.'),
            ('TE_HISTORICO',                'VARCHAR2(25)',  None,  False, None, 'Descricao do historico do lancamento no banco. Campo G094.'),
            ('TE_NUMERO_DOCUMENTO',         'VARCHAR2(38)',  None,  False, None, 'Numero do documento ou complemento. Campo G095. 38 chars neste extrato.'),
        ],
    },
    {
        'num': '045', 'name': 'DET_VALOR_LANCAMENTO', 'seg': 'I (Gestão Caixa)',
        'desc_table': (
            'Segmento I do Extrato para Gestao de Caixa (Retorno). Decomposicao do valor do '
            'lancamento nos montantes que afetam cada tipo de saldo: disponivel, vinculado e bloqueado.'
        ),
        'cols': [
            ('ID_SEG_I_CAIXA',              'NUMBER',        None,  True,  'PK', 'Identificador surrogate gerado por sequence.'),
            ('ID_DETALHE_REG',              'NUMBER',        None,  True,  'FK', 'FK para IPAGTB007_DETALHE_REG.'),
            ('NU_VALOR_TOTAL',              'NUMBER(18,2)',  None,  False, None, 'Valor total do lancamento (CDS). Campo G090.'),
            ('NU_VALOR_DISPONIVEL',         'NUMBER(18,2)',  None,  False, None, 'Valor disponivel do lancamento (DPV). Campo F007.'),
            ('NU_VALOR_VINCULADO',          'NUMBER(18,2)',  None,  False, None, 'Valor vinculado do lancamento (SCR). Campo F008.'),
            ('NU_VALOR_BLOQUEADO',          'NUMBER(18,2)',  None,  False, None, 'Valor bloqueado do lancamento (SSR). Campo F009.'),
        ],
    },
    # ===== VENDOR =====
    {
        'num': '046', 'name': 'DET_CONTRATO_VENDOR', 'seg': 'K',
        'desc_table': (
            'Segmento K do Vendor (Remessa/Retorno). Dados do comprador e do contrato de '
            'financiamento: inscricao, endereco, dados para debito, nosso numero e ramo de atividade.'
        ),
        'cols': [
            ('ID_SEG_K',                    'NUMBER',        None,  True,  'PK', 'Identificador surrogate gerado por sequence.'),
            ('ID_DETALHE_REG',              'NUMBER',        None,  True,  'FK', 'FK para IPAGTB007_DETALHE_REG.'),
            ('CO_INSTRUCAO_MOVIMENTO',      'NUMBER(2)',     None,  False, None, 'Codigo da instrucao para movimento. Campo V002.'),
            ('CO_MOTIVO_OCORRENCIA',        'NUMBER(3)',     None,  False, None, 'Identificacao da ocorrencia. Campo V010.'),
            ('CO_TIPO_INSCRICAO_COMPRADOR', 'CHAR(1)',       None,  False, None, 'Tipo de inscricao do comprador. Campo G005.'),
            ('NU_INSCRICAO_COMPRADOR',      'VARCHAR2(14)',  None,  False, None, '[DADO_PESSOAL] Numero de inscricao (CPF/CNPJ) do comprador. Campo G006.'),
            ('NO_COMPRADOR',                'VARCHAR2(40)',  None,  False, None, 'Nome do comprador. Campo G013.'),
            ('TE_ENDERECO_COMPRADOR',       'VARCHAR2(40)',  None,  False, None, 'Endereco do comprador. Campo G032.'),
            ('TE_BAIRRO_COMPRADOR',         'VARCHAR2(15)',  None,  False, None, 'Bairro do comprador. Campo G032.'),
            ('NU_CEP_COMPRADOR',            'NUMBER(5)',     None,  False, None, 'CEP do comprador. Campo G034.'),
            ('NU_SUFIXO_CEP_COMPRADOR',     'NUMBER(3)',     None,  False, None, 'Sufixo do CEP do comprador. Campo G035.'),
            ('NO_CIDADE_COMPRADOR',         'VARCHAR2(15)',  None,  False, None, 'Cidade do comprador. Campo G033.'),
            ('SG_UF_COMPRADOR',             'CHAR(2)',       None,  False, None, 'UF do comprador. Campo G036.'),
            ('NU_BANCO_DEBITO',             'NUMBER(3)',     None,  False, None, 'Codigo do banco na conta de debito. Campo G001.'),
            ('NU_AGENCIA_DEBITO',           'NUMBER(5)',     None,  False, None, 'Codigo da agencia de debito. Campo G008.'),
            ('CO_DV_AGENCIA_DEBITO',        'CHAR(1)',       None,  False, None, 'Digito verificador da agencia de debito. Campo G009.'),
            ('NU_CONTA_DEBITO',             'VARCHAR2(12)',  None,  False, None, 'Conta corrente para debito. Campo G010.'),
            ('CO_DV_CONTA_DEBITO',          'CHAR(1)',       None,  False, None, 'Digito verificador da conta de debito. Campo G011.'),
            ('CO_DV_AGENCIA_CONTA_DEBITO',  'CHAR(1)',       None,  False, None, 'Digito verificador agencia/conta de debito. Campo G012.'),
            ('NU_NOSSO_NUMERO',             'VARCHAR2(20)',  None,  False, None, 'Identificador do titulo no banco. Campo G069.'),
            ('CO_RAMO_ATIVIDADE',           'NUMBER(6)',     None,  False, None, 'Ramo de atividade social do comprador. Campo V004.'),
            ('CO_PROGRAMA_OPERACIONAL',     'VARCHAR2(5)',   None,  False, None, 'Identifica caracteristicas da operacao. Campo V033.'),
            ('TE_MENSAGEM',                 'VARCHAR2(5)',   None,  False, None, 'Mensagem. Campo V044.'),
            ('TE_USO_EMPRESA_BENEFICIARIO', 'VARCHAR2(27)',  None,  False, None, 'Identificador do titulo na empresa. Campo G072.'),
        ],
    },
    {
        'num': '047', 'name': 'DET_PAGAMENTO_VENDOR', 'seg': 'L',
        'desc_table': (
            'Segmento L do Vendor (Remessa). Dados do pagamento ao fornecedor: documento, '
            'contrato, datas, taxas, parcelas, multa, desconto, protesto e abatimento.'
        ),
        'cols': [
            ('ID_SEG_L',                     'NUMBER',        None,  True,  'PK', 'Identificador surrogate gerado por sequence.'),
            ('ID_DETALHE_REG',               'NUMBER',        None,  True,  'FK', 'FK para IPAGTB007_DETALHE_REG.'),
            ('NU_DOCUMENTO',                 'VARCHAR2(15)',  None,  False, None, 'Numero da duplicata. Campo V045.'),
            ('NU_CONTRATO',                  'NUMBER(10)',    None,  False, None, 'Numero do contrato de financiamento. Campo V007.'),
            ('DH_EMISSAO_TITULO',            'DATE',          None,  False, None, 'Data de emissao do titulo. Campo G071.'),
            ('DH_FINANCIAMENTO',             'DATE',          None,  False, None, 'Data do financiamento. Campo V001.'),
            ('NU_VALOR_NOMINAL',             'NUMBER(15,2)',  None,  False, None, 'Valor nominal do titulo. Campo G070.'),
            ('NU_TAXA_VENDEDOR',             'NUMBER(8,5)',   None,  False, None, 'Taxa de juros do vendedor. Campo V011.'),
            ('NU_TAXA_COMPRADOR',            'NUMBER(8,5)',   None,  False, None, 'Taxa de juros do comprador. Campo V012.'),
            ('CO_MOEDA_VENDEDOR',            'NUMBER(2)',     None,  False, None, 'Codigo da moeda do vendedor. Campo V032.'),
            ('CO_MOEDA_COMPRADOR',           'NUMBER(2)',     None,  False, None, 'Codigo da moeda do comprador. Campo G065.'),
            ('DH_PRIMEIRO_VENCIMENTO',       'DATE',          None,  False, None, 'Data do primeiro vencimento do titulo. Campo V025.'),
            ('DH_VENCIMENTO_FINAL',          'DATE',          None,  False, None, 'Data de vencimento final. Campo V008.'),
            ('CO_TIPO_VENCIMENTO_PARCELA',   'CHAR(1)',       None,  False, None, 'Tipo de vencimento da parcela. Campo V009.'),
            ('NU_PERIODICIDADE_VENCIMENTO',  'NUMBER(2)',     None,  False, None, 'Periodicidade do prazo de vencimento. Campo V046.'),
            ('QT_PARCELA',                   'NUMBER(2)',     None,  False, None, 'Quantidade de parcelas. Campo V006.'),
            ('CO_FORMA_PAGAMENTO',           'CHAR(1)',       None,  False, None, 'Forma de pagamento. Campo V005.'),
            ('CO_EQUALIZACAO',               'CHAR(1)',       None,  False, None, 'Tipo de equalizacao. Campo V021.'),
            ('CO_MODALIDADE_EQUALIZACAO',    'CHAR(1)',       None,  False, None, 'Modalidade da equalizacao. Campo V022.'),
            ('DH_PRIMEIRA_REPACTUACAO',      'DATE',          None,  False, None, 'Data da primeira repactuacao. Campo V015.'),
            ('DH_ULTIMA_REPACTUACAO',        'DATE',          None,  False, None, 'Data da ultima repactuacao. Campo V016.'),
            ('NU_PERIODICIDADE_REPACTUACAO', 'NUMBER(2)',     None,  False, None, 'Periodicidade da repactuacao. Campo V017.'),
            ('CO_MULTA',                     'CHAR(1)',       None,  False, None, 'Codigo da multa. Campo G073.'),
            ('DH_MULTA',                     'DATE',          None,  False, None, 'Data da multa. Campo G074.'),
            ('NU_VALOR_MULTA',               'NUMBER(15,2)',  None,  False, None, 'Valor/percentual da multa. Campo G075.'),
            ('CO_DESCONTO',                  'CHAR(1)',       None,  False, None, 'Codigo do desconto. Campo V040.'),
            ('DH_DESCONTO',                  'DATE',          None,  False, None, 'Data do desconto. Campo V041.'),
            ('NU_VALOR_DESCONTO',            'NUMBER(15,2)',  None,  False, None, 'Valor/percentual do desconto. Campo V037.'),
            ('DH_PRORROGACAO_VENCIMENTO',    'DATE',          None,  False, None, 'Nova data de vencimento (prorrogacao). Campo V018.'),
            ('NU_NOVA_TAXA_VENDEDOR',        'NUMBER(8,5)',   None,  False, None, 'Nova taxa de juros do vendedor. Campo V048.'),
            ('NU_NOVA_TAXA_COMPRADOR',       'NUMBER(8,5)',   None,  False, None, 'Nova taxa de juros do comprador. Campo V049.'),
            ('CO_PAGAMENTO_IOF',             'CHAR(1)',       None,  False, None, 'Forma de pagamento do IOF/abatimento. Campo V020.'),
            ('NU_PRAZO_DEBITO_TRANSFERENCIA','NUMBER(2)',     None,  False, None, 'Prazo para debito e transferencia. Campo V019.'),
            ('CO_PROTESTO',                  'CHAR(1)',       None,  False, None, 'Codigo para protesto. Campo V042.'),
            ('NU_PRAZO_PROTESTO',            'VARCHAR2(2)',   None,  False, None, 'Numero de dias para protesto. Campo V043.'),
            ('NU_VALOR_ABATIMENTO',          'NUMBER(15,2)',  None,  False, None, 'Valor de abatimento. Campo G045.'),
            ('CO_ESPECIE_TITULO',            'NUMBER(2)',     None,  False, None, 'Especie do titulo. Campo C015.'),
        ],
    },
    {
        'num': '048', 'name': 'DET_RETORNO_CONTRATO_VENDOR', 'seg': 'M',
        'desc_table': (
            'Segmento M do Vendor (Retorno). Confirmacao do contrato pelo banco: taxas anuais, '
            'equalizacao, valores (nominal, financiado, IOF, resgate, tarifa, liquido).'
        ),
        'cols': [
            ('ID_SEG_M',                     'NUMBER',        None,  True,  'PK', 'Identificador surrogate gerado por sequence.'),
            ('ID_DETALHE_REG',               'NUMBER',        None,  True,  'FK', 'FK para IPAGTB007_DETALHE_REG.'),
            ('CO_MOVIMENTO_RETORNO',         'NUMBER(2)',     None,  False, None, 'Codigo de movimento retorno. Campo V003.'),
            ('CO_MOTIVO_OCORRENCIA',         'NUMBER(3)',     None,  False, None, 'Motivo da ocorrencia. Campo V010.'),
            ('NU_CONTRATO',                  'NUMBER(10)',    None,  False, None, 'Numero do contrato de financiamento. Campo V007.'),
            ('NU_DOCUMENTO',                 'VARCHAR2(15)',  None,  False, None, 'Numero da duplicata. Campo V045.'),
            ('CO_FORMA_PAGAMENTO',           'CHAR(1)',       None,  False, None, 'Forma de pagamento. Campo V005.'),
            ('QT_PARCELA',                   'NUMBER(2)',     None,  False, None, 'Quantidade de parcelas. Campo V006.'),
            ('NU_NUMERO_PARCELA',            'NUMBER(2)',     None,  False, None, 'Numero da parcela. Campo V026.'),
            ('DH_PRIMEIRO_VENCIMENTO',       'DATE',          None,  False, None, 'Data do primeiro vencimento. Campo V025.'),
            ('DH_VENCIMENTO_ULTIMA_PARCELA', 'DATE',          None,  False, None, 'Data do vencimento da ultima parcela. Campo V008.'),
            ('NU_TAXA_VENDEDOR',             'NUMBER(8,5)',   None,  False, None, 'Taxa de juros do vendedor. Campo V011.'),
            ('NU_TAXA_COMPRADOR',            'NUMBER(8,5)',   None,  False, None, 'Taxa de juros do comprador. Campo V012.'),
            ('CO_MOEDA_VENDEDOR',            'NUMBER(2)',     None,  False, None, 'Codigo da moeda do vendedor. Campo V032.'),
            ('CO_MOEDA_COMPRADOR',           'NUMBER(2)',     None,  False, None, 'Codigo da moeda do comprador. Campo G065.'),
            ('NU_TAXA_ANUAL_VENDEDOR',       'NUMBER(8,5)',   None,  False, None, 'Taxa de juros anual do vendedor. Campo V013.'),
            ('NU_TAXA_ANUAL_COMPRADOR',      'NUMBER(8,5)',   None,  False, None, 'Taxa de juros anual do comprador. Campo V014.'),
            ('CO_EQUALIZACAO',               'CHAR(1)',       None,  False, None, 'Tipo de equalizacao. Campo V021.'),
            ('CO_MODALIDADE_EQUALIZACAO',    'CHAR(1)',       None,  False, None, 'Modalidade da equalizacao. Campo V022.'),
            ('CO_TIPO_LANCAMENTO_EQUALIZACAO','CHAR(1)',      None,  False, None, 'Tipo de lancamento do valor de equalizacao. Campo V047.'),
            ('CO_PAGAMENTO_IOF',             'CHAR(1)',       None,  False, None, 'Forma de pagamento do IOF. Campo V020.'),
            ('NU_VALOR_NOMINAL',             'NUMBER(15,2)',  None,  False, None, 'Valor nominal do titulo. Campo G070.'),
            ('NU_VALOR_FINANCIADO',          'NUMBER(15,2)',  None,  False, None, 'Valor financiado. Campo V023.'),
            ('NU_VALOR_EQUALIZACAO',         'NUMBER(15,2)',  None,  False, None, 'Valor da equalizacao. Campo V024.'),
            ('NU_VALOR_IOF',                 'NUMBER(15,2)',  None,  False, None, 'Valor do IOF recolhido. Campo G077.'),
            ('NU_VALOR_RESGATE',             'NUMBER(15,2)',  None,  False, None, 'Valor de resgate. Campo V029.'),
            ('NU_VALOR_TARIFA',              'NUMBER(15,2)',  None,  False, None, 'Valor da tarifa/custas. Campo G076.'),
            ('NU_VALOR_LIQUIDO',             'NUMBER(15,2)',  None,  False, None, 'Valor liquido a ser creditado. Campo G078.'),
            ('TE_USO_EMPRESA_BENEFICIARIO',  'VARCHAR2(25)',  None,  False, None, 'Identificacao do titulo na empresa. Campo G072.'),
            ('CO_ESPECIE_TITULO',            'NUMBER(2)',     None,  False, None, 'Especie do titulo. Campo V051.'),
        ],
    },
    {
        'num': '049', 'name': 'DET_RETORNO_PAGAMENTO_VENDOR', 'seg': 'N (Vendor)',
        'desc_table': (
            'Segmento N do Vendor (Retorno). Dados da liquidacao da parcela: valores pagos, '
            'juros, IOF, multa, desconto, equalizacao, situacao do contrato e da parcela.'
        ),
        'cols': [
            ('ID_SEG_N_VENDOR',              'NUMBER',        None,  True,  'PK', 'Identificador surrogate gerado por sequence.'),
            ('ID_DETALHE_REG',               'NUMBER',        None,  True,  'FK', 'FK para IPAGTB007_DETALHE_REG.'),
            ('CO_MOVIMENTO_RETORNO',         'NUMBER(2)',     None,  False, None, 'Codigo de movimento retorno. Campo V003.'),
            ('CO_MOTIVO_OCORRENCIA',         'NUMBER(3)',     None,  False, None, 'Motivo da ocorrencia. Campo V010.'),
            ('NU_VALOR_VENCIMENTO',          'NUMBER(15,2)',  None,  False, None, 'Valor da parcela no vencimento. Campo V027.'),
            ('DH_BAIXA_LIQUIDACAO',          'DATE',          None,  False, None, 'Data da baixa/liquidacao. Campo V036.'),
            ('NU_VALOR_PAGO',                'NUMBER(15,2)',  None,  False, None, 'Valor da parcela paga. Campo V030.'),
            ('NU_VALOR_JUROS_MORA',          'NUMBER(15,2)',  None,  False, None, 'Valor de juros de mora/comissao de permanencia. Campo V028.'),
            ('NU_VALOR_IOF_ATRASO',          'NUMBER(15,2)',  None,  False, None, 'Valor do IOF sobre atraso. Campo V031.'),
            ('NU_VALOR_MULTA',               'NUMBER(15,2)',  None,  False, None, 'Valor da multa. Campo G048.'),
            ('NU_VALOR_DESCONTO',            'NUMBER(15,2)',  None,  False, None, 'Valor do desconto. Campo G046.'),
            ('NU_VALOR_EQUALIZACAO',         'NUMBER(15,2)',  None,  False, None, 'Valor da equalizacao. Campo V024.'),
            ('CO_SITUACAO_CONTRATO',         'CHAR(1)',       None,  False, None, 'Situacao do contrato. Campo V038.'),
            ('CO_SITUACAO_PARCELA',          'CHAR(1)',       None,  False, None, 'Situacao da parcela. Campo V039.'),
            ('DH_PRORROGACAO_VENCIMENTO',    'DATE',          None,  False, None, 'Nova data de vencimento. Campo V018.'),
            ('NU_NOVA_TAXA_VENDEDOR',        'NUMBER(8,5)',   None,  False, None, 'Nova taxa de juros do vendedor. Campo V048.'),
            ('NU_NOVA_TAXA_COMPRADOR',       'NUMBER(8,5)',   None,  False, None, 'Nova taxa de juros do comprador. Campo V049.'),
            ('CO_DESCONTO',                  'CHAR(1)',       None,  False, None, 'Codigo do desconto. Campo V040.'),
            ('DH_DESCONTO',                  'DATE',          None,  False, None, 'Data do desconto. Campo V041.'),
            ('NU_VALOR_DESCONTO_CONCEDIDO',  'NUMBER(15,2)',  None,  False, None, 'Valor/percentual do desconto concedido. Campo V037.'),
            ('CO_PROTESTO',                  'CHAR(1)',       None,  False, None, 'Codigo para protesto. Campo V042.'),
            ('NU_PRAZO_PROTESTO',            'VARCHAR2(2)',   None,  False, None, 'Numero de dias para protesto. Campo V043.'),
            ('NU_VALOR_ABATIMENTO',          'NUMBER(15,2)',  None,  False, None, 'Valor de abatimento. Campo G045.'),
            ('NU_VALOR_CONCENTRADO',         'NUMBER(15,2)',  None,  False, None, 'Valor concentrado. Campo V034.'),
            ('NU_PERCENTUAL_CONCENTRACAO',   'NUMBER(8,5)',   None,  False, None, 'Percentual de concentracao. Campo V035.'),
            ('NU_VALOR_ENCARGO_COMPRADOR',   'NUMBER(15,2)',  None,  False, None, 'Valor dos encargos do comprador. Campo V050.'),
        ],
    },
    # ===== CUSTODIA DE CHEQUES =====
    {
        'num': '050', 'name': 'DET_CUSTODIA_CHEQUE', 'seg': 'D',
        'desc_table': (
            'Segmento D da Custodia de Cheques (Remessa/Retorno). Dados do cheque: CMC7, '
            'emitente, valor, datas de captura/deposito/credito, dados de devolucao e emprestimo.'
        ),
        'cols': [
            ('ID_SEG_D',                     'NUMBER',        None,  True,  'PK', 'Identificador surrogate gerado por sequence.'),
            ('ID_DETALHE_REG',               'NUMBER',        None,  True,  'FK', 'FK para IPAGTB007_DETALHE_REG.'),
            ('CO_TIPO_MOVIMENTO',            'NUMBER(2)',     None,  False, None, 'Tipo de movimento remessa/retorno. Campo K002.'),
            ('CO_FINALIDADE',                'NUMBER(2)',     None,  False, None, 'Codigo da finalidade do movimento. Campo K003.'),
            ('CO_FORMA_ENTRADA',             'CHAR(1)',       None,  False, None, 'Forma de entrada dos dados do cheque. Campo K004.'),
            ('TE_CMC7',                      'VARCHAR2(34)',  None,  False, None, 'Identificacao do cheque (CMC7). Campo K005.'),
            ('CO_TIPO_INSCRICAO_EMITENTE',   'CHAR(1)',       None,  False, None, 'Tipo de inscricao do emitente. Campo K006.'),
            ('NU_INSCRICAO_EMITENTE',        'VARCHAR2(14)',  None,  False, None, '[DADO_PESSOAL] Numero de inscricao do emitente do cheque. Campo K007.'),
            ('NU_VALOR_CHEQUE',              'NUMBER(15,2)',  None,  False, None, 'Valor do cheque. Campo K008.'),
            ('DH_CAPTURA',                   'DATE',          None,  False, None, 'Data da captura do cheque no cliente. Campo K009.'),
            ('DH_DEPOSITO',                  'DATE',          None,  False, None, 'Data para deposito do cheque. Campo K010.'),
            ('DH_CREDITO',                   'DATE',          None,  False, None, 'Data prevista para debito/credito. Campo K011.'),
            ('TE_SEU_NUMERO',                'VARCHAR2(20)',  None,  False, None, 'Numero atribuido pelo cliente. Campo K012.'),
            ('NU_AGENCIA_DEVOLUCAO',         'NUMBER(5)',     None,  False, None, 'Codigo da agencia para devolucao. Campo K013.'),
            ('NU_CONTA_DEVOLUCAO',           'VARCHAR2(12)',  None,  False, None, 'Numero da conta para devolucao. Campo K014.'),
            ('NU_VALOR_JUROS',               'NUMBER(11,2)',  None,  False, None, 'Valor de juros da operacao de emprestimo. Campo K015.'),
            ('NU_VALOR_IOF',                 'NUMBER(11,2)',  None,  False, None, 'Valor de IOF da operacao de emprestimo. Campo K016.'),
            ('NU_VALOR_OUTROS_ENCARGO',      'NUMBER(11,2)',  None,  False, None, 'Valor de outros encargos da operacao de emprestimo. Campo K017.'),
            ('NU_NUMERO_CONTRATO',           'NUMBER(17)',    None,  False, None, 'Numero do contrato da operacao de emprestimo. Campo K018.'),
            ('NU_TAXA_JUROS',                'NUMBER(7,4)',   None,  False, None, 'Taxa de juros da operacao de emprestimo. Campo K019.'),
            ('TE_OCORRENCIA',                'CHAR(10)',      None,  False, None, 'Codigos das ocorrencias do detalhe. Campo K020.'),
        ],
    },
    # ===== EMPRESTIMO CONSIGNACAO =====
    {
        'num': '051', 'name': 'DET_EMPRESTIMO_CONSIGNACAO', 'seg': 'H (Empréstimo)',
        'desc_table': (
            'Segmento H do Emprestimo por Consignacao (Remessa/Retorno). Dados do mutuario, '
            'operacao de credito, parcelas, valores, arrendamento mercantil e conta corrente.'
        ),
        'cols': [
            ('ID_SEG_H_EMPRESTIMO',          'NUMBER',        None,  True,  'PK', 'Identificador surrogate gerado por sequence.'),
            ('ID_DETALHE_REG',               'NUMBER',        None,  True,  'FK', 'FK para IPAGTB007_DETALHE_REG.'),
            ('CO_TIPO_MOVIMENTO',            'CHAR(1)',       None,  False, None, 'Tipo de movimento. Campo G060.'),
            ('NO_MUTUARIO',                  'VARCHAR2(30)',  None,  False, None, 'Nome do mutuario. Campo G013.'),
            ('CO_UNIDADE_ADMINISTRATIVA',    'VARCHAR2(6)',   None,  False, None, 'Codigo de unidade administrativa. Campo H004.'),
            ('NU_CPF_MUTUARIO',              'NUMBER(11)',    None,  False, None, '[DADO_PESSOAL] Numero do CPF do mutuario. Campo H006.'),
            ('TE_IDENTIFICACAO_MUTUARIO',    'VARCHAR2(12)',  None,  False, None, 'Identificacao do mutuario na empresa/orgao. Campo H007.'),
            ('CO_STATUS_MUTUARIO',           'CHAR(1)',       None,  False, None, 'Status do mutuario. Campo H008.'),
            ('CO_REGIME_CONTRATACAO',        'CHAR(1)',       None,  False, None, 'Regime de contratacao do mutuario. Campo H009.'),
            ('CO_SITUACAO_SINDICAL',         'CHAR(1)',       None,  False, None, 'Situacao sindical do mutuario. Campo H010.'),
            ('CO_VERBA_RESCISORIA',          'CHAR(1)',       None,  False, None, 'Comprometimento da verba rescisoria. Campo H011.'),
            ('NU_VALOR_MARGEM',              'NUMBER(9,2)',   None,  False, None, 'Valor da margem. Campo H012.'),
            ('NU_IDENTIFICACAO_SINDICATO',   'NUMBER(8)',     None,  False, None, 'Identificador do sindicato. Campo H013.'),
            ('CO_CENTRAL_SINDICAL',          'CHAR(1)',       None,  False, None, 'Identificacao da central sindical. Campo H014.'),
            ('CO_TIPO_OPERACAO',             'CHAR(1)',       None,  False, None, 'Tipo de operacao de credito. Campo H015.'),
            ('NU_DIA_VENCIMENTO',            'NUMBER(2)',     None,  False, None, 'Dia de vencimento da parcela. Campo H016.'),
            ('NU_MES_VENCIMENTO',            'NUMBER(2)',     None,  False, None, 'Mes de vencimento da parcela. Campo H017.'),
            ('NU_ANO_VENCIMENTO',            'NUMBER(4)',     None,  False, None, 'Ano de vencimento da parcela. Campo H018.'),
            ('NU_NUMERO_PARCELA',            'NUMBER(2)',     None,  False, None, 'Numero da parcela a ser consignada. Campo H019.'),
            ('QT_PARCELA',                   'NUMBER(2)',     None,  False, None, 'Quantidade de parcelas do contrato. Campo H020.'),
            ('DH_INICIO_CONTRATO',           'DATE',          None,  False, None, 'Data de inicio do contrato. Campo H021.'),
            ('DH_FIM_CONTRATO',              'DATE',          None,  False, None, 'Data de fim do contrato. Campo H022.'),
            ('NU_VALOR_LIBERADO',            'NUMBER(9,2)',   None,  False, None, 'Valor total liberado. Campo H023.'),
            ('NU_VALOR_OPERACAO',            'NUMBER(9,2)',   None,  False, None, 'Valor total da operacao. Campo H024.'),
            ('NU_VALOR_PARCELA',             'NUMBER(9,2)',   None,  False, None, 'Valor total da parcela. Campo H025.'),
            ('NU_VALOR_SALDO_DEVEDOR',       'NUMBER(9,2)',   None,  False, None, 'Valor total do saldo devedor. Campo H026.'),
            ('TE_IDENTIFICACAO_CONTRATO',    'VARCHAR2(20)',  None,  False, None, 'Identificacao do contrato no banco. Campo H027.'),
            ('QT_CONTRATO',                  'NUMBER(2)',     None,  False, None, 'Quantidade de contratos no banco. Campo H028.'),
            ('NU_VALOR_CONTRAPRESTACAO',     'NUMBER(9,2)',   None,  False, None, 'Valor da contraprestacao (arrendamento mercantil). Campo H029.'),
            ('NU_VALOR_RESIDUAL_GARANTIDO',  'NUMBER(9,2)',   None,  False, None, 'Valor residual garantido (arrendamento mercantil). Campo H030.'),
            ('CO_TIPO_RESIDUAL_GARANTIDO',   'CHAR(1)',       None,  False, None, 'Tipo residual garantido. Campo H031.'),
            ('NU_AGENCIA_MUTUARIO',          'NUMBER(5)',     None,  False, None, 'Agencia mantenedora da conta do mutuario. Campo G008.'),
            ('CO_DV_AGENCIA_MUTUARIO',       'CHAR(1)',       None,  False, None, 'Digito verificador da agencia do mutuario. Campo G009.'),
            ('NU_CONTA_MUTUARIO',            'VARCHAR2(12)',  None,  False, None, 'Numero da conta corrente do mutuario. Campo G010.'),
            ('CO_DV_CONTA_MUTUARIO',         'CHAR(1)',       None,  False, None, 'Digito verificador da conta do mutuario. Campo G011.'),
            ('TE_OCORRENCIA',                'CHAR(10)',      None,  False, None, 'Codigos das ocorrencias para retorno. Campo G059.'),
        ],
    },
    # ===== COMPROR =====
    {
        'num': '052', 'name': 'DET_COMPROR', 'seg': 'I (Compror)',
        'desc_table': (
            'Segmento I do Compror (Remessa/Retorno). Dados do financiamento Compror: contrato, '
            'documento, taxas, parcelas, encargos, IOF, resgate, juros e multa.'
        ),
        'cols': [
            ('ID_SEG_I_COMPROR',             'NUMBER',        None,  True,  'PK', 'Identificador surrogate gerado por sequence.'),
            ('ID_DETALHE_REG',               'NUMBER',        None,  True,  'FK', 'FK para IPAGTB007_DETALHE_REG.'),
            ('NU_CONTRATO',                  'NUMBER(10)',    None,  False, None, 'Numero do contrato de financiamento. Campo I001.'),
            ('NU_DOCUMENTO',                 'VARCHAR2(15)',  None,  False, None, 'Numero da nota fiscal, fatura ou duplicata. Campo I002.'),
            ('DH_COMPRA',                    'DATE',          None,  False, None, 'Data da compra. Campo I003.'),
            ('CO_REGIME_ENCARGO',            'CHAR(1)',       None,  False, None, 'Regime de encargos financeiros. Campo I004.'),
            ('CO_MODALIDADE_ENCARGO',        'NUMBER(2)',     None,  False, None, 'Modalidade de encargos financeiros. Campo I005.'),
            ('NU_TAXA_JUROS',                'NUMBER(8,5)',   None,  False, None, 'Taxa de juros da operacao. Campo I006.'),
            ('CO_FORMA_REPOSICAO',           'CHAR(1)',       None,  False, None, 'Forma de reposicao. Campo I007.'),
            ('CO_METODOLOGIA_CALCULO',       'CHAR(1)',       None,  False, None, 'Metodologia de calculo dos encargos. Campo I008.'),
            ('DH_PRIMEIRO_VENCIMENTO',       'DATE',          None,  False, None, 'Data do primeiro vencimento da parcela. Campo I009.'),
            ('DH_VENCIMENTO_FINAL',          'DATE',          None,  False, None, 'Data de vencimento final. Campo I010.'),
            ('CO_TIPO_VENCIMENTO_PARCELA',   'CHAR(1)',       None,  False, None, 'Tipo de vencimento da parcela. Campo I011.'),
            ('NU_PERIODICIDADE_VENCIMENTO',  'NUMBER(2)',     None,  False, None, 'Periodicidade do prazo de vencimento. Campo I012.'),
            ('QT_PARCELA',                   'NUMBER(2)',     None,  False, None, 'Quantidade de parcelas. Campo I013.'),
            ('NU_NOSSO_NUMERO',              'VARCHAR2(20)',  None,  False, None, 'Numero do documento atribuido pelo banco. Campo I014.'),
            ('CO_FORMA_PAGAMENTO',           'CHAR(1)',       None,  False, None, 'Forma de pagamento. Campo I015.'),
            ('NU_VALOR_ENCARGO',             'NUMBER(15,2)',  None,  False, None, 'Valor dos encargos da operacao. Campo I016.'),
            ('CO_PAGAMENTO_IOF',             'CHAR(1)',       None,  False, None, 'Forma de pagamento do IOF. Campo I017.'),
            ('NU_VALOR_IOF',                 'NUMBER(15,2)',  None,  False, None, 'Valor do IOF recolhido. Campo G077.'),
            ('NU_VALOR_RESGATE',             'NUMBER(15,2)',  None,  False, None, 'Valor de resgate. Campo I018.'),
            ('NU_VALOR_JUROS_MORA',          'NUMBER(15,2)',  None,  False, None, 'Valor de juros de mora/comissao de permanencia. Campo I019.'),
            ('NU_VALOR_IOF_ATRASO',          'NUMBER(15,2)',  None,  False, None, 'Valor do IOF sobre atraso. Campo I020.'),
            ('NU_VALOR_MULTA',               'NUMBER(15,2)',  None,  False, None, 'Valor da multa. Campo G048.'),
        ],
    },
    {
        'num': '053', 'name': 'DET_PARCELA_COMPROR', 'seg': 'I-11',
        'desc_table': (
            'Segmento I-11 do Compror (Remessa/Retorno). Registro opcional com informacao das '
            'parcelas da operacao Compror. Cada registro contem ate 4 parcelas. Pode ocorrer '
            'multiplas vezes conforme a quantidade de parcelas do contrato.'
        ),
        'cols': [
            ('ID_SEG_I11',                   'NUMBER',        None,  True,  'PK', 'Identificador surrogate gerado por sequence.'),
            ('ID_DETALHE_REG',               'NUMBER',        None,  True,  'FK', 'FK para IPAGTB007_DETALHE_REG.'),
            ('NU_NUMERO_PARCELA_1',          'NUMBER(2)',     None,  False, None, 'Numero da parcela 1. Campo I021.'),
            ('NU_VALOR_PARCELA_1',           'NUMBER(15,2)',  None,  False, None, 'Valor da parcela 1. Campo I022.'),
            ('DH_VENCIMENTO_PARCELA_1',      'DATE',          None,  False, None, 'Data de vencimento da parcela 1. Campo I023.'),
            ('NU_NOSSO_NUMERO_PARCELA_1',    'VARCHAR2(20)',  None,  False, None, 'Nosso numero da parcela 1. Campo I014.'),
            ('NU_NUMERO_PARCELA_2',          'NUMBER(2)',     None,  False, None, 'Numero da parcela 2. Campo I021.'),
            ('NU_VALOR_PARCELA_2',           'NUMBER(15,2)',  None,  False, None, 'Valor da parcela 2. Campo I022.'),
            ('DH_VENCIMENTO_PARCELA_2',      'DATE',          None,  False, None, 'Data de vencimento da parcela 2. Campo I023.'),
            ('NU_NOSSO_NUMERO_PARCELA_2',    'VARCHAR2(20)',  None,  False, None, 'Nosso numero da parcela 2. Campo I014.'),
            ('NU_NUMERO_PARCELA_3',          'NUMBER(2)',     None,  False, None, 'Numero da parcela 3. Campo I021.'),
            ('NU_VALOR_PARCELA_3',           'NUMBER(15,2)',  None,  False, None, 'Valor da parcela 3. Campo I022.'),
            ('DH_VENCIMENTO_PARCELA_3',      'DATE',          None,  False, None, 'Data de vencimento da parcela 3. Campo I023.'),
            ('NU_NOSSO_NUMERO_PARCELA_3',    'VARCHAR2(20)',  None,  False, None, 'Nosso numero da parcela 3. Campo I014.'),
            ('NU_NUMERO_PARCELA_4',          'NUMBER(2)',     None,  False, None, 'Numero da parcela 4. Campo I021.'),
            ('NU_VALOR_PARCELA_4',           'NUMBER(15,2)',  None,  False, None, 'Valor da parcela 4. Campo I022.'),
            ('DH_VENCIMENTO_PARCELA_4',      'DATE',          None,  False, None, 'Data de vencimento da parcela 4. Campo I023.'),
            ('NU_NOSSO_NUMERO_PARCELA_4',    'VARCHAR2(20)',  None,  False, None, 'Nosso numero da parcela 4. Campo I014.'),
        ],
    },
    # ===== SUB-SEGMENTOS Y =====
    {
        'num': '060', 'name': 'DET_SACADOR_AVALISTA', 'seg': 'Y-01',
        'desc_table': (
            'Segmento Y-01 da Cobranca (Remessa/Retorno). Dados do sacador/avalista: '
            'inscricao (CPF/CNPJ), nome e endereco completo.'
        ),
        'cols': [
            ('ID_SEG_Y01',                   'NUMBER',        None,  True,  'PK', 'Identificador surrogate gerado por sequence.'),
            ('ID_DETALHE_REG',               'NUMBER',        None,  True,  'FK', 'FK para IPAGTB007_DETALHE_REG.'),
            ('CO_TIPO_INSCRICAO',            'CHAR(1)',       None,  False, None, 'Tipo de inscricao do sacador/avalista. Campo G005.'),
            ('NU_INSCRICAO',                 'VARCHAR2(15)',  None,  False, None, '[DADO_PESSOAL] Numero de inscricao do sacador/avalista. Campo G006.'),
            ('NO_SACADOR_AVALISTA',          'VARCHAR2(40)',  None,  False, None, 'Nome do sacador/avalista. Campo C060.'),
            ('TE_ENDERECO',                  'VARCHAR2(40)',  None,  False, None, 'Endereco do sacador/avalista. Campo G032.'),
            ('TE_BAIRRO',                    'VARCHAR2(15)',  None,  False, None, 'Bairro. Campo G032.'),
            ('NU_CEP',                       'NUMBER(5)',     None,  False, None, 'CEP. Campo G034.'),
            ('NU_SUFIXO_CEP',                'NUMBER(3)',     None,  False, None, 'Sufixo do CEP. Campo G035.'),
            ('NO_CIDADE',                    'VARCHAR2(15)',  None,  False, None, 'Cidade. Campo G033.'),
            ('SG_UF',                        'CHAR(2)',       None,  False, None, 'Unidade da Federacao. Campo G036.'),
        ],
    },
    {
        'num': '061', 'name': 'DET_ALEGACAO_PAGADOR', 'seg': 'Y-02',
        'desc_table': (
            'Segmento Y-02 da Alegacao do Pagador (Remessa/Retorno). Contestacao de boleto '
            'pelo pagador: codigo de barras, codigo padrao, ocorrencia e complemento.'
        ),
        'cols': [
            ('ID_SEG_Y02',                   'NUMBER',        None,  True,  'PK', 'Identificador surrogate gerado por sequence.'),
            ('ID_DETALHE_REG',               'NUMBER',        None,  True,  'FK', 'FK para IPAGTB007_DETALHE_REG.'),
            ('TE_CODIGO_BARRAS',             'VARCHAR2(44)',  None,  False, None, 'Codigo de barras do titulo. Campo G063.'),
            ('CO_PADRAO',                    'VARCHAR2(2)',   None,  False, None, 'Codigo padrao. Campo G062.'),
            ('CO_OCORRENCIA',                'VARCHAR2(4)',   None,  False, None, 'Codigo de ocorrencia da alegacao. Campo A001.'),
            ('TE_COMPLEMENTO_OCORRENCIA',    'VARCHAR2(150)', None,  False, None, 'Complemento da ocorrencia. Campo A002.'),
            ('TE_OCORRENCIA_RETORNO',        'CHAR(10)',      None,  False, None, 'Codigo de ocorrencia para retorno. Campo G059.'),
        ],
    },
    {
        'num': '062', 'name': 'DET_DADOS_PAGADOR', 'seg': 'Y-03',
        'desc_table': (
            'Segmento Y-03 do Boleto Eletronico (Retorno). Dados do pagador informados '
            'pelo beneficiario: inscricao, nome e endereco completo.'
        ),
        'cols': [
            ('ID_SEG_Y03',                   'NUMBER',        None,  True,  'PK', 'Identificador surrogate gerado por sequence.'),
            ('ID_DETALHE_REG',               'NUMBER',        None,  True,  'FK', 'FK para IPAGTB007_DETALHE_REG.'),
            ('CO_TIPO_INSCRICAO_PAGADOR',    'CHAR(1)',       None,  False, None, 'Tipo de inscricao do pagador. Campo G005.'),
            ('NU_INSCRICAO_PAGADOR',         'VARCHAR2(15)',  None,  False, None, '[DADO_PESSOAL] Numero de inscricao do pagador. Campo G006.'),
            ('NO_PAGADOR',                   'VARCHAR2(40)',  None,  False, None, 'Nome do pagador. Campo G013.'),
            ('TE_ENDERECO',                  'VARCHAR2(40)',  None,  False, None, 'Endereco do pagador. Campo G032.'),
            ('TE_BAIRRO',                    'VARCHAR2(15)',  None,  False, None, 'Bairro. Campo G032.'),
            ('NU_CEP',                       'NUMBER(5)',     None,  False, None, 'CEP. Campo G034.'),
            ('NU_SUFIXO_CEP',                'NUMBER(3)',     None,  False, None, 'Sufixo do CEP. Campo G035.'),
            ('NO_CIDADE',                    'VARCHAR2(15)',  None,  False, None, 'Cidade. Campo G033.'),
            ('SG_UF',                        'CHAR(2)',       None,  False, None, 'Unidade da Federacao. Campo G036.'),
        ],
    },
    {
        'num': '063', 'name': 'DET_ENVIO_ALTERNATIVO', 'seg': 'Y-04',
        'desc_table': (
            'Segmento Y-04 (Remessa/Retorno). Dados para envio de documento por meio alternativo: '
            'e-mail, celular (SMS), chave PIX, URL do QR Code e TXID.'
        ),
        'cols': [
            ('ID_SEG_Y04',                   'NUMBER',        None,  True,  'PK', 'Identificador surrogate gerado por sequence.'),
            ('ID_DETALHE_REG',               'NUMBER',        None,  True,  'FK', 'FK para IPAGTB007_DETALHE_REG.'),
            ('TE_EMAIL',                     'VARCHAR2(50)',  None,  False, None, 'E-mail para envio da informacao. Campo G032.'),
            ('NU_DDD',                       'NUMBER(2)',     None,  False, None, 'Codigo DDD do celular. Campo G032.'),
            ('NU_CELULAR',                   'NUMBER(9)',     None,  False, None, 'Numero do celular para envio de SMS. Campo G032.'),
            ('CO_TIPO_CHAVE_PIX',            'CHAR(1)',       None,  False, None, 'Tipo de chave PIX. Campo G103.'),
            ('TE_CHAVE_PIX_URL',             'VARCHAR2(77)',  None,  False, None, 'Chave PIX ou URL do QR Code. Campo G102.'),
            ('TE_TXID',                      'VARCHAR2(35)',  None,  False, None, 'Codigo de identificacao do QR Code (TXID). Campo G102.'),
        ],
    },
    {
        'num': '064', 'name': 'DET_CHEQUE_PAGAMENTO', 'seg': 'Y-05',
        'desc_table': (
            'Segmento Y-05 da Cobranca (Retorno). Dados de cheques utilizados para pagamento. '
            'Cada registro contem ate 6 cheques identificados pelo CMC7. Pode ocorrer multiplas vezes.'
        ),
        'cols': [
            ('ID_SEG_Y05',                   'NUMBER',        None,  True,  'PK', 'Identificador surrogate gerado por sequence.'),
            ('ID_DETALHE_REG',               'NUMBER',        None,  True,  'FK', 'FK para IPAGTB007_DETALHE_REG.'),
            ('TE_CMC7_CHEQUE_1',             'VARCHAR2(34)',  None,  False, None, 'Identificacao do cheque 1 (CMC7). Campo C076.'),
            ('TE_CMC7_CHEQUE_2',             'VARCHAR2(34)',  None,  False, None, 'Identificacao do cheque 2 (CMC7). Campo C076.'),
            ('TE_CMC7_CHEQUE_3',             'VARCHAR2(34)',  None,  False, None, 'Identificacao do cheque 3 (CMC7). Campo C076.'),
            ('TE_CMC7_CHEQUE_4',             'VARCHAR2(34)',  None,  False, None, 'Identificacao do cheque 4 (CMC7). Campo C076.'),
            ('TE_CMC7_CHEQUE_5',             'VARCHAR2(34)',  None,  False, None, 'Identificacao do cheque 5 (CMC7). Campo C076.'),
            ('TE_CMC7_CHEQUE_6',             'VARCHAR2(34)',  None,  False, None, 'Identificacao do cheque 6 (CMC7). Campo C076.'),
        ],
    },
    {
        'num': '065', 'name': 'DET_RATEIO_CREDITO', 'seg': 'Y-50',
        'desc_table': (
            'Segmento Y-50 da Cobranca (Remessa/Retorno). Rateio de credito entre beneficiarios: '
            'conta corrente origem, nosso numero, tipo de calculo, dados do beneficiario do rateio, '
            'parcela, floating e motivo de ocorrencia. Pode ocorrer multiplas vezes.'
        ),
        'cols': [
            ('ID_SEG_Y50',                   'NUMBER',        None,  True,  'PK', 'Identificador surrogate gerado por sequence.'),
            ('ID_DETALHE_REG',               'NUMBER',        None,  True,  'FK', 'FK para IPAGTB007_DETALHE_REG.'),
            ('NU_AGENCIA',                   'NUMBER(5)',     None,  False, None, 'Agencia mantenedora da conta. Campo G008.'),
            ('CO_DV_AGENCIA',                'CHAR(1)',       None,  False, None, 'Digito verificador da agencia. Campo G009.'),
            ('NU_CONTA_CORRENTE',            'VARCHAR2(12)',  None,  False, None, 'Numero da conta corrente. Campo G010.'),
            ('CO_DV_CONTA',                  'CHAR(1)',       None,  False, None, 'Digito verificador da conta. Campo G011.'),
            ('CO_DV_AGENCIA_CONTA',          'CHAR(1)',       None,  False, None, 'Digito verificador agencia/conta. Campo G012.'),
            ('NU_NOSSO_NUMERO',              'VARCHAR2(20)',  None,  False, None, 'Identificacao do titulo no banco. Campo G069.'),
            ('CO_CALCULO_RATEIO',            'CHAR(1)',       None,  False, None, 'Codigo de calculo do rateio. Campo C061. 1=Valor Cobrado, 2=Valor Registro, 3=Menor Valor.'),
            ('CO_TIPO_VALOR_INFORMADO',      'CHAR(1)',       None,  False, None, 'Tipo de valor informado. Campo C062. 1=Percentual, 2=Valor.'),
            ('NU_VALOR_PERCENTUAL',          'NUMBER(15,3)',  None,  False, None, 'Valor ou percentual do rateio. Campo C074.'),
            ('NU_BANCO_BENEFICIARIO',        'NUMBER(3)',     None,  False, None, 'Codigo do banco para credito do beneficiario. Campo G001.'),
            ('NU_AGENCIA_BENEFICIARIO',      'NUMBER(5)',     None,  False, None, 'Codigo da agencia para credito do beneficiario. Campo G008.'),
            ('CO_DV_AGENCIA_BENEFICIARIO',   'CHAR(1)',       None,  False, None, 'Digito da agencia do beneficiario. Campo G009.'),
            ('NU_CONTA_BENEFICIARIO',        'VARCHAR2(12)',  None,  False, None, 'Conta corrente do beneficiario. Campo G010.'),
            ('CO_DV_CONTA_BENEFICIARIO',     'CHAR(1)',       None,  False, None, 'Digito da conta do beneficiario. Campo G011.'),
            ('CO_DV_AGENCIA_CONTA_BENEFICIARIO','CHAR(1)',    None,  False, None, 'Digito agencia/conta do beneficiario. Campo G012.'),
            ('NO_BENEFICIARIO',              'VARCHAR2(40)',  None,  False, None, 'Nome do beneficiario do rateio. Campo G013.'),
            ('TE_PARCELA',                   'VARCHAR2(6)',   None,  False, None, 'Identificacao da parcela do rateio. Campo C063.'),
            ('QT_FLOATING',                  'NUMBER(3)',     None,  False, None, 'Quantidade de dias para credito do beneficiario. Campo C064.'),
            ('DH_CREDITO',                   'DATE',          None,  False, None, 'Data de credito do beneficiario. Campo C065.'),
            ('TE_MOTIVO_OCORRENCIA',         'CHAR(10)',      None,  False, None, 'Identificacao das rejeicoes. Campo C066.'),
            ('NU_ISPB_BANCO_DESTINATARIO',   'NUMBER(8)',     None,  False, None, 'ISPB do banco destinatario no SPB. Campo P015.'),
        ],
    },
    {
        'num': '066', 'name': 'DET_NOTA_FISCAL', 'seg': 'Y-51',
        'desc_table': (
            'Segmento Y-51 da Cobranca/Boleto (Remessa/Retorno). Dados de notas fiscais '
            'vinculadas ao titulo. Cada registro contem ate 5 notas fiscais com numero, valor e data.'
        ),
        'cols': [
            ('ID_SEG_Y51',                   'NUMBER',        None,  True,  'PK', 'Identificador surrogate gerado por sequence.'),
            ('ID_DETALHE_REG',               'NUMBER',        None,  True,  'FK', 'FK para IPAGTB007_DETALHE_REG.'),
            ('NU_NOTA_FISCAL_1',             'VARCHAR2(15)',  None,  False, None, 'Numero da nota fiscal 1. Campo C067.'),
            ('NU_VALOR_NOTA_FISCAL_1',       'NUMBER(15,2)',  None,  False, None, 'Valor da nota fiscal 1. Campo C068.'),
            ('DH_EMISSAO_NOTA_FISCAL_1',     'DATE',          None,  False, None, 'Data de emissao da nota fiscal 1. Campo C069.'),
            ('NU_NOTA_FISCAL_2',             'VARCHAR2(15)',  None,  False, None, 'Numero da nota fiscal 2. Campo C067.'),
            ('NU_VALOR_NOTA_FISCAL_2',       'NUMBER(15,2)',  None,  False, None, 'Valor da nota fiscal 2. Campo C068.'),
            ('DH_EMISSAO_NOTA_FISCAL_2',     'DATE',          None,  False, None, 'Data de emissao da nota fiscal 2. Campo C069.'),
            ('NU_NOTA_FISCAL_3',             'VARCHAR2(15)',  None,  False, None, 'Numero da nota fiscal 3. Campo C067.'),
            ('NU_VALOR_NOTA_FISCAL_3',       'NUMBER(15,2)',  None,  False, None, 'Valor da nota fiscal 3. Campo C068.'),
            ('DH_EMISSAO_NOTA_FISCAL_3',     'DATE',          None,  False, None, 'Data de emissao da nota fiscal 3. Campo C069.'),
            ('NU_NOTA_FISCAL_4',             'VARCHAR2(15)',  None,  False, None, 'Numero da nota fiscal 4. Campo C067.'),
            ('NU_VALOR_NOTA_FISCAL_4',       'NUMBER(15,2)',  None,  False, None, 'Valor da nota fiscal 4. Campo C068.'),
            ('DH_EMISSAO_NOTA_FISCAL_4',     'DATE',          None,  False, None, 'Data de emissao da nota fiscal 4. Campo C069.'),
            ('NU_NOTA_FISCAL_5',             'VARCHAR2(15)',  None,  False, None, 'Numero da nota fiscal 5. Campo C067.'),
            ('NU_VALOR_NOTA_FISCAL_5',       'NUMBER(15,2)',  None,  False, None, 'Valor da nota fiscal 5. Campo C068.'),
            ('DH_EMISSAO_NOTA_FISCAL_5',     'DATE',          None,  False, None, 'Data de emissao da nota fiscal 5. Campo C069.'),
        ],
    },
    {
        'num': '067', 'name': 'DET_NOTA_FISCAL_ADICIONAL', 'seg': 'Y-52',
        'desc_table': (
            'Segmento Y-52 da Cobranca/Boleto (Remessa/Retorno). Informacoes adicionais de nota '
            'fiscal incluindo chave de acesso DANFE. Cada registro contem ate 2 notas fiscais com '
            'numero, valor, data e chave DANFE. Pode ocorrer multiplas vezes.'
        ),
        'cols': [
            ('ID_SEG_Y52',                   'NUMBER',        None,  True,  'PK', 'Identificador surrogate gerado por sequence.'),
            ('ID_DETALHE_REG',               'NUMBER',        None,  True,  'FK', 'FK para IPAGTB007_DETALHE_REG.'),
            ('NU_NOTA_FISCAL_1',             'VARCHAR2(15)',  None,  False, None, 'Numero da nota fiscal 1. Campo C067.'),
            ('NU_VALOR_NOTA_FISCAL_1',       'NUMBER(15,2)',  None,  False, None, 'Valor da nota fiscal 1. Campo C068.'),
            ('DH_EMISSAO_NOTA_FISCAL_1',     'DATE',          None,  False, None, 'Data de emissao da nota fiscal 1. Campo C069.'),
            ('TE_CHAVE_DANFE_1',             'VARCHAR2(44)',  None,  False, None, 'Chave de acesso DANFE da nota fiscal 1. Campo C083.'),
            ('NU_NOTA_FISCAL_2',             'VARCHAR2(15)',  None,  False, None, 'Numero da nota fiscal 2. Campo C067.'),
            ('NU_VALOR_NOTA_FISCAL_2',       'NUMBER(15,2)',  None,  False, None, 'Valor da nota fiscal 2. Campo C068.'),
            ('DH_EMISSAO_NOTA_FISCAL_2',     'DATE',          None,  False, None, 'Data de emissao da nota fiscal 2. Campo C069.'),
            ('TE_CHAVE_DANFE_2',             'VARCHAR2(44)',  None,  False, None, 'Chave de acesso DANFE da nota fiscal 2. Campo C083.'),
        ],
    },
    {
        'num': '068', 'name': 'DET_TIPO_PAGAMENTO', 'seg': 'Y-53',
        'desc_table': (
            'Segmento Y-53 da Cobranca (Remessa/Retorno). Identificacao do tipo de pagamento '
            'e regras para alteracao do valor nominal do titulo (valor maximo, minimo, percentual).'
        ),
        'cols': [
            ('ID_SEG_Y53',                   'NUMBER',        None,  True,  'PK', 'Identificador surrogate gerado por sequence.'),
            ('ID_DETALHE_REG',               'NUMBER',        None,  True,  'FK', 'FK para IPAGTB007_DETALHE_REG.'),
            ('CO_TIPO_PAGAMENTO',            'NUMBER(2)',     None,  False, None, 'Identificacao do tipo de pagamento. Campo C078.'),
            ('QT_PAGAMENTO_POSSIVEL',        'NUMBER(2)',     None,  False, None, 'Quantidade de pagamentos possiveis. Campo C079.'),
            ('CO_TIPO_VALOR_MAXIMO',         'CHAR(1)',       None,  False, None, 'Tipo de valor informado para valor maximo. Campo C080.'),
            ('NU_VALOR_MAXIMO',              'NUMBER(15,2)',  None,  False, None, 'Valor maximo permitido. Campo C081.'),
            ('NU_PERCENTUAL_MAXIMO',         'NUMBER(15,5)',  None,  False, None, 'Percentual maximo permitido. Campo C081.'),
            ('CO_TIPO_VALOR_MINIMO',         'CHAR(1)',       None,  False, None, 'Tipo de valor informado para valor minimo. Campo C080.'),
            ('NU_VALOR_MINIMO',              'NUMBER(15,2)',  None,  False, None, 'Valor minimo permitido. Campo C082.'),
            ('NU_PERCENTUAL_MINIMO',         'NUMBER(15,5)',  None,  False, None, 'Percentual minimo permitido. Campo C082.'),
        ],
    },
]

AUDIT_COLS = [
    ('DH_INCLUSAO',           'DATE',         'SYSDATE', True,  None, 'Data e hora de inclusao do registro.'),
    ('DH_ALTERACAO',          'DATE',          None,      False, None, 'Data e hora da ultima alteracao.'),
    ('NO_USUARIO_INCLUSAO',   'VARCHAR2(60)',  None,      True,  None, 'Login do usuario ou processo que incluiu.'),
    ('NO_USUARIO_ALTERACAO',  'VARCHAR2(60)',  None,      False, None, 'Login do usuario ou processo que alterou.'),
]

def full_table_name(t):
    return f"IPAGTB{t['num']}_{t['name']}"

def gen_vp(tables):
    lines = []
    lines.append('')
    lines.append('-- =============================================================================')
    lines.append('-- NOVOS SEGMENTOS CNAB240 (IPAGTB040-068)')
    lines.append('-- =============================================================================')
    for t in tables:
        tname = full_table_name(t)
        pk_col = [c for c in t['cols'] if c[4] == 'PK'][0]
        fk_col = [c for c in t['cols'] if c[4] == 'FK'][0]
        lines.append('')
        lines.append(f'CREATE TABLE {tname} (')
        all_cols = t['cols'] + AUDIT_COLS
        col_lines = []
        for col_name, col_type, default, not_null, role, comment in all_cols:
            nn = ' NOT NULL' if not_null and role != 'PK' else ''
            dado_pessoal = '  -- [DADO_PESSOAL]' if '[DADO_PESSOAL]' in comment else ''
            col_lines.append(f'    {col_name:<40s} {col_type}{nn},{dado_pessoal}')
        # PK
        col_lines.append(f'    CONSTRAINT IPAGTB{t["num"]}_PK')
        col_lines.append(f'        PRIMARY KEY ({pk_col[0]}),')
        # FK
        col_lines.append(f'    CONSTRAINT IPAGTB007_IPAGTB{t["num"]}_FK01')
        col_lines.append(f'        FOREIGN KEY ({fk_col[0]}) REFERENCES IPAGTB007_DETALHE_REG (ID_DETALHE_REG)')
        # remove trailing comma from last col line before constraints
        for i in range(len(col_lines)):
            pass
        lines.extend(col_lines)
        lines.append(');')
    return '\n'.join(lines) + '\n'

def gen_oracle(tables):
    lines = []
    lines.append('')
    lines.append('-- =============================================================================')
    lines.append('-- NOVOS SEGMENTOS CNAB240 (IPAGTB040-068)')
    lines.append('-- =============================================================================')
    for t in tables:
        tname = full_table_name(t)
        pk_col = [c for c in t['cols'] if c[4] == 'PK'][0]
        fk_col = [c for c in t['cols'] if c[4] == 'FK'][0]
        lines.append('')
        lines.append(f'-- ----------------------------------------------------------------------------')
        lines.append(f'-- {tname} - Segmento {t["seg"]}')
        lines.append(f'-- ----------------------------------------------------------------------------')
        lines.append(f'CREATE SEQUENCE {tname}_SQ START WITH 1 INCREMENT BY 1 NOCACHE;')
        lines.append('')
        lines.append(f'CREATE TABLE {tname} (')
        all_cols = t['cols'] + AUDIT_COLS
        col_lines = []
        for col_name, col_type, default, not_null, role, comment in all_cols:
            parts = f'    {col_name:<40s} {col_type}'
            if role == 'PK':
                parts += f'  DEFAULT ON NULL {tname}_SQ.NEXTVAL'
            elif default:
                parts += f'  DEFAULT {default}'
            if not_null:
                parts += '  NOT NULL'
            parts += ','
            col_lines.append(parts)
        # PK
        col_lines.append(f'    CONSTRAINT IPAGTB{t["num"]}_PK')
        col_lines.append(f'        PRIMARY KEY ({pk_col[0]}),')
        # FK
        col_lines.append(f'    CONSTRAINT IPAGTB007_IPAGTB{t["num"]}_FK01')
        col_lines.append(f'        FOREIGN KEY ({fk_col[0]}) REFERENCES IPAGTB007_DETALHE_REG (ID_DETALHE_REG)')
        lines.extend(col_lines)
        lines.append(');')
        lines.append('')
        # Index on FK
        lines.append(f'CREATE INDEX {tname}_IDX01 ON {tname} (ID_DETALHE_REG);')
        lines.append('')
        # COMMENT ON TABLE
        lines.append(f"COMMENT ON TABLE {tname} IS")
        lines.append(f"    '{t['desc_table']}';")
        # COMMENT ON COLUMNs
        for col_name, col_type, default, not_null, role, comment in all_cols:
            dado = ''
            clean_comment = comment
            if '[DADO_PESSOAL]' in comment:
                clean_comment = comment
            lines.append(f"COMMENT ON COLUMN {tname}.{col_name} IS")
            lines.append(f"    '{clean_comment}';")
        lines.append('')
    return '\n'.join(lines) + '\n'


# Generate and append
vp_ddl = gen_vp(TABLES)
oracle_ddl = gen_oracle(TABLES)

with open('DDL_CNAB240_VP.sql', 'a', encoding='utf-8') as f:
    f.write(vp_ddl)

with open('DDL_CNAB240_ORACLE.sql', 'a', encoding='utf-8') as f:
    f.write(oracle_ddl)

print(f'VP: {len(TABLES)} tabelas adicionadas')
print(f'Oracle: {len(TABLES)} tabelas adicionadas com sequences, comments e indexes')
print(f'Total de colunas (sem auditoria): {sum(len(t["cols"]) for t in TABLES)}')
print(f'Tabelas: {", ".join(full_table_name(t) for t in TABLES)}')
