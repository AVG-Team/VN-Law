import os
import zipfile
import requests

ZIP_URL = "https://phapdien.moj.gov.vn/TraCuuPhapDien/Files/BoPhapDienDienTu.zip"

def download_and_extract_zip():
    """Tải và giải nén file zip"""
    response = requests.get(ZIP_URL)
    zip_path = "./data/BoPhapDienDienTu.zip"
    os.makedirs("./data/phap-dien/", exist_ok=True)
    with open(zip_path, 'wb') as f:
        f.write(response.content)

    # Check if the file is a valid zip file
    if zipfile.is_zipfile(zip_path):
        with zipfile.ZipFile(zip_path, 'r') as zip_ref:
            zip_ref.extractall("./data/phap-dien")
        os.remove(zip_path)
        print("Downloaded and extracted zip file successfully!")
    else:
        os.remove(zip_path)
        print("Error: The downloaded file is not a valid zip file.")