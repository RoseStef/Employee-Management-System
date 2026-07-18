#!/bin/bash

# ====================================================================================
# IT Employee Management System
# Author: Stefan Rose
# Description:
# A Bash-based employee management tool that simulates IT onboarding
# and offboarding within a Linux environment.
# ====================================================================================

#############################################
# Global Variables
#############################################

TITLE="IT Employee Management System"

EMPLOYEE_DIR="employees"
LOG_DIR="logs"
DEPARTMENT_DIR="departments"
AUDIT_LOG="$LOG_DIR/audit.log"

#############################################
# Initial Setup
#############################################

mkdir -p "$EMPLOYEE_DIR"
mkdir -p "$LOG_DIR"
mkdir -p "$DEPARTMENT_DIR"

touch "$AUDIT_LOG"

#############################################
# Logging Function
#############################################

log_action() {

    echo "$(date '+%d/%m/%Y %H:%M:%S') - $1" >> "$AUDIT_LOG"

}

#############################################
# Employee ID Generator
#############################################

get_next_employee_id() {

    highest=0

    for file in "$EMPLOYEE_DIR"/EMP*.txt
    do

        [ -e "$file" ] || continue

        number=$(basename "$file" .txt | sed 's/EMP//')

        if ((10#$number > highest)); then
            highest=$((10#$number))
        fi

    done

    printf "EMP%04d" $((highest + 1))

}

#############################################
# Add Employee(s)
#############################################

add_employee() {

    while true
    do

        clear

        echo "================================="
        echo " Add Employee(s)"
        echo "================================="
        echo

        read -p "How many employees would you like to create? (1-50 or B to return): " employee_count

        if [[ "$employee_count" =~ ^[Bb]$ ]]; then
            return
        fi

        if ! [[ "$employee_count" =~ ^[0-9]+$ ]]; then
            echo
            echo "Please enter a valid number."
            read -p "Press Enter to continue..."
            continue
        fi

        if (( employee_count < 1 || employee_count > 50 ))
        then
            echo
            echo "Please enter a value between 1 and 50."
            read -p "Press Enter to continue..."
            continue
        fi

        break

    done

    for ((i=1;i<=employee_count;i++))
    do

        clear

        echo "================================="
        echo " Employee $i of $employee_count"
        echo "================================="
        echo

        employee_id=$(get_next_employee_id)

        read -p "Employee Name: " employee_name
        read -p "Department: " employee_department
        read -p "Role: " employee_role

        department_folder="$DEPARTMENT_DIR/$employee_department"
        mkdir -p "$department_folder"
        chmod 750 "$department_folder"

        employee_file="$EMPLOYEE_DIR/$employee_id.txt"

        cat > "$employee_file" <<EOF
=================================
Employee Record
=================================

Employee ID : $employee_id
Name        : $employee_name
Department  : $employee_department
Role        : $employee_role
Status      : Active
Created     : $(date '+%d/%m/%Y %H:%M:%S')

EOF

        chmod 640 "$employee_file"

        ln -sfn "../../$employee_file" "$department_folder/$employee_id.txt" 2>/dev/null || cp "$employee_file" "$department_folder/$employee_id.txt"

        log_action "Created $employee_id ($employee_name)"

        echo
        echo "$employee_id created successfully."

    done

    echo
    echo "$employee_count employee(s) successfully created."

    read -p "Press Enter to return to the menu..."

}

#############################################
# Main Menu
#############################################

show_menu() {

    while true
    do

        clear

        echo "================================="
        echo " $TITLE"
        echo "================================="
        echo
        echo "1. Add Employee(s)"
        echo "2. Disable An Employee From The System"
        echo "3. Remove Employee(s)"
        echo "4. Search Employee"
        echo "5. List Employee"
        echo "6. List Employee Permissions"
        echo "7. Change Employee Permissions"
        echo "8. Change Employee Department"
        echo "9. List Group Permissions"
        echo "10. Change Group Permissions"
        echo "11. Statistics"
        echo "12. Exit"
        echo

        read -p "Select an option: " choice

        case "$choice" in

            1)
                add_employee
                ;;

            2)
                disable_employee
                ;;

            3)
                remove_employee
                ;;

            4)
                search_employee
                ;;

            5)
                list_employees
                ;;

            6)
                list_permissions
                ;;

            7)
                change_permissions
                ;;

            8)
                change_department
                ;;

            9)
                list_group_permissions
                ;;

            10)
                change_group_permissions
                ;;

            11)
                statistics
                ;;

            12)
                clear
                echo "================================="
                echo " Thank You"
                echo "================================="
                echo
                echo "Exiting Employee Management System..."
                echo
                exit 0
                ;;

            *)
                echo
                echo "Invalid option."
                read -p "Press Enter to continue..."
                ;;

        esac

    done

}

