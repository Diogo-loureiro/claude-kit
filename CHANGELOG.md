# Changelog

## v0.1.2 (2026-10-31)
- CI do template: gitleaks instalado direto e rodado pelo `scripts/check ci` (obrigatório no CI). A action `gitleaks-action` falhava no primeiro push de repositório novo (commit raiz sem pai).

## v0.1.1 (2026-10-31)
- Template ts: Biome restrito a `src/` e `tests/` (versões novas também formatam Markdown e quebravam o CI).

## v0.1.0 (2026-10-31)
- Camada global: CLAUDE.md (regras do Karpathy adaptadas ao modo autônomo), deny de segredos,
  skills `/spec` e `/ship`, `install.sh` (symlinks + merge de settings sem sobrescrever valores seus).
- Template Copier (stack `none | py | ts`): `scripts/check fast|stop|ci`, hooks PreToolUse (guard),
  PostToolUse (format) e Stop (gate com no máximo 3 bloqueios seguidos), pre-commit, CI com gitleaks
  e gates `harness-approved` / `deps-approved`, workflow semanal `kit-update`.
- `kit-ci`: shellcheck + geração de projeto por stack + testes de comportamento dos hooks.
