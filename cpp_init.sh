#!/bin/bash

# Vérifier si un nom de projet est fourni
if [ $# -eq 0 ]; then
  echo "Usage: $0 <NomDuProjet>"
  exit 1
fi

PROJECT_NAME=$1

# Création de la structure des dossiers
echo "Création de la structure pour le projet '$PROJECT_NAME'..."
mkdir -p $PROJECT_NAME/{src,include,build,bin,lib}

# Fichier main.cpp par défaut
echo "Création d'un fichier main.cpp par défaut..."
cat <<EOL > $PROJECT_NAME/src/main.cpp
#include <iostream>

int main() {
    std::cout << "Hello, $PROJECT_NAME!" << std::endl;
    return 0;
}
EOL

# Création du fichier CMakeLists.txt
echo "Création du fichier CMakeLists.txt..."
cat <<EOL > $PROJECT_NAME/CMakeLists.txt
cmake_minimum_required(VERSION 3.10)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

project($PROJECT_NAME)

# header
include_directories(include)

file(GLOB SOURCES "src/*.cpp")

add_executable(\${PROJECT_NAME} \${SOURCES})

# Ajout des lib externe
#target_link_libraries(\${PROJECT_NAME}
#    PRIVATE
#    ${CMAKE_SOURCE_DIR}/lib/Library1/libLibrary1.so
#    ${CMAKE_SOURCE_DIR}/lib/Library2/libLibrary2.so
#)

set_target_properties(\${PROJECT_NAME} PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "\${CMAKE_BINARY_DIR}/../bin"
)
EOL

# Fin
echo "Template de projet C++ créé avec succès dans le dossier '$PROJECT_NAME'."
echo "Pour commencer :"
echo "  cd $PROJECT_NAME/build"
echo "  cmake .."
echo "  cmake --build ."
echo "  cp compile_commands.json .."
