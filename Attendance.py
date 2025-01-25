import sqlite3
from datetime import datetime

# Connect to the SQLite database
connection = sqlite3.connect("Attendance.db")
cursor = connection.cursor()

# Get the current timestamp and time
timestamp = datetime.now().strftime("%Y-%m-%d")
time = datetime.now().strftime("%H:%M:%S")

def fetch():
    # Prompt the user to input the username
    username = input("Enter the username to search: ")
    
    try:
        # Query to select all rows where 'Username' matches the input
        cursor.execute("SELECT * FROM Attendance WHERE Username = ?", (username,))
        
        # Fetch all the results
        rows = cursor.fetchall()
        
        # Initialize variables for counting rows and summing overtime
        row_count = 0
        total_overtime = 0
        
        # Print the rows
        if rows:
            print(f"\nRecords found for username '{username}':")
            print(f"\nUsername  |   Date    |  Time-in  | Time-out | Overtime")
            
            for row in rows:
                # Increment row count
                row_count += 1
                
                # Add the overtime value (assuming it's in the 5th column, adjust the index if needed)
                overtime_value = row[4]  # Adjust the index depending on your table structure
                total_overtime += overtime_value
                
                # Print the row details
                print(f"{row[0]}  | {row[1]} | {row[2]} | {row[3]} | {overtime_value}")
            
            # Print the summary
            print(f"\nTotal rows fetched: {row_count}")
            print(f"Total Overtime: {total_overtime}")    
    except sqlite3.Error as e:
        print(f"No records found for the username '{username}'.")



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


def holiday_attendance():
    print("You have selected Holiday Attendance.")
    # Add your logic for holiday attendance here
    print("Holiday Attendance recorded successfully.\n")

def leave_application():
    print("You have selected Leave Application.")
    # Add your logic for leave application here
    print("Leave Application processed successfully.\n")

def main_menu():
    while True:
        # Display menu options
        print("ATTENDANCE")
        print("1 - TIME IN")
        print("2 - TIME OUT")
        print("3 - HOLIDAY ATTENDANCE")
        print("4 - LEAVE APPLICATION")
        print("5 - BACK")

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
            holiday_attendance()
        elif choice == 4:
            leave_application()
        elif choice == 6:
            fetch()
        elif choice == 5:
            print("Returning to the main menu. Goodbye!")
            break
        else:
            print("Invalid choice. Please select a valid option (1-5).\n")

# Run the program
if __name__ == "__main__":
    main_menu()

# Close the database connection when the program ends
connection.close()
