       IDENTIFICATION DIVISION.
       PROGRAM-ID. UI.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 LINE-NUMBER    PIC 99 VALUE 1.
       01 BORDER-TOP     PIC X(51) 
           VALUE "===================================================".
       01 BORDER-BOTTOM  PIC X(51) 
           VALUE "===================================================".
       01 SPACE-LINE     PIC X(51) 
           VALUE "||                                                ||".
       01 CENTERED-LINE  PIC X(51).

       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           PERFORM CLEAR-SCREEN
           PERFORM DISPLAY-BORDER
           STOP RUN.

       CLEAR-SCREEN.
           DISPLAY SPACES.

       DISPLAY-BORDER.
           DISPLAY BORDER-TOP.

           PERFORM VARYING LINE-NUMBER FROM 1 BY 1 UNTIL LINE-NUMBER > 2
               DISPLAY SPACE-LINE
           END-PERFORM.

           MOVE "||            +----------------------+             ||" 
           TO CENTERED-LINE
           DISPLAY CENTERED-LINE.
           MOVE "||            |        Login        |             ||" 
           TO CENTERED-LINE
           DISPLAY CENTERED-LINE.
           MOVE "||            |       Register      |             ||"
           TO CENTERED-LINE
           DISPLAY CENTERED-LINE.
           MOVE "||            |         Exit        |             ||" 
           TO CENTERED-LINE
           DISPLAY CENTERED-LINE.
           MOVE "||            +----------------------+             ||"
           TO CENTERED-LINE
           DISPLAY CENTERED-LINE.

           PERFORM VARYING LINE-NUMBER FROM 1 BY 1 UNTIL LINE-NUMBER > 2
               DISPLAY SPACE-LINE
           END-PERFORM.

           DISPLAY BORDER-BOTTOM.

       END PROGRAM UI. 
