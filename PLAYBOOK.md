# Playbook: como trabalhar com o claude-kit

A ideia em uma frase: **você define o que é "certo" com exemplos; o agente faz; verificações
automáticas decidem se está pronto.** Você não revisa código; revisa intenção.

## O ciclo de uma tarefa

1. **Uma tarefa = uma sessão.** Abra o Claude no projeto. Ao terminar, `/clear`.
2. **Peça em 4 partes**, curto (veja abaixo).
3. O agente trabalha. A cada edição o arquivo é formatado; ao final do turno o `Stop hook`
   roda `scripts/check stop` e não o deixa parar enquanto algo falha.
4. `/ship` → checks completos, revisão em contexto novo, commit e PR com evidência.
5. O CI roda os mesmos checks + segredos + gates. Você olha **o resumo do PR**, não o código.
6. **Valide rodando** antes do merge: use a funcionalidade de verdade (mande o input real, veja a
   saída). Testes provam o que você especificou; usar prova que era isso que você queria.
   É assim que você "segura o volante" sem ler código.

## Prompts: curtos, com critério de pronto

Não precisa de prompt gigante. As regras permanentes já estão no CLAUDE.md, nos hooks e no CI;
o prompt só diz **o que muda agora**. Use as 4 partes (uma linha cada basta):

```
Objetivo: <o que o usuário passa a conseguir fazer>
Abordagem: <se você já tem preferência; senão omita>
Não quero: <limites: sem dependência nova, não mexer em X>
Pronto quando: <teste/comando/comportamento verificável>
```

Exemplo real:
```
Objetivo: importar extrato OFX do Nubank para a conta escolhida.
Não quero: dependência nova sem me perguntar; mexer no cálculo de saldo.
Pronto quando: importar o mesmo arquivo 2x não duplica transações e scripts/check stop passa.
```

Prompt longo só faz sentido como **spec** (abaixo), e quem escreve a spec é o agente, entrevistando você.

## Por tamanho de tarefa

| Tamanho | Como pedir | O que você aprova |
|---|---|---|
| Trivial (typo, config, bug de 1 arquivo) | Prompt direto, 1–2 linhas | Nada: hooks + CI |
| Médio (feature de 2–10 arquivos) | 4 partes; "comece por um teste que falha" | O PR (resumo + evidência) |
| Grande/crítico (dinheiro, auth, importação, schema) | `/spec <feature>` → aprovar → `/clear` → `/goal os testes de aceitação e scripts/check stop passam` | **A tabela de exemplos** (commit = trava) |
| Mecânico em massa (renomear em 40 arquivos) | `/model sonnet` numa sessão própria, ou `/batch` | CI verde |

Tarefas grandes: `Shift+Tab` (plan mode) antes de codar ajuda a ver o plano em 10 linhas.

## As 3 coisas que só você decide
1. **Exemplos de aceitação** (o que é certo). Commitar `tests/acceptance/` = aprovar.
2. **Dependências novas**: o CI exige o label `deps-approved` no PR.
3. **Mudanças no harness** (hooks, lint, CI, testes aprovados): label `harness-approved`.
   Para você mesmo editar esses arquivos numa sessão: `KIT_UNLOCK=1 claude`.

## Comandos do dia a dia
- `/clear` entre tarefas · `/rewind` para desfazer um caminho ruim · `/btw` para pergunta paralela
- `/effort low|medium|high` (padrão: medium; high só para bug difícil ou código desconhecido)
- `/usage` e `/context`: custo e o que está ocupando contexto
- Duas correções sem sucesso? `/clear` e um prompt melhor, em vez de insistir.

## Isso é "loop engineering"?
Em parte, e na dose certa:
- **Loop interno** (agente ↔ verificações): o Stop hook e o `/goal` fazem o agente iterar até
  os checks passarem. Isso é harness engineering, e é o que mais rende.
- **Loop externo** (agendado): o workflow `kit-update` toda segunda e, no futuro, rotinas
  estreitas (ex.: triagem de PRs do Renovate). Sempre com condição de parada verificável e teto de custo.
- **O que evitamos**: loop aberto ("construa o app durante a noite"), fábrica de vários agentes
  e subagentes por especialidade. Gastam muito mais tokens sem ganho comprovado para quem trabalha sozinho.

## Mais agentes ou mais estrutura? (para o seu trabalho e para apps agênticos)
Checklist da Anthropic ("Common workflow patterns", mar/2026), na ordem:
1. Um agente só dá conta? **Pare aqui** (é o caso quase sempre).
2. Há dependências claras entre etapas? Fluxo **sequencial**.
3. Subtarefas independentes e velocidade importa? **Paralelo**, com a forma de juntar os resultados decidida antes.
4. Refinar melhora a qualidade de forma **mensurável**? **Avaliador-otimizador**, com limite de
   iterações. Se um linter ou teste resolve, use-o em vez de um agente avaliador.

Mantenha sempre a versão de um agente só como linha de base para provar que a estrutura extra ajuda.

## Rotina de custo
- **Diária:** olhar `/usage`.
- **Semanal:** `npx ccusage@latest`; podar plugins "Not used recently".
- **Mensal:** `/doctor prompt-audit`; levar ao kit os erros repetidos (seção "Armadilhas" de cada projeto).
- Se o limite apertar: `/clear` mais cedo → effort menor → Sonnet no mecânico → só então plano maior.

## Melhorar o framework
Toda melhoria nasce **no claude-kit**, nunca direto num projeto. Veja o README do kit.
