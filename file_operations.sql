/*
| Do some file operations
| Can be used to test that UTL_FILE operations all work.
| Has the full list of exceptions as defined in the Oracle docs (11.2.0.4)
|
*/

DECLARE
   s_operation   VARCHAR2 (10) := '&operation'; -- READ, WRITE, COPY, DELETE, RENAME
   s_lineout     VARCHAR2 (32767) := '&output_text' || NULL;
   s_readtext    VARCHAR2 (32767);
   file_handle   UTL_FILE.FILE_TYPE;
   s_directory   VARCHAR2 (32) := '&dir_obj';
   s_filename    VARCHAR2 (32) := '&filename';
   s_new_filename VARCHAR2(32);
BEGIN
   IF s_filename IS NULL OR s_directory IS NULL
   THEN
      DBMS_OUTPUT.PUT_LINE (
         'You need to know a file name and directory object whatever it is you want to do');
   END IF;

   CASE s_operation
      WHEN 'READ'
      THEN
         file_handle   := UTL_FILE.FOPEN(s_directory, s_filename, 'r');
         UTL_FILE.GET_LINE(file_handle, s_readtext);
         DBMS_OUTPUT.PUT_LINE('LINE READ - ' || s_readtext);
         UTL_FILE.FCLOSE(file_handle);
      WHEN 'WRITE'
      THEN
         file_handle   := UTL_FILE.FOPEN (s_directory, s_filename, 'a');
         UTL_FILE.PUT_LINE (file_handle, s_lineout);
         DBMS_OUTPUT.PUT_LINE ('LINE WRITTEN - ' || s_lineout);
         UTL_FILE.FCLOSE (file_handle);
      WHEN 'COPY'
      THEN
         s_new_filename   := s_filename || '_copied';
         UTL_FILE.FCOPY (s_directory,
                         s_filename,
                         s_directory,
                         s_new_filename);
      WHEN 'DELETE'
      THEN
         UTL_FILE.FREMOVE (s_directory, s_filename);
      WHEN 'RENAME'
      THEN
         s_new_filename   := s_filename || '_renamed';
         UTL_FILE.FRENAME (s_directory,
                           s_filename,
                           s_directory,
                           s_new_filename);
      ELSE
         DBMS_OUTPUT.PUT_LINE ('I dont know what operation you want to perform ?');
   END CASE;

   UTL_FILE.FCLOSE (file_handle);
   
