#!/usr/bin/env python3
import os

version_file = "version.txt"

if not os.path.exists(version_file):
    new_version = "v1"
else:
    with open(version_file, "r") as f:
        current_version = f.read().strip().lstrip("v")
        try:
            current_num = int(current_version)
        except ValueError:
            current_num = 0
        new_version = f"v{current_num + 1}"

with open(version_file, "w") as f:
    f.write(new_version)

print(new_version)  # Output so CI can capture it
