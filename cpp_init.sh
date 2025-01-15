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

# Exemple : Création de sous-dossiers dans lib/ pour chaque bibliothèque
mkdir -p $PROJECT_NAME/lib/{Library1,Library2}

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

# Nom du projet
project($PROJECT_NAME)

# Ajouter le dossier include/ pour les headers
include_directories(include)

# Ajouter les fichiers source
file(GLOB SOURCES "src/*.cpp")

# Ajouter les bibliothèques
# Chaque bibliothèque a son propre dossier sous lib/
link_directories(
    \${CMAKE_SOURCE_DIR}/lib/Library1
    \${CMAKE_SOURCE_DIR}/lib/Library2
)

# Définir les bibliothèques nécessaires
set(EXTERNAL_LIBRARIES "")

# Exemple d'ajout de bibliothèques spécifiques
# list(APPEND EXTERNAL_LIBRARIES Library1 Library2)

# Définir l'exécutable
add_executable(\${PROJECT_NAME} \${SOURCES})

# Lier les bibliothèques à l'exécutable
target_link_libraries(\${PROJECT_NAME} \${EXTERNAL_LIBRARIES})

# Spécifier où se trouvera le binaire
set_target_properties(\${PROJECT_NAME} PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "\${CMAKE_BINARY_DIR}/../bin"
)
EOL

# Fin
echo "Template de projet C++ créé avec succès dans le dossier '$PROJECT_NAME'."
echo "Pour commencer :"
echo "  cd $PROJECT_NAME/build"
echo "  cmake .."
echo "  make"
