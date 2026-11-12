# hydra — PT-BR nativo (Termux/ARM64)

thc-hydra recompilado do fonte oficial com dois patches:

- **fdsan** — corrige o abort do Bionic (double-close de fd) no carregamento das
  wordlists via zlib. Sem isso o hydra crasha no Android. Fix: `dup()` do fd pro zlib.
- **ajuda + man em PT-BR** — `hydra`, `hydra -h` e `man hydra` em português.

## Instalar
```bash
bash BUILD.sh
```
Clona o thc-hydra oficial, aplica `hydra-ptbr.patch`, compila e instala (+ man PT).

## Usar
```bash
hydra        # sintaxe e opcoes em PT-BR
hydra -h     # ajuda completa
man hydra    # manual detalhado
```

Base do patch: upstream `4c5bf65`. Licenca do hydra: AGPL-3.0 (van Hauser / THC).
