/*
|  Print the ASCII code table from 31 to 95
*/

WITH subqf(idx)
     AS (SELECT --+ inline
                ROWNUM + 31
         FROM       DUAL
         CONNECT BY ROWNUM <= 95)
SELECT 'DEC' AS "Format"
     , LISTAGG(TRIM(TO_CHAR(idx, '000')), '|') WITHIN GROUP (ORDER BY idx)
          "Values"
FROM   subqf
UNION ALL
SELECT 'HEX' AS "Format"
     , LISTAGG(TRIM(TO_CHAR(idx, '0X')), ' |') WITHIN GROUP (ORDER BY idx)
          "Values"
FROM   subqf
UNION ALL
SELECT 'CHR' AS "Format"
     , LISTAGG(CHR(idx), '  |') WITHIN GROUP (ORDER BY idx) "Values"
FROM   subqf;