EXCEPTION
   WHEN UTL_FILE.INVALID_PATH
   THEN
      DBMS_OUTPUT.PUT_LINE ('ERROR - ' || SQLCODE);
      DBMS_OUTPUT.PUT_LINE ('File location is invalid, i.e. I cant find either the path or the file');
      UTL_FILE.FCLOSE_ALL;
   WHEN UTL_FILE.INVALID_MODE
   THEN
      DBMS_OUTPUT.PUT_LINE ('ERROR - ' || SQLCODE);
      DBMS_OUTPUT.PUT_LINE ('INVALID_MODE - The open_mode parameter in FOPEN is invalid.');
      UTL_FILE.FCLOSE_ALL;
   WHEN UTL_FILE.INVALID_FILEHANDLE
   THEN
      DBMS_OUTPUT.PUT_LINE ('ERROR - ' || SQLCODE);
      DBMS_OUTPUT.PUT_LINE ('File handle is invalid.');
      UTL_FILE.FCLOSE_ALL;
   WHEN UTL_FILE.INVALID_OPERATION
   THEN
      DBMS_OUTPUT.PUT_LINE ('ERROR - ' || SQLCODE);
      DBMS_OUTPUT.PUT_LINE ('INVALID_OPERATION - File could not be opened or operated on as requested.');
      UTL_FILE.FCLOSE_ALL;
   WHEN UTL_FILE.READ_ERROR
   THEN
      DBMS_OUTPUT.PUT_LINE ('ERROR - ' || SQLCODE);
      DBMS_OUTPUT.PUT_LINE (
         'READ_ERROR - Operating system error occurred during the read operation.');
      UTL_FILE.FCLOSE_ALL;
   WHEN UTL_FILE.WRITE_ERROR
   THEN
      DBMS_OUTPUT.PUT_LINE ('ERROR - ' || SQLCODE);
      DBMS_OUTPUT.PUT_LINE (
         'WRITE_ERROR - Operating system error occurred during the write operation.');
      UTL_FILE.FCLOSE_ALL;
   WHEN UTL_FILE.INTERNAL_ERROR
   THEN
      DBMS_OUTPUT.PUT_LINE ('ERROR - ' || SQLCODE);
      DBMS_OUTPUT.PUT_LINE ('INTERNAL_ERROR - Unspecified PL/SQL error');
      UTL_FILE.FCLOSE_ALL;
   WHEN UTL_FILE.CHARSETMISMATCH
   THEN
      DBMS_OUTPUT.PUT_LINE ('ERROR - ' || SQLCODE);
      DBMS_OUTPUT.PUT_LINE (
         'CHARSETMISMATCH - file is opened using FOPEN_NCHAR, but later I/O operations use nonchar functions such as PUTF or GET_LINE.');
      UTL_FILE.FCLOSE_ALL;
   WHEN UTL_FILE.FILE_OPEN
   THEN
      DBMS_OUTPUT.PUT_LINE ('ERROR - ' || SQLCODE);
      DBMS_OUTPUT.PUT_LINE (
         'FILE_OPEN - The requested operation failed because the file is open.');
      UTL_FILE.FCLOSE_ALL;
   WHEN UTL_FILE.INVALID_MAXLINESIZE
   THEN
      DBMS_OUTPUT.PUT_LINE ('ERROR - ' || SQLCODE);
      DBMS_OUTPUT.PUT_LINE (
         'INVALID_MAXLINESIZE - The MAX_LINESIZE value for FOPEN() is invalid; it should be within the range 1 to 32767.');
      UTL_FILE.FCLOSE_ALL;
   WHEN UTL_FILE.INVALID_FILENAME
   THEN
      DBMS_OUTPUT.PUT_LINE ('ERROR - ' || SQLCODE);
      DBMS_OUTPUT.PUT_LINE ('INVALID_FILENAME - The filename parameter is invalid');
      UTL_FILE.FCLOSE_ALL;
   WHEN UTL_FILE.ACCESS_DENIED
   THEN
      DBMS_OUTPUT.PUT_LINE ('ERROR - ' || SQLCODE);
      DBMS_OUTPUT.PUT_LINE ('ACCESS_DENIED - Permission to access to the file location is denied.');
      UTL_FILE.FCLOSE_ALL;
   WHEN UTL_FILE.INVALID_OFFSET
   THEN
      DBMS_OUTPUT.PUT_LINE ('ERROR - ' || SQLCODE);
      DBMS_OUTPUT.PUT_LINE (
         'INVALID_OFFSET - ABSOLUTE_OFFSET = NULL and RELATIVE_OFFSET = NULL, or ABSOLUTE_OFFSET < 0, or Either offset caused a seek past the end of the file');
      UTL_FILE.FCLOSE_ALL;
   WHEN UTL_FILE.DELETE_FAILED
   THEN
      DBMS_OUTPUT.PUT_LINE ('ERROR - ' || SQLCODE);
      DBMS_OUTPUT.PUT_LINE ('DELETE_FAILED - The requested file delete operation failed.');
      UTL_FILE.FCLOSE_ALL;
   WHEN UTL_FILE.RENAME_FAILED
   THEN
      DBMS_OUTPUT.PUT_LINE ('ERROR - ' || SQLCODE);
      DBMS_OUTPUT.PUT_LINE ('RENAME_FAILED - The requested file rename operation failed');
      UTL_FILE.FCLOSE_ALL;
END;