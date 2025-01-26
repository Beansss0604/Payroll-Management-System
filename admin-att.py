import sqlite3
from datetime import datetime
import subprocess

connection = sqlite3.connect("Attendance.db")
cursor = connection.cursor()

timestamp = datetime.now().strftime("%Y-%m-%d")
time = datetime.now().strftime("%H:%M:%S")

def fetch_mainmenu():
    while True:
        print("\nRECORD MAIN MENU")
        print("1 - REGULAR ATTENDANCE RECORD")
        print("2 - HOLIDAY ATTENDANCE RECORD")
        print("3 - LEAVE RECORD")
        print("4 - BACK TO MAIN MENU")

        try:
            choice = int(input("Enter your choice (1-4): "))
        except ValueError:
            print("Invalid input. Please enter a number between 1 and 4.\n")
            continue

        if choice == 1:
            fetch_reg()
        elif choice == 2:
            fetch_holi()  
        elif choice == 3:
            fetch_leave()
        elif choice == 4:
            print("Returning to the main menu.\n")
            break
        else:
            print("Invalid choice. Please select a valid option (1-4).\n")

def fetch_leave():
    username = input("Enter the username to search: ")

    try:
        cursor.execute("SELECT * FROM Leave WHERE Username = ?", (username,))

        rows = cursor.fetchall()

        row_count = 0

        if rows:
            print(f"\nRecords found for username '{username}':")
            print(f"\nUsername |  Type  |  Date")

            for row in rows:
                row_count += 1

                print(f"{row[0]}  , {row[1]} , {row[2]}")

            print(f"\nTotal rows fetched: {row_count}")

    except sqlite3.Error as e:
        print(f"Error fetching records for '{username}': {e}")
        print("Failed to fetch records.")


def fetch_holi():
    username = input("Enter the username to search: ")

    try:
        cursor.execute("SELECT * FROM Holiday WHERE Username = ?", (username,))

        rows = cursor.fetchall()

        row_count = 0
        if rows:
            print(f"\nRecords found for username '{username}':")
            print(f"\nUsername |  Date   |  Time-in  | Time-out")

            for row in rows:
                row_count += 1

                print(f"{row[0]}  , {row[1]} , {row[2]} , {row[3]}")

            print(f"\nTotal rows fetched: {row_count}")

    except sqlite3.Error as e:
        print(f"Error fetching records for '{username}': {e}")
        print("Failed to fetch records.")

def fetch_reg():
    username = input("Enter the username to search: ")

    try:
        cursor.execute("SELECT * FROM Attendance WHERE Username = ?", (username,))

        rows = cursor.fetchall()

        row_count = 0
        total_overtime = 0

        if rows:
            print(f"\nRecords found for username '{username}':")
            print(f"\nUsername |  Date   |  Time-in  | Time-out | Overtime")

            for row in rows:
                row_count += 1

                overtime_value = row[4] if row[4] is not None else 0  
                if isinstance(overtime_value, (int, float)): 
                    total_overtime += overtime_value
                else:
                    print(f"Invalid overtime value found for record {row[0]}: {overtime_value}")

                print(f"{row[0]}  , {row[1]} , {row[2]} , {row[3]} , {overtime_value}")

            print(f"\nTotal rows fetched: {row_count}")
            print(f"Total Overtime: {total_overtime}")

    except sqlite3.Error as e:
        print(f"Error fetching records for '{username}': {e}")
        print("Failed to fetch records.")

def cobol_back():
    subprocess.run(['./Admin'])

def main_menu():
    while True:
        # Display menu options
        print("\nATTENDANCE MENU")
        print("1 - FETCH RECORDS")
        print("2 - RETURN TO MAIN MANU")

        # Accept user's choice
        try:
            choice = int(input("Enter your choice (1-2): "))
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
