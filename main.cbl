       IDENTIFICATION DIVISION.
       PROGRAM-ID. AUTHENTICATION.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT USER-FILE
           ASSIGN TO "Record.txt"
           ORGANIZATION IS INDEXED
            ACCESS MODE IS RANDOM
            RECORD KEY IS USER-ID.

       DATA DIVISION.
       FILE SECTION.
       FD USER-FILE.
       01 USER-RECORD.
           02 USER-ID PIC X(30).
           02 USER-PASSWORD PIC X(30).
           02 EMPLOYEE-NAME PIC X(30).
           02 EMPLOYEE-DOB PIC X(15).
           02 EMPLOYEE-GENDER PIC A(10).
           02 EMPLOYEE-MARITAL-STATUS PIC A(10).
           02 EMPLOYEE-NATIONALITY PIC A(10).
           02 EMPLOYEE-EMAIL PIC X(20).
           02 EMPLOYEE-CONTACT PIC Z(12).
           02 EMPLOYEE-ADDRESS PIC X(40).

       WORKING-STORAGE SECTION.
       01 CHOICE PIC 9.
       01 WS-OPEN PIC X.
       01 WS-INPUT-PASSWORD PIC X(30).

       PROCEDURE DIVISION.
       MAIN-MENU.
           PERFORM CLEARSCREEN
           PERFORM UNTIL CHOICE = 3
           DISPLAY "==================================================="
           DISPLAY "|||||||||||===============================|||||||||" 
           DISPLAY "|||||||||||| $ PAYROLL MANAGEMENT SYSTEM $ ||||||||"
           DISPLAY "|||||||||||===============================|||||||||"       
           DISPLAY "|=================================================|"
           DISPLAY "||||||||||||||||===================||||||||||||||||"     
           DISPLAY "||||||||||||||||| [1] - REGISTER  |||||||||||||||||"
           DISPLAY "||||||||||||||||===================||||||||||||||||"
           DISPLAY "|=================================================|"
           DISPLAY "||||||||||||||||===================||||||||||||||||"
           DISPLAY "||||||||||||||||| [2] - LOGIN     |||||||||||||||||"
           DISPLAY "||||||||||||||||===================||||||||||||||||"
           DISPLAY "|=================================================|"
           DISPLAY "||||||||||||||||===================||||||||||||||||"
           DISPLAY "||||||||||||||||| [3] - EXIT      |||||||||||||||||"
           DISPLAY "||||||||||||||||===================||||||||||||||||"
           DISPLAY "==================================================="
           DISPLAY "[CHOOSE AN OPTION]: " WITH NO ADVANCING           
           ACCEPT CHOICE
 
           EVALUATE CHOICE
               WHEN 1
                   PERFORM USER-REGISTER
               WHEN 2
                   PERFORM USER-LOGIN
               WHEN OTHER
                  DISPLAY "INVALID OPTION"
           END-EVALUATE
           END-PERFORM.
           STOP RUN.
      

       USER-REGISTER.
       PERFORM CLEARSCREEN
       OPEN I-O USER-FILE
           DISPLAY "|=================================================|"
           DISPLAY "||||||||||||||||===================||||||||||||||||"     
           DISPLAY "|||||||||||||||  [1] - REGISTER     |||||||||||||||"
           DISPLAY "||||||||||||||||===================||||||||||||||||"
           DISPLAY "|=================================================|"
           DISPLAY "[ENTER USERNAME]: " WITH NO ADVANCING
           ACCEPT USER-ID
       READ USER-FILE KEY IS USER-ID
           INVALID KEY
               PERFORM USER-REGISTER-LOOP
           NOT INVALID KEY
           DISPLAY "|=================================================|"
           DISPLAY "|||||||||||||=========================|||||||||||||"     
           DISPLAY "||||||||||||  USERNAME ALREADY EXISTS! ||||||||||||"
           DISPLAY "|||||||||||||=========================|||||||||||||"
           DISPLAY "|=================================================|"
          DISPLAY "[DO YOU WANT TO CONTINUE? (Y/N)]: " WITH NO ADVANCING
           ACCEPT WS-OPEN
              IF WS-OPEN = "Y" OR "y"
                    CLOSE USER-FILE
                    PERFORM USER-REGISTER
                ELSE
                    CLOSE USER-FILE
                    PERFORM MAIN-MENU
         STOP RUN.
     
       USER-REGISTER-LOOP.
           DISPLAY "==================================================="
           DISPLAY "[ENTER PASSWORD]: " NO ADVANCING
            ACCEPT USER-PASSWORD
           DISPLAY "==================================================="
           DISPLAY "[ENTER EMPLOYEE NAME]: " WITH NO ADVANCING
            ACCEPT EMPLOYEE-NAME
           DISPLAY "==================================================="
           DISPLAY "[ENTER EMPLOYEE DOB(mm/dd/yy)]: " WITH NO ADVANCING
            ACCEPT EMPLOYEE-DOB
           DISPLAY "==================================================="
           DISPLAY "[ENTER EMPLOYEE GENDER(M/F)]: " WITH NO ADVANCING
            ACCEPT EMPLOYEE-GENDER
           DISPLAY "==================================================="
           DISPLAY "[ENTER EMPLOYEE STATUS(Single, Married, etc)]: "
            WITH NO ADVANCING
            ACCEPT EMPLOYEE-MARITAL-STATUS
           DISPLAY "==================================================="
           DISPLAY "[ENTER EMPLOYEE NATIONALITY]: " WITH NO ADVANCING
            ACCEPT EMPLOYEE-NATIONALITY
           DISPLAY "==================================================="
           DISPLAY "[ENTER EMPLOYEE EMAIL]: " WITH NO ADVANCING
            ACCEPT EMPLOYEE-EMAIL
           DISPLAY "==================================================="
           DISPLAY "[ENTER EMPLOYEE CONTACT]: " WITH NO ADVANCING
            ACCEPT EMPLOYEE-CONTACT
           DISPLAY "==================================================="
           DISPLAY "[ENTER EMPLOYEE ADDRESS]: " WITH NO ADVANCING
            ACCEPT EMPLOYEE-ADDRESS
            
            
            WRITE USER-RECORD
              END-WRITE.
              CLOSE USER-FILE
           DISPLAY "|=================================================|"
           DISPLAY "|||||||||====================================||||||"     
           DISPLAY "||||||||  USERNAME RESGISTERED SUCCESSFULLY!  |||||"
           DISPLAY "|||||||||====================================||||||"
           DISPLAY "|=================================================|"
           PERFORM MAIN-MENU
           STOP RUN.

       USER-LOGIN.
       OPEN I-O USER-FILE 
       PERFORM CLEARSCREEN
           DISPLAY "|=================================================|"
           DISPLAY "||||||||||||||||===================||||||||||||||||"
           DISPLAY "|||||||||||||||    [2] - LOGIN      |||||||||||||||"
           DISPLAY "||||||||||||||||===================||||||||||||||||"
           DISPLAY "|=================================================|"
           DISPLAY "[ENTER USERNAME]: " NO ADVANCING
           ACCEPT USER-ID


           READ USER-FILE KEY IS USER-ID
           INVALID KEY
           DISPLAY "|=================================================|"
           DISPLAY "|||=============================================|||"
           DISPLAY "      RECORD NOT FOUND FOR USER-ID: " USER-ID
           DISPLAY "             PLEASE REGISTER FIRST!"
           DISPLAY "|||=============================================|||"
           DISPLAY "|=================================================|"   
           DISPLAY "Press enter to try again... " 
           ACCEPT OMITTED
           CLOSE USER-FILE
           PERFORM USER-LOGIN
           NOT INVALID KEY
           DISPLAY "==================================================="          
           DISPLAY "[ENTER PASSWORD]: " NO ADVANCING
               ACCEPT WS-INPUT-PASSWORD
               IF WS-INPUT-PASSWORD = USER-PASSWORD
           DISPLAY "|=================================================|"
           DISPLAY "|||=============================================|||"
           DISPLAY "     LOGIN SUCCESSFUL! WELCOME " EMPLOYEE-NAME     
           DISPLAY "|||=============================================|||"
           DISPLAY "|=================================================|"   
                CLOSE USER-FILE
                PERFORM MAIN-PARA       
               ELSE
           DISPLAY "|=================================================|"
           DISPLAY "|||=============================================|||"     
           DISPLAY "||  ERROR: INCORRECT PASSWORD. PLEASE TRY AGAIN. ||"
           DISPLAY "|||=============================================|||"
           DISPLAY "|=================================================|"
           DISPLAY "DO YOU WANT TO TRY AGAIN? (Y/N): " WITH NO ADVANCING
              ACCEPT WS-OPEN
                IF WS-OPEN = "Y" OR "y"
                    CLOSE USER-FILE
                        PERFORM USER-LOGIN
                    ELSE
                CLOSE USER-FILE
                PERFORM MAIN-MENU
       STOP RUN.

        MAIN-PARA.
        PERFORM CLEARSCREEN
        PERFORM UNTIL CHOICE = 5
           DISPLAY "==================================================="
           DISPLAY "|||||||||||===============================|||||||||" 
           DISPLAY "|||||||||| $ EMPLOYEE RECORD MANAGEMENT $  ||||||||"
           DISPLAY "|||||||||||===============================|||||||||"       
           DISPLAY "|=================================================|"
           DISPLAY "||||||=======================================||||||"     
           DISPLAY "|||||   [1] - EDIT/DELETE EMPLOYEE RECORD     |||||"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|=================================================|"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|||||       [2] - VIEW EMPLOYEE RECORD        |||||"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|=================================================|"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|||||       [3] - ATTENDANCE                  |||||"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|=================================================|"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|||||       [4] - GENERATE PAYSLIP            |||||"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|=================================================|"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|||||       [5] - BACK TO MENU                |||||"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|=================================================|"
           DISPLAY "[CHOOSE AN OPTION]: " WITH NO ADVANCING           
           ACCEPT CHOICE

        EVALUATE CHOICE
        WHEN 1
            PERFORM EDIT-DELETE
        WHEN 2
            PERFORM VIEW-RECORD
        WHEN 3
            PERFORM ATTENDANCE
        WHEN 4
            PERFORM PAYSLIP
        WHEN 5
            PERFORM MAIN-MENU

        END-PERFORM   
        STOP RUN.

        EDIT-DELETE.
        DISPLAY "1 - EDIT EMPLOYEE RECORD"
        DISPLAY "2 - DELETE EMPLOYEE RECORD"
        DISPLAY "3 - BACK"
        DISPLAY "ENTER YOUR CHOICE: " WITH NO ADVANCING
        ACCEPT CHOICE
        
        EVALUATE CHOICE
        WHEN 1
            PERFORM EDIT-RECORD
        WHEN 2
            PERFORM DELETE-RECORD
        WHEN 3
            PERFORM MAIN-PARA
        STOP RUN. 

        EDIT-RECORD.

        STOP RUN.

        DELETE-RECORD.

        STOP RUN.

        VIEW-RECORD.
        DISPLAY "1 - VIEW EMPLOYEE RECORD"
        DISPLAY "2 - VIEW ATTENDANCE RECORD"
        DISPLAY "3 - BACK"
        ACCEPT CHOICE
        
        EVALUATE CHOICE
        WHEN 1
            PERFORM RECORD-FILE
        WHEN 3
            PERFORM MAIN-PARA
        STOP RUN. 

       RECORD-FILE.
       DISPLAY "ENTER YOUR USERNAME: " WITH NO ADVANCING
       ACCEPT USER-ID 
       OPEN I-O USER-FILE.
           READ USER-FILE KEY IS USER-ID
               INVALID KEY
                   DISPLAY "RECORD NOT FOUND FOR USER-ID: " USER-ID
               NOT INVALID KEY
                   DISPLAY "RECORD FOUND:"
                   DISPLAY "USER-ID: " USER-ID
                   DISPLAY "PASSWORD: " USER-PASSWORD
                   DISPLAY "EMPLOYEE NAME: " EMPLOYEE-NAME
                   DISPLAY "EMPLOYEE DOB: " EMPLOYEE-DOB
                   DISPLAY "EMPLOYEE GENDER: " EMPLOYEE-GENDER
                   DISPLAY "EMPLOYEE STATUS: " EMPLOYEE-MARITAL-STATUS
                   DISPLAY "EMPLOYEE NATIONALITY: " EMPLOYEE-NATIONALITY
                   DISPLAY "EMPLOYEE EMAIL: " EMPLOYEE-EMAIL
                   DISPLAY "EMPLOYEE CONTACT: " EMPLOYEE-CONTACT
                   DISPLAY "EMPLOYEE ADDRESS: " EMPLOYEE-ADDRESS
           END-READ.
       CLOSE USER-FILE.
       DISPLAY "PRESS ENTER TO CONTINUE..."
         ACCEPT OMITTED
       PERFORM MAIN-MENU
           STOP RUN.

        ATTENDANCE.
        DISPLAY "1 - TIME IN"
        DISPLAY "2 - TIME OUT"
        DISPLAY "3 - LEAVE"
        DISPLAY "4 - BACK"
        STOP RUN.

        PAYSLIP.
        DISPLAY "1 - GENERATE PAYSLIP"
        DISPLAY "2 - BACK"
        STOP RUN.

       CLEARSCREEN.
           CALL 'SYSTEM' USING 'clear'.

      


        