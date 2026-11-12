#!/data/data/com.termux/files/usr/bin/bash
# Reproduz o port do Plank 0.11.89 para Termux/ARM64, do fonte, e gera o .deb.
# Uso: bash BUILD.sh   (roda no proprio Termux)
set -e

WORK="$HOME/port-plank"
VER="0.11.89"

echo "[1/5] Dependencias (x11-repo + build + libs)..."
pkg install -y x11-repo
pkg update -y
pkg install -y valac meson ninja pkg-config clang autoconf automake libtool \
    gtk3 libgee libwnck bamf libdbusmenu glib libcairo libx11 \
    gettext intltool libxml2-utils gnome-menus || true

echo "[2/5] Clonando o fonte..."
rm -rf "$WORK"; mkdir -p "$WORK"; cd "$WORK"
git clone --depth 1 https://github.com/ricotz/plank.git
cd plank

echo "[3/5] Configurando (autotools)..."
export VALAFLAGS="--vapidir=$PREFIX/share/vala/vapi"
export CFLAGS="-Wno-implicit-function-declaration -Wno-incompatible-pointer-types"
./autogen.sh --prefix="$PREFIX" --disable-apport --disable-docs --disable-benchmark --disable-static

echo "[4/5] Compilando..."
make -j"$(nproc)"

echo "[5/5] Instalando em staging e empacotando .deb..."
rm -rf "$WORK/stage"
make install DESTDIR="$WORK/stage"
mkdir -p "$WORK/stage/DEBIAN"; chmod 755 "$WORK/stage/DEBIAN"
cat > "$WORK/stage/DEBIAN/control" <<EOF
Package: plank
Version: $VER
Architecture: $(dpkg --print-architecture)
Maintainer: W3skerSec <noreply@github.com>
Depends: gtk3, glib, libgee, libwnck, bamf, libdbusmenu, libcairo, libx11, libxi, libxfixes, gnome-menus
Section: x11
Priority: optional
Homepage: https://launchpad.net/plank
Description: Plank - the simplest dock (port nativo Termux/ARM64)
 Dock leve do elementaryOS/XFCE compilado nativamente para o Termux.
EOF
chmod 644 "$WORK/stage/DEBIAN/control"
cd "$WORK"
dpkg-deb --build --root-owner-group stage "plank_${VER}_$(dpkg --print-architecture).deb"
echo "OK -> $WORK/plank_${VER}_$(dpkg --print-architecture).deb"
echo "Instale com: dpkg -i plank_${VER}_*.deb  (ou use: pkg install plank-reloaded)"
