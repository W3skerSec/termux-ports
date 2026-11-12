#!/data/data/com.termux/files/usr/bin/bash
# Habilita o ambiente glibc do Termux (loader ld-linux-aarch64.so.1 + runner).
# Pre-requisito pra rodar binarios glibc no Termux (ex: Antigravity CLI / agy).
# Fonte: glibc-repo OFICIAL do Termux (nao re-hospedamos binarios de terceiros).
set -e

echo "[1/3] Habilitando o glibc-repo oficial..."
pkg install -y glibc-repo
pkg update -y

echo "[2/3] Instalando glibc + runner (fornece o loader que falta)..."
pkg install -y glibc glibc-runner

echo "[3/3] Verificando o loader..."
LOADER="$PREFIX/glibc/lib/ld-linux-aarch64.so.1"
if [ -f "$LOADER" ]; then
    echo "OK -> loader presente: $LOADER"
    echo "Pronto. Binarios glibc ja podem rodar (ex: instalador do Antigravity)."
else
    echo "ERRO: loader ainda ausente ($LOADER)."
    echo "Verifique mirror/rede: pkg update && pkg install glibc"
    exit 1
fi
