# Vérifier si un nom de projet est fourni
if ($args.Count -eq 0) {
    Write-Host "Usage: .\script.ps1 <NomDuProjet>"
    exit 1
}

$PROJECT = $args[0]

# Création de la structure des dossiers
Write-Host "Création de la structure pour le projet '$PROJECT'..."
New-Item -ItemType Directory -Path "$PROJECT\src", "$PROJECT\include", "$PROJECT\build", "$PROJECT\bin", "$PROJECT\lib" | Out-Null

# Fichier main.cpp par défaut
Write-Host "Création d'un fichier main.cpp par défaut..."
@"
#include <iostream>

int main() {
    std::cout << "Hello, $PROJECT!" << std::endl;
    return 0;
}
"@ | Set-Content -Path "$PROJECT\src\main.cpp"

# Création du fichier CMakeLists.txt
Write-Host "Création du fichier CMakeLists.txt..."

# Utilisation de guillemets simples pour ne pas interpréter les variables
$CMakeContent = @'
cmake_minimum_required(VERSION 3.10)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

project(${PROJECT})

# header
include_directories(include)

file(GLOB SOURCES "src/*.cpp")

add_executable(${PROJECT_NAME} ${SOURCES})

if(WIN32)
  # Ajout des lib externe
  #target_link_libraries(\${PROJECT_NAME}
  #    PRIVATE
  #    ${CMAKE_SOURCE_DIR}/lib/Library1/libLibrary1.dll
  #    ${CMAKE_SOURCE_DIR}/lib/Library2/libLibrary2.lib
elseif(UNIX)
  # Ajout des lib externe
  #target_link_libraries(\${PROJECT_NAME}
  #    PRIVATE
  #    ${CMAKE_SOURCE_DIR}/lib/Library1/libLibrary1.so
  #    ${CMAKE_SOURCE_DIR}/lib/Library2/libLibrary2.a
  #)
endif()

set_target_properties(${PROJECT_NAME} PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/../bin"
)
'@

# Remplacement dynamique de la variable $PROJECT_NAME
$CMakeContent = $CMakeContent -replace "\$\{PROJECT\}", $PROJECT

# Écriture dans le fichier CMakeLists.txt
$CMakeContent | Out-File -Encoding UTF8 -FilePath "$PROJECT\CMakeLists.txt"

# Fin
Write-Host "Template de projet C++ créé avec succès dans le dossier '$PROJECT'."
Write-Host "Pour commencer :"
Write-Host "  cd $PROJECT\build"
Write-Host "  cmake .."
Write-Host "  cmake --build ."
Write-Host "  copy compile_commands.json .."
