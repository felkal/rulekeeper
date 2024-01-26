#!/bin/bash

# Function to set up Amazona Database
setup_amazona() {
    echo "Setting up Amazona Database..."
    # Add your setup commands for Amazona here
    # ...
    copy_policy "manifest_amazona.json"
    echo "Amazona Database setup completed."
}

# Function to set up Blog Database
setup_blog() {
    echo "Setting up Blog Database..."
    # Add your setup commands for Blog here
    # ...
    copy_policy "manifest_blog.json"
    echo "Blog Database setup completed."
}

# Function to set up Habitica Database
setup_habitica() {
    echo "Setting up Habitica Database..."
    # Add your setup commands for Habitica here
    # ...
    copy_policy "manifest_habitica.json"
    echo "Habitica Database setup completed."
}

# Function to set up Leb Database
setup_leb() {
    echo "Setting up Leb Database..."
    # Add your setup commands for Leb here
    # ...
    copy_policy "manifest_leb.json"
    echo "Leb Database setup completed."
}

# Function to copy policy file
copy_policy() {
    local policy_file="$1"
    if [ -f "Policies/$policy_file" ]; then
        cp "Policies/$policy_file" "RuleKeeperManager/policies/data/privacy_policy.json"
        echo "Privacy policy copied: $policy_file"
    else
        echo "Privacy policy file not found: $policy_file"
    fi
}

PS3="Choose an application to set up: "

options=("Amazona Database" "Blog Database" "Habitica Database" "Leb Database" "Quit")

select choice in "${options[@]}"; do
    case $REPLY in
        1)
            setup_amazona
            ;;
        2)
            setup_blog
            ;;
        3)
            setup_habitica
            ;;
        4)
            setup_leb
            ;;
        5)
            echo "User canceled."
            break
            ;;
        *)
            echo "Invalid option. Please choose a number between 1 and 4."
            ;;
    esac
    break  # Exit the loop after processing the user's choice
done