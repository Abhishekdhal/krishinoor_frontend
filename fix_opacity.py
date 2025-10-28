import re
import sys

for file_path in sys.argv[1:]:
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    def replace_opacity(match):
        try:
            opacity_value = float(match.group(1))
            alpha_value = int(round(255 * opacity_value))
            return f'.withAlpha({alpha_value})'
        except ValueError:
            return match.group(0)

    content = re.sub(r'\.withOpacity\((.*?)\)', replace_opacity, content)

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)