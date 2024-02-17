#!/bin/bash

# Path to the folder containing public SSH keys
keys_folder="/path/to/keys/folder"

# Output file for user information
output_file="user_information.txt"

# Ensure the keys folder exists
if [ ! -d "$keys_folder" ]; then
    echo "Error: Keys folder not found."
    exit 1
fi


# Iterate through each public key file in the folder
for key_file in "$keys_folder"/*_key.pub; do
    if [ -f "$key_file" ]; then
        # Extract username from the key file name
        username=$(basename "$key_file" | sed 's/_key.pub//')

        # Check if the user exists
        if id "$username" &>/dev/null; then
            # Ensure the user has a home directory
            sudo mkdir -p "/home/$username" && sudo chown "$username:$username" "/home/$username"

            # Create the .ssh directory and authorized_keys file
            sudo -u "$username" mkdir -p "/home/$username/.ssh"
            sudo -u "$username" touch "/home/$username/.ssh/authorized_keys"

            # Append the public key to the authorized_keys file
            cat "$key_file" | sudo -u "$username" tee -a "/home/$username/.ssh/authorized_keys" > /dev/null
            echo "Public key added for user: $username"

            # Log user information to the output file
            echo "$username" >> "$output_file"
        else
            echo "Error: User $username not found. Skipping..."
        fi
    fi
done

echo "Home directories and SSH keys stashed successfully."
echo "User information logged to $output_file."


## script to add the keys of the required users to their designated directory - assumes they dont havea home directory 
## also creates user listtouch