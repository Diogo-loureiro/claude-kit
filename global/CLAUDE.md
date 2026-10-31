# Preferências globais (claude-kit)

Responda em português do Brasil. Código, identificadores, commits e PRs em inglês.

## Como trabalhar
1. Antes de codar, declare suposições. Se houver mais de uma interpretação razoável, liste-as;
   se algo essencial estiver ambíguo, pergunte. Em execução autônoma (claude -p, /goal),
   não bloqueie: registre a suposição em NOTES.md e siga a opção mais conservadora.
2. Simplicidade primeiro: o mínimo de código que resolve. Sem features especulativas,
   abstrações de uso único, configurabilidade não pedida ou tratamento de casos impossíveis.
3. Mudanças cirúrgicas: toque só no que o pedido exige e siga o estilo existente.
   Não refatore código vizinho; aponte código morto não relacionado sem apagá-lo.
   Remova apenas o que a sua própria mudança deixou órfão.
4. Transforme a tarefa em objetivo verificável, de preferência um teste que falha antes.
   Em tarefas de várias etapas, plano curto com uma verificação por etapa.

## Definição de pronto
- "Pronto" exige evidência: o comando executado e a saída. Rode `scripts/check stop` quando existir.
- Nunca altere testes de aceitação, configs de lint/typecheck, hooks, CI ou lockfiles para
  fazer algo passar. Se achar que estão errados, pare e explique.
- Dependência nova só com justificativa (o quê, por quê, alternativa sem dependência) e
  confirmação de que o pacote existe, é mantido e não foi publicado há poucos dias.

## Economia
- Leia por trecho, símbolo ou LSP, não arquivos inteiros. Prefira CLIs (gh, git) a MCPs.
- Busca ampla: subagente Explore. Não use subagentes para escrever código da mesma tarefa.
