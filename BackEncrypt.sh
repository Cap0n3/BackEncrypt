#!/bin/bash
#
# A small Bash script utility for creating a tar archive of a folder and encrypting/decrypting it with a password stored in a file.
#
# Usage for encryption: ./BackEncrypt.sh <source_folder_path> <destination_folder_path> <password_file>
# Usage for decryption: ./BackEncrypt.sh --decrypt <encrypted_archive_path> <destination_folder_path> <password_file>
# 
# Author: Alexandre Guillin
# Date: 2024-01-01
# Version: 1.0.0

# ========================== #
# ===== UTILS FUNCTIONS ==== #
# ========================== #

print_error() {
    echo -e "\033[0;31m[!!!] $1\033[0m"
}

print_success() {
    echo -e "\033[0;32m[OK] $1\033[0m"
}

print_info() {
    echo -e "\033[0;34m[INFO] $1\033[0m"
}

print_additional_info() {
    echo -e "\033[0;33m[***] $1\033[0m"
}

decrypt_and_extract() {
    # Check if the correct number of arguments are provided
    if [[ "$#" -ne 4 ]]; then
        print_additional_info "Usage: $0 --decrypt <encrypted_archive_path> <destination_folder_path> <password_file>"
        exit 1
    fi

    # Assign the source and destination paths from script arguments
    local encrypted_archive_path="$2"
    local destination_path="$3"
    local password_file="$4"

    # Check if the source path is a file and exists and if destination path and password file exist
    if [[ ! -f "$encrypted_archive_path" || ! -e "$destination_path" || ! -e "$password_file" ]]; then
        print_error "Error: Source path is not a file or does not exist or destination path or password file do not exist."
        exit 1
    fi

    # Set the decrypted archive file name
    local decrypted_archive="$destination_path/decrypted_archive_$timestamp.tar.gz"

    # Decrypt and extract the archive file with a password from the file
    openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter 100000 -salt -d -in "$encrypted_archive_path" -out "$decrypted_archive" -pass file:"$password_file"
    
    # Extract the decrypted archive file
    tar -xzf "$decrypted_archive" -C "$destination_path" --strip-components=1

    # Remove the decrypted archive file (optional, comment this line if you want to keep it)
    rm "$decrypted_archive"

    print_success "Decryption and extraction completed successfully."
    exit 0
}

# ==================== #
# ====== CHECKS ====== #
# ==================== #

# Check if option --decrypt is provided as the first argument and if so, decrypt the archive at given path
if [ "$1" == "--decrypt" ]; then
    decrypt_and_extract "$@"
fi

# Check if the correct number of arguments are provided
if [ "$#" -ne 3 ]; then
    print_additional_info "This script creates a tar archive of a source path and encrypts it with a password from a file."
    print_additional_info "Usage for encryption: $0 <source_path> <destination_path> <password_file>"
    print_additional_info "Usage for decryption: $0 --decrypt <encrypted_archive_path> <destination_path> <password_file>"
    exit 1
fi

# Assign the source and destination paths from script arguments
source_path="$1"
destination_path="$2"
password_file="$3"

# Check if the source path exists
if [ ! -e "$source_path" ]; then
    print_error "Error: Source path does not exist."
    exit 1
fi

# Check if the destination path exists
if [ ! -e "$destination_path" ]; then
    print_error "Error: Destination path does not exist."
    exit 1
fi

# Check if the password file exists
if [ ! -e "$password_file" ]; then
    print_error "Error: Password file does not exist."
    exit 1
fi

# ==================== #
# ====== SCRIPT ====== #
# ==================== #

# Create a timestamp for the archive file
timestamp=$(date +"%Y-%m-%d_%H%M%S")

# Get name of folder of source path
source_folder_name=$(basename "$source_path")

# Set the archive file name
archive_file="$destination_path/archive_$timestamp.tar.gz"

# Set the encrypted archive file name
encrypted_archive="$destination_path/${source_folder_name}_$timestamp.tar.gz.enc"

# Create a tar archive of the source path
tar -czf "$archive_file" "$source_path"

# Encrypt the archive file with a password from the file
openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter 100000 -salt -in "$archive_file" -out "$encrypted_archive" -pass file:"$password_file"

# Remove the original archive file (optional, comment this line if you want to keep it)
rm "$archive_file"

print_success "Backup and encryption completed successfully."
