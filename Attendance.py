import sqlite3
from datetime import datetime
import subprocess
import os

connection = sqlite3.connect("Attendance.db")
cursor = connection.cursor()

timestamp = datetime.now().strftime("%Y-%m-%d")
time = datetime.now().strftime("%H:%M:%S")

def clear_screen():
    """Clears the terminal screen."""
    os.system('cls' if os.name == 'nt' else 'clear')

def is_valid_date(date_string):
    """Validates the format of a date string (YYYY/MM/DD)."""
    try:
        datetime.strptime(date_string, "%Y/%m/%d")
        return True
    except ValueError:
        return False

def fetch_mainmenu():
    while True:
        clear_screen()

        print("===================================================")
        print("|||||||||||||=========================|||||||||||||")
        print("||||||||||||||      FETCH RECORDS    ||||||||||||||")
        print("|||||||||||||=========================|||||||||||||")
        print("===================================================")
        print("|||||||||||=============================|||||||||||")
        print("||||||||||  [1] - REGULAR ATTENDANCE     ||||||||||")
        print("|||||||||||=============================|||||||||||")
        print("===================================================")
        print("|||||||||||=============================|||||||||||")
        print("||||||||||  [2] - HOLIDAY ATTENDANCE     ||||||||||")
        print("|||||||||||=============================|||||||||||")
        print("===================================================")
        print("|||||||||||==============================||||||||||")
        print("||||||||||    [3] - LEAVE RECORD          |||||||||")
        print("|||||||||||==============================||||||||||")
        print("===================================================")
        print("|||||||||||==============================||||||||||")
        print("||||||||||    [4] - BACK TO MAIN MENU     |||||||||")
        print("|||||||||||==============================||||||||||")
        print("===================================================")

        try:
            choice = int(input("[CHOOSE AN OPTION]: "))
        except ValueError:
            print("Invalid input. Please enter a number between 1 and 4.\n")
            input("Press Enter to continue...")
            continue

      
        if choice == 1:
            fetch_reg()
            input("Press Enter to return to the record menu...")
        elif choice == 2:
            fetch_holi()
            input("Press Enter to return to the record menu...")
        elif choice == 3:
            fetch_leave()
            input("Press Enter to return to the record menu...")
        elif choice == 4:
            print("Returning to the main menu.\n")
            break
        else:
            print("Invalid choice. Please select a valid option (1-4).\n")
            input("Press Enter to continue...")

def fetch_leave():
    clear_screen()

    print("===================================================")
    print("|||||||||||==============================||||||||||")
    print("||||||||||       [3] - LEAVE RECORD       |||||||||")
    print("|||||||||||==============================||||||||||")
    print("===================================================")
    username = input("Enter the username to search: ")
    print("===================================================")

    try:
        cursor.execute("SELECT * FROM Leave WHERE Username = ?", (username,))

        rows = cursor.fetchall()

        row_count = 0

        if rows:
            print(f"\nRecords found for username '{username}':")
            print("===================================================")
            print(f"\nUsername |  Type  |  Date")

            for row in rows:
                row_count += 1

                print(f"{row[0]}  , {row[1]} , {row[2]}")

            print(f"\nTotal days: {row_count}")
            print("===================================================")
            print (" ")

    except sqlite3.Error as e:
        print(f"Error fetching records for '{username}': {e}")
        print("Failed to fetch records.")


def fetch_holi():
    clear_screen()

    print("===================================================")
    print("|||||||||||==============================||||||||||")
    print("||||||||||   [2] - HOLIDAY ATTENDANCE     |||||||||")
    print("|||||||||||==============================||||||||||")
    print("===================================================")
    username = input("Enter the username to search: ")
    print("===================================================")

    try:
        cursor.execute("SELECT * FROM Holiday WHERE Username = ?", (username,))

        rows = cursor.fetchall()

        row_count = 0
        if rows:
            print(f"\nRecords found for username '{username}':")
            print("===================================================")
            print(f"\nUsername |  Date   |  Time-in  | Time-out")

            for row in rows:
                row_count += 1

                print(f"{row[0]}  , {row[1]} , {row[2]} , {row[3]}")
                print("===================================================")

            print(f"\nTotal days: {row_count}")
            print("===================================================")
            print (" ")

    except sqlite3.Error as e:
        print(f"Error fetching records for '{username}': {e}")
        print("Failed to fetch records.")