disable_employee() {

    clear

    echo "================================="
    echo " Disable An Employee"
    echo "================================="
    echo

    read -p "Enter Employee ID or Employee Name: " search

    file=""

    # Search by Employee ID
    if [[ -f "$EMPLOYEE_DIR/$search.txt" ]]; then

        file="$EMPLOYEE_DIR/$search.txt"

    else

        # Search by Employee Name
        for employee_file in "$EMPLOYEE_DIR"/*.txt
        do

            name=$(grep "^Name" "$employee_file" | cut -d':' -f2 | xargs)

            if [[ "${name,,}" == "${search,,}" ]]; then
                file="$employee_file"
                break
            fi

        done

    fi

    if [[ -z "$file" ]]; then

        echo
        echo "Employee not found."
        echo
        read -p "Press Enter to continue..."
        return

    fi

    emp_id=$(grep "^Employee ID" "$file" | cut -d':' -f2 | xargs)
    emp_name=$(grep "^Name" "$file" | cut -d':' -f2 | xargs)

    sed -i 's/^Status.*/Status      : Disabled/' "$file"

    log_action "Disabled $emp_id ($emp_name)"

    echo
    echo "$emp_name ($emp_id) has been disabled."
    echo

    read -p "Press Enter to continue..."

}


remove_employee() {

    clear
    echo "================================="
    echo " Remove Employee(s)"
    echo "================================="
    echo

    read -p "Enter Employee ID(s) separated by spaces: " ids

    for emp_id in $ids
    do
        file="$EMPLOYEE_DIR/$emp_id.txt"

        if [[ -f "$file" ]]; then
            rm "$file"
            log_action "Removed $emp_id"
            echo "$emp_id removed."
        else
            echo "$emp_id not found."
        fi
    done

    read -p "Press Enter to continue..."

}

