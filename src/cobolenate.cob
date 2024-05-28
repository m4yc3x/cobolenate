       >>SOURCE FORMAT FREE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. Cobolenate.
       AUTHOR. github.com/m4yc3x.
       DATE-WRITTEN. May 27th, 2024.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT CSV-FILE ASSIGN TO 'input.csv'
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT OUTPUT-FILE ASSIGN TO 'output.dat'
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  CSV-FILE.
       01  CSV-RECORD PIC X(1024).

       FD  OUTPUT-FILE.
       01  OUTPUT-RECORD PIC X(1024).

       WORKING-STORAGE SECTION.
       01  WS-CSV-HEADER.
           05  WS-HEADER-FIELD OCCURS 10 TIMES PIC X(100).
       01  WS-CSV-DATA.
           05  WS-DATA-FIELD OCCURS 10 TIMES PIC X(100).
       01  WS-USER-CHOICE PIC 9(1).
       01  WS-OUTPUT-FORMAT PIC X(10).
       01  WS-EOF PIC X VALUE 'N'.
       01  WS-INDEX PIC 9(2) VALUE 1.
       01  WS-START PIC 9(4) VALUE 1.
       01  WS-MATCHED-HEADERS OCCURS 10 TIMES PIC X(100).
       01  WS-DATA-TYPE-HEADERS OCCURS 10 TIMES PIC X(100).
       01  WS-UNMATCHED-INDEX PIC 9(2) VALUE 1.


       PROCEDURE DIVISION.
           DISPLAY "Starting Cobolenate..."
           DISPLAY "Which data type do you want to convert to?"
           DISPLAY "1. vCard"
           DISPLAY "2. JSON"
           DISPLAY "3. XML"
           DISPLAY "4. SQL"
           DISPLAY "5. Excel"
           DISPLAY "Choice: " WITH NO ADVANCING
           ACCEPT WS-USER-CHOICE
           PERFORM MAIN-PROCEDURE
           STOP RUN.

       MAIN-PROCEDURE.
           OPEN INPUT CSV-FILE
           OPEN OUTPUT OUTPUT-FILE
           PERFORM READ-CSV-HEADER
           PERFORM MATCH-HEADERS
           PERFORM UNTIL WS-EOF = 'Y'
               PERFORM READ-CSV-DATA
               PERFORM PROCESS-DATA
               PERFORM WRITE-OUTPUT
           END-PERFORM
           CLOSE CSV-FILE
           CLOSE OUTPUT-FILE
           STOP RUN.

       READ-CSV-HEADER.
           READ CSV-FILE INTO CSV-RECORD
           AT END
               MOVE 'Y' TO WS-EOF
           NOT AT END
               PERFORM PARSE-CSV-HEADER
           END-READ.

       PARSE-CSV-HEADER.
           MOVE 1 TO WS-INDEX
           MOVE 1 TO WS-START
           PERFORM VARYING WS-INDEX FROM 1 BY 1 UNTIL WS-INDEX > 10
               UNSTRING CSV-RECORD
                   DELIMITED BY ","
                   INTO WS-HEADER-FIELD(WS-INDEX)
                   WITH POINTER WS-START
               END-UNSTRING
           END-PERFORM.

       MATCH-HEADERS.
           PERFORM VARYING WS-INDEX FROM 1 BY 1 UNTIL WS-INDEX > 10
               MOVE WS-HEADER-FIELD(WS-INDEX) TO WS-MATCHED-HEADERS(WS-INDEX)
               IF WS-HEADER-FIELD(WS-INDEX) NOT = "name" AND
                  WS-HEADER-FIELD(WS-INDEX) NOT = "phone"
                   DISPLAY "Enter the data type header for " WS-HEADER-FIELD(WS-INDEX) ": " WITH NO ADVANCING
                   ACCEPT WS-MATCHED-HEADERS(WS-INDEX)
               END-IF
           END-PERFORM.

       READ-CSV-DATA.
           READ CSV-FILE INTO CSV-RECORD
           AT END
               MOVE 'Y' TO WS-EOF
           NOT AT END
               PERFORM PARSE-CSV-RECORD
           END-READ.

       PARSE-CSV-RECORD.
           MOVE 1 TO WS-INDEX
           MOVE 1 TO WS-START
           PERFORM VARYING WS-INDEX FROM 1 BY 1 UNTIL WS-INDEX > 10
               UNSTRING CSV-RECORD
                   DELIMITED BY ","
                   INTO WS-DATA-FIELD(WS-INDEX)
                   WITH POINTER WS-START
               END-UNSTRING
           END-PERFORM.

       PROCESS-DATA.
           EVALUATE WS-USER-CHOICE
               WHEN 1
                   PERFORM CONVERT-TO-VCARD
               WHEN 2
                   PERFORM CONVERT-TO-JSON
               WHEN 3
                   PERFORM CONVERT-TO-XML
               WHEN 4
                   PERFORM CONVERT-TO-SQL
               WHEN 5
                   PERFORM CONVERT-TO-EXCEL
               WHEN OTHER
                   DISPLAY 'Invalid choice'
           END-EVALUATE.

       CONVERT-TO-VCARD.
           MOVE 'BEGIN:VCARD' TO OUTPUT-RECORD
           WRITE OUTPUT-RECORD
           MOVE 'VERSION:3.0' TO OUTPUT-RECORD
           WRITE OUTPUT-RECORD
           PERFORM VARYING WS-INDEX FROM 1 BY 1 UNTIL WS-INDEX > 10
               IF WS-MATCHED-HEADERS(WS-INDEX) = "name"
                   MOVE 'FN:' TO OUTPUT-RECORD
                   STRING WS-DATA-FIELD(WS-INDEX) DELIMITED BY SPACE INTO OUTPUT-RECORD
                   WRITE OUTPUT-RECORD
               ELSE IF WS-MATCHED-HEADERS(WS-INDEX) = "phone"
                   MOVE 'TEL:' TO OUTPUT-RECORD
                   STRING WS-DATA-FIELD(WS-INDEX) DELIMITED BY SPACE INTO OUTPUT-RECORD
                   WRITE OUTPUT-RECORD
               ELSE IF WS-MATCHED-HEADERS(WS-INDEX) = "address"
                   MOVE 'ADR:' TO OUTPUT-RECORD
                   STRING WS-DATA-FIELD(WS-INDEX) DELIMITED BY SPACE INTO OUTPUT-RECORD
                   WRITE OUTPUT-RECORD
               ELSE IF WS-MATCHED-HEADERS(WS-INDEX) NOT = SPACES
                   MOVE WS-MATCHED-HEADERS(WS-INDEX) TO OUTPUT-RECORD
                   STRING ':' WS-DATA-FIELD(WS-INDEX) DELIMITED BY SPACE INTO OUTPUT-RECORD
                   WRITE OUTPUT-RECORD
               END-IF
           END-PERFORM
           MOVE 'END:VCARD' TO OUTPUT-RECORD
           WRITE OUTPUT-RECORD.

       CONVERT-TO-JSON.
           MOVE '{' TO OUTPUT-RECORD
           WRITE OUTPUT-RECORD
           PERFORM VARYING WS-INDEX FROM 1 BY 1 UNTIL WS-INDEX > 10
               IF WS-INDEX > 1
                   MOVE ',' TO OUTPUT-RECORD
                   WRITE OUTPUT-RECORD
               END-IF
               STRING '"' WS-MATCHED-HEADERS(WS-INDEX) '": "' WS-DATA-FIELD(WS-INDEX) '"' INTO OUTPUT-RECORD
               WRITE OUTPUT-RECORD
           END-PERFORM
           MOVE '}' TO OUTPUT-RECORD
           WRITE OUTPUT-RECORD.

       CONVERT-TO-XML.
           MOVE '<record>' TO OUTPUT-RECORD
           WRITE OUTPUT-RECORD
           PERFORM VARYING WS-INDEX FROM 1 BY 1 UNTIL WS-INDEX > 10
               STRING '<' WS-MATCHED-HEADERS(WS-INDEX) '>' WS-DATA-FIELD(WS-INDEX) '</' WS-MATCHED-HEADERS(WS-INDEX) '>' INTO OUTPUT-RECORD
               WRITE OUTPUT-RECORD
           END-PERFORM
           MOVE '</record>' TO OUTPUT-RECORD
           WRITE OUTPUT-RECORD.

       CONVERT-TO-SQL.
           MOVE 'INSERT INTO table_name (' TO OUTPUT-RECORD
           PERFORM VARYING WS-INDEX FROM 1 BY 1 UNTIL WS-INDEX > 10
               IF WS-INDEX > 1
                   STRING ', ' INTO OUTPUT-RECORD
               END-IF
               STRING WS-MATCHED-HEADERS(WS-INDEX) INTO OUTPUT-RECORD
           END-PERFORM
           STRING ') VALUES (' INTO OUTPUT-RECORD
           WRITE OUTPUT-RECORD
           PERFORM VARYING WS-INDEX FROM 1 BY 1 UNTIL WS-INDEX > 10
               IF WS-INDEX > 1
                   STRING ', ' INTO OUTPUT-RECORD
               END-IF
               STRING "'" WS-DATA-FIELD(WS-INDEX) "'" INTO OUTPUT-RECORD
           END-PERFORM
           STRING ');' INTO OUTPUT-RECORD
           WRITE OUTPUT-RECORD.

       CONVERT-TO-EXCEL.
           MOVE SPACES TO OUTPUT-RECORD
           PERFORM VARYING WS-INDEX FROM 1 BY 1 UNTIL WS-INDEX > 10
               IF WS-INDEX > 1
                   STRING ',' INTO OUTPUT-RECORD
               END-IF
               STRING WS-DATA-FIELD(WS-INDEX) DELIMITED BY SPACE INTO OUTPUT-RECORD
           END-PERFORM
           WRITE OUTPUT-RECORD.

       WRITE-OUTPUT.
           WRITE OUTPUT-RECORD.

       