def fetch_reg():
    clear_screen()

    print("===================================================")
    print("|||||||||||==============================||||||||||")
    print("||||||||||    [1] - REGULAR ATTENDANCE    |||||||||")
    print("|||||||||||==============================||||||||||")
    print("===================================================")
    username = input("Enter the username to search: ")
    print("===================================================")

    try:
        cursor.execute("SELECT * FROM Attendance WHERE Username = ?", (username,))

        rows = cursor.fetchall()

        row_count = 0
        total_overtime = 0

        if rows:
            print(f"\nRecords found for username '{username}':")
            print("===================================================")
            print(f"\nUsername |  Date   |  Time-in  | Time-out | Overtime")

            for row in rows:
                row_count += 1

                overtime_value = row[4] if row[4] is not None else 0  
                if isinstance(overtime_value, (int, float)): 
                    total_overtime += overtime_value
                else:
                    print(f"Invalid overtime value found for record {row[0]}: {overtime_value}")

                print(f"{row[0]}  , {row[1]} , {row[2]} , {row[3]} , {overtime_value}")
            print("===================================================")
            print(f"\nTotal days: {row_count}")
            print("===================================================")
            print(f"Total Overtime: {total_overtime}")
            print (" ")
            print (" ")

    except sqlite3.Error as e:
        print(f"Error fetching records for '{username}': {e}")
        print("Failed to fetch records.")

def time_in():
    clear_screen()

    print("===================================================")
    print("|||||||||||==============================||||||||||")
    print("||||||||||         [1] - TIME IN          |||||||||")
    print("|||||||||||==============================||||||||||")
    print("===================================================")
    username = input("Enter Username: ")
    print (" ")
    
    try:
        cursor.execute('''
            INSERT INTO Attendance (Username, Date, "Time-in")
            VALUES (?, ?, ?)
        ''', (username, timestamp, time))
        connection.commit()  #
        print ("|=================================================|")
        print ("|||||||||====================================||||||")    
        print ("||||||||     TIME IN RECORDED SUCCESSFULLY!   |||||")
        print ("|||||||||====================================||||||")
        print ("|=================================================|")
    except sqlite3.Error as e:
        print ("|=================================================|")
        print ("|||||||||====================================||||||")    
        print ("||||||||        FAILED TO RECORD TIME IN!     |||||")
        print ("|||||||||====================================||||||")
        print ("|=================================================|")

def time_out():
    clear_screen()

    print("===================================================")
    print("|||||||||||==============================||||||||||")
    print("||||||||||        [2] - TIME OUT          |||||||||")
    print("|||||||||||==============================||||||||||")
    print("===================================================")
    username = input("Enter Username: ")
    print (" ")
    
    try:
        cursor.execute('''
            INSERT INTO Attendance (Username, Date, "Time-out")
            VALUES (?, ?, ?)
            ON CONFLICT(Username, Date) 
            DO UPDATE SET "Time-out" = excluded."Time-out"
        ''', (username, timestamp, time))
        
        connection.commit()
        print ("|=================================================|")
        print ("|||||||||====================================||||||")    
        print ("||||||||    TIME OUT RECORDED SUCCESSFULLY!   |||||")
        print ("|||||||||====================================||||||")
        print ("|=================================================|")
    except sqlite3.Error as e:
        print ("|=================================================|")
        print ("|||||||||====================================||||||")    
        print ("||||||||       FAILED TO RECORD TIME OUT!     |||||")
        print ("|||||||||====================================||||||")
        print ("|=================================================|")


