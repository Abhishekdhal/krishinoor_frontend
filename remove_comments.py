import re
import sys

def remove_comments(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Protect URLs by replacing them with placeholders
    content = content.replace("http://", "__HTTP__")
    content = content.replace("https://", "__HTTPS__")

    # Remove single-line comments (//)
    content = re.sub(r"//.*", "", content)
    # Remove multi-line comments (/* */)
    content = re.sub(r"/\*.*?\*/", "", content, flags=re.DOTALL)

    # Restore URLs
    content = content.replace("__HTTP__", "http://")
    content = content.replace("__HTTPS__", "https://")

    # Remove trailing whitespace from lines and extra newlines
    lines = [line.rstrip() for line in content.splitlines()]
    non_empty_lines = [line for line in lines if line.strip() != ""]
    content = "\n".join(non_empty_lines)

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python remove_comments.py <file_path>")
        sys.exit(1)
    
    file_path = sys.argv[1]
    remove_comments(file_path)