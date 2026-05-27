-- =============================================================================
-- CONSULTAS DE EXEMPLO — MODELO CNAB240 IPAG
-- =============================================================================
-- Banco de referencia: Itau (NU_BANCO_COMPENSACAO = 341)
-- Adaptavel para qualquer banco alterando o filtro.
-- =============================================================================


-- ---------------------------------------------------------------------------
-- 1. LOTES PENDENTES DE ENVIO PARA O ITAU
--    Busca lotes cujo despacho esta PENDENTE ou em RETENTATIVA,
--    filtrando apenas arquivos do Itau (341).
-- ---------------------------------------------------------------------------
SELECT
    arq.NO_NOME_ARQUIVO,
    arq.DH_GERACAO_ARQUIVO,
    lt.ID_LOTE,
    lt.NU_NUMERO_LOTE,
    ts.CO_TIPO_SERVICO,
    ts.NO_TIPO_SERVICO,
    sd.CO_SERVICO                                         AS CO_SERVICO_DESTINO,
    dl.CO_STATUS_DESPACHO,
    dl.NU_TENTATIVA_ATUAL,
    dl.DH_PROXIMO_ENVIO
FROM
    IPAGTB027_DESPACHO_LOTE      dl
    JOIN IPAGTB004_LOTE          lt  ON lt.ID_LOTE            = dl.ID_LOTE
    JOIN IPAGTB001_ARQUIVO       arq ON arq.ID_ARQUIVO        = lt.ID_ARQUIVO
    JOIN IPAGTB031_TIPO_SERVICO  ts  ON ts.ID_TIPO_SERVICO    = lt.ID_TIPO_SERVICO
    JOIN IPAGTB037_SERVICO_DESTINO sd ON sd.ID_SERVICO_DESTINO = dl.ID_SERVICO_DESTINO
WHERE
    arq.NU_BANCO_COMPENSACAO = 341
    AND dl.CO_STATUS_DESPACHO IN ('PENDENTE', 'RETENTATIVA')
ORDER BY
    dl.DH_PROXIMO_ENVIO NULLS FIRST,
    lt.NU_NUMERO_LOTE;


-- ---------------------------------------------------------------------------
-- 2. LOTES DO ITAU PRONTOS PARA ENVIO AGORA
--    Igual ao anterior, mas so retorna os que ja podem ser enviados
--    (DH_PROXIMO_ENVIO <= SYSDATE ou nunca tentados).
-- ---------------------------------------------------------------------------
SELECT
    dl.ID_DESPACHO_LOTE,
    lt.ID_LOTE,
    arq.NO_NOME_ARQUIVO,
    lt.NU_NUMERO_LOTE,
    sd.CO_SERVICO                                         AS CO_SERVICO_DESTINO,
    sd.TE_URL_DESTINO,
    dl.CO_STATUS_DESPACHO,
    dl.NU_TENTATIVA_ATUAL,
    dl.NU_MAX_TENTATIVA
FROM
    IPAGTB027_DESPACHO_LOTE      dl
    JOIN IPAGTB004_LOTE          lt  ON lt.ID_LOTE            = dl.ID_LOTE
    JOIN IPAGTB001_ARQUIVO       arq ON arq.ID_ARQUIVO        = lt.ID_ARQUIVO
    JOIN IPAGTB037_SERVICO_DESTINO sd ON sd.ID_SERVICO_DESTINO = dl.ID_SERVICO_DESTINO
WHERE
    arq.NU_BANCO_COMPENSACAO = 341
    AND dl.CO_STATUS_DESPACHO IN ('PENDENTE', 'RETENTATIVA')
    AND (dl.DH_PROXIMO_ENVIO IS NULL OR dl.DH_PROXIMO_ENVIO <= SYSDATE)
    AND dl.NU_TENTATIVA_ATUAL < dl.NU_MAX_TENTATIVA
    AND sd.IN_ATIVO = 'S'
ORDER BY
    CASE dl.CO_STATUS_DESPACHO
        WHEN 'PENDENTE'    THEN 1
        WHEN 'RETENTATIVA' THEN 2
    END,
    dl.DH_PROXIMO_ENVIO NULLS FIRST;


