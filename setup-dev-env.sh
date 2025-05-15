#!/bin/bash
set -e

# ─────────────────────────────────────────────────────────────
# 📦 Configurador de entorno de desarrollo ESP-IDF + Docker
# Clona la plantilla y copia .devcontainer y .vscode a tu proyecto
# Uso:
#   ./setup-dev-env.sh /ruta/al/proyecto [--update]
# ─────────────────────────────────────────────────────────────

TEMPLATE_REPO="https://github.com/JairoDev/esp32-dev-env.git"
TEMPLATE_BRANCH="main"
TEMP_DIR=".tmp-dev-env"
TARGETS=(".devcontainer" ".vscode")

# ─── Validación de parámetros ────────────────────────────────

if [[ -z "$1" ]]; then
    echo "❌ Error: Debes proporcionar la ruta del proyecto ESP-IDF."
    echo "ℹ️  Uso: $0 /ruta/al/proyecto [--update]"
    exit 1
fi

PROJECT_PATH=$(realpath "$1")

if [[ ! -d "$PROJECT_PATH" ]]; then
    echo "❌ Error: La ruta proporcionada no es un directorio válido."
    exit 1
fi

MODE="normal"
if [[ "$2" == "--update" ]]; then
    MODE="update"
fi

# ─── Acción principal ────────────────────────────────────────

echo "🚀 Configurando entorno de desarrollo para: $PROJECT_PATH"

if [[ "$MODE" == "update" ]]; then
    echo "🔁 Modo actualización activado"
    for dir in "${TARGETS[@]}"; do
        echo "🧹 Borrando $PROJECT_PATH/$dir..."
        rm -rf "$PROJECT_PATH/$dir"
    done
fi

echo "📥 Clonando plantilla desde $TEMPLATE_REPO..."
git clone --depth 1 --branch "$TEMPLATE_BRANCH" "$TEMPLATE_REPO" "$TEMP_DIR"

for dir in "${TARGETS[@]}"; do
    echo "📦 Copiando $dir a $PROJECT_PATH..."
    cp -r "$TEMP_DIR/$dir" "$PROJECT_PATH/"
done

echo "🧼 Eliminando temporales..."
rm -rf "$TEMP_DIR"

echo "✅ Entorno configurado correctamente en $PROJECT_PATH"
echo "💡 Abre el proyecto en VSCode y selecciona: 'Reopen in Container'"
