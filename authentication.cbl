       IDENTIFICATION DIVISION.
       PROGRAM-ID. AUTHENTICATION.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT USER-FILE 
           ASSIGN TO "UserAuthentication.dat"
               ORGANIZATION IS LINE SEQUENTIAL.
       DATA DIVISION.
       FILE SECTION.
       FD USER-FILE.
       01 USER-RECORD.
           05 USER-ID PIC X(30).
           05 USER-PASSWORD PIC X(30).
       WORKING-STORAGE SECTION.
       01 WS-USERNAME PIC X(30).
       01 WS-PASSWORD PIC X(30).
       01 WS-CHOICE PIC 9.
       01 WS-EOF PIC X VALUE 'N'.
       01 WS-EXIST PIC X VALUE 'N'.
       01 WS-VALID PIC X VALUE 'N'.
       PROCEDURE DIVISION.
       MAIN.
           DISPLAY "1 - REGISTER"
           DISPLAY "2 - LOGIN"
           DISPLAY "CHOOSE AN OPTION: " NO ADVANCING 
               ACCEPT WS-CHOICE

           EVALUATE WS-CHOICE
               WHEN 1
                   PERFORM USER-REGISTER
               WHEN 2
                   PERFORM USER-LOGIN
               WHEN OTHER
                  DISPLAY "INVALID OPTION"
           END-EVALUATE
           STOP RUN.

       USER-REGISTER.
              OPEN OUTPUT USER-FILE
              DISPLAY "ENTER USERNAME: " NO ADVANCING
              ACCEPT WS-USERNAME
              DISPLAY "ENTER PASSWORD: " NO ADVANCING
              ACCEPT WS-PASSWORD
              MOVE WS-USERNAME TO USER-ID
              MOVE WS-PASSWORD TO USER-PASSWORD
              WRITE USER-RECORD
              CLOSE USER-FILE
              DISPLAY "USER REGISTERED SUCCESSFULLY".
       
       USER-LOGIN.
                OPEN INPUT USER-FILE
                DISPLAY "ENTER USERNAME: " NO ADVANCING
                ACCEPT WS-USERNAME
                DISPLAY "ENTER PASSWORD: " NO ADVANCING
                ACCEPT WS-PASSWORD
                PERFORM UNTIL WS-EOF = 'Y'
                    READ USER-FILE INTO USER-RECORD
                        AT END
                            MOVE 'Y' TO WS-EOF
                        NOT AT END
                IF WS-USERNAME = USER-ID THEN 
                   MOVE 'Y' TO WS-EXIST
                   IF WS-PASSWORD = USER-PASSWORD THEN 
                       MOVE 'Y' TO WS-VALID
                       DISPLAY "LOGIN SUCCESSFUL"
                   CLOSE USER-FILE
                   END-IF
                END-IF
                END-PERFORM
                CLOSE USER-FILE
                IF WS-EXIST = 'N' THEN
                   DISPLAY "ACCOUNT DOES NOT EXIST"
                ELSE IF WS-VALID = 'N' THEN
                   DISPLAY "INCORRECT USERNAME OR PASSWORD"
                END-IF.
