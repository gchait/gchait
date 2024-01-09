COLOURS = {
    "good": "\033[92m{}\033[0m",
    "bad": "\033[91m{}\033[0m",
    "not_good": "\033[93m{}\033[0m",
}


def warn(msg, rc=0):
    """Warns the user and exits the program."""
    msg = textwrap.fill("Warning: " + msg, MAX_OUTPUT_LINE_LEN)
    print(COLOURS["not_good"].format(msg))
    sys.exit(rc)


def fail(msg, rc):
    """Exits the program with the given message and return code."""
    msg = textwrap.fill(msg, MAX_OUTPUT_LINE_LEN)
    print(COLOURS["bad"].format(msg))
    sys.exit(rc)


def succeed(msg):
    """Prints the result of a successful operation."""
    msg = textwrap.fill(msg, MAX_OUTPUT_LINE_LEN)
    print(COLOURS["good"].format(msg))


def switch_dir():
    """Changes the CWD to the directory containing the script, so that opening relative paths would work."""
    abs_path = os.path.abspath(__file__)
    dir_name = os.path.dirname(abs_path)
    os.chdir(dir_name)


def verify_programs():
    """Checks if the required programs exist."""
    for program in REQUIRED_PROGRAMS:
        if shutil.which(program) is None:
            fail(f"The program {program} is required to run this script.", 1)


def yaml_read(path):
    """Reads a YAML file, returning it as a dictionary."""
    try:
        with open(path, "r") as f:
            data = yaml.safe_load(f)
    except OSError:
        fail(f"File {path} could not be found or accessed.", 1)
    return data


def yaml_write(path, data):
    """Writes a dictionary to a YAML file at the given path."""
    with open(path, "w") as f:
        yaml.dump(data, f)


def delete(path):
    """Deletes a given file."""
    try:
        os.remove(path)
    except OSError:
        pass
    succeed(f"File {path} is now deleted.")


def str_presenter(dumper, data):
    """Adds support for multiline strings inside a YAML."""
    if len(data.splitlines()) > 1:
        return dumper.represent_scalar("tag:yaml.org,2002:str", data, style="|")
    return dumper.represent_scalar("tag:yaml.org,2002:str", data)


if __name__ == "__main__":
    try:
        # Calculate for great success
        tool_name_len = len(TOOL_NAME)
        odd_flag = tool_name_len & 1 ^ MAX_OUTPUT_LINE_LEN & 1
        decor_len = int((MAX_OUTPUT_LINE_LEN - 4 - tool_name_len) / 2)

        # Decorate the output and run
        print("─" * MAX_OUTPUT_LINE_LEN)
        print(f".{':' * decor_len} {TOOL_NAME} {':' * (decor_len + odd_flag)}.")
        print("─" * MAX_OUTPUT_LINE_LEN)
        main()
    finally:
        print("─" * MAX_OUTPUT_LINE_LEN)
