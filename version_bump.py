import re

VERSION_FILE = "version.txt"

def read_version():
    try:
        with open(VERSION_FILE, "r") as f:
            version = f.read().strip()
            # Expect version format like v2, v3...
            return version
    except FileNotFoundError:
        # If no version file exists, start from v1
        return "v1"

def bump_version(version):
    # Extract the numeric part
    match = re.match(r"v(\d+)", version)
    if not match:
        raise ValueError(f"Invalid version format: {version}")
    number = int(match.group(1))
    number += 1
    return f"v{number}"

def write_version(version):
    with open(VERSION_FILE, "w") as f:
        f.write(version)

def main():
    old_version = read_version()
    new_version = bump_version(old_version)
    write_version(new_version)
    print(new_version)

if __name__ == "__main__":
    main()