-- ---------------------------------------------------------------------------
-- 3. RESUMO POR SERVICO: QUANTOS LOTES DO ITAU ESTAO EM CADA STATUS
-- ---------------------------------------------------------------------------
SELECT
    sd.CO_SERVICO,
    sd.NO_SERVICO,
    dl.CO_STATUS_DESPACHO,
    COUNT(*)                                              AS QT_LOTE
FROM
    IPAGTB027_DESPACHO_LOTE      dl
    JOIN IPAGTB004_LOTE          lt  ON lt.ID_LOTE            = dl.ID_LOTE
    JOIN IPAGTB001_ARQUIVO       arq ON arq.ID_ARQUIVO        = lt.ID_ARQUIVO
    JOIN IPAGTB037_SERVICO_DESTINO sd ON sd.ID_SERVICO_DESTINO = dl.ID_SERVICO_DESTINO
WHERE
    arq.NU_BANCO_COMPENSACAO = 341
GROUP BY
    sd.CO_SERVICO,
    sd.NO_SERVICO,
    dl.CO_STATUS_DESPACHO
ORDER BY
    sd.CO_SERVICO,
    dl.CO_STATUS_DESPACHO;


-- ---------------------------------------------------------------------------
-- 4. LOTES DO ITAU EM ERRO (esgotaram tentativas)
-- ---------------------------------------------------------------------------
SELECT
    arq.NO_NOME_ARQUIVO,
    arq.DH_GERACAO_ARQUIVO,
    lt.ID_LOTE,
    lt.NU_NUMERO_LOTE,
    ts.NO_TIPO_SERVICO,
    sd.CO_SERVICO                                         AS CO_SERVICO_DESTINO,
    dl.NU_TENTATIVA_ATUAL,
    dl.NU_MAX_TENTATIVA,
    dl.DH_ULTIMO_ENVIO,
    dl.CO_STATUS_HTTP,
    dl.TE_RESPOSTA_SERVICO
FROM
    IPAGTB027_DESPACHO_LOTE      dl
    JOIN IPAGTB004_LOTE          lt  ON lt.ID_LOTE            = dl.ID_LOTE
    JOIN IPAGTB001_ARQUIVO       arq ON arq.ID_ARQUIVO        = lt.ID_ARQUIVO
    JOIN IPAGTB031_TIPO_SERVICO  ts  ON ts.ID_TIPO_SERVICO    = lt.ID_TIPO_SERVICO
    JOIN IPAGTB037_SERVICO_DESTINO sd ON sd.ID_SERVICO_DESTINO = dl.ID_SERVICO_DESTINO
WHERE
    arq.NU_BANCO_COMPENSACAO = 341
    AND dl.CO_STATUS_DESPACHO = 'ERRO'
ORDER BY
    dl.DH_ULTIMO_ENVIO DESC;


-- ---------------------------------------------------------------------------
-- 5. HISTORICO DE TENTATIVAS DE ENVIO DE UM LOTE ESPECIFICO DO ITAU
--    Troque :ID_LOTE pelo ID desejado.
-- ---------------------------------------------------------------------------
SELECT
    hd.NU_NUMERO_TENTATIVA,
    hd.CO_STATUS_RESULTADO,
    hd.DH_ENVIO,
    hd.DH_RESPOSTA,
    hd.NU_DURACAO_MS,
    hd.CO_STATUS_HTTP,
    hd.NU_PROTOCOLO_EXTERNO,
    hd.TE_RESPOSTA_SERVICO
FROM
    IPAGTB028_HISTORICO_DESPACHO hd
    JOIN IPAGTB027_DESPACHO_LOTE dl ON dl.ID_DESPACHO_LOTE = hd.ID_DESPACHO_LOTE
    JOIN IPAGTB004_LOTE          lt ON lt.ID_LOTE          = dl.ID_LOTE
    JOIN IPAGTB001_ARQUIVO       arq ON arq.ID_ARQUIVO     = lt.ID_ARQUIVO