def holi_timein():
    clear_screen()

    print("===================================================")
    print("|||||||||||==============================||||||||||")
    print("||||||||||         [1] - TIME IN          |||||||||")
    print("|||||||||||==============================||||||||||")
    print("===================================================")
    username = input("Enter the username to search: ")
    print("===================================================")
    try:
        cursor.execute('''
            INSERT INTO Holiday (Username, Date, "Time-in")
            VALUES (?, ?, ?)
        ''', (username, timestamp, time))
        connection.commit()  #
        print ("|=================================================|")
        print ("|||||||||====================================||||||")    
        print ("||||||||     TIME IN RECORDED SUCCESSFULLY!   |||||")
        print ("|||||||||====================================||||||")
        print ("|=================================================|")
    except sqlite3.Error as e:
        print ("|=================================================|")
        print ("|||||||||====================================||||||")    
        print ("||||||||        FAILED TO RECORD TIMEIN!      |||||")
        print ("|||||||||====================================||||||")
        print ("|=================================================|")
        input("Press Enter to return to the main menu...")

def holi_timeout():
    clear_screen()

    print("===================================================")
    print("|||||||||||==============================||||||||||")
    print("||||||||||        [2] - TIME OUT          |||||||||")
    print("|||||||||||==============================||||||||||")
    print("===================================================")
    username = input("Enter the username to search: ")
    print("===================================================")
    
    try:
        cursor.execute('''
            INSERT INTO Holiday (Username, Date, "Time-out")
            VALUES (?, ?, ?)
            ON CONFLICT(Username, Date) 
            DO UPDATE SET "Time-out" = excluded."Time-out"
        ''', (username, timestamp, time))
        
        connection.commit()
        print ("|=================================================|")
        print ("|||||||||====================================||||||")    
        print ("||||||||    TIME OUT RECORDED SUCCESSFULLY!   |||||")
        print ("|||||||||====================================||||||")
        print ("|=================================================|")
    except sqlite3.Error as e:
        print ("|=================================================|")
        print ("|||||||||====================================||||||")    
        print ("||||||||       FAILED TO RECORD TIMEOUT!      |||||")
        print ("|||||||||====================================||||||")
        print ("|=================================================|")
        input("Press Enter to return to the main menu...")

def holiday_mainmenu():
    while True:
        clear_screen()

        print("===================================================")
        print("|||||||||||||=========================|||||||||||||")
        print("||||||||||||    HOLIDAY ATTENDANCE     ||||||||||||")
        print("|||||||||||||=========================|||||||||||||")
        print("===================================================")
        print("|||||||||||=============================|||||||||||")
        print("||||||||||         [1] - TIME IN         ||||||||||")
        print("|||||||||||=============================|||||||||||")
        print("===================================================")
        print("|||||||||||=============================|||||||||||")
        print("||||||||||         [2] - TIME OUT        ||||||||||")
        print("|||||||||||=============================|||||||||||")
        print("===================================================")
        print("|||||||||||==============================||||||||||")
        print("||||||||||    [3] - BACK TO MAIN MENU     |||||||||")
        print("|||||||||||==============================||||||||||")
        print("===================================================")


        try:
            choice = int(input("[CHOOSE AN OPTION]: "))
        except ValueError:
            print("Invalid input. Please enter a number between 1 and 3.\n")
            input("Press Enter to continue...")
            continue

       

        if choice == 1:
            holi_timein()
            input("Press Enter to return to the main menu...")
        elif choice == 2:
            holi_timeout()  
            input("Press Enter to return to the main menu...")
        elif choice == 3:
            print("Returning to the main menu.\n")
            break
        else:
            print("Invalid choice. Please select a valid option (1-3).\n")
            input("Press Enter to continue...")

