import sys
import os
import re

include_dirs = set()
source_files = set()

def recursive_search(path):
# print(path)
    for file in os.listdir(path):
        if (file == ".") or (file == ".."):
            continue

        full_name = os.path.join(path, file)
        if os.path.isdir(full_name) and not os.path.islink(path):
            recursive_search(full_name)

        if re.search("\\.(h|hh|hpp)$", file) is not None:
            include_dirs.add(path)
            source_files.add(full_name)
        elif re.search("\\.(c|cc|cpp|cxx)$", file) is not None:
            source_files.add(full_name)

if len(sys.argv) < 3:
    print("Usage " + sys.argv[0] + "<project> <path>")
    sys.exit(1)

project_name = sys.argv[1]
start_path = sys.argv[2]
recursive_search(start_path)

cmakelists = open(os.path.join(start_path, "CMakeLists.txt"), "w")
cmakelists.write("cmake_minimum_required(VERSION 2.8)\n")
cmakelists.write("project(" + project_name + ")\n\n")
cmakelists.write("set(CMAKE_CXX_STANDARD 11)\n")

skip_chars = len(start_path)

cmakelists.write("include_directories(\n")
cmakelists.write("    .\n")
for dir in sorted(include_dirs):
     cmakelists.write("    " + dir[skip_chars:] + "\n")
cmakelists.write(")\n\n")

cmakelists.write("add_executable(" + project_name + "\n")
for file in sorted(source_files):
    cmakelists.write("    " + file[skip_chars:] + "\n")
cmakelists.write(")")