WHERE
    arq.NU_BANCO_COMPENSACAO = 341
    AND dl.ID_LOTE = :ID_LOTE
ORDER BY
    hd.NU_NUMERO_TENTATIVA;


-- ---------------------------------------------------------------------------
-- 6. LOTES DE COBRANCA DO ITAU PENDENTES (tipo servico 01)
--    Util para ver especificamente boletos de cobranca aguardando envio.
-- ---------------------------------------------------------------------------
SELECT
    arq.NO_NOME_ARQUIVO,
    lt.ID_LOTE,
    lt.NU_NUMERO_LOTE,
    dl.CO_STATUS_DESPACHO,
    dl.NU_TENTATIVA_ATUAL,
    dl.DH_PROXIMO_ENVIO,
    (SELECT COUNT(*) FROM IPAGTB007_DETALHE_REG dr WHERE dr.ID_LOTE = lt.ID_LOTE)
                                                          AS QT_DETALHE_NO_LOTE
FROM
    IPAGTB027_DESPACHO_LOTE      dl
    JOIN IPAGTB004_LOTE          lt  ON lt.ID_LOTE            = dl.ID_LOTE
    JOIN IPAGTB001_ARQUIVO       arq ON arq.ID_ARQUIVO        = lt.ID_ARQUIVO
WHERE
    arq.NU_BANCO_COMPENSACAO = 341
    AND lt.CO_TIPO_SERVICO = '01'
    AND dl.CO_STATUS_DESPACHO IN ('PENDENTE', 'RETENTATIVA')
ORDER BY
    arq.DH_GERACAO_ARQUIVO,
    lt.NU_NUMERO_LOTE;


-- ---------------------------------------------------------------------------
-- 7. PAINEL CONSOLIDADO: STATUS DE TODOS OS ARQUIVOS DO ITAU
--    Mostra progresso da carga + despachos por arquivo.
-- ---------------------------------------------------------------------------
SELECT
    arq.ID_ARQUIVO,
    arq.NO_NOME_ARQUIVO,
    arq.DH_GERACAO_ARQUIVO,
    cc.CO_STATUS_CARGA,
    cc.QT_LOTE_ESPERADO,
    cc.QT_LOTE_CONCLUIDO,
    ROUND(cc.QT_LOTE_CONCLUIDO * 100.0 / NULLIF(cc.QT_LOTE_ESPERADO, 0), 1)
                                                          AS NU_PERCENTUAL_CARGA,
    SUM(CASE WHEN dl.CO_STATUS_DESPACHO = 'PENDENTE'    THEN 1 ELSE 0 END)
                                                          AS QT_DESPACHO_PENDENTE,
    SUM(CASE WHEN dl.CO_STATUS_DESPACHO = 'ENVIADO'     THEN 1 ELSE 0 END)
                                                          AS QT_DESPACHO_ENVIADO,
    SUM(CASE WHEN dl.CO_STATUS_DESPACHO = 'CONFIRMADO'  THEN 1 ELSE 0 END)
                                                          AS QT_DESPACHO_CONFIRMADO,
    SUM(CASE WHEN dl.CO_STATUS_DESPACHO = 'ERRO'        THEN 1 ELSE 0 END)
                                                          AS QT_DESPACHO_ERRO,
    SUM(CASE WHEN dl.CO_STATUS_DESPACHO = 'RETENTATIVA' THEN 1 ELSE 0 END)
                                                          AS QT_DESPACHO_RETENTATIVA
FROM
    IPAGTB001_ARQUIVO              arq
    LEFT JOIN IPAGTB025_CONTROLE_CARGA cc ON cc.ID_ARQUIVO  = arq.ID_ARQUIVO
    LEFT JOIN IPAGTB004_LOTE           lt ON lt.ID_ARQUIVO  = arq.ID_ARQUIVO
    LEFT JOIN IPAGTB027_DESPACHO_LOTE  dl ON dl.ID_LOTE     = lt.ID_LOTE
WHERE
    arq.NU_BANCO_COMPENSACAO = 341
