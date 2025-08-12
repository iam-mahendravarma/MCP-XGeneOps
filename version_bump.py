import os
import re

VERSION_FILE = "version.txt"

# If version.txt does not exist, start at v1
if not os.path.exists(VERSION_FILE):
    version = "v1"
else:
    with open(VERSION_FILE, "r") as f:
        current = f.read().strip()
        match = re.match(r"v(\d+)", current)
        if match:
            num = int(match.group(1)) + 1
            version = f"v{num}"
        else:
            version = "v1"

with open(VERSION_FILE, "w") as f:
    f.write(version)

print(version)
