       IDENTIFICATION DIVISION.
       PROGRAM-ID. SUBPROG.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT USER-FILE
           ASSIGN TO "Record.txt"
           ORGANIZATION IS INDEXED
            ACCESS MODE IS RANDOM
            RECORD KEY IS USER-ID.

            SELECT PAYSLIP-FILE ASSIGN TO "Payslip.txt"
                ORGANIZATION IS INDEXED
                ACCESS MODE IS RANDOM
                RECORD KEY IS USERNAME.


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
           02 EMPLOYEE-CONTACT PIC X(12).
           02 EMPLOYEE-ADDRESS PIC X(40).

       FD PAYSLIP-FILE.
        01 PAYSLIP-RECORD.
            02 USERNAME                 PIC X(30).
            02 PAYSLIP-PERIOD           PIC X(30).
            02 EMP-NAME                 PIC X(30).
            02 BASIC-SALARY             PIC 9(4).
            02 FD-OVERTIME              PIC Z(6).99.
            02 FD-NIGHT-DIFF            PIC Z(6).99.
            02 FD-HOLIDAY               PIC Z(6).99.
            02 FD-TOTAL-PAY             PIC Z(6).99.
            02 FD-LATE PIC Z(6).99.
            02 FD-ABSENT PIC Z(6).99.
            02 FD-UNDERTIME PIC Z(6).99.
            02 FD-SSS PIC 999.
            02 FD-PAGIBIG PIC 999.
            02 FD-PHILHEALTH PIC 999.
            02 FD-TOTAL-DEDUCTION PIC Z(6).99.
            02 FD-NETPAY PIC Z(6).99.

       WORKING-STORAGE SECTION.
       01 CHOICE PIC 9.
       01 WS-OPEN PIC X.
       01 WS-INPUT-PASSWORD PIC X(30).
       01 ATT-REC PIC X(100) VALUE "python3 Attendance.py".
       01 WS-NEW-VALUE PIC X(40).
       01 WS-DELETE-CONFIRM PIC X.

       PROCEDURE DIVISION.
       
       MAIN-PARA.
        PERFORM CLEAR-SCREEN
        PERFORM UNTIL CHOICE = 5
           DISPLAY "==================================================="
           DISPLAY "|||||||||||===============================|||||||||" 
           DISPLAY "|||||||||| $ EMPLOYEE RECOMANAGEMENT $  ||||||||"
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
                   PERFORM RECORD-FILE
               WHEN 3
                   PERFORM ATTENDANCE
               WHEN 4
                   PERFORM PAYSLIP
               WHEN 5
           CALL "SYSTEM" USING BY REFERENCE "python3 Call.py"
               WHEN OTHER 
                   DISPLAY "INVALID OPTION"
                   ACCEPT omitted
                   PERFORM MAIN-PARA
           END-EVALUATE
           END-PERFORM   
        STOP RUN.

           ATTENDANCE.
           CALL "SYSTEM" USING BY REFERENCE ATT-REC.
           STOP RUN.

        EDIT-DELETE.
           PERFORM CLEAR-SCREEN
           PERFORM UNTIL CHOICE = 3
           DISPLAY "|=================================================|"
           DISPLAY "||||||=======================================||||||"     
           DISPLAY "|||||      EDIT/DELETE EMPLOYEE RECORD        |||||"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|=================================================|"
           DISPLAY "||||||=======================================||||||"     
           DISPLAY "|||||      [1] - EDIT EMPLOYEE RECORD         |||||"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|=================================================|"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|||||      [2] - DELETE EMPLOYEE RECORD       |||||"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|=================================================|"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|||||      [3] - BACK TO MENU                 |||||"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|=================================================|"
           DISPLAY "[CHOOSE AN OPTION]: " WITH NO ADVANCING            
           ACCEPT CHOICE
        
           EVALUATE CHOICE
               WHEN 1
                   PERFORM EDIT-RECORD
               WHEN 2
                   PERFORM DELETE-RECORD
               WHEN 3
                   PERFORM MAIN-PARA
               WHEN OTHER 
                   DISPLAY "INVALID OPTION"
                   ACCEPT OMITTED
                   PERFORM EDIT-DELETE
           END-EVALUATE
           END-PERFORM
           STOP RUN. 

       EDIT-RECORD.
           PERFORM CLEAR-SCREEN
           DISPLAY "|=================================================|"
           DISPLAY "||||||=======================================||||||"     
           DISPLAY "|||||      [1] - EDIT EMPLOYEE RECORD         |||||"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|=================================================|"
           DISPLAY "[ENTER EMPLOYEE'S USERNAME TO EDIT]: " NO ADVANCING
           ACCEPT USER-ID
           DISPLAY "==================================================="     

           OPEN I-O USER-FILE
           READ USER-FILE KEY IS USER-ID
               INVALID KEY
           DISPLAY "|=================================================|"
           DISPLAY "|||||||||||||=========================|||||||||||||"     
           DISPLAY "||||||||||||    EMPLOYEE NOT FOUND!    ||||||||||||"
           DISPLAY "|||||||||||||=========================|||||||||||||"
           DISPLAY "|=================================================|"
          DISPLAY "[DO YOU WANT TO CONTINUE? (Y/N)]: " WITH NO ADVANCING
           ACCEPT WS-OPEN
              IF WS-OPEN = "Y" OR "y"
                    CLOSE USER-FILE
                    PERFORM EDIT-DELETE
                ELSE
                    CLOSE USER-FILE
                    PERFORM MAIN-PARA
                   
               NOT INVALID KEY
           DISPLAY "[CURRENT PASSWORD]: " USER-PASSWORD
           DISPLAY "ENTER NEW PASSWORD(PRESS ENTER TO KEEP CURRENT): "
           WITH NO ADVANCING
           ACCEPT WS-NEW-VALUE
           DISPLAY "==================================================="     
           IF WS-NEW-VALUE NOT = SPACES THEN
               MOVE WS-NEW-VALUE TO USER-PASSWORD
           END-IF

           DISPLAY "[CURRENT NAME]: " EMPLOYEE-NAME
           DISPLAY "ENTER NEW NAME(PRESS ENTER TO KEEP CURRENT): "
           WITH NO ADVANCING 
           ACCEPT WS-NEW-VALUE
           DISPLAY "==================================================="     
           IF WS-NEW-VALUE NOT = SPACES THEN
                MOVE WS-NEW-VALUE TO EMPLOYEE-NAME
           END-IF

           DISPLAY "[CURRENT DOB]: " EMPLOYEE-DOB
           DISPLAY "ENTER NEW DOB(PRESS ENTER TO KEEP CURRENT): " 
           WITH NO ADVANCING
           ACCEPT WS-NEW-VALUE
           DISPLAY "==================================================="    
           IF WS-NEW-VALUE NOT = SPACES THEN
               MOVE WS-NEW-VALUE TO EMPLOYEE-DOB
           END-IF

           DISPLAY "[CURRENT GENDER]: " EMPLOYEE-GENDER
           DISPLAY "ENTER NEW GENDER(PRESS ENTER TO KEEP CURRENT): " 
           WITH NO ADVANCING
           ACCEPT WS-NEW-VALUE
           DISPLAY "==================================================="    
           IF WS-NEW-VALUE NOT = SPACES THEN
               MOVE WS-NEW-VALUE TO EMPLOYEE-GENDER
           END-IF

           DISPLAY "[CURRENT MARITAL STATUS]: " EMPLOYEE-MARITAL-STATUS
       DISPLAY "ENTER NEW MARITAL STATUS(PRESS ENTER TO KEEP CURRENT): "
           WITH NO ADVANCING
           ACCEPT WS-NEW-VALUE
           DISPLAY "==================================================="    
           IF WS-NEW-VALUE NOT = SPACES THEN
               MOVE WS-NEW-VALUE TO EMPLOYEE-MARITAL-STATUS
           END-IF

           DISPLAY "[CURRENT NATIONALITY]: " EMPLOYEE-NATIONALITY
       DISPLAY "ENTER NEW NATIONALITY(Press ENTER to keep current): " 
           WITH NO ADVANCING
           ACCEPT WS-NEW-VALUE
           DISPLAY "==================================================="    
           IF WS-NEW-VALUE NOT = SPACES THEN
                MOVE WS-NEW-VALUE TO EMPLOYEE-NATIONALITY
           END-IF

           DISPLAY "[CURRENT EMAIL]: " EMPLOYEE-EMAIL
           DISPLAY "ENTER NEW EMAIL(PRESS ENTER TO KEEP CURRENT): " 
           WITH NO ADVANCING
           ACCEPT WS-NEW-VALUE
           DISPLAY "==================================================="    
           IF WS-NEW-VALUE NOT = SPACES THEN
               MOVE WS-NEW-VALUE TO EMPLOYEE-EMAIL
           END-IF

           DISPLAY "[CURRENT CONTACT]: " EMPLOYEE-CONTACT
           DISPLAY "ENTER NEW CONTACT(PRESS ENTER TO KEEP CURRENT): " 
           WITH NO ADVANCING
           ACCEPT WS-NEW-VALUE
           DISPLAY "==================================================="    
           IF WS-NEW-VALUE NOT = SPACES THEN
               MOVE WS-NEW-VALUE TO EMPLOYEE-CONTACT
           END-IF

           DISPLAY "[CURRENT ADDRESS]: " EMPLOYEE-ADDRESS
           DISPLAY "ENTER NEW ADDRESS(PRESS ENTER TO KEEP CURRENT): " 
           WITH NO ADVANCING
           ACCEPT WS-NEW-VALUE
           DISPLAY "==================================================="    
           IF WS-NEW-VALUE NOT = SPACES THEN
               MOVE WS-NEW-VALUE TO EMPLOYEE-ADDRESS
           END-IF
           
           REWRITE USER-RECORD
               INVALID KEY
           DISPLAY "|=================================================|"
           DISPLAY "|||||||||================================||||||||||"     
           DISPLAY "||||||||  ERROR: UNABLE TO UPDATE RECORD! |||||||||"
           DISPLAY "|||||||||================================||||||||||"
           DISPLAY "|=================================================|"
          DISPLAY "[DO YOU WANT TO CONTINUE? (Y/N)]: " WITH NO ADVANCING
           ACCEPT WS-OPEN
              IF WS-OPEN = "Y" OR "y"
                    CLOSE USER-FILE
                    PERFORM EDIT-DELETE
                ELSE
                    CLOSE USER-FILE
                    PERFORM MAIN-PARA
           END-REWRITE
           PERFORM CLEAR-SCREEN
           DISPLAY "|=================================================|"
           DISPLAY "|||||||||================================||||||||||"     
           DISPLAY "||||||||   RECORD UPDATED SUCCESSFULLY!   |||||||||"
           DISPLAY "|||||||||================================||||||||||"
           DISPLAY "|=================================================|"
           DISPLAY "PRESS ENTER TO CONTINUE..." WITH NO ADVANCING
              ACCEPT OMITTED   
                CLOSE USER-FILE
                PERFORM MAIN-PARA       
           CLOSE USER-FILE.
           

        DELETE-RECORD.
           PERFORM CLEAR-SCREEN
           DISPLAY "|=================================================|"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|||||      [2] - DELETE EMPLOYEE RECORD       |||||"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|=================================================|"
           DISPLAY "[ENTER EMPLOYEE'S USERNAME TO DELETE DETAILS]: " 
           WITH NO ADVANCING
           ACCEPT USER-ID
           

           OPEN I-O USER-FILE
           READ USER-FILE KEY IS USER-ID
               INVALID KEY
           DISPLAY "|=================================================|"
           DISPLAY "|||||||||||||=========================|||||||||||||"     
           DISPLAY "||||||||||||    EMPLOYEE NOT FOUND!    ||||||||||||"
           DISPLAY "|||||||||||||=========================|||||||||||||"
           DISPLAY "|=================================================|"
          DISPLAY "[DO YOU WANT TO CONTINUE? (Y/N)]: " WITH NO ADVANCING
           ACCEPT WS-OPEN
              IF WS-OPEN = "Y" OR "y"
                    CLOSE USER-FILE
                    PERFORM EDIT-DELETE
                ELSE
                    CLOSE USER-FILE
                    PERFORM MAIN-PARA               
                   
               NOT INVALID KEY
           DISPLAY "==================================================="    
           DISPLAY "CURRENT NAME: " EMPLOYEE-NAME
           DISPLAY "DELETE NAME? (Y/N): " WITH NO ADVANCING
           ACCEPT WS-DELETE-CONFIRM
           DISPLAY "==================================================="   
           IF WS-DELETE-CONFIRM = 'Y' OR WS-DELETE-CONFIRM = 'y' THEN
               MOVE SPACES TO EMPLOYEE-NAME
           END-IF

           DISPLAY "CURRENT DOB: " EMPLOYEE-DOB
           DISPLAY "DELETE DOB? (Y/N): " WITH NO ADVANCING
           ACCEPT WS-DELETE-CONFIRM
           DISPLAY "==================================================="    
           IF WS-DELETE-CONFIRM = 'Y' OR WS-DELETE-CONFIRM = 'y' THEN
               MOVE SPACES TO EMPLOYEE-DOB
           END-IF

           DISPLAY "CURRENT GENDER: " EMPLOYEE-GENDER
           DISPLAY "DELETE GENDER? (Y/N): " WITH NO ADVANCING
           ACCEPT WS-DELETE-CONFIRM
           DISPLAY "==================================================="    
           IF WS-DELETE-CONFIRM = 'Y' OR WS-DELETE-CONFIRM = 'y' THEN
               MOVE SPACES TO EMPLOYEE-GENDER
           END-IF

           DISPLAY "CURRENT MARITAL STATUS: " EMPLOYEE-MARITAL-STATUS
           DISPLAY "DELETE MARITAL STATUS? (Y/N): " WITH NO ADVANCING
           ACCEPT WS-DELETE-CONFIRM
           DISPLAY "==================================================="    
           IF WS-DELETE-CONFIRM = 'Y' OR WS-DELETE-CONFIRM = 'y' THEN
               MOVE SPACES TO EMPLOYEE-MARITAL-STATUS
           END-IF

           DISPLAY "CURRENT NATIONALITY: " EMPLOYEE-NATIONALITY
           DISPLAY "DELETE NATIONALITY? (Y/N): " WITH NO ADVANCING
           ACCEPT WS-DELETE-CONFIRM
           DISPLAY "==================================================="    
           IF WS-DELETE-CONFIRM = 'Y' OR WS-DELETE-CONFIRM = 'y' THEN
               MOVE SPACES TO EMPLOYEE-NATIONALITY
           END-IF

           DISPLAY "CURRENT EMAIL: " EMPLOYEE-EMAIL
           DISPLAY "DELETE EMAIL? (Y/N): " WITH NO ADVANCING
           ACCEPT WS-DELETE-CONFIRM
           DISPLAY "==================================================="    
           IF WS-DELETE-CONFIRM = 'Y' OR WS-DELETE-CONFIRM = 'y' THEN
               MOVE SPACES TO EMPLOYEE-EMAIL
           END-IF
           
           DISPLAY "CURRENT CONTACT: " EMPLOYEE-CONTACT
           DISPLAY "DELETE CONTACT? (Y/N): " WITH NO ADVANCING
           ACCEPT WS-DELETE-CONFIRM
           DISPLAY "==================================================="    
           IF WS-DELETE-CONFIRM = 'Y' OR WS-DELETE-CONFIRM = 'y' THEN
               MOVE SPACES TO EMPLOYEE-CONTACT
           END-IF

           DISPLAY "CURRENT ADDRESS: " EMPLOYEE-ADDRESS
           DISPLAY "DELETE ADDRESS? (Y/N): " WITH NO ADVANCING
           ACCEPT WS-DELETE-CONFIRM
           DISPLAY "==================================================="    
           IF WS-DELETE-CONFIRM = 'Y' OR WS-DELETE-CONFIRM = 'y' THEN
               MOVE SPACES TO EMPLOYEE-ADDRESS
           END-IF
            
           REWRITE USER-RECORD
               INVALID KEY
           PERFORM CLEAR-SCREEN
           DISPLAY "|=================================================|"
           DISPLAY "|||||||||================================||||||||||"     
           DISPLAY "||||||||  ERROR: UNABLE TO UPDATE RECORD! |||||||||"
           DISPLAY "|||||||||================================||||||||||"
           DISPLAY "|=================================================|"
          DISPLAY "[DO YOU WANT TO CONTINUE? (Y/N)]: " WITH NO ADVANCING
           ACCEPT WS-OPEN
              IF WS-OPEN = "Y" OR "y"
                    CLOSE USER-FILE
                    PERFORM EDIT-DELETE
                ELSE
                    CLOSE USER-FILE
                    PERFORM MAIN-PARA
           END-REWRITE
           PERFORM CLEAR-SCREEN
           DISPLAY "|=================================================|"
           DISPLAY "|||||||||================================||||||||||"     
           DISPLAY "||||||||   RECORD UPDATED SUCCESSFULLY!   |||||||||"
           DISPLAY "|||||||||================================||||||||||"
           DISPLAY "|=================================================|"
           DISPLAY "PRESS ENTER TO CONTINUE..." WITH NO ADVANCING
              ACCEPT OMITTED   
                CLOSE USER-FILE
                PERFORM MAIN-PARA       
           END-READ.
           CLOSE USER-FILE.

       RECORD-FILE.
           PERFORM CLEAR-SCREEN
           DISPLAY "|=================================================|"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|||||           VIEW EMPLOYEE RECORD          |||||"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|=================================================|"
           DISPLAY "[ENTER YOUR USERNAME]: " WITH NO ADVANCING
           ACCEPT USER-ID 
           OPEN I-O USER-FILE.
           READ USER-FILE KEY IS USER-ID
               INVALID KEY
           DISPLAY "|=================================================|"
           DISPLAY "|||=============================================|||"
           DISPLAY "      RECORD NOT FOUND FOR USER-ID: " USER-ID
           DISPLAY "|||=============================================|||"
           DISPLAY "|=================================================|"   
          DISPLAY "[DO YOU WANT TO CONTINUE? (Y/N)]: " WITH NO ADVANCING
           ACCEPT WS-OPEN
              IF WS-OPEN = "Y" OR "y"
                    CLOSE USER-FILE
                    PERFORM RECORD-FILE
                ELSE
                    CLOSE USER-FILE
                    PERFORM MAIN-PARA
               NOT INVALID KEY
           DISPLAY "|=================================================|"
           DISPLAY "||||||||||||||||=================||||||||||||||||||"     
           DISPLAY "||||||||||||||    RECORD FOUND:   |||||||||||||||||"
           DISPLAY "||||||||||||||||=================||||||||||||||||||"
           DISPLAY "|=================================================|"
                   DISPLAY "USER-ID: " USER-ID
           DISPLAY "==================================================="    
                   DISPLAY "PASSWORD: " USER-PASSWORD
           DISPLAY "==================================================="    
                   DISPLAY "EMPLOYEE NAME: " EMPLOYEE-NAME
           DISPLAY "==================================================="
                   DISPLAY "EMPLOYEE DOB: " EMPLOYEE-DOB
           DISPLAY "==================================================="    
                   DISPLAY "EMPLOYEE GENDER: " EMPLOYEE-GENDER
           DISPLAY "==================================================="    
                   DISPLAY "EMPLOYEE STATUS: " EMPLOYEE-MARITAL-STATUS
           DISPLAY "==================================================="    
                   DISPLAY "EMPLOYEE NATIONALITY: " EMPLOYEE-NATIONALITY
           DISPLAY "==================================================="    
                   DISPLAY "EMPLOYEE EMAIL: " EMPLOYEE-EMAIL
           DISPLAY "==================================================="    
                   DISPLAY "EMPLOYEE CONTACT: " EMPLOYEE-CONTACT
           DISPLAY "==================================================="    
                   DISPLAY "EMPLOYEE ADDRESS: " EMPLOYEE-ADDRESS
           DISPLAY "==================================================="    
                   DISPLAY "PRESS ENTER TO CONTINUE..." NO ADVANCING
                       ACCEPT OMITTED
           END-READ.
           CLOSE USER-FILE.
       
           PERFORM MAIN-PARA
           STOP RUN.

        PAYSLIP.
           PERFORM CLEAR-SCREEN
           DISPLAY "|=================================================|"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|||||       [4] - GENERATE PAYSLIP            |||||"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|=================================================|"
           DISPLAY "[ENTER PAYSLIP CODE]: " WITH NO ADVANCING
           ACCEPT USERNAME
           OPEN I-O PAYSLIP-FILE 
           READ PAYSLIP-FILE KEY IS USERNAME
           INVALID KEY
           DISPLAY "|=================================================|"
           DISPLAY "|||=============================================|||"
           DISPLAY "       RECORD NOT FOUND FOR CODE: " USERNAME       
           DISPLAY "|||=============================================|||"
           DISPLAY "|=================================================|"
           DISPLAY "[DO YOU WANT TO TRY AGAIN? (Y/N)]: " 
          WITH NO ADVANCING
           ACCEPT WS-OPEN
              IF WS-OPEN = "Y" OR "y"
                    CLOSE PAYSLIP-FILE
                    PERFORM PAYSLIP
              ELSE
                    CLOSE PAYSLIP-FILE
                    PERFORM MAIN-PARA
            NOT INVALID KEY
           DISPLAY " "
           DISPLAY "PAYSLIP PERIOD: " PAYSLIP-PERIOD
           DISPLAY "|=================================================|"
           DISPLAY "EMPLOYEE NAME: " EMP-NAME
           DISPLAY "|=================================================|"
           DISPLAY "BASIC PAY: " BASIC-SALARY
           DISPLAY "|=================================================|"
           DISPLAY "|                    ADD                          |"
           DISPLAY "|=================================================|"
           DISPLAY "OVERTIME PAY: " FD-OVERTIME
           DISPLAY "NIGHT DIFFERENTIAL: " FD-NIGHT-DIFF
           DISPLAY "HOLIDAY PAY: " FD-HOLIDAY
           DISPLAY "|=================================================|"
           DISPLAY "TOTAL PAY: " FD-TOTAL-PAY
           DISPLAY "|=================================================|"
           DISPLAY "|                  DEDUCTIONS                     |"
           DISPLAY "|=================================================|"
           DISPLAY "SSS: " FD-SSS
           DISPLAY "PAGIBIG: " FD-PAGIBIG
           DISPLAY "PHILHEALTH: " FD-PHILHEALTH
           DISPLAY "LATE/S: " FD-LATE
           DISPLAY "ABSENT/S: " FD-ABSENT
           DISPLAY "UNDERTIME/S: " FD-UNDERTIME
           DISPLAY "|=================================================|"
           DISPLAY "TOTAL DEDUCTION: " FD-TOTAL-DEDUCTION
           DISPLAY "|=================================================|"
           DISPLAY "|||=============================================|||"
           DISPLAY "               NET PAY: " FD-NETPAY
           DISPLAY "|||=============================================|||"
           DISPLAY "|=================================================|"
           CLOSE PAYSLIP-FILE 
           DISPLAY "PRESS ANY KEY TO CONTINUE..."
           ACCEPT OMITTED
            PERFORM MAIN-PARA
        STOP RUN.

       CLEAR-SCREEN.
           CALL 'SYSTEM' USING 'clear'.