def leave_application():
    clear_screen()

    print("===================================================")
    print("|||||||||||==============================||||||||||")
    print("||||||||||    [4] - LEAVE APPLICATION     |||||||||")
    print("|||||||||||==============================||||||||||")
    print("===================================================")
    username = input("[Enter Username]: ")
    print("===================================================")
    print ("Choose types of leave: Maternity, Paternity, Sick ")
    print (   "Bereavement, Vacation, Unpaid, Personal, Others")
    print("===================================================")
    leave = input("[Type of leave]: ").strip()
    print("===================================================")
    date = input("[Enter Date(YYYY/MM/DD)]: ").strip()  

    if not is_valid_date(date):
        print("Invalid date format. Please use YYYY/MM/DD.")
        input("Press Enter to return to the menu...")
        return

    try:
        cursor.execute('''
            INSERT INTO Leave (Username, Type, Date)
            VALUES (?, ?, ?)
        ''', (username, leave, date))
        connection.commit() 
        print ("|=================================================|")
        print ("|||||||||====================================||||||")    
        print ("||||||||     LEAVE SUCCESSFULLY PROCESSED!    |||||")
        print ("|||||||||====================================||||||")
        print ("|=================================================|")

    except sqlite3.Error as e:
     print ("|=================================================|")
     print ("|||||||||====================================||||||")    
     print ("||||||||      LEAVE APPLICATION FAILED!       |||||")
     print ("|||||||||====================================||||||")
     print ("|=================================================|")

def cobol_back():
    subprocess.run(['./Subprog'])

def main_menu():
    while True:
        clear_screen()
        # Display menu options

        print("===================================================")
        print("|||||||||||||||=======================|||||||||||||")
        print("||||||||||||||     ATTENDANCE LOG      ||||||||||||")
        print("|||||||||||||||=======================|||||||||||||")
        print("===================================================")
        print("|||||||||||||||||===================|||||||||||||||")
        print("||||||||||||||||   [1] - TIME IN     ||||||||||||||")
        print("|||||||||||||||||===================|||||||||||||||")
        print("===================================================")
        print("|||||||||||||||||===================|||||||||||||||")
        print("||||||||||||||||   [2] - TIME OUT    ||||||||||||||")
        print("|||||||||||||||||===================|||||||||||||||")
        print("===================================================")
        print("|||||||||||==============================||||||||||")
        print("||||||||||    [3] - HOLIDAY ATTENDANCE    |||||||||")
        print("|||||||||||==============================||||||||||")
        print("===================================================")
        print("|||||||||||==============================||||||||||")
        print("||||||||||    [4] - LEAVE APPLICATION     |||||||||")
        print("|||||||||||==============================||||||||||")
        print("===================================================")
        print("|||||||||||==============================||||||||||")
        print("||||||||||    [5] - FETCH RECORDS         |||||||||")
        print("|||||||||||==============================||||||||||")
        print("===================================================")
        print("|||||||||||==============================||||||||||")
        print("||||||||||    [6] - BACK TO MAIN MENU     |||||||||")
        print("|||||||||||==============================||||||||||")
        print("===================================================")
        # Accept user's choice
        try:
            choice = int(input("[CHOOSE AN OPTION]: "))
        except ValueError:
            print("Invalid input. Please enter a number between 1 and 6.\n")
            input("Press Enter to continue...")
            continue

        
        
        # Evaluate user's choice
        if choice == 1:
            time_in()
            input("Press Enter to return to the main menu...")
        elif choice == 2:
            time_out()
            input("Press Enter to return to the main menu...")
        elif choice == 3:
            holiday_mainmenu()  # This will now call the holiday menu
            input("Press Enter to return to the main menu...")
        elif choice == 4:
            leave_application()
            input("Press Enter to return to the main menu...")
        elif choice == 5:
            fetch_mainmenu()
            input("Press Enter to return to the main menu...")
        elif choice == 6:
            cobol_back()
        else:
            print("Invalid choice. Please select a valid option (1-6).\n")

# Run the program
if __name__ == "__main__":
    main_menu()

# Close the database connection when the program ends
connection.close()
