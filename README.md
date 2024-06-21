# File Integrity Monitor

This PowerShell script is designed to monitor file integrity within a directory. It includes two main functionalities: creating a new baseline of file hashes and monitoring files against this saved baseline.

## Functions

- **Get-SHA512Hash**: This function takes a file path as input and calculates its SHA512 hash.
- **Remove-ExistingBaseline**: This function checks if a file named `baseline_record.txt` exists in the current directory. If it does, the function deletes it.

## Main Script

The script prompts the user to choose between creating a new baseline (Option 1) or beginning monitoring with a saved baseline (Option 2).

### Option 1 - Create New Baseline

If the user selects **Option 1**, the script will:
- Call `Remove-ExistingBaseline` to ensure no previous baseline exists.
- Collect all files in the `.\TargetFiles` directory.
- Calculate the SHA512 hash for each file.
- Append each file's path and hash to `baseline_record.txt`.

### Option 2 - Begin Monitoring

If the user selects **Option 2**, the script will:
- Create a dictionary to store file paths and their corresponding hashes from `baseline_record.txt`.
- Enter a continuous loop to monitor the files:
  - Every second, it checks all files in the `.\TargetFiles` directory.
  - For each file, it calculates the current hash and compares it with the stored hash in the dictionary.
  - If a file is new (not in the dictionary), it notifies the user of the creation.
  - If a file's hash has changed, it notifies the user of the modification.
  - If a file from the baseline is missing, it notifies the user of the deletion.

## Security and Integrity

This script is useful for maintaining the security and integrity of files by detecting any unauthorized changes. It's a simple form of intrusion detection where file modifications can indicate potential security breaches.

## Permissions and Environment

Remember to run this script with the necessary permissions and in a trusted environment, as it has the capability to delete files (`Remove-Item`) and continuously monitor a directory.
