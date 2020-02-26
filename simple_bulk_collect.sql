/*
|  Simple bulk collect
*/

DECLARE
  TYPE client_orders_rt IS RECORD
    (client_no   client_order.client_no%TYPE,
     client_ord_count  NUMBER);
  
  TYPE order_count_t IS TABLE OF client_orders_rt;
  
  l_order_count   order_count_t;
      
BEGIN
  SELECT client_no, COUNT(DISTINCT clients_order_id)
    BULK COLLECT INTO l_order_count
    FROM   client_order
    GROUP BY client_no;  
      
  FOR i IN 1..l_order_count.COUNT
  LOOP
    DBMS_OUTPUT.PUT_LINE('RECORD '||TO_CHAR(i)||' : '||l_order_count(i).client_no||' Num orders: '||TO_CHAR(l_order_count(i).client_ord_count));
  END LOOP;
END; 