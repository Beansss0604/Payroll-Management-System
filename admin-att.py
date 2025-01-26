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
    username = input("Enter the employee's name to search: ")
    print("===================================================")

    try:
        cursor.execute("SELECT * FROM Leave WHERE Username = ?", (username,))

        rows = cursor.fetchall()

        if rows:
            row_count = 0
            print(f"\nRecords found for username '{username}':")
            print("===================================================")
            print(f"\nUsername |  Type  |  Date")

            for row in rows:
                row_count += 1
                print(f"{row[0]}  , {row[1]} , {row[2]}")

            print(f"\nTotal days: {row_count}")
            print("===================================================")
            print(" ")
        else:
            print(f"No records found for username '{username}'.")
            print("===================================================")

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
    username = input("Enter the employee's name to search: ")
    print("===================================================")

    try:
        cursor.execute("SELECT * FROM Holiday WHERE Username = ?", (username,))

        rows = cursor.fetchall()

        if rows:
            row_count = 0
            print(f"\nRecords found for username '{username}':")
            print("===================================================")
            print(f"\nUsername |  Date   |  Time-in  | Time-out")

            for row in rows:
                row_count += 1
                print(f"{row[0]}  , {row[1]} , {row[2]} , {row[3]}")
                print("===================================================")

            print(f"\nTotal days: {row_count}")
            print("===================================================")
            print(" ")
        else:
            print(f"No records found for username '{username}'.")
            print("===================================================")

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
    username = input("Enter the employee's name to search: ")
    print("===================================================")

    try:
        cursor.execute("SELECT * FROM Attendance WHERE Username = ?", (username,))

        rows = cursor.fetchall()

        if rows:
            row_count = 0
            total_overtime = 0

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
            print(" ")
            print(" ")
        else:
            print(f"No records found for username '{username}'.")
            print("===================================================")

    except sqlite3.Error as e:
        print(f"Error fetching records for '{username}': {e}")
        print("Failed to fetch records.")


def cobol_back():
    subprocess.run(['./Admin'])

def main_menu():
    while True:
        clear_screen()
        # Display menu options
        print("===================================================")
        print("|||||||||||||||=======================|||||||||||||")
        print("||||||||||||||     ATTENDANCE MENU     ||||||||||||")
        print("|||||||||||||||=======================|||||||||||||")
        print("===================================================")
        print("|||||||||||||||||===================|||||||||||||||")
        print("|||||||||||    [1] - FETCH RECORDS      |||||||||||")
        print("|||||||||||||||||===================|||||||||||||||")
        print("===================================================")
        print("|||||||||||==============================||||||||||")
        print("||||||||||    [2] - BACK TO MAIN MENU     |||||||||")
        print("|||||||||||==============================||||||||||")
        print("===================================================")

        # Accept user's choice
        try:
            choice = int(input("[CHOOSE AN OPTION]: "))
        except ValueError:
            print("Invalid input. Please enter a number between 1 and 2.\n")
            continue

        # Evaluate user's choice
        if choice == 1:
            fetch_mainmenu()
        elif choice == 2:
            cobol_back()
        else:
            print("Invalid choice. Please select a valid option (1-2).\n")

# Run the program
if __name__ == "__main__":
    main_menu()

# Close the database connection when the program ends
connection.close()
