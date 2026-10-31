---
name: ship
description: Fecha uma tarefa - roda todos os checks, revisa o diff em contexto novo, commita e abre PR com evidência.
disable-model-invocation: true
---

# Ship

1. Rode `scripts/check ci`. Se falhar, corrija (no máximo 2 tentativas); senão pare e relate.
2. Revise o diff com a skill `code-review` (contexto novo): correção contra a spec, ignore estilo.
   Corrija só os achados de alta confiança e rode o passo 1 de novo.
3. Se o diff toca dinheiro, auth, parsing, importação ou I/O: rode também `security-review`.
4. Se estiver na `main`, crie a branch: `git switch -c <feat|fix|chore>/<slug>`.
   Commit no formato Conventional Commits, em inglês.
5. `git push -u origin HEAD` e `gh pr create` com o corpo:
   **O quê** / **Por quê** / **Evidência** (comandos + últimas linhas da saída) / **Riscos** / link da spec.
6. Responda com a URL do PR. Não faça merge.
