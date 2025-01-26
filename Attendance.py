import sqlite3
from datetime import datetime
import subprocess
import os

connection = sqlite3.connect("Attendance.db")
cursor = connection.cursor()

timestamp = datetime.now().strftime("%Y-%m-%d")
time = datetime.now().strftime("%H:%M:%S")

def time_in():
    print("You have selected Time-In.")
    username = input("Enter Username: ")
    
    try:
        cursor.execute('''
            INSERT INTO Attendance (Username, Date, "Time-in")
            VALUES (?, ?, ?)
        ''', (username, timestamp, time))
        connection.commit()  #
        print("Time-In recorded successfully.\n")
    except sqlite3.Error as e:
        print("Failed to record Time-In.\n")

def time_out():
    print("You have selected Time-Out.")
    username = input("Enter Username: ")
    
    try:
        cursor.execute('''
            INSERT INTO Attendance (Username, Date, "Time-out")
            VALUES (?, ?, ?)
            ON CONFLICT(Username, Date) 
            DO UPDATE SET "Time-out" = excluded."Time-out"
        ''', (username, timestamp, time))
        
        connection.commit()
        print("Time-Out recorded successfully.\n")
    except sqlite3.Error as e:
        print("Failed to record Time-Out.\n")


def holi_timein():
    print("You have selected Holiday Attendance.")
    username = input("Enter Username: ")
    try:
        cursor.execute('''
            INSERT INTO Holiday (Username, Date, "Time-in")
            VALUES (?, ?, ?)
        ''', (username, timestamp, time))
        connection.commit()  #
        print("Time-In recorded successfully.\n")
    except sqlite3.Error as e:
        print("Failed to record Time-In.\n")

def holi_timeout():
    print("You have selected Time-Out.")
    username = input("Enter Username: ")
    
    try:
        cursor.execute('''
            INSERT INTO Holiday (Username, Date, "Time-out")
            VALUES (?, ?, ?)
            ON CONFLICT(Username, Date) 
            DO UPDATE SET "Time-out" = excluded."Time-out"
        ''', (username, timestamp, time))
        
        connection.commit()
        print("Time-Out recorded successfully.\n")
    except sqlite3.Error as e:
        print("Failed to record Time-Out.\n")

def holiday_mainmenu():
    while True:
        print("\nHOLIDAY MENU")
        print("1 - TIME IN")
        print("2 - TIME OUT")
        print("3 - BACK TO MAIN MENU")

        try:
            choice = int(input("Enter your choice (1-3): "))
        except ValueError:
            print("Invalid input. Please enter a number between 1 and 3.\n")
            continue

        if choice == 1:
            holi_timein()
        elif choice == 2:
            holi_timeout()  
        elif choice == 3:
            print("Returning to the main menu.\n")
            break
        else:
            print("Invalid choice. Please select a valid option (1-3).\n")

def leave_application():
    print("You have selected Leave Application.")
    username = input("Enter Username: ")
    leave = input("Type of leave: ")
    date = input("Enter Date(YYYY/MM/DD): ")    

    try:
        cursor.execute('''
            INSERT INTO Leave (Username, Type, Date)
            VALUES (?, ?, ?)
        ''', (username, leave, date))
        connection.commit() 
        print("Leave Application processed successfully.\n")
    except sqlite3.Error as e:
     print("Leave Application process failed.\n")

def cobol_back():
    subprocess.run(['./Subprog'])

def main_menu():
    os.system('clear')
    while True:
        # Display menu options
        print("\nATTENDANCE MENU")
        print("1 - TIME IN")
        print("2 - TIME OUT")
        print("3 - HOLIDAY ATTENDANCE")
        print("4 - LEAVE APPLICATION")
        print("5 - RETURN TO MAIN MANU")

        # Accept user's choice
        try:
            choice = int(input("Enter your choice (1-5): "))
        except ValueError:
            print("Invalid input. Please enter a number between 1 and 5.\n")
            continue

        # Evaluate user's choice
        if choice == 1:
            time_in()
        elif choice == 2:
            time_out()
        elif choice == 3:
            holiday_mainmenu()  # This will now call the holiday menu
        elif choice == 4:
            leave_application()
        elif choice == 5:
            cobol_back()
            break
        else:
            print("Invalid choice. Please select a valid option (1-5).\n")

# Run the program
if __name__ == "__main__":
    main_menu()

# Close the database connection when the program ends
connection.close()
