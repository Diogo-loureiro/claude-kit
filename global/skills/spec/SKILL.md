---
name: spec
description: Transforma um pedido grande ou crítico (dinheiro, auth, importação, schema) em spec curta com tabela de exemplos e testes de aceitação que falham. O humano aprova os exemplos, não o código.
disable-model-invocation: true
argument-hint: <feature>
---

# Spec: $ARGUMENTS

O humano aprova **intenção** (exemplos concretos), nunca código. O produto desta skill é executável.

1. Leia só o necessário: CLAUDE.md do projeto e os módulos relacionados (LSP ou grep, por trecho).
2. Faça de uma vez as perguntas (no máximo 5) sobre decisões que o código não responde.
   Sem humano disponível: registre em "Suposições" e siga a opção mais conservadora.
3. Escreva `docs/specs/<feature>.md` com no máximo 60 linhas:
   - **Objetivo** (1–3 frases) e **Fora de escopo**
   - **Exemplos**: tabela `cenário | entrada | resultado esperado`. Inclua bordas: zero, negativo,
     arredondamento, duplicado, fuso horário/virada de mês, entrada inválida.
   - **Invariantes** (viram property tests), **Decisões** e **Suposições**
4. Escreva um teste por linha da tabela em `tests/acceptance/` e rode-os: todos devem **falhar**
   agora pelo motivo certo (mostre a saída).
5. Pare. Mostre a tabela e peça aprovação. O humano aprova commitando:
   `git add docs/specs tests/acceptance && git commit -m "spec: <feature>"`. Commitado = travado.
6. Diga o próximo passo: `/clear` e então
   `/goal os testes em tests/acceptance/<feature>* e scripts/check stop passam`.
