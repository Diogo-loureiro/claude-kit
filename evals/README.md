# Evals do kit (a fazer: v0.2)

Objetivo: saber se uma mudança no kit (regra no CLAUDE.md, hook, skill) **melhora ou piora**
acerto e custo, em vez de decidir por opinião. Recomendação da Anthropic (out/2026): 10 exemplos
"de ouro" bastam para começar, e cada um deve rodar mais de uma vez por causa da variância.

Plano:
1. Quando o App_financas tiver código, escolher ~10 tarefas reais e pequenas (1 bug, 1 feature,
   1 regra de dinheiro, 1 importação...), cada uma com testes de aceitação que definem "certo".
2. `evals/run.sh`: para cada tarefa, worktree limpa no commit-base, então
   `claude -p "<prompt>" --max-turns 40 --max-budget-usd 2 --output-format json`, 2 execuções;
   registrar se os testes passam, custo e turnos.
3. Rodar antes de cada tag que mude o comportamento do agente; anotar o resultado no CHANGELOG.
