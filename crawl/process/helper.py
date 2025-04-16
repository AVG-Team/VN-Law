import json
import re

def convert_roman_to_num(roman_num):
    roman_num = roman_num.upper()
    num_convert_roman = {'I': 10, 'V': 50, 'X': 100, 'L': 500, 'C': 1000, 'D': 5000, 'M': 10000}
    letter = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I']
    num = 0
    for i, roman_char in enumerate(roman_num):
        if roman_char not in num_convert_roman:
            num += letter.index(roman_char) + 1
            continue
        if i > 0 and num_convert_roman[roman_char] > num_convert_roman[roman_num[i - 1]]:
            num += num_convert_roman[roman_char] - 2 * num_convert_roman[roman_num[i - 1]]
        else:
            num += num_convert_roman[roman_char]
    return num

def extract_input(input_str):
    pattern = r"\((.*?)\)"
    match = re.search(pattern, input_str)
    return match.group(1) if match else None

def read_json_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        return json.load(f)

def write_json_file(json_obj, file_path):
    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(json_obj, f, ensure_ascii=False)