GROUP BY
    arq.ID_ARQUIVO,
    arq.NO_NOME_ARQUIVO,
    arq.DH_GERACAO_ARQUIVO,
    cc.CO_STATUS_CARGA,
    cc.QT_LOTE_ESPERADO,
    cc.QT_LOTE_CONCLUIDO
ORDER BY
    arq.DH_GERACAO_ARQUIVO DESC;


-- ---------------------------------------------------------------------------
-- 8. LOTES DO ITAU QUE NUNCA RECEBERAM DESPACHO
--    Identifica lotes carregados mas que nao tiveram registro criado em
--    IPAGTB027 (possivel falha no fluxo de carga).
-- ---------------------------------------------------------------------------
SELECT
    arq.NO_NOME_ARQUIVO,
    lt.ID_LOTE,
    lt.NU_NUMERO_LOTE,
    lt.CO_TIPO_SERVICO,
    ts.NO_TIPO_SERVICO,
    lt.DH_INCLUSAO                                        AS DH_INCLUSAO_LOTE
FROM
    IPAGTB004_LOTE              lt
    JOIN IPAGTB001_ARQUIVO      arq ON arq.ID_ARQUIVO     = lt.ID_ARQUIVO
    JOIN IPAGTB031_TIPO_SERVICO ts  ON ts.ID_TIPO_SERVICO = lt.ID_TIPO_SERVICO
    LEFT JOIN IPAGTB027_DESPACHO_LOTE dl ON dl.ID_LOTE    = lt.ID_LOTE
WHERE
    arq.NU_BANCO_COMPENSACAO = 341
    AND dl.ID_DESPACHO_LOTE IS NULL
ORDER BY
    lt.DH_INCLUSAO;


-- ---------------------------------------------------------------------------
-- 9. USANDO A VIEW IPAGTV002_DESPACHO_PENDENTE (forma mais simples)
--    A view ja encapsula a logica de fila de trabalho.
-- ---------------------------------------------------------------------------
SELECT *
  FROM IPAGTV002_DESPACHO_PENDENTE vdp
 WHERE vdp.ID_ARQUIVO IN (
         SELECT ID_ARQUIVO
           FROM IPAGTB001_ARQUIVO
          WHERE NU_BANCO_COMPENSACAO = 341
       )
 ORDER BY
    vdp.NU_PRIORIDADE_FILA,
    vdp.DH_PROXIMO_ENVIO NULLS FIRST;


-- ---------------------------------------------------------------------------
-- 10. SELECT ... FOR UPDATE SKIP LOCKED (para consumidor de fila)
--     Uso real em PL/SQL: o processo pega o proximo lote pendente do Itau,
--     trava o registro para evitar concorrencia, e processa.
-- ---------------------------------------------------------------------------
SELECT
    dl.ID_DESPACHO_LOTE,
    dl.ID_LOTE,
    sd.TE_URL_DESTINO,
    sd.CO_SERVICO
FROM
    IPAGTB027_DESPACHO_LOTE      dl
    JOIN IPAGTB004_LOTE          lt  ON lt.ID_LOTE            = dl.ID_LOTE
    JOIN IPAGTB001_ARQUIVO       arq ON arq.ID_ARQUIVO        = lt.ID_ARQUIVO
    JOIN IPAGTB037_SERVICO_DESTINO sd ON sd.ID_SERVICO_DESTINO = dl.ID_SERVICO_DESTINO
WHERE
    arq.NU_BANCO_COMPENSACAO = 341
    AND dl.CO_STATUS_DESPACHO IN ('PENDENTE', 'RETENTATIVA')
    AND (dl.DH_PROXIMO_ENVIO IS NULL OR dl.DH_PROXIMO_ENVIO <= SYSDATE)
    AND dl.NU_TENTATIVA_ATUAL < dl.NU_MAX_TENTATIVA
    AND sd.IN_ATIVO = 'S'
ORDER BY
    dl.DH_PROXIMO_ENVIO NULLS FIRST
FETCH FIRST 1 ROWS ONLY
FOR UPDATE OF dl.CO_STATUS_DESPACHO SKIP LOCKED;