search_employee() {

    clear
    echo "================================="
    echo " Search Employee"
    echo "================================="
    echo

    read -p "Enter Employee ID or Name: " query

    found=false

    for file in "$EMPLOYEE_DIR"/*.txt
    do
        if grep -qi "$query" "$file"; then
            echo
            echo "---------------------------------"
            cat "$file"
            echo "---------------------------------"
            found=true
        fi
    done

    if [[ "$found" = false ]]; then
        echo
        echo "No matching employee found."
    fi

    read -p "Press Enter to continue..."

}

list_employees() {

    clear

    echo "==============================================="
    echo "                Employee List"
    echo "==============================================="
    echo

    printf "%-10s %-25s %-20s %-10s\n" \
    "Employee ID" "Employee Name" "Department" "Status"

    printf "%-10s %-25s %-20s %-10s\n" \
    "----------" "-------------" "----------" "------"

    for file in "$EMPLOYEE_DIR"/*.txt
    do

        [ -e "$file" ] || continue

        emp_id=$(grep "^Employee ID" "$file" | cut -d':' -f2 | xargs)
        name=$(grep "^Name" "$file" | cut -d':' -f2 | xargs)
        dept=$(grep "^Department" "$file" | cut -d':' -f2 | xargs)
        status=$(grep "^Status" "$file" | cut -d':' -f2 | xargs)

        printf "%-10s %-25s %-20s %-10s\n" \
        "$emp_id" "$name" "$dept" "$status"

    done

    echo
    read -p "Press Enter to continue..."

}

list_permissions() {

    clear

    echo "================================="
    echo " Employee Permissions"
    echo "================================="
    echo

    read -p "Enter Employee ID or Employee Name: " search

    file=""

    # Search by Employee ID
    if [[ -f "$EMPLOYEE_DIR/$search.txt" ]]; then

        file="$EMPLOYEE_DIR/$search.txt"

    else

        # Search by Employee Name
        for employee_file in "$EMPLOYEE_DIR"/*.txt
        do

            name=$(grep "^Name" "$employee_file" | cut -d':' -f2 | xargs)

            if [[ "${name,,}" == "${search,,}" ]]; then
                file="$employee_file"
                break
            fi

        done

    fi

    if [[ -z "$file" ]]; then

        echo
        echo "Employee not found."
        echo
        read -p "Press Enter to continue..."
        return

    fi

    emp_id=$(grep "^Employee ID" "$file" | cut -d':' -f2 | xargs)
    emp_name=$(grep "^Name" "$file" | cut -d':' -f2 | xargs)

    echo
    echo "Employee : $emp_name ($emp_id)"
    echo "Current Permissions:"
    echo "--------------------------------"

    permissions=$(stat -c "%a" "$file")

    echo "$permissions"

    echo

    if [[ "$permissions" == "640" ]]; then

        echo "No custom permissions have been assigned."
        echo
        echo "It is recommended to assign appropriate permissions."
        echo

        read -p "Would you like to assign permissions? (Y/N): " answer

        if [[ "$answer" =~ ^[Yy]$ ]]; then

            while true
            do

                read -p "Enter permission number (e.g. 755, 640, 600): " new_perm

                if [[ "$new_perm" =~ ^[0-7]{3}$ ]]; then

                    owner=${new_perm:0:1}

                    if (( owner < 4 )); then

                        echo
                        echo "The owner must have at least read permission (400-777)."
                        continue

                    fi

                    chmod "$new_perm" "$file"

                    log_action "Changed permissions for $emp_id to $new_perm"

                    echo
                    echo "Permissions updated successfully."
                    echo
                    break

                else

                    echo
                    echo "Invalid permission. Enter a three-digit number between 000 and 777."

                fi

            done

        else

            echo
            echo "Warning: Leaving files with default permissions may not meet security requirements."

        fi

    fi

    echo
    read -p "Press Enter to return to the main menu..."

}

change_permissions() {

    clear

    echo "================================="
    echo " Change Employee Permissions"
    echo "================================="
    echo

    read -p "Enter Employee ID or Employee Name: " search

    file=""

    # Search by Employee ID
    if [[ -f "$EMPLOYEE_DIR/$search.txt" ]]; then

        file="$EMPLOYEE_DIR/$search.txt"

    else

        # Search by Employee Name
        for employee_file in "$EMPLOYEE_DIR"/*.txt
        do

            name=$(grep "^Name" "$employee_file" | cut -d':' -f2 | xargs)

            if [[ "${name,,}" == "${search,,}" ]]; then
                file="$employee_file"
                break
            fi

        done

    fi

    if [[ -z "$file" ]]; then

        echo
        echo "Employee not found."
        echo
        read -p "Press Enter to continue..."
        return

    fi

    emp_id=$(grep "^Employee ID" "$file" | cut -d':' -f2 | xargs)
    emp_name=$(grep "^Name" "$file" | cut -d':' -f2 | xargs)

    current_perm=$(stat -c "%a" "$file")

    echo
    echo "Employee           : $emp_name ($emp_id)"
    echo "Current Permission : $current_perm"
    echo

    while true
    do

        read -p "Enter new permission (e.g. 640, 600, 755): " new_perm

        if [[ ! "$new_perm" =~ ^[0-7]{3}$ ]]; then

            echo
            echo "Invalid permission. Enter a value between 000 and 777."
            continue

        fi

        owner=${new_perm:0:1}

        if (( owner < 4 )); then

            echo
            echo "The owner must have at least read permission (400-777)."
            continue

        fi

        chmod "$new_perm" "$file"

        log_action "Changed permissions for $emp_id to $new_perm"

        echo
        echo "Permissions updated successfully."
        echo

        break

    done

    read -p "Press Enter to continue..."

}

change_department() {

    clear
    echo "================================="
    echo " Change Employee Department"
    echo "================================="
    echo

    read -p "Enter Employee ID: " emp_id
    file="$EMPLOYEE_DIR/$emp_id.txt"

    if [[ ! -f "$file" ]]; then
        echo "Employee not found."
        read -p "Press Enter to continue..."
        return
    fi

    old_dept=$(grep "^Department" "$file" | cut -d":" -f2 | xargs)
    read -p "New Department: " new_dept

    mkdir -p "$DEPARTMENT_DIR/$new_dept"

    sed -i "s/^Department.*/Department  : $new_dept/" "$file"

    rm -f "$DEPARTMENT_DIR/$old_dept/$emp_id.txt"
    ln -sfn "../../employees/$emp_id.txt" "$DEPARTMENT_DIR/$new_dept/$emp_id.txt" 2>/dev/null || cp "$file" "$DEPARTMENT_DIR/$new_dept/$emp_id.txt"

    log_action "Changed department for $emp_id to $new_dept"

    echo
    echo "Department updated."
    read -p "Press Enter to continue..."

}

