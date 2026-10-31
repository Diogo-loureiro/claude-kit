# claude-kit

Framework pessoal para desenvolvimento agêntico com Claude Code: um agente por tarefa,
contexto mínimo e **verificações determinísticas** no lugar da revisão humana de código.
Como trabalhar no dia a dia: [PLAYBOOK.md](PLAYBOOK.md). Porquê de cada escolha: [docs/rationale-2026-10.md](docs/rationale-2026-10.md) (notas de pesquisa em [docs/research/](docs/research/)).

## Camadas e como cada uma chega aos projetos

| Camada | Onde | Propagação |
|---|---|---|
| Regras globais + skills `/spec` e `/ship` | `global/` → symlinks em `~/.claude` | `git pull` no kit (imediato) |
| Hooks, `scripts/check`, lint, CI do projeto | `template/` (Copier) | PR semanal automático (`kit-update`) em cada projeto |
| Testes do próprio kit | `.github/workflows/kit-ci.yml`, `tests/` | todo push |

`scripts/check` é a única fonte dos checks: os hooks do agente, o pre-commit e o CI chamam o mesmo script.

## Instalar (uma vez por máquina)

```bash
uv tool install copier
git clone https://github.com/Diogo-loureiro/claude-kit ~/Projetos/claude-kit
~/Projetos/claude-kit/install.sh
```

## Projeto novo

```bash
copier copy --trust gh:Diogo-loureiro/claude-kit ~/Projetos/meu-projeto   # pergunta nome e stack
cd ~/Projetos/meu-projeto
git add -A && git commit -m "chore: scaffold from claude-kit"
gh repo create meu-projeto --private --source . --push
```
Primeira sessão no projeto: peça ao Claude para preencher o `CLAUDE.md` (regras de domínio) e,
se a stack ainda não foi decidida, troque depois com `copier update --trust -d stack=py` (ou `ts`).
Depois que tiver a stack, instale o LSP: `/plugin install pyright-lsp@claude-plugins-official` (ou `typescript-lsp`).

## Projeto existente

```bash
cd projeto && copier copy --trust gh:Diogo-loureiro/claude-kit .   # arquivos do projeto não são sobrescritos
```

## Melhorar o kit (e levar a todos os projetos)

1. Mude aqui, nunca direto num projeto. Arquivos do kit são bloqueados para o agente nos projetos.
2. Se a mudança afeta o comportamento do agente, rode antes os evals (`evals/`) e compare custo e acerto.
3. Atualize o `CHANGELOG.md`, commit, `git tag vX.Y.Z && git push --tags`. O `kit-ci` precisa estar verde.
4. Na segunda seguinte cada projeto recebe um PR `chore: update claude-kit to vX.Y.Z`
   (ou rode na hora: aba Actions → kit-update → Run workflow). CI verde → merge.

Versões: patch/minor = ajuste compatível; major = exige ação no projeto (explique no CHANGELOG).
A cada nova geração de modelo, rode os evals e **remova** o que deixou de fazer diferença.

## Arquivos: de quem é cada um

- **Do kit** (atualizados pelo `copier update`; bloqueados para o agente): `.claude/settings.json`,
  `scripts/check`, `scripts/agent/*`, `.githooks/*`, `.github/workflows/*`, `ruff.toml`, `biome.json`.
- **Do projeto** (criados uma vez, nunca sobrescritos): `CLAUDE.md`, `README.md`, `pyproject.toml`,
  `package.json`, `tsconfig.json`, `src/`, `tests/`, `docs/`, `scripts/check.d/*.sh`.
