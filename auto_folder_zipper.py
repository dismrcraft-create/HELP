import os
import zipfile

base_path = os.path.dirname(os.path.abspath(__file__))

for item in os.listdir(base_path):
    folder_path = os.path.join(base_path, item)
    if os.path.isdir(folder_path):
        zip_path = os.path.join(base_path, f"{item}.zip")
        with zipfile.ZipFile(zip_path, 'w', zipfile.ZIP_DEFLATED) as zipf:
            for root, dirs, files in os.walk(folder_path):
                for file in files:
                    file_path = os.path.join(root, file)
                    arcname = os.path.relpath(file_path, folder_path)
                    zipf.write(file_path, arcname)
        print(f"Compressed: {item} -> {item}.zip")
