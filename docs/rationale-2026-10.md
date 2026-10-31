# Troque cerimônia por sensores determinísticos

Para um dev solo em 2026, o framework agêntico mais barato e confiável tem cinco peças: **um agente forte numa sessão por tarefa** (Opus 5.5 em effort *medium*, o padrão oficial), **contexto mínimo** (CLAUDE.md curto, `/clear` entre tarefas, cache preservado), **specs leves proporcionais ao tamanho da tarefa**, **sensores determinísticos** que substituem a revisão humana (hooks, lint, typecheck, testes, SAST, gates de dependência) e **poucos plugins**. Multi-agente, loops abertos, frameworks pesados de SDD e pacotes de dezenas de skills consomem tokens sem evidência de ganho para quem trabalha sozinho. A Anthropic, os estudos independentes e praticantes céticos como Fabio Akita convergem no essencial: verificação executável é a maior alavanca de qualidade, e cada token extra de contexto ou de agente adicional custa dinheiro e às vezes custa acurácia. Isso importa ainda mais porque você não vai revisar código. Nesse cenário, a qualidade precisa vir do pipeline e não do modelo: mesmo os melhores modelos de 2026 passam em apenas **~56–68% das tarefas sem introduzir vulnerabilidade conhecida** ([Veracode](https://www.veracode.com/news/llms-are-getting-smarter-but-not-safer-veracode-2026-genai-code-security-report-finds-ai-generated-code-security-has-stalled-at-56%25-pass-rate/)). Sua revisão passa a ser de **intenção**: você aprova critérios de aceitação, dependências novas e mudanças no próprio harness. Para distribuir o padrão, recomendo **um único repositório `claude-kit`** contendo a camada global (`~/.claude`), um marketplace pessoal de plugins, um template Copier com `copier update`, workflows de CI reutilizáveis e um preset do Renovate. O App_financas é o primeiro consumidor. O plano de adoção leva quatro semanas.

> **Legenda de evidência usada no texto:** **[Doc]** documentação oficial da Anthropic (vinculante sobre o produto, mas sem estudo controlado); **[Vendor]** alegação de fornecedor ou autor de ferramenta (viés comercial); **[Estudo]** pesquisa independente ou revisada por pares; **[Anedota]** relato de praticante, blog ou fórum. Onde as fontes conflitam, o texto diz.

## O mercado e a Anthropic convergem em um agente, contexto mínimo e verificação

**O que o mercado usa em 2026.** O Claude Code virou a ferramenta agêntica dominante: **65,5%** dos 12.255 respondentes da pesquisa Stack Overflow 2026 o usaram no último ano, contra 58,7% do Copilot, 29,5% do Codex e 25,5% do Cursor [Estudo/survey] ([Stack Overflow 2026](https://survey.stackoverflow.co/2026/ai/data/ai-code-agent)). A JetBrains reporta 39% de uso no trabalho, mas esse número vem de resumo secundário que não verifiquei ([syntior](https://www.syntior.com/updates/ai-coding-agents-developer-surveys-2026)). Arquivos de contexto viraram padrão de fato: o AGENTS.md foi doado à Agentic AI Foundation da Linux Foundation em dezembro de 2025, com 40 mil ou mais projetos usando ([OpenAI](https://openai.com/index/agentic-ai-foundation/)). Popularidade, porém, não é evidência de eficácia. Os repositórios mais estrelados do ecossistema são o Superpowers (~310 mil estrelas), o "CLAUDE.md do Karpathy" (~227 mil), o Spec Kit (~144 mil) e o BMAD (~55 mil). Nenhum deles tem benchmark independente de custo ou qualidade ([GitHub superpowers](https://github.com/obra/superpowers); [GitHub spec-kit](https://github.com/github/spec-kit)). O movimento real é outro. O SDD pesado (Spec Kit, Kiro, BMAD) está perdendo espaço para plano leve e revisão do plano ("SDD morreu, viva o plan mode") [Anedota] ([Instil](https://instil.co/blog/spec-driven-development-is-dead-long-live-plan-mode)). Paralelismo extremo, como o Gas Town de Steve Yegge com 20–30 instâncias e **~US$100/hora**, é tratado como curiosidade [Anedota] ([danielvaughan](https://codex.danielvaughan.com/2026/04/08/gas-town-multi-agent-factory/)). Simon Willison, que roda agentes em paralelo, aponta que o gargalo é revisar a saída deles ([simonwillison.net](https://simonwillison.net/2025/Oct/5/parallel-coding-agents/)). Assinatura domina a API para uso interativo pesado. Pelos relatos de terceiros, o Max 5x virou "Max" (US$100) e o Max 20x virou "Ultra" (US$200) em 30/10/2026, e os planos agora incluem créditos de API [Anedota/imprensa] ([CellCog](https://cellcog.ai/blog/claude-max-ultra-rename/)). A alegação de que o Codex gasta 2–4× menos tokens que o Claude Code é anedótica ([hongkiat](https://www.hongkiat.com/blog/codex-vs-claude-code-2026/)).

**O que a Anthropic recomenda hoje.** A documentação atual do Claude Code substitui explicitamente o post de boas práticas de abril de 2025 [Doc] ([Best practices](https://code.claude.com/docs/en/best-practices)). Os princípios: escrever um CLAUDE.md **curto (<200 linhas)** só com o que o modelo não infere do código (comandos exatos de teste, typecheck e lint, armadilhas, decisões fora do repo, "o que você já corrigiu duas vezes"); dar ao agente **um check executável** ("sem isso, você é a suíte de testes") e pedir **evidência** (comando e saída); colocar em **hook** o que não pode ter exceção ("se você continua enfatizando uma linha do CLAUDE.md e o Claude ainda erra, ela pertence a um hook"); entrevistar o usuário até escrever um **SPEC.md** e construir em sessão nova; usar `/code-review` num subagente novo que nunca viu a conversa, instruído a ignorar estilo ("skip style"); e, depois de duas correções fracassadas, rodar `/clear` e escrever um prompt melhor. A mesma página lista o que **parar de fazer**: gerenciar contexto agressivamente ("a maioria dos modelos atuais tem janela de 1M e compacta sozinha"), usar subagentes "para proteger o contexto" ou "para uma resposta melhor", ÊNFASE EM MAIÚSCULAS, frases como "think hard" (use o *effort*), "não seja preguiçoso" e descrever arquitetura e layout de arquivos no CLAUDE.md [Doc] ([Best practices](https://code.claude.com/docs/en/best-practices)). Por trás de tudo está o princípio de 2024: "encontre a solução mais simples possível e só aumente a complexidade quando necessário" ([Building effective agents](https://www.anthropic.com/engineering/building-effective-agents)).

**Modelos e preços (verificados na página oficial em 31/10/2026)** [Doc] ([Pricing](https://platform.claude.com/docs/en/about-claude/pricing); [Models overview](https://platform.claude.com/docs/en/about-claude/models/overview)):

| Modelo | Input /MTok | Leitura de cache | Output /MTok | Papel recomendado |
|---|---|---|---|---|
| Fable 5.1 | US$10 | US$0,25 | US$50 | Só sob demanda: causa raiz difícil, decisão de arquitetura ambígua |
| **Opus 5.5** | **US$4** | **US$0,20** | **US$20** | **Padrão do Claude Code**, effort padrão *medium* |
| Sonnet 5.5 | US$2 | US$0,10 | US$10 | Trabalho mecânico em lote, menor custo |
| Haiku 5.5 (≤100k) | US$0,10 | US$0,01 | US$0,50 | Subagentes simples; o Explore já usa Haiku |

A escrita em cache custa 1,25× o input (TTL de 5 min) ou 2× (TTL de 1 h). O Batch dá 50% de desconto. Todos os modelos têm 1M de contexto, e o tokenizador dos modelos 4.7+ gera **~30% mais tokens** para o mesmo texto ([Pricing](https://platform.claude.com/docs/en/about-claude/pricing)). **Conflito dentro da própria documentação:** a página de custos diz para "reservar Opus" para arquitetura e usar Sonnet na maioria das tarefas, enquanto a de boas práticas diz que "o Opus 5.5 padrão lida bem com a maior parte do código" ([Costs](https://code.claude.com/docs/en/costs); [Best practices](https://code.claude.com/docs/en/best-practices)). A explicação provável é o corte de preço do Opus 5.5 para US$4/US$20, que deixou o Opus só 2× mais caro que o Sonnet. Há outra divergência: o effort padrão do Sonnet 5.5 é *high* na API e *medium* no Claude Code ([Model config](https://code.claude.com/docs/en/model-config)).

## Os estudos punem tokens extras, não verificação

Os estudos independentes contradizem a intuição de que gastar mais compra qualidade. A tabela resume o que sustenta cada regra do framework.

| Achado | Número | Força | Fonte |
|---|---|---|---|
| Agentes gastam muito mais tokens que chat | ~4× (agente), ~15× (multi-agente) | Vendor (interno) | [Anthropic](https://www.anthropic.com/engineering/multi-agent-research-system) |
| Multi-agente piora tarefas sequenciais | 180 configurações; erros amplificados até **17,2×** | Estudo | [Google/DeepMind/MIT](https://arxiv.org/abs/2512.08296) |
| Gasto de tokens varia muito e não compra acurácia | até **30×** entre execuções da mesma tarefa; input domina o custo | Estudo | [Microsoft/Stanford](https://arxiv.org/abs/2604.22750) |
| Modelos e esforços mais caros raramente estão na fronteira de Pareto | mais *reasoning effort* reduziu a acurácia na maioria das execuções | Estudo (ICLR 2026) | [HAL](https://arxiv.org/abs/2510.11977) |
| Overthinking derruba resolução | o1 high: 29,1% a ~US$1.400; low: 21% a ~US$400 | Estudo (2025) | [Cuadron](https://arxiv.org/abs/2502.08235) |
| Contexto longo degrada todos os modelos | 18 LLMs; 11 de 13 caem à metade em 32K | Estudo | [Chroma](https://trychroma.com/research/context-rot); [NoLiMa](https://arxiv.org/html/2502.05167v3) |
| Mascarar observações antigas basta | ~50% mais barato, solve rate igual ou maior que sumarização por LLM | Estudo | [Complexity Trap](https://arxiv.org/abs/2508.21433) |
| Cache estável corta custo | 41–80% de economia | Estudo (não revisado) | [Don't Break the Cache](https://arxiv.org/abs/2601.06007) |
| Arquivos de contexto quase não ajudam | gerados por LLM: −0,5 a −2% de sucesso e **+20% de custo**; escritos à mão: ~+4% | Estudo (ICLR 2026) | [ETH Zurich](https://arxiv.org/html/2602.11988v1) |
| Testes corretos são a maior alavanca | **94,3%** no SWE-bench Verified com testes humanos vs 69,8% com testes autogerados | Estudo | [TDFlow](https://arxiv.org/abs/2510.23761) |
| Leitura de arquivos domina tokens | **>70%** dos tokens (Sonnet 4.5) | Estudo | [SWE-Pruner Pro](https://huggingface.co/papers/2607.18213.md) |

Juntos, esses estudos apontam **contexto pequeno e verificação forte** como a combinação de menor custo por tarefa resolvida. Há um **conflito com a documentação**. A Anthropic diz que contexto "raramente é o problema" porque a janela tem 1M e a compactação é automática ([Best practices](https://code.claude.com/docs/en/best-practices)). Os estudos (Chroma 2025, LOCA-bench 2026) mostram que a qualidade cai conforme o contexto cresce ([LOCA-bench](https://arxiv.org/abs/2602.07962)). As duas coisas são verdade em planos diferentes: a janela deixou de ser o limite, a qualidade e o custo de input não. Então a prática continua sendo **uma tarefa por sessão** e `/clear` ao terminar. O cache torna barata a sessão longa *dentro* de uma tarefa, porque a leitura custa 0,05× o input no Opus e no Sonnet 5.5 ([Pricing](https://platform.claude.com/docs/en/about-claude/pricing)).

O efeito na produtividade é incerto e depende do contexto. O RCT do METR mediu **19% de lentidão** com ferramentas do início de 2025. O follow-up de 2026 sugere ganho, mas o próprio METR chama esse dado de "evidência muito fraca" ([METR](https://metr.org/blog/2026-02-24-uplift-update/)). O DORA 2025 descreve a IA como "amplificador": ela ajuda times com feedback rápido e arquitetura desacoplada e não ajuda os demais ([DORA](https://dora.dev/research/ai/)). A Faros, que é fornecedora, viu o tempo de revisão de PR subir **91%** nos times com alta adoção ([Faros](https://www.faros.ai/blog/ai-software-engineering)). Para você a lição é direta. Como você não revisa código, o gargalo vira a verificação automática, e é nela que vale investir.

## Harness vale; loop só com freio; SDD em dose proporcional

**Harness engineering** é projetar tudo em volta do modelo: docs-mapa, linters, testes, regras de arquitetura, scripts de init, arquivos de progresso, sandbox. Birgitta Böckeler (Thoughtworks) organizou o conceito em **guias** (feedforward: CLAUDE.md, specs, skills) e **sensores** (feedback). Os sensores *computacionais* (testes, lint, typecheck, testes estruturais) são baratos e determinísticos e devem rodar sempre. Os *inferenciais* (revisão por LLM) são caros e devem ser usados com parcimônia. Nas palavras dela, "só feedback leva a erros repetidos; só feedforward nunca verifica se as regras funcionaram" [Vendor/opinião especializada] ([martinfowler.com](https://martinfowler.com/articles/harness-engineering.html)). O caso mais citado é o da OpenAI: ~1M de linhas e ~1.500 PRs sem código escrito à mão, com AGENTS.md de ~100 linhas funcionando como mapa e arquitetura em camadas imposta por linters cujas mensagens dizem como corrigir. É **alegação de fornecedor, sem dados de custo** ([InfoQ](https://www.infoq.com/news/2026/02/openai-harness-engineering-codex)). A própria Anthropic mostra o preço: uma execução solo do Opus 4.5 custou **US$9 em 20 min e entregou a funcionalidade central quebrada**; o harness completo custou **US$200 em 6 h** e entregou um app funcional [Vendor] ([Anthropic](https://www.anthropic.com/research/harness-design-long-running-apps)). No mesmo post, a Anthropic **removeu peças do harness** (resets de contexto, sprints) conforme os modelos melhoraram. A regra que sai daí: revise o harness a cada geração de modelo e corte o que não sustenta resultado.

**Loop engineering** é o nível acima: sistemas que disparam o agente por agenda ou evento, com uma condição de parada verificável por máquina, estado persistente e verificador separado do executor. O termo se popularizou com Addy Osmani em junho de 2026, e o essay **não tem métrica nenhuma**. Osmani mesmo alerta para *comprehension debt* e *intent debt* e resume: "agentes rodam o loop interno; você é dono do externo" [Anedota] ([Osmani](https://addyosmani.com/blog/loop-engineering/)). O ancestral é o loop "Ralph" de Geoffrey Huntley (`while :; do cat PROMPT.md | claude; done`). As alegações de custo dele circulam só em blogs ([The Register](https://www.theregister.com/2026/01/27/ralph_wiggum_claude_loops)). A crítica mais útil: um loop só vale quando o sucesso é checável, a falha é acionável e o custo é limitado ([Piper Street](https://piperstreetsoftware.pages.dev/articles/ralph-loop-isnt-a-strategy.html)). Conclusão: **sem harness, loop só queima tokens.** O uso defensável é estreito: `/goal` com "testes e lint verdes", ou `claude -p` com `--max-turns` e `--max-budget-usd` ([Best practices](https://code.claude.com/docs/en/best-practices)).

**SDD ainda vale, na forma *spec-first* e em dose proporcional.** Böckeler separa três níveis: *spec-first* (spec da tarefa atual, que ela considera valioso), *spec-anchored* e *spec-as-source* (que ela pede cautela por combinarem "a rigidez do MDD com o não determinismo dos LLMs"). Nos testes dela, o Kiro gerou 4 user stories com 16 critérios de aceitação para um bugfix pequeno ("marreta para quebrar noz") ([martinfowler.com](https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html)). Uma comparação de um único autor mediu o Spec Kit gastando **~2× os tokens** do OpenSpec ([Medium](https://medium.com/it-chronicles/is-your-safe-choice-burning-your-budget-1cfddf8782e4)). Um benchmark de fornecedor (50 tickets) concluiu que a spec "se paga" em features e pipelines de dados, **não nos tickets pequenos** [Vendor] ([Uvik](https://uvik.net/spec-driven-development-benchmark/)). Se você já usava SDD, mantenha o hábito em features grandes e críticas, corte a cerimônia no resto e **mude o produto da spec**: em vez de markdown que envelhece, ela deve gerar **testes de aceitação executáveis**. É aí que SDD, harness e loop se encontram, porque o teste de aceitação é ao mesmo tempo o guia, o sensor e a condição de parada do loop. Depois do merge, descarte a spec ou incorpore o que restar em `docs/`.

**O "CLAUDE.md do Karpathy" não é do Karpathy.** O repositório `forrestchang/andrej-karpathy-skills` (que hoje redireciona para `multica-ai`, com ~227 mil estrelas) foi escrito por **Forrest Chang**, a partir de um post de Karpathy no X de 26/01/2026 sobre os vícios dos LLMs ao programar. **Karpathy é cofundador da OpenAI e ex-diretor de IA da Tesla, nunca trabalhou na Anthropic** ([GitHub](https://github.com/forrestchang/andrej-karpathy-skills); [The Decoder](https://the-decoder.com/former-tesla-ai-chief-andrej-karpathy-now-codes-mostly-in-english-just-three-months-after-calling-ai-agents-useless/)). O arquivo tem quatro regras: pensar antes de codar (declarar suposições, perguntar o que estiver ambíguo); simplicidade primeiro; mudanças cirúrgicas; execução orientada a objetivo verificável. **Não existe benchmark algum** do arquivo, e o README só lista sinais qualitativos. Pelo estudo da ETH, espere ganho marginal. As regras são baratas e boas, então vale incorporá-las em ~10 linhas do seu CLAUDE.md global, sem instalar o plugin. Ajuste a regra 1 para modo autônomo: quando não houver humano para responder, o agente registra a suposição em arquivo e segue a opção conservadora.

**O post do TabNews não é do Akita.** "Programando em Alto Nível na era da IA: É possível?" foi repostado pelo usuário *JoasSurfer* a partir de um artigo de **Sergio Oliveira Jr.** de 13/09/2026, que não menciona Akita ([TabNews](https://www.tabnews.com.br/JoasSurfer/programando-em-alto-nivel-na-era-da-ia-e-possivel); [original](https://soliveira.pages.dev/pt-br/blog/programar-um-nivel-acima/)). É um ensaio conceitual: a IA seria a próxima camada de abstração, a linguagem natural deixa decisões em aberto ("um pagamento aprovado mas não liquidado entra no total?") e por isso é preciso esclarecer regras e pedir testes com exemplos concretos. O texto não traz workflow, números nem custos. A confusão se explica porque Akita usa uma tese parecida ("um compilador novo pra uma disciplina velha") ([Akita, out/2026](https://akitaonrails.com/2026/10/12/llms-agentes-competente-o-suficiente/)).

**A posição real do Akita.** Ele fez uma maratona de 500+ horas, gerou 24 repositórios e estimou um ganho de **~5× ("possivelmente 10× com slop")**. É autoavaliação: nenhum projeto passou de 8/10 e vários ficaram em 1–2/10 [Anedota bem documentada] ([Akita, mai/2026](https://akitaonrails.com/2026/05/14/terminando-maratona-ia-sucesso-ou-fracasso/)). O método dele é XP: TDD obrigatório, CI, releases pequenos e revisão commit a commit. Ele recomenda arquivos com menos de 500 linhas (idealmente 200–300), nomes fáceis de achar com grep, tipos explícitos e um CLAUDE.md de ~100 linhas ([Clean Code pra agentes](https://akitaonrails.com/2026/04/20/clean-code-para-agentes-de-ia/)). Em agosto de 2026 chamou harness, loop e graph engineering de "bullshit", rejeitou SDD ("prosa não compila") e multi-agente ([hot take](https://akitaonrails.com/2026/08/18/hot-take-harness-loop-engineering-graph-engineering-sao-bullshit/)). Ele concorda com a Anthropic em testes como oráculo, iteração em vez de one-shot, CLAUDE.md curto, simplicidade e ceticismo com multi-agente. As divergências são três. A primeira, sobre specs, é em boa parte semântica: o pedido-padrão dele (objetivo, abordagem, o que não quer, como validar) já é uma mini-spec. A segunda é o meio de imposição: ele confia na disciplina humana, a Anthropic em hooks. A terceira é o harness, e aqui ele se contradiz: em abril dizia que "o harness do Claude Code é simplesmente superior" ([Akita, abr/2026](https://akitaonrails.com/2026/04/15/como-falar-com-o-claude-code-efetivamente/)) e em agosto que harness mal importa. O benchmark dele mede tarefas isoladas, e os posts da Anthropic tratam de trabalho multissessão, então cada um provavelmente acerta no seu regime. **A adaptação crucial para você:** o Akita revisa cada commit, você não vai. Tudo o que ele faz por disciplina, seu framework precisa fazer por automação.

## Quatro plugins essenciais; o resto é custo recorrente

Desde a v2.1.x as definições de ferramentas MCP são **adiadas por padrão** (tool search) e as skills carregam só a descrição até serem invocadas, então o custo ocioso caiu [Doc] ([MCP](https://code.claude.com/docs/en/mcp); [Skills](https://code.claude.com/docs/en/skills)). O custo real vem de quatro fontes: plugins de workflow que disparam subagentes e revisões, hooks sempre ligados que chamam LLM, saídas grandes de ferramentas (screenshots, dumps de banco) e bootstraps injetados em toda sessão. Também vale a lição de 2025 sobre CLIs: `gh`, `git` e `sentry-cli` "ainda são mais eficientes em contexto que servidores MCP" ([Costs](https://code.claude.com/docs/en/costs)).

O **conjunto mínimo** reúne o que tem fonte oficial ou recomendação consistente. Os comandos built-in `/code-review`, `/security-review` e `/simplify` já vêm no Claude Code e dispensam os plugins `code-review`, `pr-review-toolkit` e `code-simplifier`. O plugin LSP da sua linguagem (`typescript-lsp` ou `pyright-lsp`) é recomendado pela própria documentação de custos, porque "uma chamada de go to definition substitui um grep seguido da leitura de vários arquivos candidatos" ([Costs](https://code.claude.com/docs/en/costs)). O **Context7** é um MCP remoto para documentação de bibliotecas por versão e é o mais recomendado do ecossistema. Para medir custo, use o **session-report** (oficial) ou o `ccusage` ([marketplace.json](https://raw.githubusercontent.com/anthropics/claude-plugins-official/main/.claude-plugin/marketplace.json); [ccusage](https://github.com/ccusage/ccusage)). Para E2E, prefira o **Playwright via CLI** ao MCP. A evidência aqui **conflita**: um relato mede ~114k tokens com o MCP contra ~27k com o CLI, enquanto a Checkly achou os dois "mais ou menos iguais" ([Shipyard](https://shipyard.build/blog/playwright-mcp-vs-cli/); [Checkly](https://www.checklyhq.com/blog/mcp-vs-cli-token-efficiency/)). Na dúvida, o CLI também roda no CI, então fico com ele.

**Superpowers: bom, mas não essencial para você.** O workflow dele (brainstorm → plano → TDD → revisão) coincide com o que este relatório recomenda para tarefas grandes. O autor alega que a versão 6 ficou "até 60% mais barata" na suíte de avaliação dele mesmo [Vendor] ([blog.fsck.com](https://blog.fsck.com/2026/06/15/Superpowers-6/)). Usuários relatam **10× de consumo** em tarefas simples e "queimou todo o meu plano Max" [Anedota] ([HN](https://news.ycombinator.com/item?id=48739459); [JoanMedia](https://www.joanmedia.dev/ai-blog/the-honest-tradeoffs-of-superpowers-token-costs-overkill-and-the-alternatives)). Como o seu framework já terá regras do Karpathy, spec-lite e gates próprios, o Superpowers seria uma **segunda metodologia concorrente** no contexto. A JoanMedia resume o problema: "duas metodologias competindo no contexto são piores que uma". Deixe-o de fora do baseline. Se quiser, teste-o em uma única feature grande na semana 4 e meça o custo com `/usage`.

**Bloat a evitar:** BMAD (12+ agentes, "difícil de justificar para dev solo"), Ruflo/claude-flow (enxames), SuperClaude (com atividade em queda), pacotes inteiros de subagentes como wshobson e VoltAgent (cada agente instalado acrescenta uma descrição ao contexto), `ralph-loop` (custo potencialmente ilimitado), `claude-code-router` e o plugin do Karpathy (incorpore as regras em vez de instalar) ([comparativo GSD/BMAD](https://samy-portfolio.pages.dev/blog/2026/gsd-vs-speckit-bmad-compound-engineering); [JoanMedia](https://www.joanmedia.dev/ai-blog/the-honest-tradeoffs-of-superpowers-token-costs-overkill-and-the-alternatives)). O `security-guidance` oficial roda hooks a cada edição e uma revisão por LLM a cada Stop, ou seja, tem custo permanente. Para um app financeiro prefira primeiro os sensores determinísticos (Semgrep, gitleaks) e reserve o `/security-review` para diffs sensíveis. Plugins de banco de dados (supabase, neon, prisma) só depois de escolher a stack, e **só apontando para bancos de dev**. A meta é **3–6 plugins e 2–4 MCPs**. Toda semana, poda o que o `/plugin` marcar como "Not used recently" ([Discover plugins](https://code.claude.com/docs/en/discover-plugins)).

## Sem revisão humana, o código precisa ser legível para máquinas e cercado por gates

**Clean code ainda importa, mas por outro motivo.** O leitor agora é o agente, e a saúde do código determina o custo e a taxa de defeitos dele. Num estudo revisado por pares, mas escrito pela própria fornecedora, a CodeScene mediu **+30% de risco de defeito** quando a IA trabalha em código pouco saudável ([PR Newswire](https://tools.prnewswire.com/en-us/live/20823/release/20260128EN71904)). Números relatados em segunda mão indicam **+35% a +45% de tokens** em código ruim [Vendor] ([Vaughan](https://codex.danielvaughan.com/2026/06/06/ai-ready-code-health-codescene-research-codex-cli-agent-performance-quality-gates/)). Ofuscar apenas os nomes de identificadores já degrada bastante a compreensão do LLM [Estudo] ([arXiv 2510.03178](https://arxiv.org/html/2510.03178v1)). Os agentes copiam os padrões que encontram, então um código saudável desde o início se reforça e um código ruim acumula dívida mais rápido. Mantenha o que é **mecanicamente checável ou reduz leitura**: nomes descritivos, módulos pequenos e coesos, fronteiras e direção de dependência explícitas, nada de duplicação, baixa complexidade e tipos estritos. Descarte a cerimônia de hierarquias profundas e interfaces para tudo. A Anthropic avisa que revisores ansiosos por achar problemas empurram para "camadas extras de abstração" ([Best practices](https://code.claude.com/docs/en/best-practices)).

**Linters, formatters e typecheck são obrigatórios** e são o sensor mais barato que existe, já que custam zero tokens quando passam. A receita oficial: formatter num hook `PostToolUse`; typecheck num hook `Stop` que sai com código 2 e bloqueia o fim do turno até passar (no máximo 8 bloqueios seguidos); `PreToolUse` bloqueando caminhos protegidos; `onFailure: "block"` em scanners de segredo; e "mantenha pequeno o conjunto imposto; se chegar a quarenta, a maioria é preferência" [Doc] ([Best practices](https://code.claude.com/docs/en/best-practices)). Dois reforços de praticantes. Faça a saída ser **silenciosa no sucesso e fail-fast na falha** ([HumanLayer](https://www.humanlayer.dev/blog/context-efficient-backpressure)). Escreva **mensagens de lint que já dizem como corrigir**, como faz a OpenAI ([InfoQ](https://www.infoq.com/news/2026/02/openai-harness-engineering-codex)). Proteja os arquivos de configuração, porque agentes às vezes editam o `.eslintrc` em vez de corrigir o código.

**Limite de linhas por arquivo: você está metade certo.** Não existe benchmark controlado que relacione tamanho de arquivo com acurácia de edição, e nenhum número específico tem respaldo. Também não procede a cifra de "76% dos tokens são leituras de arquivo" que apareceu antes: ela não foi confirmada, e o dado verificável mais próximo é **>70%** no SWE-Pruner Pro, com Sonnet 4.5 ([HF papers](https://huggingface.co/papers/2607.18213.md)). Mesmo assim, a evidência indireta aponta todos na mesma direção. Leituras dominam o custo. O Read do Claude Code devolve **2.000 linhas por padrão** e trunca o resto, segundo issues da comunidade sem confirmação na doc oficial ([issue #20223](https://github.com/anthropics/claude-code/issues/20223)). Praticantes relatam degradação de edição a partir de **~700–1.000 linhas** [Anedota] ([Cursor forum](https://forum.cursor.com/t/max-file-length-for-ai-edits-refactor-to-multiple-files/2989)). E o agente não vai se limitar por conta própria. A posição recomendada é **nenhuma regra de tamanho no CLAUDE.md**, só um sensor de lint barato: aviso a partir de ~500 linhas por arquivo e erro a partir de ~800 (excluindo código gerado e fixtures), aviso em funções com mais de ~80 linhas e **complexidade cognitiva ≤15**, que pesa mais que a contagem de linhas. Não divida arquivo só para bater um número, porque fragmentar demais também gera leituras e indireção.

**Testes enxutos, com o humano aprovando a intenção.** Testes gerados por IA tendem a descrever o comportamento *atual* do código, inclusive bugs, e não o *esperado* [Estudo] ([arXiv 2410.21136](https://arxiv.org/html/2410.21136v1)). Cobertura de código não mede poder de detecção de falhas ([MUTGEN](https://arxiv.org/pdf/2506.02954v6)). Já com testes corretos o agente resolve 94% ([TDFlow](https://arxiv.org/abs/2510.23761)). Por isso o ponto de aprovação humana é a **tabela de exemplos de aceitação**, transformada em testes que o agente não pode editar. A distribuição recomendada segue o *testing trophy*. A maior parte do esforço vai em **integração** nas fronteiras (banco real via testcontainers ou SQLite, HTTP). Lógica pura de domínio leva **unitários**. Os 3–5 jornadas críticas levam **smoke E2E** com Playwright. Testes de contrato só se houver consumidores implantados separadamente. Para dinheiro, use **property-based testing** (fast-check em TS, Hypothesis em Python) sobre invariantes:

- a soma das parcelas é igual ao total;
- o arredondamento erra no máximo 1 centavo;
- saldo é igual à soma das transações;
- importar o mesmo extrato duas vezes não muda nada (idempotência);
- conversões fazem ida e volta sem perda.

Um estudo da Anthropic com a Northeastern mostrou que agentes escrevem bons testes de propriedade: 56% dos bugs reportados eram válidos, com patches aceitos no NumPy ([arXiv 2510.09907](https://arxiv.org/html/2510.09907v1)). **Mutation testing** responde à pergunta "os testes da IA são reais?". Use Stryker incremental (TS) ou mutmut (Python), só nos módulos de domínio, à noite, com mutation score ≥60–70%. Böckeler o coloca no pipeline pós-integração por causa do custo ([martinfowler.com](https://martinfowler.com/articles/harness-engineering.html)). Prefira cobertura de **diff** (~80% das linhas alteradas) a uma meta global.

**Segurança vem do pipeline, não do modelo.** Pelo Veracode 2026, a taxa média de aprovação em segurança está **estável em ~56%**, e o tamanho do modelo não faz diferença. O Claude Opus 4.8 ficou em 62% e o melhor modelo em 68% ([Veracode](https://www.veracode.com/news/llms-are-getting-smarter-but-not-safer-veracode-2026-genai-code-security-report-finds-ai-generated-code-security-has-stalled-at-56%25-pass-rate/)). Sobre **slopsquatting**: num estudo da USENIX 2025, 19,7% das referências a pacotes eram alucinadas (~5,2% nos modelos comerciais), e **43% delas se repetiam em toda nova execução**, o que as torna previsíveis para um atacante ([Socket](https://socket.dev/blog/slopsquatting-how-ai-hallucinations-are-fueling-a-new-class-of-supply-chain-attacks)). As camadas recomendadas:

- **gitleaks** no pre-commit e no CI, mais o push protection do GitHub;
- **Semgrep CE** no CI, mais CodeQL se o repositório for público;
- **OSV-Scanner** ou `npm audit`/`pip-audit` para dependências;
- **Renovate com `minimumReleaseAge`**, para nunca instalar uma versão publicada há poucas horas;
- um **gate de dependência nova**: o CI falha se o manifest ganhar um pacote sem o label `deps-approved`, que só você aplica;
- lockfile sempre commitado, com `npm ci` ou `uv sync --frozen`;
- `deny` de leitura de `.env` nas permissões do agente.

Revisores LLM têm viés de supercorreção e taxas relevantes de falso positivo ([arXiv 2603.00539](https://arxiv.org/html/2603.00539v1)), então trate o `/code-review` como sensor, não como oráculo: uma passada por PR, contexto novo, foco em correção contra a spec, ignorar estilo, corrigir só os achados de alta confiança.

## Um único repositório `claude-kit` distribui o padrão para todos os projetos

O Claude Code tem regras de composição que determinam a arquitetura [Doc] ([Memory](https://code.claude.com/docs/en/memory); [Settings](https://code.claude.com/docs/en/settings); [Features overview](https://code.claude.com/docs/en/features-overview)). CLAUDE.md e rules **se somam**: todos os níveis carregam juntos e nenhum sobrescreve o outro. Settings seguem precedência (managed > CLI > local > projeto > usuário), e as listas se fundem. Hooks de todas as fontes **disparam todos**. Skills e subagentes se sobrescrevem por nome, em ordens opostas: a skill pessoal vence a do projeto, e o subagente do projeto vence o pessoal. Plugins são a unidade oficial para empacotar skills, agentes, hooks e MCP, mas **não carregam CLAUDE.md, rules nem permissões** ([Plugin components](https://code.claude.com/docs/en/plugins/components)). Sessões na nuvem e no CI enxergam só o que está commitado, **nunca o `~/.claude`** ([Settings](https://code.claude.com/docs/en/settings)). A consequência é que cada tipo de artefato precisa de um canal de distribuição próprio.

Para melhorias chegarem a projetos já em andamento, o **Copier** é a ferramenta madura. O `copier update` regenera o projeto a partir da versão antiga do template, calcula o seu diff, aplica a versão nova e reaplica o diff. Conflitos aparecem como marcadores inline ou arquivos `.rej`. O `_skip_if_exists` protege arquivos que o projeto customiza, e o `copier check-update` sai com código 2 quando há atualização ([Copier updating](https://copier.readthedocs.io/en/stable/updating/); [configuring](https://copier.readthedocs.io/en/stable/configuring/)). Template de repositório do GitHub e degit não têm caminho de atualização. Os workflows reutilizáveis do GitHub (`on: workflow_call`) são referenciados por tag ou SHA ([GitHub Docs](https://docs.github.com/en/actions/how-tos/reuse-automations/reuse-workflows)). O Renovate aceita presets compartilhados num repositório git, no formato `github>usuario/repo` ([Renovate](https://docs.renovatebot.com/config-presets/)). O Ruff **não tem `extend` remoto**, então a configuração Python é copiada pelo template ([ruff-sync](https://pypi.org/project/ruff-sync/)).

**A decisão, enxuta: um só repositório com cinco pastas, cada uma com um mecanismo de propagação.** Quatro repositórios separados seriam over-engineering para um dev solo. Pacote npm de configuração, Projen e Nx ficam de fora até existirem três ou mais repositórios TS com configuração repetida.

```
claude-kit/                         (git; público ou privado com acesso de Actions liberado)
├── global/                         → symlink em ~/.claude   (propaga: git pull)
│   ├── CLAUDE.md                   ≤50 linhas, regras do Karpathy adaptadas
│   └── settings.json               deny de segredos, model, marketplace + plugins
├── .claude-plugin/marketplace.json → marketplace pessoal    (propaga: in-place / plugin update)
├── plugins/core/                   UM plugin: skills spec + ship, agente spec-check, hook guard
├── copier.yml                      _subdirectory: template; pergunta stack: ts|py
├── template/                       → copier copy / copier update (propaga: tag + sync script)
│   ├── CLAUDE.md.jinja             _skip_if_exists (o projeto é dono)
│   ├── .claude/settings.json       hooks + permissões + enabledPlugins (o template é dono)
│   ├── .claude/rules/{ts,py,money}.md   com paths: (só carregam quando relevantes)
│   ├── scripts/check               ÚNICA fonte dos checks: fast | stop | ci
│   ├── scripts/agent/{guard,fast,stop}.sh
│   ├── biome.json | ruff.toml, tsconfig/pyproject base, lefthook.yml
│   ├── .github/workflows/ci.yml    ~10 linhas chamando o workflow reutilizável
│   └── renovate.json               { "extends": ["github>Diogo-loureiro/claude-kit"] }
├── .github/workflows/{ts,py,security}.yml   on: workflow_call  (propaga: tag @v1)
├── default.json                    preset do Renovate (minimumReleaseAge, automerge devDeps)
├── install.sh                      symlinks + marketplace add + plugins oficiais
└── sync-projects.sh                copier check-update/update em todos os repos
```

O ponto central desse desenho é o `scripts/check`. Os hooks do agente, o lefthook e o CI chamam **o mesmo script**, então um check novo entra num lugar só e chega aos três níveis. Os hooks de qualidade ficam no `.claude/settings.json` do projeto, e não num plugin, porque dependem da stack e precisam estar commitados para funcionar na nuvem e no CI. O plugin `core` leva apenas o que é universal: as skills manuais `spec` e `ship` com `disable-model-invocation: true` (custo zero de contexto até serem chamadas), um subagente somente-leitura `spec-check` e um guard de comandos perigosos. Para quem adiciona o marketplace por caminho local, os plugins com fonte relativa são lidos no lugar, então uma edição vale na sessão seguinte sem precisar subir a versão. Em outras máquinas, omita o campo `version` para acompanhar os commits, já que o auto-update vem desligado para marketplaces de terceiros ([Host a marketplace](https://code.claude.com/docs/en/plugins/host-marketplace)). Armadilhas a evitar: não editar o `.copier-answers.yml` à mão; não usar symlinks de `.claude/rules` apontando para fora do repositório (exigem aprovação, descartam regras com `paths` e quebram no CI); não repetir nomes de skill entre a camada global e o projeto ([distribuição, Memory](https://code.claude.com/docs/en/memory)).

## O framework pronto para adotar

### Workflow por tamanho de tarefa

| Tamanho | Exemplos | Modelo / effort | Fluxo | Gate de "pronto" |
|---|---|---|---|---|
| **Trivial** | typo, renomear, config, bug de 1 arquivo com causa conhecida | Opus 5.5 *low/medium* (sessão padrão) | Prompt específico direto, sem plano. `/clear` ao terminar | Hooks (format + Stop) verdes. Commit |
| **Médio** | feature de 2–10 arquivos, bug em área conhecida | Opus 5.5 *medium*; *high* se o código for desconhecido, o teste for flaky ou houver mudança de schema | Plan mode (Shift+Tab) ou pedido em 4 partes (objetivo / abordagem / o que não quero / como validar). **Teste que falha primeiro**. Implementar | Stop hook verde, então `/code-review` (fresh, skip style), PR com evidência, CI verde |
| **Grande / crítico** | dinheiro, auth, sync/importação, schema, feature multissessão | Spec: Opus 5.5 *high* (Fable 5.1 só para arquitetura ambígua). Build: **sessão nova**, Opus 5.5 *medium* | Skill `spec`: entrevista, `docs/specs/<feature>.md` com tabela de exemplos, testes de aceitação. **Você aprova e o hook trava.** Sessão nova: `/goal "testes de aceitação + scripts/check ci verdes"`. Multissessão: `docs/progress.json` | Tudo do médio + `/security-review` + property tests + mutation noturno no domínio |
| **Mecânico em massa** | migração de lint, renomes em dezenas de arquivos | Sonnet 5.5 em sessão própria | `/batch` (unidades em worktrees) ou `claude -p` com `--max-turns`/`--max-budget-usd` | CI verde por unidade |

### Regras de contexto e cache

As regras abaixo vêm da documentação, exceto onde indicado ([Prompt caching](https://code.claude.com/docs/en/prompt-caching); [Costs](https://code.claude.com/docs/en/costs); [cache blog](https://claude.dev/blog/lessons-from-building-claude-code-prompt-caching-is-everything/)):

| Regra | Por quê |
|---|---|
| Escolha modelo e effort **no início** da sessão e não troque de modelo no meio | Trocar de modelo invalida o cache. Mudar o effort não invalida nos modelos 5.5 e no Fable 5.1 |
| **Uma tarefa por sessão**; `/clear` ao terminar ("não custa nada") | A qualidade cai com o contexto (Chroma, LOCA-bench) |
| `/compact <foco>` só em pausas naturais; `/rewind` para abandonar um caminho | O compact relê a conversa inteira; o rewind volta a um prefixo já cacheado |
| Não ligue nem desligue MCPs ou plugins no meio da sessão | Plugins que trazem servidores MCP invalidam o cache |
| Evite `opusplan` se você alterna o plan mode com frequência | Cada alternância troca de modelo e recria o cache |
| Uso via API key: `promptCacheTtl: "1h"` | O TTL padrão por API é de 5 min; na assinatura já é 1 h |
| Perguntas paralelas em `/btw` | Ficam fora do histórico |
| Saídas de comando silenciosas e fail-fast | Uma suíte de testes filtrada cai de dezenas de milhares de tokens para centenas |
| Busca ampla com o subagente Explore (Haiku); navegação com o LSP | Mantém a leitura fora do contexto principal |
| Confira `/usage` (linha "Prompt cache (main)") e `/context` | Mostram o hit rate do cache e o que está ocupando contexto |

### Template do `~/.claude/CLAUDE.md` global (≤50 linhas)

```markdown
# Preferências globais

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
- "Pronto" exige evidência: o comando executado e a saída. Rode os checks do projeto.
- Nunca altere testes de aceitação, configs de lint/typecheck, hooks, CI ou lockfiles para
  fazer algo passar. Se achar que estão errados, pare e explique.
- Dependência nova só com justificativa (o quê, por quê, alternativa sem dependência) e
  confirmação de que o pacote existe, é mantido e não foi publicado há poucos dias.

## Economia
- Leia por trecho, símbolo ou LSP, não arquivos inteiros. Prefira CLIs (gh, git) a MCPs.
- Busca ampla: subagente Explore. Não use subagentes para escrever código em paralelo.
```

### Template do `CLAUDE.md` de projeto (App_financas, ≤80 linhas)

```markdown
# App Finanças: mapa para o agente
Stack: <preencher após decisão>. Spec ativa: docs/specs/. Progresso multissessão: docs/progress.json.

## Comandos (use exatamente estes)
- Verificação rápida (igual ao Stop hook): `scripts/check stop`
- Tudo (igual ao CI): `scripts/check ci`
- Um teste: `<pnpm vitest run caminho> | <uv run pytest caminho -q>`
- Dev server: `<comando>`

## Regras de domínio que o código não mostra
- Dinheiro: inteiro em centavos (TS) ou Decimal (Python). Nunca float.
- Datas: armazenar em UTC; regras de mês, fatura e vencimento em America/Sao_Paulo.
- Importação de extratos é idempotente (chave natural: <definir>).

## Fora do alcance do agente
- tests/acceptance/** e fixtures aprovadas: só o humano altera.
- Migrações já aplicadas: nunca editar; criar nova.

## Armadilhas
<!-- Adicione aqui só o que o agente errou duas vezes. Comentários HTML não custam tokens. -->

## Ao compactar
Preserve: spec ativa, decisões tomadas, arquivos alterados, falhas pendentes.
```

### Checklist do harness

| Camada | O que roda | Onde | Custo em tokens |
|---|---|---|---|
| PreToolUse | `guard.sh`: bloqueia escrita em `.env*`, configs de lint/ts/ruff, `.github/workflows`, `.claude/`, `scripts/agent/`, `tests/acceptance/**`, migrações aplicadas e lockfiles | `.claude/settings.json` do projeto | 0 (só a mensagem se bloquear) |
| PostToolUse (Edit/Write) | formatar + lint `--fix` **só no arquivo alterado** (`biome check --write` / `ruff format && ruff check --fix --quiet`) | idem | 0 |
| Stop (exit 2) | sem mudanças no git, sai na hora; senão typecheck estrito, lint só de erros, checagem de arquitetura (dependency-cruiser / import-linter) e testes afetados com fail-fast. Saída silenciosa no sucesso; até 40 linhas na falha | idem | só na falha |
| Permissões | `deny` para `Read(./.env*)`, `Read(~/.ssh/**)`, `*.pem` | global e projeto | 0 |
| Lint de estrutura | max-lines ~500 aviso / ~800 erro, função ~80, complexidade cognitiva ≤15, knip/vulture para código morto | config do template | 0 |
| Pre-commit (lefthook) | gitleaks nos arquivos staged + `scripts/check stop` | `lefthook.yml` | 0 |
| CI (PR, obrigatório) | instalação limpa a partir do lockfile; format/lint/typecheck/arquitetura; testes completos com cobertura de diff ≥80%; Semgrep; gitleaks; OSV/audit; **gate de dependência nova**; **gate de mudança no harness** (label `harness-approved`); smoke do Playwright | `claude-kit/.github/workflows/*.yml@v1` | 0 |
| Noturno | Stryker/mutmut incremental no domínio (≥60–70%); knip; Renovate | idem | 0 |
| Inferencial | `/code-review` (uma vez por PR) + `/security-review` em diffs de auth, dinheiro, parsing e I/O, dentro da skill `ship` | local | um subagente por PR |

O trecho essencial do `.claude/settings.json` gerado pelo template fica assim. Confira o formato de `extraKnownMarketplaces` no schema oficial antes de commitar.

```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "permissions": { "deny": ["Read(./.env)", "Read(./.env.*)", "Read(./**/*.pem)"] },
  "hooks": {
    "PreToolUse":  [{ "matcher": "Edit|Write|MultiEdit", "hooks": [{ "type": "command", "command": "\"$CLAUDE_PROJECT_DIR\"/scripts/agent/guard.sh" }] }],
    "PostToolUse": [{ "matcher": "Edit|Write|MultiEdit", "hooks": [{ "type": "command", "command": "\"$CLAUDE_PROJECT_DIR\"/scripts/agent/fast.sh" }] }],
    "Stop":        [{ "hooks": [{ "type": "command", "command": "\"$CLAUDE_PROJECT_DIR\"/scripts/agent/stop.sh" }] }]
  },
  "enabledPlugins": {
    "core@claude-kit": true,
    "typescript-lsp@claude-plugins-official": true,
    "context7@claude-plugins-official": true
  }
}
```

Lembre que hooks, deny rules e scripts protegidos param o agente nas ferramentas Edit e Write, mas um `sed -i` via Bash passa por eles. Quem fecha esse buraco é o **gate de mudança no harness no CI**, e é exatamente para isso que ele existe.

### Plugins e MCPs mínimos (comandos)

```bash
# Oficiais (marketplace claude-plugins-official já vem registrado)
/plugin install typescript-lsp@claude-plugins-official   # ou pyright-lsp@claude-plugins-official
/plugin install context7@claude-plugins-official
/plugin install session-report@claude-plugins-official
# Seu kit (caminho local = edição vale na hora)
claude plugin marketplace add ~/Projetos/claude-kit
claude plugin install core@claude-kit
# Custo fora do Claude Code
npx ccusage@latest            # uso diário e por bloco de 5 h
# Built-ins, não instalar nada: /code-review, /security-review, /simplify, /goal, /usage, /context
# Depois de escolher a stack: um plugin de banco (supabase | neon | prisma), só apontando para dev
```

### Quando usar subagentes, multi-agente e loops

| Use | Não use |
|---|---|
| Explore (embutido, Haiku) para buscas amplas | Subagente "para dar uma resposta melhor": é o mesmo modelo, só com olhos novos |
| Revisor em contexto novo (`/code-review`, `spec-check` somente leitura) | Agent teams (~7× tokens) e enxames (BMAD, Ruflo) |
| Worktrees (`claude -w`) para **tarefas independentes**, no máximo 2–3 ao mesmo tempo | Vários agentes escrevendo código da **mesma** tarefa (decisões conflitantes, segundo a Cognition) |
| `/goal` com condição verificável; `claude -p` com `--max-turns` e `--max-budget-usd` | Loops abertos sem teto ("constrói o app durante a noite"), `ralph-loop` |
| Rotinas agendadas estreitas (triagem de PRs do Renovate) depois que o harness estiver maduro | Loop sem testes de aceitação aprovados: sem oráculo, ele roda em vão |

Fontes da tabela: [Best practices](https://code.claude.com/docs/en/best-practices); [Costs](https://code.claude.com/docs/en/costs); [Cognition](https://cognition.ai/blog/dont-build-multi-agents); [Google](https://arxiv.org/abs/2512.08296).

### Monitoramento de custo

Use a **assinatura Max (US$100)** para o trabalho interativo ("não pague por token", como diz o Akita). Para trabalho headless, os créditos de API inclusos no plano podem servir, mas a cobertura deles foi noticiada por terceiros e não está confirmada. Se usar API key, configure `promptCacheTtl: "1h"`. Como referência oficial, deployments enterprise gastam em média **~US$13 por dev por dia ativo e US$150–250 por mês**, e 90% ficam abaixo de US$30 por dia [Doc] ([Costs](https://code.claude.com/docs/en/costs)). Segundo a mesma página, gasto alto inesperado "geralmente vem de sessões longas nunca limpas ou de Opus deixado como padrão" também nos subagentes. A rotina:

- **Diária:** olhar o `/usage` (meta de cache acima de 85–90%; o exemplo da doc mostra 91%).
- **Semanal:** `npx ccusage@latest` e o relatório do session-report, para achar os prompts mais caros; podar o que o `/plugin` marcar como "Not used recently".
- **Mensal:** rodar `/doctor prompt-audit` e cortar linhas do CLAUDE.md.

Se o limite do plano apertar, aplique as alavancas nesta ordem: `/clear` com mais frequência, effort menor, Sonnet para trabalho mecânico e, só por último, um plano maior.

### Plano de adoção

| Quando | Entregas | Pronto quando |
|---|---|---|
| **Semana 1, dias 1–2: camada global** | Criar `~/Projetos/claude-kit` (git + GitHub). Escrever `global/CLAUDE.md` (template acima) e `global/settings.json` (deny de segredos, `"model": "opus"`). `install.sh` com os symlinks. Instalar LSP, context7 e session-report. Medir uma linha de base com `ccusage` | `/context` mostra CLAUDE.md global ≤50 linhas; `/doctor prompt-audit` limpo |
| **Semana 1, dias 3–5: kit mínimo** | Plugin `core` (skills `spec` e `ship`, agente `spec-check`, guard). Template Copier com `stack: ts\|py`, `scripts/check`, `scripts/agent/*.sh`, `.claude/settings.json`, lefthook, configs de biome/ruff, caller do CI, `renovate.json`. Workflows reutilizáveis `ts.yml`/`py.yml`/`security.yml`. Tag `v0.1.0` | `copier copy` num diretório vazio gera um projeto cujo CI passa |
| **Semana 1, fim: App_financas** | `git init`. Sessão de spec-lite da arquitetura (Opus 5.5 *high*): stack, banco, web ou mobile. `copier copy gh:Diogo-loureiro/claude-kit . --trust`. Ativar o Renovate e a branch protection (status checks obrigatórios) | O primeiro PR passa por todos os gates |
| **Semana 2: núcleo de dinheiro** | Spec de "conta, transação, saldo, importação". Tabela de exemplos aprovada **por você**, que vira testes de aceitação travados. Property tests (soma, arredondamento, idempotência, fuso horário). Implementar com `/goal`. Mutation testing noturno no domínio. Um smoke do Playwright | Mutation score ≥60% no domínio; a CI noturna roda |
| **Semana 3: segurança e custo** | Semgrep, OSV, gate de dependência nova, gate de harness, `minimumReleaseAge`. `/security-review` na skill `ship`. Revisar o `/usage` e ajustar effort e modelo | Um PR de teste adicionando um pacote falso é bloqueado |
| **Semana 4: retro e catraca** | Transformar em regra de lint ou teste estrutural todo erro que o agente repetiu. Podar plugins e linhas do CLAUDE.md. Opcional: testar o Superpowers numa feature grande e comparar o custo. `sync-projects.sh` + tag `v1.0.0` | Kit `v1.0.0` aplicado via `copier update` sem conflito |
| **Contínuo** | Melhorias sempre entram no `claude-kit`, depois tag, depois `sync-projects.sh` (`copier check-update --quiet \|\| copier update --defaults --conflict rej` em branch), depois PRs. A cada nova geração de modelo, remova peças do harness que deixaram de fazer diferença | Todos os repos na mesma tag do kit |

## Conclusão

A mudança de 2026 é que o custo e a qualidade deixaram de depender de *quanto* o agente faz e passaram a depender de *contra o que* ele é verificado. Os estudos mostram que mais tokens, mais effort e mais agentes não compram acurácia de forma confiável, e que testes corretos compram muita. Para quem não vai revisar código, a consequência é inverter o investimento: menos prosa para o modelo (CLAUDE.md, specs longas, metodologias empilhadas) e mais sensores determinísticos, com o seu tempo concentrado no único lugar que nenhum sensor alcança, que é dizer com exemplos concretos o que "certo" significa. O SDD que você praticava sobrevive desde que vire teste de aceitação. As regras do "Karpathy" e o ceticismo do Akita chegam ao mesmo lugar por outro caminho: o que o Akita garante com disciplina humana, você vai garantir com hooks e CI.

A maior incerteza é que quase tudo sobre harness, loops e plugins ainda é alegação de fornecedor ou anedota. O próprio harness da Anthropic perdeu peças a cada geração de modelo. Por isso a propriedade mais valiosa do `claude-kit` não é nenhuma regra específica, e sim a capacidade de mudar barato: uma tag e um `copier update` aplicam a todos os projetos tanto um gate novo quanto a remoção de um gate que deixou de ser útil.
