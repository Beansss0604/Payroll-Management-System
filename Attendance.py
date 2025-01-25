import sqlite3
from datetime import datetime

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

def main_menu():
    while True:
        # Display menu options
        print("\nATTENDANCE MENU")
        print("1 - TIME IN")
        print("2 - TIME OUT")
        print("3 - HOLIDAY ATTENDANCE")
        print("4 - LEAVE APPLICATION")
        print("5 - FETCH RECORDS")
        print("6 - EXIT")

        # Accept user's choice
        try:
            choice = int(input("Enter your choice (1-6): "))
        except ValueError:
            print("Invalid input. Please enter a number between 1 and 6.\n")
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
            fetch_mainmenu()
        elif choice == 6:
            print("Exiting the program. Goodbye!")
            break
        else:
            print("Invalid choice. Please select a valid option (1-6).\n")

# Run the program
if __name__ == "__main__":
    main_menu()

# Close the database connection when the program ends
connection.close()
