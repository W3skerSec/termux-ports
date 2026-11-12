<div align="center">

<img src="https://img.shields.io/badge/Termux-000000?style=for-the-badge&logo=gnometerminal&logoColor=white" alt="Termux"/>
<img src="https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white" alt="Android"/>
<img src="https://img.shields.io/badge/ARM64-aarch64-blue?style=for-the-badge&logo=arm&logoColor=white" alt="ARM64"/>
<img src="https://img.shields.io/badge/Build-from%20source-orange?style=for-the-badge&logo=gnu" alt="from source"/>

# 🔧 Termux Ported Libs

### Bibliotecas C/C++/Vala portadas e compiladas **nativamente** para o Termux

Cada port documentado: dependências · processo de build · pacote `.deb` · notas de ABI · **sem gambiarra de linkagem**

[![No TUR](https://img.shields.io/badge/TUR-N%C3%A3o-red?style=flat-square)](https://github.com/W3skerSec/termux-ported-libs)
[![Native](https://img.shields.io/badge/Build-Nativo%20ARM64-brightgreen?style=flat-square&logo=arm)](https://github.com/W3skerSec/termux-ported-libs)
[![License](https://img.shields.io/badge/Licen%C3%A7a-por%20lib-yellow?style=flat-square)](#licenças)

</div>

---

## 🎯 Por que este repositório?

Muita gente trava no Termux e desiste, ou apela pra **proot** / **TUR** / gambiarra de `LD_PRELOAD`. Aqui a regra é outra:

> **Nunca aceitar "Não Existe" como resposta.** Se a lib é software livre, ela compila no ARM64 — é só resolver as dependências direito e empacotar certo.

Cada lib aqui foi **compilada do fonte no próprio Termux** (bionic libc, aarch64), empacotada como `.deb` instalável e documentada do zero: o que faltava, como buildar, e por que funciona. O que builda hoje continua buildando.

---

## 📦 Matriz de Libs Portadas

| Lib | Versão | Arquitetura | Instalação | Finalidade Técnica |
|:---|:---:|:---:|:---|:---|
| 🪟 **Plank** | `0.11.89` | `aarch64` | `dpkg -i plank/plank_0.11.89_aarch64.deb` | Dock leve (elementaryOS/XFCE), em Vala. Build do fonte com bamf + libwnck + libgee + dbusmenu. **Ver nota ⚠️ abaixo.** |

> ⚠️ ** 

*( [Como contribuir um port](#-como-portar-uma-lib-metodologia).)*

---

## 🛠️ Como portar uma lib (metodologia)

O mesmo roteiro que gerou o plank. Serve pra qualquer lib C/C++/Vala com autotools ou meson.

### 1. Levantar as dependências (antes de qualquer build)
```bash
# as libs existem no repo do Termux?
for m in gtk+-3.0 gee-0.8 libwnck-3.0 libbamf3 dbusmenu-gtk3-0.4; do
  pkg-config --exists "$m" && echo "$m OK ($(pkg-config --modversion $m))" || echo "$m FALTA"
done
# as bindings Vala (.vapi) existem?
dpkg -L <pacote> | grep '\.vapi$'
```
Regra de ouro: **habilite o `x11-repo`** (`pkg install x11-repo`) — metade das libs gráficas mora lá.

### 2. Clonar e configurar
```bash
git clone --depth 1 <fonte>
cd projeto
# autotools:
./autogen.sh --prefix=$PREFIX --disable-apport --disable-docs
# ou meson:
meson setup build --prefix=$PREFIX && ninja -C build
```
Dicas Termux: `.vapi` vivem em `$PREFIX/share/vala/vapi` → `export VALAFLAGS="--vapidir=$PREFIX/share/vala/vapi"`. E **nada de `/tmp`** (não é gravável) — use `$TMPDIR`.

### 3. Compilar e instalar num staging
```bash
make -j$(nproc)
make install DESTDIR=$HOME/stage   # não suja o $PREFIX; captura os arquivos
```

### 4. Empacotar como `.deb`
```bash
mkdir -p stage/DEBIAN && chmod 755 stage/DEBIAN
# Depends = ldd/readelf -d do binário → dpkg -S de cada .so
cat > stage/DEBIAN/control <<EOF
Package: <nome>
Version: <ver>
Architecture: $(dpkg --print-architecture)
Depends: <libs>
Description: <...>
EOF
dpkg-deb --build --root-owner-group stage <nome>_<ver>_aarch64.deb
```

---

## 📥 Instalação dos `.deb`

```bash
git clone https://github.com/W3skerSec/termux-ported-libs
cd termux-ported-libs
dpkg -i plank/plank_0.11.89_aarch64.deb
# resolve dependências se faltar algo:
apt-get install -f -y
```

## 🧩 Ambiente glibc (pré-requisito, não é port nosso)

Alguns binários exigem o **glibc do Termux** (loader `ld-linux-aarch64.so.1`) — ex: o
[Antigravity CLI](https://github.com/wallentx/antigravity-cli-termux) (`agy`). Isso **não**
é re-hospedado aqui: vem do **glibc-repo oficial** do Termux. Habilite com:

```bash
bash glibc/setup-glibc.sh
# ou manualmente:
pkg install -y glibc-repo && pkg update && pkg install -y glibc glibc-runner
```

Erro típico sem isso: `Missing Termux glibc loader: .../glibc/lib/ld-linux-aarch64.so.1`.

## Licenças

Cada lib mantém a licença do seu projeto upstream (Plank: GPL-3.0). Este repositório apenas empacota builds nativos; os créditos são dos autores originais.
