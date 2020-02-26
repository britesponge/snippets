SELECT lo.os_user_name,
       CASE lo.locked_mode
          WHEN 6 THEN 'X - Exclusive'
          WHEN 5 THEN 'SSX - S/Row X'
          WHEN 4 THEN 'S - Share'
          WHEN 3 THEN 'SX - Row X'
          WHEN 2 THEN 'SS - Row S'
          ELSE TO_CHAR (lo.locked_mode)
       END
          AS lock_MODE,
       obj.object_name
FROM   v$locked_object lo
       INNER JOIN all_objects obj ON obj.object_id = lo.object_id