list_group_permissions() {

    clear

    echo "====================================================="
    echo "             Department Group Permissions"
    echo "====================================================="
    echo

    printf "%-20s %-15s\n" "Department" "Permissions"
    printf "%-20s %-15s\n" "----------" "-----------"

    for folder in "$DEPARTMENT_DIR"/*
    do

        [ -d "$folder" ] || continue

        department=$(basename "$folder")
        permissions=$(stat -c "%a" "$folder")

        printf "%-20s %-15s\n" "$department" "$permissions"

    done

    echo
    read -p "Press Enter to continue..."

}


change_group_permissions() {

    clear

    echo "================================="
    echo " Change Group Permissions"
    echo "================================="
    echo

    read -p "Enter Department Name: " department

    folder="$DEPARTMENT_DIR/$department"

    if [[ ! -d "$folder" ]]; then
        echo
        echo "Department not found."
        echo
        read -p "Press Enter to continue..."
        return
    fi

    current_perm=$(stat -c "%a" "$folder")

    echo
    echo "Department Selected : $department"
    echo "Current Permission  : $current_perm"
    echo

    read -p "Assign a different permission? (Y/N): " answer

    if [[ "$answer" =~ ^[Yy]$ ]]; then

        while true
        do
            read -p "Enter new permission (e.g. 750): " new_perm

            if [[ "$new_perm" =~ ^[0-7]{3}$ ]]; then

                owner=${new_perm:0:1}

                if (( owner < 4 )); then

                    echo "The owner must have at least read permission (400-777)."
                    continue

                fi

                chmod "$new_perm" "$folder"
                log_action "Changed group permissions for $department to $new_perm"
                echo
                echo "Department permissions updated successfully."
                break
            else
                echo "Invalid permission. Enter a value between 000 and 777."
            fi
        done
    fi

    echo
    read -p "Press Enter to return to the main menu..."

}

statistics() {

    clear
    echo "================================="
    echo " System Statistics"
    echo "================================="
    echo

    total=$(ls "$EMPLOYEE_DIR"/*.txt 2>/dev/null | wc -l)
    active=$(grep -R "Status      : Active" "$EMPLOYEE_DIR" | wc -l)
    disabled=$(grep -R "Status      : Disabled" "$EMPLOYEE_DIR" | wc -l)

    echo "Total Employees   : $total"
    echo "Active Employees  : $active"
    echo "Disabled Employees: $disabled"

    echo
    read -p "Press Enter to continue..."

}

#############################################
# Start Program
#############################################

show_menu