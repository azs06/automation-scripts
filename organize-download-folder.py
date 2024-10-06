import os
import shutil
from collections import defaultdict

# Define the folder to organize
folder_to_organize = os.path.expanduser("~/Downloads")

# Define the extensions and corresponding folder names
file_types = {
    "documents": [".pdf", ".doc", ".docx", ".txt", ".xls", ".xlsx", ".ppt", ".pptx"],
    "images": [".jpg", ".jpeg", ".png", ".gif", ".bmp", ".tiff", ".svg", ".webp"],
    "archives": [".zip", ".rar", ".7z", ".tar", ".gz"],
    "iso": [".iso"],
    # Add more categories and extensions as needed
}

# Define the ignore list
ignore_list = [".ds_store", ".tmp"]  # Add extensions to be ignored

# Create a default dictionary to map extensions to folder names
extension_to_folder = defaultdict(lambda: "others")
for folder, extensions in file_types.items():
    for ext in extensions:
        extension_to_folder[ext] = folder

# Create subfolders if they don't exist
for folder in set(extension_to_folder.values()):
    subfolder_path = os.path.join(folder_to_organize, folder)
    if not os.path.exists(subfolder_path):
        os.makedirs(subfolder_path)

# Track missed extensions
missed_extensions = set()

# Move files to corresponding subfolders
for filename in os.listdir(folder_to_organize):
    file_path = os.path.join(folder_to_organize, filename)
    if os.path.isfile(file_path):
        file_extension = os.path.splitext(filename)[1].lower()
        if file_extension in ignore_list:
            continue
        target_folder = extension_to_folder[file_extension]
        target_path = os.path.join(folder_to_organize, target_folder)
        
        # Ensure the target folder exists
        if not os.path.exists(target_path):
            os.makedirs(target_path)
        
        try:
            # Move the file to the target folder
            shutil.move(file_path, os.path.join(target_path, filename))
            print(f"Moved: {filename} to {target_folder}")
        except Exception as e:
            missed_extensions.add(file_extension)
            print(f"Error moving file {filename}: {e}")

# Print out missed extensions
if missed_extensions:
    print("\nMissed extensions:")
    for ext in missed_extensions:
        print(ext)

print("File organization complete.")
