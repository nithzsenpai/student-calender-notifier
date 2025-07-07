#!/bin/bash
# Check if whiptail is installed
if ! command -v whiptail &>/dev/null; then
 echo "whiptail is not installed. Install it using: sudo apt install whiptail"
 exit 1
fi
# Prompt the user to enter their name
username=$(whiptail --inputbox "Enter your name:" 8 40 --title "User Input" 3>&1 1>&2 2>&3)
# Check if the user canceled
if [[ $? -ne 0 ]]; then
 echo "Operation canceled."
 exit 1
fi
# Prompt the user to enter their class
class=$(whiptail --inputbox "Enter your class (e.g.3d):" 8 40 --title "Class Input" 3>&1 1>&2 2>&3)
if [[ $? -ne 0 ]]; then
 echo "Operation canceled."
 exit 1
fi
# Look for class.txt file
filename="${class}.txt"
holidays="holidays.txt"
if [[ -f "$filename" ]]; then
 # Prompt the user to enter a date
 date=$(whiptail --inputbox "Enter the date (in format DD-MM):" 8 40 --title "Date Input" 3>&1
1>&2 2>&3)
 6
 if [[ $? -ne 0 ]]; then
 echo "Operation canceled."
 exit 1
 fi
 # Extract the day and month from the date
 day=$(echo "$date" | cut -d'-' -f1 | sed 's/^0//')
 month=$(echo "$date" | cut -d'-' -f2)
 # Validate the date input
 if ! date -d "2025-$month-$day" &>/dev/null; then
 whiptail --msgbox "Invalid date format. Please enter a valid date (DD-MM)." 8 40 --title
"Error"
 exit 1
 fi
#whiptail --msgbox "Calendar for $month 2025:\n\n$cal_output" 20 60 --title "Calendar"
# Generate the calendar for the given month and year
cal_output=$(cal "$month" 2025 | sed "s/\b$day\b/[$day]/")
# Use whiptail to display the calendar
whiptail --msgbox "Calendar for $month 2025:\n\n$cal_output" 20 60 --title "Calendar"
 #whiptail --msgbox "Calendar for $month 2025:\n\n$cal_output" 20 60 --title "Calendar"
 # Greet the user
 whiptail --msgbox "Hi $username!" 8 40 --title "Greeting"
 # Check for weekends
 day_name=$(date -d "2025-$month-$day" +"%A")
 if [[ "$day_name" == "Saturday" || "$day_name" == "Sunday" ]]; then
 whiptail --msgbox "It's a holiday today because it's the weekend!" 8 40 --title "Weekend"
 fi
 # Check for holidays
 if [[ -f "$holidays" ]]; then
 holiday=$(grep "$date" "$holidays" | cut -d' ' -f1)
 if [[ -n "$holiday" ]]; then
 whiptail --msgbox "It's a holiday today because it's $holiday." 8 40 --title "Holiday"
 fi
 fi
 # Check for birthdays
 birthday_matches=$(grep "$date" "$filename" | cut -d' ' -f1)
 if [[ -n "$birthday_matches" ]]; then
 whiptail --msgbox "It's the birthday of:\n\n$birthday_matches" 12 40 --title "Birthdays"
 else
 whiptail --msgbox "There are no birthdays today in $class." 8 40 --title "No Birthdays"
 fi
else
 whiptail --msgbox "The file for $class does not exist. Please check the class name." 8 40 --title
"Error"
fi
