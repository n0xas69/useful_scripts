# Vérifier si un nom de projet est fourni
if ($args.Count -eq 0) {
    Write-Host "Usage: .\script.ps1 <NomDuProjet>"
    exit 1
}

$PROJECT_NAME = $args[0]

# Création de la structure des dossiers
Write-Host "Création de la structure pour le projet '$PROJECT_NAME'..."
New-Item -ItemType Directory -Path "$PROJECT_NAME\src", "$PROJECT_NAME\include", "$PROJECT_NAME\build", "$PROJECT_NAME\bin", "$PROJECT_NAME\lib" | Out-Null

# Fichier main.cpp par défaut
Write-Host "Création d'un fichier main.cpp par défaut..."
@"
#include <iostream>

int main() {
    std::cout << "Hello, $PROJECT_NAME!" << std::endl;
    return 0;
}
"@ | Set-Content -Path "$PROJECT_NAME\src\main.cpp"

# Création du fichier CMakeLists.txt
Write-Host "Création du fichier CMakeLists.txt..."
@'
cmake_minimum_required(VERSION 3.10)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

project(${PROJECT_NAME})

# header
include_directories(include)

file(GLOB SOURCES "src/*.cpp")

add_executable(${PROJECT_NAME} ${SOURCES})

# Ajout des lib externe
#target_link_libraries(${PROJECT_NAME}
#    PRIVATE
#    ${CMAKE_SOURCE_DIR}/lib/Library1/libLibrary1.so
#    ${CMAKE_SOURCE_DIR}/lib/Library2/libLibrary2.so
#)

set_target_properties(${PROJECT_NAME} PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/../bin"
)
'@ | Out-File -Encoding UTF8 -FilePath "$PROJECT_NAME\CMakeLists.txt"


# Fin
Write-Host "Template de projet C++ créé avec succès dans le dossier '$PROJECT_NAME'."
Write-Host "Pour commencer :"
Write-Host "  cd $PROJECT_NAME\build"
Write-Host "  cmake .."
Write-Host "  cmake --build ."
Write-Host "  copy compile_commands.json .."
