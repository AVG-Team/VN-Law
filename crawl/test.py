from process.download import download_and_extract_zip
from tasks import crawl_data

try :
    download_and_extract_zip()
except Exception as e:
    print(f"Error: {e}")