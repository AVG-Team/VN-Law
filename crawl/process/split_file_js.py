import re
import json
import os

def extract_json_from_js(js_content):
    # Thử các pattern khác nhau để tìm biến JSON
    patterns = [
        r'var\s+(\w+)\s*=\s*(\[.*?\]);',  # Pattern ban đầu
        r'var\s+(\w+)\s*=\s*(\[.*?\])(?=;|\n|$)',  # Mở rộng pattern
        r'var\s+(\w+)\s*=\s*(\[.*?\])\s*;',  # Thêm khoảng trắng
    ]

    variables = []
    for pattern in patterns:
        variables = re.findall(pattern, js_content, re.DOTALL | re.MULTILINE)
        if variables:
            break

    print(f'Tìm thấy {len(variables)} biến chứa dữ liệu JSON')

    # Xử lý từng biến
    for var_name, json_str in variables:
        try:
            # Loại bỏ các ký tự không mong muốn
            json_str = json_str.strip()

            # Thử parse JSON
            try:
                parsed_json = json.loads(json_str)
            except json.JSONDecodeError:
                # Nếu parse thất bại, thử sửa JSON
                json_str = json_str.replace("'", '"')  # Chuyển nháy đơn sang nháy kép
                parsed_json = json.loads(json_str)

            # Tạo tên file
            filename = f'./data/phap-dien/{var_name}.json'

            # Ghi file JSON
            with open(filename, 'w', encoding='utf-8') as f:
                json.dump(parsed_json, f, ensure_ascii=False, indent=2)

            print(f'Đã tạo file: {filename}')
        except Exception as e:
            print(f'Lỗi xử lý {var_name}: {e}')

# Đọc nội dung file JS
def read_js_file(filepath):
    # Thử các encoding khác nhau
    encodings = ['utf-8', 'latin-1', 'utf-16', 'cp1252']

    for encoding in encodings:
        try:
            with open(filepath, 'r', encoding=encoding) as file:
                return file.read()
        except UnicodeDecodeError:
            continue

    raise Exception("Không thể đọc file với bất kỳ encoding nào")
