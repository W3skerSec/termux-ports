#!/data/data/com.termux/files/usr/bin/bash
# Compila o hydra modernizado (PT-BR + patch fdsan p/ Android) do fonte OFICIAL.
set -e
HERE="$(cd "$(dirname "$0")" && pwd)"
echo "[1/5] deps..."
pkg install -y git clang make openssl libssh zlib pcre2 libidn libxml2-utils
echo "[2/5] clone oficial..."
cd ~ && rm -rf thc-hydra
git clone --depth 1 https://github.com/vanhauser-thc/thc-hydra.git
cd thc-hydra
echo "[3/5] aplica patch (fdsan + ajuda PT-BR)..."
git apply "$HERE/hydra-ptbr.patch"
echo "[4/5] build + install..."
./configure --prefix="$PREFIX"
make -j"$(nproc)"
make install
echo "[5/5] man PT-BR..."
install -Dm644 "$HERE/hydra.1.pt" "$PREFIX/share/man/man1/hydra.1"
echo "OK -> hydra (PT-BR) instalado. Teste:  hydra  |  man hydra"
