        IDENTIFICATION DIVISION.
        PROGRAM-ID. Admin.

        ENVIRONMENT DIVISION.
        INPUT-OUTPUT SECTION.
        FILE-CONTROL.
            SELECT USER-FILE ASSIGN TO "Record.txt"
                ORGANIZATION IS INDEXED
                ACCESS MODE IS RANDOM
                RECORD KEY IS USER-ID.

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

        WORKING-STORAGE SECTION.
        01 File-Status PIC XX.
            88 File-OK VALUE "00".
            88 File-End VALUE "46".
        01 Start-Key PIC X(30) VALUE SPACES.
        01 CHOICE PIC 9.
        01 CALLED PIC X(100) VALUE "python3 admin-att.py".
        01 WS-CHOICE PIC A(1).

        PROCEDURE DIVISION.
        MAIN-MENU.
            DISPLAY "MAIN-MENU"
            DISPLAY "1. VIEW EMPLOYEE RECORDS"
            DISPLAY "2. VIEW EMPLOYEE ATTENDANCE"
            DISPLAY "3. PROCESS EMPLOYEE PAYSLIP"
            DISPLAY "4. BACK TO LOGIN"
            DISPLAY "ENTER YOUR CHOICE: " WITH NO ADVANCING
            ACCEPT CHOICE
            EVALUATE CHOICE
                WHEN 1
                    PERFORM VIEW-RECORDS
                WHEN 2
                    PERFORM VIEW-ATTENDANCE
                WHEN 3
                    PERFORM PROCESS-PAYSLIP
                WHEN 4
                    PERFORM LOGIN
                WHEN OTHER
                    DISPLAY "INVALID CHOICE"
                    PERFORM MAIN-MENU
            END-EVALUATE
            STOP RUN.

        VIEW-RECORDS.
            OPEN I-O USER-FILE
            PERFORM UNTIL File-End
                READ USER-FILE NEXT
                    AT END
                        SET File-End TO TRUE
                    NOT AT END
                        DISPLAY "Username: " USER-ID
                        DISPLAY "Employee Name: " EMPLOYEE-NAME
                        DISPLAY " "
                END-READ
            END-PERFORM.
            CLOSE USER-FILE
            DISPLAY "ALL RECORDS DISPLAYED."
            PERFORM VIEWING-RECORDS
            STOP RUN.

        VIEWING-RECORDS.
        DISPLAY "ENTER USERNAME YOU WANT TO VIEW: " WITH NO ADVANCING
        ACCEPT USER-ID 

        OPEN I-O USER-FILE
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
        CLOSE USER-FILE

        DISPLAY "DO YOU WANT TO VIEW ANOTHER RECORD? (Y/N)" NO ADVANCING
        ACCEPT WS-CHOICE
        IF WS-CHOICE = "Y" OR WS-CHOICE = "y"
            PERFORM VIEWING-RECORDS
        ELSE
            PERFORM MAIN-MENU
        STOP RUN.

        VIEW-ATTENDANCE.
        CALL "SYSTEM" USING BY REFERENCE CALLED
        STOP RUN.

        PROCESS-PAYSLIP.

            STOP RUN.

        LOGIN.

            STOP RUN.
