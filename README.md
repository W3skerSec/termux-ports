<div align="center">

<img src="https://img.shields.io/badge/Termux-000000?style=for-the-badge&logo=gnometerminal&logoColor=white" alt="Termux"/>
<img src="https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white" alt="Android"/>
<img src="https://img.shields.io/badge/ARM64-aarch64-blue?style=for-the-badge&logo=arm&logoColor=white" alt="ARM64"/>

# 🔧 Termux Ports

### Ports nativos pra Termux (ARM64), organizados por categoria

Cada port é **receita + patch** (compila do fonte oficial) — não re-hospeda software de terceiros. Sem TUR, sem gambiarra.

</div>

---

## 🛠️ Ferramentas

| Ferramenta | Versão | Instalação | O que é |
|:---|:---:|:---|:---|
| **hydra** | `v9.8dev` | `bash tools/hydra/BUILD.sh` | Login cracker (THC). Recompilado + **patch fdsan** (roda no Android) + ajuda e `man` em **PT-BR**. |

## 🖥️ Apps (desktop)

| App | Versão | Instalação | O que é |
|:---|:---:|:---|:---|
| **plank** | `0.11.89` | `dpkg -i apps/plank/plank_0.11.89_aarch64.deb` | Dock (elementaryOS/XFCE) compilado do fonte. ⚠️ Para uso normal, prefira `pkg install plank-reloaded` (nome oficial no x11-repo). |

## 🧩 Runtime / Ambiente

| Item | Instalação | O que é |
|:---|:---|:---|
| **glibc** | `bash runtime/glibc/setup-glibc.sh` | Habilita o glibc do Termux (loader `ld-linux-aarch64.so.1`) do **glibc-repo oficial**. Pré-requisito pra binários glibc (ex: Antigravity CLI). |

---

## 🛠️ Como portar (metodologia)

O mesmo roteiro usado aqui, pra qualquer lib/ferramenta C/C++/Vala:

1. **Deps**: `pkg-config --exists <modulo>` pra ver o que existe; habilite `x11-repo` pras libs gráficas.
2. **Fonte oficial**: `git clone` + `./configure` (autotools) ou `meson setup` (meson).
   Dicas Termux: `.vapi` em `$PREFIX/share/vala/vapi`; **nunca** `/tmp` (use `$TMPDIR`).
3. **Patch** (se precisar de ajuste p/ Android): gere com `git diff > nome.patch`.
4. **Build + pacote**: `make -j$(nproc)`; empacote com `make install DESTDIR=stage` + `dpkg-deb`,
   ou um `BUILD.sh` que aplica o patch e instala.

Antes de portar, cheque se já não existe sob outro nome (ex: plank → `plank-reloaded`).

## Licenças

Cada port mantém a licença do projeto upstream (hydra: AGPL-3.0; plank: GPL-3.0; glibc: LGPL).
Este repositório só distribui **receitas, patches e builds** — créditos aos autores originais.
