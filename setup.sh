#!/bin/bash
# Setup.sh, a script to install CppCompile 2.3.1
# This script will create a C++ program that compiles and runs other C++ files.
# It will also check for the presence of g++ and copy to /usr/local/bin.
# Enhanced with -e for colored output.

echo -e "\033[38;5;255mCppCompile 2.3.1 installer\033[0m"

echo -e "\033[38;5;10mWriting C++ files...\033[0m"

if ! command -v g++ &>/dev/null; then
    echo -e "\033[38;5;9mError: g++ not found. Please install a C++ compiler.\033[0m"
    exit 1
fi

if [[ -f /usr/local/bin/cppcompile ]]; then
    echo -e "\033[38;5;9mWarning: cppcompile already exists. Overwriting...\033[0m"
fi

cat > "cppcompile.cpp" <<'EOF'
#include <iostream>
#include <fstream>
#include <cstdlib>
#include <string>
#include <vector>
#include <filesystem>

bool has_flag(const std::vector<std::string>& args, const std::string& flag) {
    return std::find(args.begin(), args.end(), flag) != args.end();
}

std::string get_include(const std::vector<std::string>& args) {
    for (const std::string& arg : args) {
        if (arg.rfind("--include=", 0) == 0) {
            return arg.substr(10);
        }
    }
    return "";
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        std::cerr << "Usage: " << argv[0] << " <file.cpp> [args...] [-nR] [-nC] [-pR] [--include=X]" << std::endl;
        return 1;
    }

    std::vector<std::string> args(argv + 1, argv + argc);
    std::string filepath = args[0];
    std::filesystem::path full_path = std::filesystem::absolute(filepath);
    std::filesystem::path output = full_path.parent_path() / full_path.stem();

    // Preprocess: insert #include if requested
    std::string include_header = get_include(args);
    if (!include_header.empty()) {
        std::ifstream in(filepath);
        if (!in) {
            std::cerr << "Error: Unable to open file: " << filepath << std::endl;
            return 1;
        }
        std::string temp_file = full_path.parent_path() / (full_path.stem().string() + "_cppcompile_tmp.cpp");
        std::ofstream out(temp_file);
        out << "#include <" << include_header << ">\n";
        out << in.rdbuf();
        out.close();
        filepath = temp_file;
    }

    std::string compile_cmd = "g++ " + filepath + " -o " + output.string();
    std::string run_cmd = output.string();

    for (size_t i = 1; i < args.size(); ++i) {
        if (args[i][0] != '-') {
            run_cmd += " " + args[i];
        }
    }

    if (has_flag(args, "-pR")) {
        std::cout << "[Print Only]\nCompile: " << compile_cmd << "\nRun: " << run_cmd << std::endl;
        return 0;
    }

    if (!has_flag(args, "-nC")) {
        std::cout << "Running: " << compile_cmd << std::endl;
        int compile_result = std::system(compile_cmd.c_str());
        if (compile_result != 0) {
            std::cerr << "Compilation failed with code: " << compile_result << std::endl;
            return compile_result;
        }
    }

    if (!has_flag(args, "-nR")) {
        std::cout << "Running binary: " << run_cmd << std::endl;
        return std::system(run_cmd.c_str());
    }

    return 0;
}
EOF

g++ cppcompile.cpp -o cppcompile -std=c++17
sudo cp cppcompile /usr/local/bin/cppcompile
sudo chmod +x /usr/local/bin/cppcompile
rm cppcompile.cpp
rm cppcompile

echo -e "\033[38;5;10mInstallation complete.\033[0m"
echo -e "\033[38;5;10mYou can now use the command 'cppcompile <file.cpp> [args...]' to compile and run C++ files.\033[0m"
