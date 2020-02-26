/*
|  Just generate the standard fizzbuzz comma separated
*/

WITH num_list AS
(SELECT rownum r
 FROM dual
 CONNECT BY ROWNUM <= 100)
SELECT LISTAGG(full_list.fizzbuzz, ' ') WITHIN GROUP ( ORDER BY rownum) AS FizzyBuzzy
  FROM 
      (SELECT (CASE WHEN MOD(num.r,3) = 0 THEN 'Fizz '
              WHEN MOD(num.r,5) = 0 THEN 'Buzz '
              ELSE TO_CHAR(num.r)
              END) fizzbuzz
         FROM num_list num
       ORDER BY num.r asc) full_list