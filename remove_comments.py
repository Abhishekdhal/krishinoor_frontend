
import re
import sys

def remove_comments(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # This regex is designed to remove comments from Dart code.
    # It handles single-line (//) and multi-line (/* */) comments.
    # It specifically avoids removing URLs (http:// or https://).
    # It also preserves /// documentation comments.
    # It also preserves ignore_for_file directives.
    content = re.sub(r"(?<!https:|http:)//(?!/|\s*ignore_for_file:).*", "", content)
    content = re.sub(r"/\*[​‌‍‎‏﻿	
               　  ]*?*/", "", content, flags=re.DOTALL)

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
