        IDENTIFICATION DIVISION.
        PROGRAM-ID. Admin.

        ENVIRONMENT DIVISION.
        INPUT-OUTPUT SECTION.
        FILE-CONTROL.
            SELECT USER-FILE ASSIGN TO "Record.txt"
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
            02 USER-ID                  PIC X(30).
            02 USER-PASSWORD            PIC X(30).
            02 EMPLOYEE-NAME            PIC X(30).
            02 EMPLOYEE-DOB             PIC X(15).
            02 EMPLOYEE-GENDER          PIC A(10).
            02 EMPLOYEE-MARITAL-STATUS  PIC A(10).
            02 EMPLOYEE-NATIONALITY     PIC A(10).
            02 EMPLOYEE-EMAIL           PIC X(20).
            02 EMPLOYEE-CONTACT         PIC X(12).
            02 EMPLOYEE-ADDRESS         PIC X(40).
            02 SLIP-CODE                PIC X(30).

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
        01 File-Status PIC XX.
            88 File-OK VALUE "00".
            88 File-End VALUE "10".
        01 CHOICE PIC 9.
        01 WS-CHOICE PIC A.
        01 WS-OVERTIME-HOURS PIC 999.
        01 WS-OVERTIME PIC 9(5).
        01 WS-NIGHT-DIFF-HOURS PIC 999.
        01 WS-NIGHT-DIFF PIC 9(5).
        01 WS-HOLIDAY-HOURS PIC 999.
        01 WS-HOLIDAY PIC 9(5).
        01 WS-TOTAL-PAY PIC 9(5).
        01 WS-LATE PIC 999.
        01 WS-LATERES PIC 9(5).
        01 WS-ABSENT PIC 999.
        01 WS-ABSENTRES PIC 9(5).
        01 WS-UNDERTIME PIC 999.
        01 WS-UNDERTIMERES PIC 9(5).
        01 WS-SSS PIC 999 VALUE 225.
        01 WS-PAGIBIG PIC 999 VALUE 200.
        01 WS-PHILHEALTH PIC 999 VALUE 180.
        01 WS-TOTALDEDUCTION PIC 9(5).
        01 WS-NETPAY PIC 9(5).99.

        PROCEDURE DIVISION.
        MAIN-MENU.
        CALL 'SYSTEM' USING 'clear'
        PERFORM UNTIL CHOICE = 5
           DISPLAY "==================================================="
           DISPLAY "||||||||||||||=======================||||||||||||||" 
           DISPLAY "|||||||||||||       ADMINS MENU       |||||||||||||"
           DISPLAY "||||||||||||||=======================||||||||||||||"
           DISPLAY "|=================================================|"
           DISPLAY "||||||=======================================||||||"     
           DISPLAY "|||||      [1] - VIEW EMPLOYEE RECORDS        |||||"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|=================================================|"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|||||      [2] - VIEW EMPLOYEE ATTENDANCE     |||||"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|=================================================|"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|||||      [3] - PROCESS EMPLOYEE PAYSLIP     |||||"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|||||     [4] - VIEW PAYSLIP FOR EMPLOYEE     |||||"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|=================================================|"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|||||          [5] - BACK TO MENU             |||||"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|=================================================|"
           DISPLAY "[CHOOSE YOUR OPTION]: " WITH NO ADVANCING
            ACCEPT CHOICE
            EVALUATE CHOICE
                WHEN 1
                    PERFORM VIEW-RECORDS
                WHEN 2
                    PERFORM VIEW-ATTENDANCE
                WHEN 3
                    PERFORM PROCESS-PAYSLIP
                WHEN 4
                    PERFORM GENERATESLIP
                WHEN 5
                   PERFORM BACK
                WHEN OTHER
           DISPLAY "|=================================================|"
           DISPLAY "|||||||||||||=========================|||||||||||||"     
           DISPLAY "||||||||||||      INVALID OPTION!      ||||||||||||"
           DISPLAY "|||||||||||||=========================|||||||||||||"
           DISPLAY "|=================================================|"
           DISPLAY 'PRESS ENTER TO CONTINUE...' WITH NO ADVANCING
                  ACCEPT OMITTED
                    PERFORM MAIN-MENU
            END-EVALUATE
            END-PERFORM
            STOP RUN.

        VIEW-RECORDS.
            CALL 'SYSTEM' USING 'clear'
           DISPLAY "|=================================================|"
           DISPLAY "||||||=======================================||||||"     
           DISPLAY "|||||      [1] - VIEW EMPLOYEE RECORDS        |||||"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|=================================================|"
            OPEN I-O USER-FILE
            PERFORM UNTIL File-End
                READ USER-FILE NEXT
                    AT END
                        SET File-End TO TRUE
                    NOT AT END
           DISPLAY "          Username: " USER-ID
           DISPLAY "          Employee Name: " EMPLOYEE-NAME
           DISPLAY "|=================================================|"                    
                END-READ
            END-PERFORM.
            CLOSE USER-FILE
            PERFORM VIEWING-RECORDS
            STOP RUN.

        VIEWING-RECORDS.
           DISPLAY "[ENTER USERNAME YOU WANT TO VIEW]: "
           WITH NO ADVANCING
           ACCEPT USER-ID 
           CALL 'SYSTEM' USING 'clear'
        OPEN I-O USER-FILE
        READ USER-FILE KEY IS USER-ID
            INVALID KEY
           DISPLAY "|=================================================|"
           DISPLAY "|||=============================================|||"
           DISPLAY "      RECORD NOT FOUND FOR USER-ID: " USER-ID
           DISPLAY "|||=============================================|||"
           DISPLAY "|=================================================|"
           DISPLAY "[DO YOU WANT TO VIEW ANOTHER RECORD]? (Y/N):" 
            NO ADVANCING
            ACCEPT WS-CHOICE
            IF WS-CHOICE = "Y" OR WS-CHOICE = "y"
                CLOSE USER-FILE
                PERFORM VIEW-RECORDS
            ELSE
                CLOSE USER-FILE
                PERFORM MAIN-MENU
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
           DISPLAY "PAYSLIP CODE: " SLIP-CODE
           DISPLAY "===================================================" 
        CLOSE USER-FILE

        DISPLAY "[DO YOU WANT TO VIEW ANOTHER RECORD]? (Y/N):" 
        NO ADVANCING
        ACCEPT WS-CHOICE
        IF WS-CHOICE = "Y" OR WS-CHOICE = "y"
            PERFORM VIEW-RECORDS
        ELSE
            PERFORM MAIN-MENU
        STOP RUN.

        VIEW-ATTENDANCE.
        CALL "SYSTEM" USING BY REFERENCE "python3 admin-att.py"
        STOP RUN.

        PROCESS-PAYSLIP.
        CALL 'SYSTEM' USING 'clear'
        PERFORM UNTIL CHOICE = 4
           DISPLAY "|=================================================|"
           DISPLAY "|||||||||||||========================||||||||||||||"     
           DISPLAY "||||||||||||    PROCESSING PAYSLIP    |||||||||||||"
           DISPLAY "|||||||||||||========================||||||||||||||"
           DISPLAY "|=================================================|"
           DISPLAY "||||||=======================================||||||"     
           DISPLAY "|||||       [1] - ADDITION IN SALARY          |||||"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|=================================================|"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|||||       [2] -  DEDUCTION IN SALARY        |||||"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|=================================================|"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|||||       [3] - CREATING PAYSLIP RECORD    |||||"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|||||           [4] - BACK TO MENU            |||||"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|=================================================|"
           DISPLAY "[CHOOSE YOUR OPTION]: " WITH NO ADVANCING
           ACCEPT CHOICE
           EVALUATE CHOICE
            WHEN 1
                PERFORM ADDITION-SALARY
            WHEN 2
                PERFORM DEDUCTION-SALARY
            WHEN 3
                PERFORM PROCESSPAY
            WHEN 4
            CALL "SYSTEM" USING BY REFERENCE "python3 Admin-call.py"
            WHEN OTHER
           DISPLAY "|=================================================|"
           DISPLAY "|||||||||====================================||||||"     
           DISPLAY "||||||||  INVALID CHOICE. PLEASE TRY AGAIN.!  |||||"
           DISPLAY "|||||||||====================================||||||"
           DISPLAY "|=================================================|"
           DISPLAY 'PRESS ENTER TO CONTINUE...' WITH NO ADVANCING
                  ACCEPT OMITTED
            PERFORM PROCESS-PAYSLIP
            END-EVALUATE
            END-PERFORM
            STOP RUN.

        ADDITION-SALARY.
           CALL 'SYSTEM' USING 'clear'
           DISPLAY "|=================================================|"
           DISPLAY "||||||=======================================||||||"     
           DISPLAY "|||||       [1] - ADDITION IN SALARY          |||||"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|=================================================|"
           DISPLAY "ENTER PAYSLIP CODE: " WITH NO ADVANCING
           ACCEPT USERNAME

        OPEN I-O PAYSLIP-FILE
           READ PAYSLIP-FILE KEY IS USERNAME
           INVALID KEY
           DISPLAY "|=================================================|"
           DISPLAY "|||||||||||||=========================|||||||||||||"     
           DISPLAY "||||||||||||   ERROR: NO CODE FOUND!   ||||||||||||"
           DISPLAY "|||||||||||||=========================|||||||||||||"
           DISPLAY "|=================================================|"
           DISPLAY "[DO YOU WANT TO TRY AGAIN]? (Y/N):" 
            NO ADVANCING
            ACCEPT WS-CHOICE
            IF WS-CHOICE = "Y" OR WS-CHOICE = "y"
                CLOSE PAYSLIP-FILE
                PERFORM ADDITION-SALARY
            ELSE
                CLOSE PAYSLIP-FILE
                PERFORM MAIN-MENU
            NOT INVALID KEY

        MOVE 9720 TO BASIC-SALARY
            
           DISPLAY "ENTER OVERTIME PAY HOURS: " 
        WITH NO ADVANCING
        ACCEPT WS-OVERTIME-HOURS
        MULTIPLY WS-OVERTIME-HOURS BY 97.2
        GIVING WS-OVERTIME
        MOVE WS-OVERTIME TO FD-OVERTIME
           DISPLAY "==================================================="
           DISPLAY "ENTER NIGHT DIFFERENTIAL HOURS: " WITH NO ADVANCING
           ACCEPT WS-NIGHT-DIFF-HOURS
           MULTIPLY WS-NIGHT-DIFF-HOURS BY 105.3 GIVING
           WS-NIGHT-DIFF
           MOVE WS-NIGHT-DIFF TO FD-NIGHT-DIFF
           DISPLAY "==================================================="
           DISPLAY "ENTER HOLIDAY HOURS: " WITH NO ADVANCING
           ACCEPT WS-HOLIDAY-HOURS
           MULTIPLY WS-HOLIDAY-HOURS BY 162 GIVING WS-HOLIDAY
           MOVE WS-HOLIDAY TO FD-HOLIDAY

           COMPUTE WS-TOTAL-PAY = WS-OVERTIME + WS-NIGHT-DIFF +
           WS-HOLIDAY + BASIC-SALARY
           MOVE WS-TOTAL-PAY TO FD-TOTAL-PAY
            
            REWRITE PAYSLIP-RECORD
               INVALID KEY
           DISPLAY "|=================================================|"
           DISPLAY "|||||||||||||=========================|||||||||||||"     
           DISPLAY "||||||||||||  ERROR: NO RECORD FOUND!  ||||||||||||"
           DISPLAY "|||||||||||||=========================|||||||||||||"
           DISPLAY "|=================================================|"
           END-REWRITE
           DISPLAY "|=================================================|"
           DISPLAY "|||||||||================================||||||||||"     
           DISPLAY "||||||||      RECORDED SUCCESSFULLY!      |||||||||"
           DISPLAY "|||||||||================================||||||||||"
           DISPLAY "|=================================================|"
           END-READ.
           CLOSE PAYSLIP-FILE.

        DEDUCTION-SALARY.
           CALL 'SYSTEM' USING 'clear'
           DISPLAY "|=================================================|"
           DISPLAY "||||||=======================================||||||"     
           DISPLAY "|||||       [2] -  DEDUCTION IN SALARY        |||||"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|=================================================|"
           DISPLAY "ENTER PAYSLIP CODE: " WITH NO ADVANCING
            ACCEPT USERNAME

           OPEN I-O PAYSLIP-FILE
           READ PAYSLIP-FILE KEY IS USERNAME
           INVALID KEY
           DISPLAY "|=================================================|"
           DISPLAY "|||||||||||||=========================|||||||||||||"     
           DISPLAY "||||||||||||  ERROR: NO RECORD FOUND!  ||||||||||||"
           DISPLAY "|||||||||||||=========================|||||||||||||"
           DISPLAY "|=================================================|"
           DISPLAY "[DO YOU WANT TO TRY AGAIN]? (Y/N):" 
            NO ADVANCING
            ACCEPT WS-CHOICE
            IF WS-CHOICE = "Y" OR WS-CHOICE = "y"
                CLOSE PAYSLIP-FILE
                PERFORM ADDITION-SALARY
            ELSE
                CLOSE PAYSLIP-FILE
                PERFORM MAIN-MENU
               NOT INVALID KEY

           DISPLAY "ENTER LATE(MINUTES): " 
           WITH NO ADVANCING
           ACCEPT WS-LATE
           COMPUTE WS-LATERES = WS-LATE * 2
           MOVE WS-LATERES TO FD-LATE
           DISPLAY "==================================================="

           DISPLAY "ENTER DAYS OF ABSENT: " WITH NO ADVANCING
           ACCEPT WS-ABSENT 
           COMPUTE WS-ABSENTRES = WS-ABSENT * 648
           MOVE WS-ABSENTRES TO FD-ABSENT
           DISPLAY "==================================================="
        
           DISPLAY "ENTER UNDERTIME HOURS: " WITH NO ADVANCING
           ACCEPT WS-UNDERTIME
           COMPUTE WS-UNDERTIMERES = WS-UNDERTIME * 81
           MOVE WS-UNDERTIMERES TO FD-UNDERTIME
           DISPLAY "==================================================="

           MOVE FD-TOTAL-PAY TO WS-TOTAL-PAY
           MOVE WS-SSS TO FD-SSS
        MOVE WS-PAGIBIG TO FD-PAGIBIG
        MOVE WS-PHILHEALTH TO FD-PHILHEALTH

        COMPUTE WS-TOTALDEDUCTION = WS-SSS + WS-PAGIBIG +
        WS-PHILHEALTH + WS-LATERES + WS-ABSENTRES + WS-UNDERTIMERES
        MOVE WS-TOTALDEDUCTION TO FD-TOTAL-DEDUCTION

        COMPUTE WS-NETPAY = WS-TOTAL-PAY - WS-TOTALDEDUCTION
        MOVE WS-NETPAY TO FD-NETPAY
            
            REWRITE PAYSLIP-RECORD
               INVALID KEY
           DISPLAY "|=================================================|"
           DISPLAY "|||||||||||||=========================|||||||||||||"     
           DISPLAY "||||||||||||  ERROR: NO RECORD FOUND!  ||||||||||||"
           DISPLAY "|||||||||||||=========================|||||||||||||"
           DISPLAY "|=================================================|"
           END-REWRITE
           DISPLAY "|=================================================|"
           DISPLAY "|||||||||================================||||||||||"     
           DISPLAY "||||||||      RECORDED SUCCESSFULLY!      |||||||||"
           DISPLAY "|||||||||================================||||||||||"
           DISPLAY "|=================================================|"
           END-READ.
           CLOSE PAYSLIP-FILE.
       
        BACK.
        CALL "SYSTEM" USING BY REFERENCE "python3 Call.py"
        STOP RUN.
        
       PROCESSPAY.
           CALL "SYSTEM" USING 'clear'
       OPEN I-O PAYSLIP-FILE
           DISPLAY "|=================================================|"
           DISPLAY "||||||||||||||||===================||||||||||||||||"     
           DISPLAY "||||||||||  [3] - CREATING PAYSLIP    |||||||||||||"
           DISPLAY "||||||||||||||||===================||||||||||||||||"
           DISPLAY "|=================================================|"
           DISPLAY "[ENTER PAYSLIP CODE]: " WITH NO ADVANCING
           ACCEPT USERNAME

       READ PAYSLIP-FILE KEY IS USERNAME
           INVALID KEY
               PERFORM CREATESLIP

           NOT INVALID KEY
           DISPLAY "|=================================================|"
           DISPLAY "|||||||||||||=========================|||||||||||||"     
           DISPLAY "||||||||||||  PAYSLIP ALREADY EXISTS!  ||||||||||||"
           DISPLAY "|||||||||||||=========================|||||||||||||"
           DISPLAY "|=================================================|"
           DISPLAY "[DO YOU WANT TO CONTINUE? (Y/N)]: "WITH NO ADVANCING
           ACCEPT WS-CHOICE
              IF WS-CHOICE = "Y" OR "y"
                    CLOSE PAYSLIP-FILE
                    PERFORM PROCESSPAY
                ELSE
                    CLOSE PAYSLIP-FILE
                    PERFORM PROCESS-PAYSLIP
         STOP RUN.

       CREATESLIP.
       DISPLAY "==================================================="
           DISPLAY "[ENTER PAYSLIP CODE]: " NO ADVANCING
            ACCEPT USERNAME
       DISPLAY "==================================================="
           DISPLAY "[ENTER PAYSLIP PERIOD]: " NO ADVANCING
            ACCEPT PAYSLIP-PERIOD
       DISPLAY "==================================================="
           DISPLAY "[ENTER EMPLOYEE NAME]: " NO ADVANCING
            ACCEPT EMP-NAME

        WRITE PAYSLIP-RECORD
        INVALID KEY
        CALL "SYSTEM" USING "clear"
        
           DISPLAY "|=================================================|"
           DISPLAY "|||||||||||||=========================|||||||||||||"     
           DISPLAY "|||||||||||| ERROR: RECORD NOT WRITTEN!||||||||||||"
           DISPLAY "|||||||||||||=========================|||||||||||||"
           DISPLAY "|=================================================|"
           DISPLAY "PRESS ANY KEY TO CONTINUE..."
           CLOSE PAYSLIP-FILE
           ACCEPT OMITTED
       NOT INVALID KEY
       CALL "SYSTEM" USING "clear"
           DISPLAY "|=================================================|"
           DISPLAY "|||||||||====================================||||||"     
           DISPLAY "||||||||    PAYSLIP CREATED SUCCESSFULLY!     |||||"
           DISPLAY "|||||||||====================================||||||"
           DISPLAY "|=================================================|"
           DISPLAY "PRESS ANY KEY TO CONTINUE..."
           CLOSE PAYSLIP-FILE
           ACCEPT OMITTED
           PERFORM PROCESS-PAYSLIP
       STOP RUN.


       GENERATESLIP.
           CALL 'SYSTEM' USING 'clear'
           DISPLAY "|=================================================|"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|||||    [4] - VIEW PAYSLIP FOR EMPLOYEE      |||||"
           DISPLAY "||||||=======================================||||||"
           DISPLAY "|=================================================|"
          DISPLAY "[ENTER PAYSLIP CODE YOU WANT TO VIEW]: " 
          WITH NO ADVANCING
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
           ACCEPT WS-CHOICE
              IF WS-CHOICE = "Y" OR "y"
                    CLOSE PAYSLIP-FILE
                    PERFORM GENERATESLIP
              ELSE
                    CLOSE PAYSLIP-FILE
                    PERFORM MAIN-MENU
            NOT INVALID KEY
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

           DISPLAY "[DO YOU WANT TO VIEW ANOTHER RECORD]? (Y/N):" 
        NO ADVANCING
        ACCEPT WS-CHOICE
            IF WS-CHOICE = "Y"
                PERFORM GENERATESLIP
            ELSE
            CALL "SYSTEM" USING BY REFERENCE "python3 Admin-call.py"
        STOP RUN.
