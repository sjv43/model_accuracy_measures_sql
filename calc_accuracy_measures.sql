SELECT
CURRENT_DATE() AS DATE,
*
  FROM (
    SELECT
    'Day 0' AS MODEL,
    MAX(SAMPLE_SIZE) AS SAMPLE_SIZE,
    MAX(TOT_HH_ACTUAL) AS TOT_HH_ACTUAL,
    MAX(TOT_HH_PRED) AS TOT_HH_PRED,
    MAX(TRUE_POS) AS TRUE_POS,
    ROUND(MAX(TRUE_POS)/MAX(TOT_HH_PRED), 4) AS PRECISION,
    ROUND((MAX(TOT_HH_PRED)-MAX(TRUE_POS))/(MAX(SAMPLE_SIZE) - MAX(TOT_HH_ACTUAL)), 4) AS FPR,
    ROUND(MAX(TRUE_POS)/MAX(TOT_HH_ACTUAL), 4) AS RECALL
    FROM (
      SELECT
      SAMPLE_SIZE,
      TOT_HH_ACTUAL,
      TOT_HH_PRED,
      TRUE_POS
      FROM (
        SELECT
        COUNT(1) AS SAMPLE_SIZE
        FROM
        [time_to_sell_validation.listings_since_20170427] ) t0,
      (
        SELECT
        COUNT(1) AS TOT_HH_ACTUAL
        FROM
        [time_to_sell_validation.listings_since_20170427]
        WHERE
        duration <= 14) t1,
      (
        SELECT
        COUNT(1) AS TOT_HH_PRED
        FROM (
          SELECT
          *
            FROM (
              SELECT
              CAST(mprid AS INTEGER) AS mprid
              FROM
              TABLE_DATE_RANGE([dev_timetosell.predictions_day0_], TIMESTAMP(DATE_ADD('20170427', -30, 'DAY')), TIMESTAMP(CURRENT_DATE()))) a
          JOIN
          [time_to_sell_validation.listings_since_20170427] b
          ON
          a.mprid = b.mprid) t2),
      (
        SELECT
        COUNT(1) AS TRUE_POS
        FROM (
          SELECT
          *
            FROM
          [time_to_sell_validation.listings_since_20170427]
          WHERE
          duration <= 14) t3
        JOIN (
          SELECT
          CAST(mprid AS INTEGER) AS mprid
          FROM
          TABLE_DATE_RANGE([dev_timetosell.predictions_day0_], TIMESTAMP(DATE_ADD('20170427', -30, 'DAY')), TIMESTAMP(CURRENT_DATE()))) t4
        ON
        t3.mprid = t4.mprid) t5)) t6,
(
  SELECT
  'Day 3' AS MODEL,
  MAX(SAMPLE_SIZE) AS SAMPLE_SIZE,
  MAX(TOT_HH_ACTUAL) AS TOT_HH_ACTUAL,
  MAX(TOT_HH_PRED) AS TOT_HH_PRED,
  MAX(TRUE_POS) AS TRUE_POS,
  ROUND(MAX(TRUE_POS)/MAX(TOT_HH_PRED), 4) AS PRECISION,
  ROUND((MAX(TOT_HH_PRED)-MAX(TRUE_POS))/(MAX(SAMPLE_SIZE) - MAX(TOT_HH_ACTUAL)), 4) AS FPR,
  ROUND(MAX(TRUE_POS)/MAX(TOT_HH_ACTUAL), 4) AS RECALL
  FROM (
    SELECT
    SAMPLE_SIZE,
    TOT_HH_ACTUAL,
    TOT_HH_PRED,
    TRUE_POS
    FROM (
      SELECT
      COUNT(1) AS SAMPLE_SIZE
      FROM
      [time_to_sell_validation.listings_since_20170427] ) t0,
    (
      SELECT
      COUNT(1) AS TOT_HH_ACTUAL
      FROM
      [time_to_sell_validation.listings_since_20170427]
      WHERE
      duration <= 14) t1,
    (
      SELECT
      COUNT(1) AS TOT_HH_PRED
      FROM (
        SELECT
        *
          FROM (
            SELECT
            CAST(mprid AS INTEGER) AS mprid
            FROM
            TABLE_DATE_RANGE([dev_timetosell.predictions_day3_], TIMESTAMP(DATE_ADD('20170427', -30, 'DAY')), TIMESTAMP(CURRENT_DATE()))) a
        JOIN
        [time_to_sell_validation.listings_since_20170427] b
        ON
        a.mprid = b.mprid) t2),
    (
      SELECT
      COUNT(1) AS TRUE_POS
      FROM (
        SELECT
        *
          FROM
        [time_to_sell_validation.listings_since_20170427]
        WHERE
        duration <= 14) t3
      JOIN (
        SELECT
        CAST(mprid AS INTEGER) AS mprid
        FROM
        TABLE_DATE_RANGE([dev_timetosell.predictions_day3_], TIMESTAMP(DATE_ADD('20170427', -30, 'DAY')), TIMESTAMP(CURRENT_DATE()))) t4
      ON
      t3.mprid = t4.mprid) t5)) t7
ORDER BY
DATE DESC,
MODEL ASC