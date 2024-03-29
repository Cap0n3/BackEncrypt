# BackEncrypt.sh

A small Bash script utility for creating a tar archive of a folder and encrypting/decrypting it with a password stored in a file.

## Prerequisites

Make sure OpenSSL is installed on your system. If not, you can install it using:

```bash
Copy code
# For Debian/Ubuntu-based systems
sudo apt-get install openssl

# For Red Hat/Fedora-based systems
sudo yum install openssl
```

## Usage

### Encryption

```bash
./BackEncrypt.sh <source_folder_path> <destination_folder_path> <password_file>
```

For example, an encrypted file name might look like `encrypted_archive_2024-01-12_024523.tar.gz.enc`, representing an encrypted archive created on January 12, 2024, at 2:45:23 PM.

### Decryption

```bash
./BackEncrypt.sh --decrypt <encrypted_archive_path> <destination_folder_path> <password_file>
```

## Notes

- Ensure the script has execution permission (`chmod +x BackEncrypt.sh`).
- Adjust the encryption and decryption algorithms and parameters if necessary.

Feel free to customize and use this script according to your backup and encryption needs.