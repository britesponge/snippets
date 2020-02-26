/*
|  Generate a sequence 'number' using alpha-numerics
|  Uses recursion in cascade_increment
|
*/

set serveroutput on size 1000  
  
  DECLARE
  p_in_seq VARCHAR2(10) := '&input_value';
  
  TYPE v_seq_value IS VARRAY(15) OF CHAR(1);
  seq_val  v_seq_value := v_seq_value(); 
  seq_len   NUMBER;
  s_next_seq  VARCHAR2(10);

  PROCEDURE cascade_increment(in_seq_val IN OUT v_seq_value, in_pos IN NUMBER)
  IS 
  
  BEGIN
/*
||  9 and Z are the end cases.
||  9 just starts incrementing at the letters.
||  Z increments to 0 and then cascades the increment to the next significant digit.
||  If we are at the most significant digit and we need to increment from Z then we need to add a digit, e.g. ZZZ becomes 1000.
*/
       CASE in_seq_val(in_pos)
       WHEN '9' THEN    -- Just increment by starting at the letters.
          in_seq_val(in_pos) := 'A';
       WHEN 'Z' THEN
          IF in_pos = 1 THEN
             in_seq_val(1) := '1';  
             in_seq_val.EXTEND;
             in_seq_val(in_seq_val.COUNT) := '0';
          ELSE
             in_seq_val(in_pos) := '0';
             cascade_increment(in_seq_val, in_pos-1);   
          END IF;
          
       ELSE
          in_seq_val(in_pos) := CHR(ASCII(in_seq_val(in_pos))+1);
       END CASE;
  END cascade_increment;

BEGIN
   seq_len := LENGTH(p_in_seq);
   seq_val.EXTEND(seq_len);
   -- Split the sequence into an array
   FOR i IN 1..seq_len LOOP
      seq_val(i) := SUBSTR(p_in_seq,i,1);
   END LOOP;

   cascade_increment(seq_val, seq_len);

   -- Put the sequence back together from the array
   FOR i IN 1..seq_val.COUNT
   LOOP
      s_next_seq := s_next_seq||seq_val(i);
   END LOOP;
 
   DBMS_OUTPUT.PUT_LINE('Next Sequence - '||s_next_seq); 

END;