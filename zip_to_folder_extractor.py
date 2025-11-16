# Copyright (c) craft

import os
import zipfile

base_path = os.path.dirname(os.path.abspath(__file__))

for filename in os.listdir(base_path):
    if filename.lower().endswith(".zip"):
        zip_path = os.path.join(base_path, filename)
        extract_folder = os.path.join(base_path, os.path.splitext(filename)[0])
        os.makedirs(extract_folder, exist_ok=True)
        with zipfile.ZipFile(zip_path, 'r') as zip_ref:
            zip_ref.extractall(extract_folder)
        print(f"Extracted: {filename} -> {extract_folder}")
