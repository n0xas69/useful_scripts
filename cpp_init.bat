@echo off
:: Vérifier si un nom de projet est fourni
if "%~1"=="" (
    echo Usage: %~nx0 <NomDuProjet>
    exit /b 1
)

set PROJECT_NAME=%~1

:: Créer la structure des dossiers
echo Création de la structure pour le projet "%PROJECT_NAME%"...
mkdir "%PROJECT_NAME%\src"
mkdir "%PROJECT_NAME%\include\Core"
mkdir "%PROJECT_NAME%\include\Math"
mkdir "%PROJECT_NAME%\include\Utils"
mkdir "%PROJECT_NAME%\build"
mkdir "%PROJECT_NAME%\bin"
mkdir "%PROJECT_NAME%\lib\Library1"
mkdir "%PROJECT_NAME%\lib\Library2"

:: Créer un fichier main.cpp par défaut
echo Création d'un fichier main.cpp par défaut...
(
    echo #include <iostream>
    echo.
    echo int main() {
    echo     std::cout << "Hello, %PROJECT_NAME%!" << std::endl;
    echo     return 0;
    echo }
) > "%PROJECT_NAME%\src\main.cpp"

:: Créer un fichier CMakeLists.txt
echo Création du fichier CMakeLists.txt...
(
    echo cmake_minimum_required\(VERSION 3.10\)
    echo.
    echo # Nom du projet
    echo project\(%PROJECT_NAME%\)
    echo.
    echo # Version de C++
    echo set\(CMAKE_CXX_STANDARD 17\)
    echo set\(CMAKE_CXX_STANDARD_REQUIRED True\)
    echo.
    echo # Inclure les headers
    echo include_directories\(
    echo     ${CMAKE_SOURCE_DIR}/include
    echo     ${CMAKE_SOURCE_DIR}/include/Core
    echo     ${CMAKE_SOURCE_DIR}/include/Math
    echo     ${CMAKE_SOURCE_DIR}/include/Utils
    echo \)
    echo.
    echo # Inclure les bibliothèques externes
    echo include_directories\(
    echo     ${CMAKE_SOURCE_DIR}/lib/Library1
    echo     ${CMAKE_SOURCE_DIR}/lib/Library2
    echo \)
    echo.
    echo # Ajouter les fichiers source
    echo file\(GLOB_RECURSE SOURCES "src/*.cpp"\)
    echo.
    echo # Ajouter les bibliothèques
    echo link_directories\(
    echo     ${CMAKE_SOURCE_DIR}/lib/Library1
    echo     ${CMAKE_SOURCE_DIR}/lib/Library2
    echo \)
    echo.
    echo # Lier les bibliothèques nécessaires
    echo set\(EXTERNAL_LIBRARIES Library1 Library2\)
    echo.
    echo # Définir l'exécutable
    echo add_executable\(${PROJECT_NAME} ${SOURCES}\)
    echo.
    echo # Lier les bibliothèques à l'exécutable
    echo target_link_libraries\(${PROJECT_NAME} ${EXTERNAL_LIBRARIES}\)
    echo.
    echo # Spécifier où se trouvera le binaire
    echo set_target_properties\(${PROJECT_NAME} PROPERTIES
    echo     RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/../bin"
    echo \)
) > "%PROJECT_NAME%\CMakeLists.txt"

:: Fin
echo Template de projet C++ créé avec succès dans le dossier "%PROJECT_NAME%".
echo Pour commencer :
echo    cd %PROJECT_NAME%\build
echo    cmake ..
echo    cmake --build .
