---
name: receita-visual
description: Receita visual vidro e grafite (nascida no Drone Sense Atende) para painéis, gráficos, cadastros e qualquer app web, no claro e no escuro. Só roda quando chamada.
disable-model-invocation: true
---

# Receita visual: vidro e grafite

**Casa limpa, piso brilhando.** Janelas de vidro fosco sobre um chão cinza com luz suave, grafite nas ações e cor só quando quer dizer algo. O claro e o escuro têm os mesmos papéis. Nasceu no Drone Sense Atende (out/2026), o app de atendimento da Drone Sense, e foi escrita para levar a outros apps: painéis, gráficos, cadastros, ferramentas internas.

**Como usar:** ponha este arquivo no projeto e peça ao agente de código (Claude Code, Codex, Cursor…): *"siga o RECEITA-VISUAL.md para a interface"*. No Claude Code também dá para guardar como skill: salve como `.claude/skills/receita-visual/SKILL.md` e chame com `/receita-visual` quando quiser; ela não liga sozinha.

Se vierem junto:
- `exemplo.html`: um painel completo feito só com esta receita (barra lateral, indicadores, gráficos, tabela, menu, janela, avisos). Abra no navegador e alterne o tema no rodapé da barra lateral.
- `referencias/`: imagens para comparar. **Olhe antes de desenhar a primeira tela.** `painel-claro.png`, `painel-escuro.png`, `painel-celular-claro.png` e `painel-celular-escuro.png` são o painel de exemplo; `camadas-escuro.png` mostra o menu de vidro sobre a tabela; `janela-claro.png`, a janela de diálogo; `atende-claro.png`, `atende-escuro.png` e `atende-celular-claro.png`, o app de onde a receita saiu.

## Como aplicar

1. Cole o bloco de tokens (§2) no CSS global, inteiro. Só os cinco `--at-marca*` podem mudar (a marca do app); o resto fica como está.
2. Ligue o Tailwind (§3). Sem Tailwind, use as classes e as variáveis direto.
3. Monte a moldura (§4) e construa com os componentes (§5). Números e gráficos: §6.
4. Ligue o tema escuro sem piscar (§7) e acerte o celular (§8).
5. Passe o checklist (§11) nos dois temas e compare com as referências, se vierem junto.

Três regras de convivência:
- **Outra marca:** troque só os cinco `--at-marca*` (o verde é o da Drone Sense). Todo o resto fica.
- **App que já tem tokens** (shadcn, `--app-*`, tema próprio): não crie um segundo sistema. Aponte os papéis dele para os `--at-*` (§3) e apague os valores antigos.
- **Hex só no bloco de tokens.** Na tela, use papéis: `text-tinta`, `bg-acao`, `var(--at-…)`.

## 1. Princípios

1. **Chão e janelas.** A tela é um chão cinza com luz suave e, sobre ele, janelas de vidro fosco com 8 a 12 px de respiro entre elas. O chão aparecendo entre as janelas dá a profundidade do vidro; sem ele, o vidro vira um cartão branco qualquer.
2. **Neutro primeiro.** Branco, cinza e grafite fazem quase toda a tela. A hierarquia vem do peso da letra e dos quatro tons de tinta, não de cor.
3. **Grafite é a ação.** Botão principal, pílula ligada, contador da lista atual, interruptor ligado: grafite com texto branco no claro, quase branco com texto grafite no escuro. Uma ação principal por tela.
4. **Cor só com motivo.** A cor da marca aparece no logo, no avatar sem foto e no aviso de novidade (contador de não lidos, ponto de "novo"). Vermelho é erro ou atraso; âmbar é atenção ou hora chegando; verde é deu certo; índigo é marcado por alguém. Ícones de menu e de botão herdam a cor do texto.
5. **Gráfico é onde a cor trabalha**, com a paleta validada da §6. O resto da tela continua neutro.
6. **Pouca tinta nas bordas.** Linhas de 1 px com 7 a 9% de opacidade e sombras longas e suaves. Nada de contorno cinza forte.
7. **Letra calma.** Inter; títulos em semibold com tracking-tight; corpo de 14 px; rótulos de 12 px em frase normal, sem caixa alta.
8. **O escuro é grafite**, não preto nem azul-marinho: os mesmos papéis com valores próprios (já estão nos tokens).

## 2. Tokens: copie inteiro

Claro em `:root`, escuro em `.dark` (classe no `<html>`). Funciona igual com Tailwind 4, Tailwind 3 e sem Tailwind. No Tailwind, cole **depois** do `@import "tailwindcss"` (v4) ou dos `@tailwind` (v3).

```css
/* ---------- Tokens: claro em :root, escuro em .dark ---------- */
:root {
  color-scheme: light;

  /* chão: o fundo da tela, com luz suave */
  --at-chao: #e9ebef;
  --at-chao-luz:
    radial-gradient(1100px 620px at 8% -12%, rgba(255, 255, 255, 0.95) 0%, rgba(255, 255, 255, 0) 62%),
    radial-gradient(900px 560px at 102% -6%, rgba(212, 219, 231, 0.9) 0%, rgba(212, 219, 231, 0) 60%),
    radial-gradient(1000px 700px at 62% 118%, rgba(219, 226, 223, 0.95) 0%, rgba(219, 226, 223, 0) 62%),
    linear-gradient(180deg, #f2f3f6 0%, #e5e7ec 100%);

  /* vidro e superfícies */
  --at-vidro: rgba(255, 255, 255, 0.6);
  --at-vidro-forte: rgba(255, 255, 255, 0.9);
  --at-vidro-borda: rgba(255, 255, 255, 0.78);
  --at-campo: rgba(255, 255, 255, 0.72);
  --at-campo-borda: rgba(17, 20, 24, 0.09);
  --at-campo-hover: #ffffff;
  --at-campo-foco: #a1a1aa;
  --at-folha: rgba(255, 255, 255, 0.95);
  --at-folha-borda: rgba(17, 20, 24, 0.06);
  --at-secao: rgba(245, 246, 249, 0.86);
  --at-divisa: rgba(17, 20, 24, 0.07);
  --at-realce: rgba(17, 20, 24, 0.04);
  --at-realce-forte: rgba(17, 20, 24, 0.05);
  --at-esqueleto: rgba(17, 20, 24, 0.05);
  --at-trilho: #cbd5e1;
  --at-veu: rgba(15, 23, 42, 0.5);
  --at-foco: rgba(24, 24, 27, 0.35);
  --at-rolagem: rgba(17, 20, 24, 0.18);
  --at-sombra-janela: 0 1px 1px rgba(17, 20, 24, 0.03), 0 18px 40px -22px rgba(17, 20, 24, 0.3);
  --at-sombra-item: 0 1px 2px rgba(17, 20, 24, 0.06), 0 8px 18px -10px rgba(17, 20, 24, 0.24);
  --at-brilho: inset 0 1px 0 rgba(255, 255, 255, 0.9);

  /* tinta (texto), do mais forte ao mais apagado */
  --at-tinta: #0f172a;
  --at-tinta-2: #475569;
  --at-tinta-3: #64748b;
  --at-tinta-4: #94a3b8;

  /* ação: grafite */
  --at-acao: #18181b;
  --at-acao-hover: #3f3f46;
  --at-acao-tinta: #ffffff;

  /* marca: troque pela do app (aqui, o verde Drone Sense) */
  --at-marca: #006c49;
  --at-marca-clara: #1f9e6e;
  --at-marca-tinta: #004532;
  --at-marca-fundo: rgba(0, 108, 73, 0.15);
  --at-marca-sombra: rgba(0, 108, 73, 0.7);

  /* tons com significado */
  --at-perigo: #e11d48;
  --at-perigo-fundo: rgba(255, 241, 242, 0.9);
  --at-perigo-borda: rgba(254, 205, 211, 0.8);
  --at-perigo-solido: #e11d48;
  --at-perigo-solido-hover: #be123c;
  --at-atencao: #b45309;
  --at-atencao-fundo: rgba(255, 251, 235, 0.9);
  --at-atencao-borda: rgba(253, 230, 138, 0.8);
  --at-ok: #047857;
  --at-ok-fundo: rgba(236, 253, 245, 0.9);
  --at-ok-borda: rgba(167, 243, 208, 0.8);
  --at-marcado: #4f46e5;
  --at-marcado-fundo: rgba(238, 242, 255, 0.9);
  --at-marcado-borda: rgba(199, 210, 254, 0.8);

  /* gráficos */
  --at-grafico-fundo: #f6f7f9;
  --at-grade: rgba(17, 20, 24, 0.07);
  --at-eixo: rgba(17, 20, 24, 0.22);
  --at-serie-destaque: #18181b;
  --at-serie-contexto: #a1a1aa;
  --at-serie-1: #2a78d6;
  --at-serie-2: #eb6834;
  --at-serie-3: #1baf7a;
  --at-serie-4: #eda100;
  --at-serie-5: #e87ba4;
  --at-serie-6: #008300;
  --at-serie-7: #4a3aa7;
  --at-serie-8: #e34948;
  --at-seq-1: #cde2fb;
  --at-seq-2: #9ec5f4;
  --at-seq-3: #6da7ec;
  --at-seq-4: #3987e5;
  --at-seq-5: #256abf;
  --at-seq-6: #184f95;
  --at-seq-7: #0d366b;
}

.dark {
  color-scheme: dark;
  --at-chao: #0d0f12;
  --at-chao-luz:
    radial-gradient(1000px 600px at 6% -14%, rgba(255, 255, 255, 0.07) 0%, rgba(255, 255, 255, 0) 60%),
    radial-gradient(900px 560px at 104% -8%, rgba(120, 138, 168, 0.14) 0%, rgba(120, 138, 168, 0) 60%),
    radial-gradient(900px 640px at 60% 120%, rgba(70, 110, 95, 0.12) 0%, rgba(70, 110, 95, 0) 60%),
    linear-gradient(180deg, #131518 0%, #0b0c0e 100%);
  --at-vidro: rgba(30, 33, 39, 0.58);
  --at-vidro-forte: rgba(54, 59, 68, 0.74);
  --at-vidro-borda: rgba(255, 255, 255, 0.07);
  --at-campo: rgba(255, 255, 255, 0.05);
  --at-campo-borda: rgba(255, 255, 255, 0.09);
  --at-campo-hover: rgba(255, 255, 255, 0.1);
  --at-campo-foco: #71717a;
  --at-folha: rgba(255, 255, 255, 0.07);
  --at-folha-borda: rgba(255, 255, 255, 0.1);
  --at-secao: rgba(27, 30, 35, 0.9);
  --at-divisa: rgba(255, 255, 255, 0.07);
  --at-realce: rgba(255, 255, 255, 0.045);
  --at-realce-forte: rgba(255, 255, 255, 0.1);
  --at-esqueleto: rgba(255, 255, 255, 0.1);
  --at-trilho: #52525b;
  --at-foco: rgba(255, 255, 255, 0.4);
  --at-rolagem: rgba(255, 255, 255, 0.14);
  --at-sombra-janela: 0 1px 1px rgba(0, 0, 0, 0.3), 0 18px 40px -20px rgba(0, 0, 0, 0.7);
  --at-sombra-item: 0 1px 2px rgba(0, 0, 0, 0.35), 0 8px 18px -10px rgba(0, 0, 0, 0.6);
  --at-brilho: inset 0 1px 0 rgba(255, 255, 255, 0.06);
  --at-tinta: #fafafa;
  --at-tinta-2: #d4d4d8;
  --at-tinta-3: #a1a1aa;
  --at-tinta-4: #71717a;
  --at-acao: #f4f4f5;
  --at-acao-hover: #ffffff;
  --at-acao-tinta: #18181b;
  --at-marca-tinta: #1f9e6e;
  --at-perigo: #fb7185;
  --at-perigo-fundo: rgba(244, 63, 94, 0.1);
  --at-perigo-borda: rgba(244, 63, 94, 0.25);
  --at-atencao: #fbbf24;
  --at-atencao-fundo: rgba(245, 158, 11, 0.1);
  --at-atencao-borda: rgba(245, 158, 11, 0.25);
  --at-ok: #34d399;
  --at-ok-fundo: rgba(16, 185, 129, 0.1);
  --at-ok-borda: rgba(16, 185, 129, 0.25);
  --at-marcado: #a5b4fc;
  --at-marcado-fundo: rgba(99, 102, 241, 0.1);
  --at-marcado-borda: rgba(129, 140, 248, 0.25);
  --at-grafico-fundo: #17191e;
  --at-grade: rgba(255, 255, 255, 0.07);
  --at-eixo: rgba(255, 255, 255, 0.2);
  --at-serie-destaque: #f4f4f5;
  --at-serie-contexto: #52525b;
  --at-serie-1: #3987e5;
  --at-serie-2: #d95926;
  --at-serie-3: #199e70;
  --at-serie-4: #c98500;
  --at-serie-5: #d55181;
  --at-serie-6: #008300;
  --at-serie-7: #9085e9;
  --at-serie-8: #e66767;
  --at-seq-1: #0d366b;
  --at-seq-2: #184f95;
  --at-seq-3: #256abf;
  --at-seq-4: #3987e5;
  --at-seq-5: #6da7ec;
  --at-seq-6: #9ec5f4;
  --at-seq-7: #cde2fb;
}

@layer base {
  html {
    font-family: "Inter", ui-sans-serif, system-ui, sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
  }
  body {
    color: var(--at-tinta);
    background-color: var(--at-chao);
  }
  :where(a, button, summary, [role="button"], [tabindex]:not(input, select, textarea)):focus-visible {
    outline: 2px solid var(--at-foco);
    outline-offset: 2px;
  }
  /* iPhone dá zoom ao focar campo com fonte menor que 16px */
  @supports (-webkit-touch-callout: none) {
    @media (max-width: 639px) {
      input, textarea, select { font-size: 16px !important; }
    }
  }
  @media (prefers-reduced-motion: reduce) {
    *, ::before, ::after {
      animation-duration: 0.01ms !important;
      animation-iteration-count: 1 !important;
      transition-duration: 0.01ms !important;
    }
  }
}

@layer components {
  .fundo-app {
    background: var(--at-chao-luz);
    background-color: var(--at-chao);
  }
  .vidro {
    background: var(--at-vidro);
    -webkit-backdrop-filter: blur(24px) saturate(160%);
    backdrop-filter: blur(24px) saturate(160%);
    border: 1px solid var(--at-vidro-borda);
    box-shadow: var(--at-sombra-janela), var(--at-brilho);
  }
  .vidro-forte {
    background: var(--at-vidro-forte);
    -webkit-backdrop-filter: blur(28px) saturate(160%);
    backdrop-filter: blur(28px) saturate(160%);
    border: 1px solid var(--at-vidro-borda);
    box-shadow: var(--at-sombra-janela);
  }
  .campo {
    background: var(--at-campo);
    border: 1px solid var(--at-campo-borda);
  }
  .folha {
    background: var(--at-folha);
    border: 1px solid var(--at-folha-borda);
    box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
  }
  .item-sel {
    background: var(--at-vidro-forte);
    box-shadow: var(--at-sombra-item);
  }
  .fundo-secao {
    background: var(--at-secao);
    -webkit-backdrop-filter: blur(14px);
    backdrop-filter: blur(14px);
  }
  .marca-logo {
    display: flex;
    align-items: center;
    justify-content: center;
    background: linear-gradient(to bottom right, var(--at-marca-clara), var(--at-marca));
    color: #fff;
    font-weight: 700;
    letter-spacing: 0.025em;
    box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.25), 0 6px 14px -8px var(--at-marca-sombra);
  }
  .rolagem-fina { scrollbar-width: thin; scrollbar-color: var(--at-rolagem) transparent; }
  .rolagem-fina::-webkit-scrollbar { width: 8px; height: 8px; }
  .rolagem-fina::-webkit-scrollbar-thumb { border-radius: 9999px; background: var(--at-rolagem); }
  .rolagem-fina::-webkit-scrollbar-track { background: transparent; }
  .rolagem-oculta { scrollbar-width: none; }
  .rolagem-oculta::-webkit-scrollbar { display: none; }
}

@supports not ((backdrop-filter: blur(1px)) or (-webkit-backdrop-filter: blur(1px))) {
  .vidro, .vidro-forte { background: var(--at-vidro-forte); }
}
```

**Tinta e ação**

| Papel | Token | Claro | Escuro | Onde |
|---|---|---|---|---|
| Tinta | `--at-tinta` | `#0f172a` | `#fafafa` | títulos, nomes, valores, texto de corpo |
| Tinta 2 | `--at-tinta-2` | `#475569` | `#d4d4d8` | texto secundário, item de menu fora de foco |
| Tinta 3 | `--at-tinta-3` | `#64748b` | `#a1a1aa` | rótulos, subtítulos, eixos, datas |
| Tinta 4 | `--at-tinta-4` | `#94a3b8` | `#71717a` | placeholder, ícone apagado, hora; nunca algo que a pessoa precisa ler para agir |
| Ação | `--at-acao` | `#18181b` | `#f4f4f5` | botão principal, pílula ligada, interruptor ligado |
| Texto na ação | `--at-acao-tinta` | `#ffffff` | `#18181b` | texto e ícone sobre o grafite |
| Marca | `--at-marca` | `#006c49` | `#006c49` | logo, contador de não lidos, ponto de novo |

**Tons com significado** (cada um tem `-fundo` e `-borda` para faixas e selos)

| Tom | Quando | Texto claro | Texto escuro |
|---|---|---|---|
| `perigo` | erro, atrasado, apagar | `#e11d48` | `#fb7185` |
| `atencao` | atenção, hora chegando, sem resposta | `#b45309` | `#fbbf24` |
| `ok` | concluído, conectado, melhorou | `#047857` | `#34d399` |
| `marcado` | sinalizado por alguém (bandeira) | `#4f46e5` | `#a5b4fc` |

As classes do bloco:

| Classe | É o quê | Onde usar |
|---|---|---|
| `fundo-app` | o chão com a luz | no contêiner da tela inteira (ou no `body`) |
| `vidro` | janela de vidro | barra lateral, painéis, cartões, topo do celular |
| `vidro-forte` | vidro quase opaco | o que flutua: menu, dica, aviso rápido, janela de diálogo, painel lateral |
| `campo` | superfície de controle | campos, botões secundários, pílulas desligadas, selos |
| `folha` | bloco opaco dentro da janela | quando algo precisa se destacar dentro de uma janela |
| `item-sel` | o vidro "levanta" | onde você está: item da barra lateral, linha selecionada |
| `fundo-secao` | faixa fixa com desfoque | cabeçalho de grupo que fica preso no topo de uma lista |
| `marca-logo` | quadrado da marca | logo (tamanho e raio vêm das classes de tamanho) |
| `rolagem-fina` / `rolagem-oculta` | barra de rolagem discreta / escondida | áreas que rolam / fileiras de pílulas que deslizam |

## 3. Ligar no Tailwind

### Tailwind 4 (Next, Astro, Vite)

```css
/* globals.css */
@import "tailwindcss";
@custom-variant dark (&:where(.dark, .dark *));

@theme {
  --font-sans: "Inter", ui-sans-serif, system-ui, sans-serif;
  --animate-surgir: surgir 0.2s ease-out;
  --animate-subir: subir 0.25s ease-out;
  @keyframes surgir {
    from { opacity: 0; }
    to { opacity: 1; }
  }
  @keyframes subir {
    from { transform: translateY(8px); opacity: 0; }
    to { transform: translateY(0); opacity: 1; }
  }
}

@theme inline {
  --color-tinta: var(--at-tinta);
  --color-tinta-2: var(--at-tinta-2);
  --color-tinta-3: var(--at-tinta-3);
  --color-tinta-4: var(--at-tinta-4);
  --color-acao: var(--at-acao);
  --color-acao-hover: var(--at-acao-hover);
  --color-acao-tinta: var(--at-acao-tinta);
  --color-marca: var(--at-marca);
  --color-marca-tinta: var(--at-marca-tinta);
  --color-marca-fundo: var(--at-marca-fundo);
  --color-divisa: var(--at-divisa);
  --color-realce: var(--at-realce);
  --color-realce-forte: var(--at-realce-forte);
  --color-campo-hover: var(--at-campo-hover);
  --color-campo-foco: var(--at-campo-foco);
  --color-esqueleto: var(--at-esqueleto);
  --color-trilho: var(--at-trilho);
  --color-veu: var(--at-veu);
  --color-foco: var(--at-foco);
  --color-perigo: var(--at-perigo);
  --color-perigo-fundo: var(--at-perigo-fundo);
  --color-perigo-borda: var(--at-perigo-borda);
  --color-perigo-solido: var(--at-perigo-solido);
  --color-perigo-solido-hover: var(--at-perigo-solido-hover);
  --color-atencao: var(--at-atencao);
  --color-atencao-fundo: var(--at-atencao-fundo);
  --color-atencao-borda: var(--at-atencao-borda);
  --color-ok: var(--at-ok);
  --color-ok-fundo: var(--at-ok-fundo);
  --color-ok-borda: var(--at-ok-borda);
  --color-marcado: var(--at-marcado);
  --color-marcado-fundo: var(--at-marcado-fundo);
  --color-marcado-borda: var(--at-marcado-borda);
}

/* ...e depois o bloco de tokens da §2 */
```

Com isso existem `text-tinta`, `text-tinta-2/3/4`, `bg-acao`, `hover:bg-acao-hover`, `text-acao-tinta`, `bg-marca`, `text-marca-tinta`, `bg-marca-fundo`, `border-divisa`, `hover:bg-realce`, `hover:bg-realce-forte`, `hover:bg-campo-hover`, `focus:border-campo-foco`, `bg-esqueleto`, `bg-trilho`, `bg-veu`, `ring-foco`, `text-perigo`, `bg-perigo-fundo`, `border-perigo-borda`, `bg-perigo-solido` (e o mesmo para `atencao`, `ok`, `marcado`), `animate-surgir` e `animate-subir`.

Fonte: carregue a Inter (400, 500, 600 e 700). No Next, com `next/font/google` e `--font-sans: var(--font-inter)`.

**Com shadcn/ui:** troque os blocos `:root` e `.dark` do shadcn por este (os `--at-*` já mudam sozinhos no escuro):

```css
:root {
  --background: var(--at-chao);
  --foreground: var(--at-tinta);
  --card: var(--at-vidro);
  --card-foreground: var(--at-tinta);
  --popover: var(--at-vidro-forte);
  --popover-foreground: var(--at-tinta);
  --primary: var(--at-acao);
  --primary-foreground: var(--at-acao-tinta);
  --secondary: var(--at-campo);
  --secondary-foreground: var(--at-tinta);
  --muted: var(--at-realce);
  --muted-foreground: var(--at-tinta-3);
  --accent: var(--at-realce-forte);
  --accent-foreground: var(--at-tinta);
  --destructive: var(--at-perigo-solido);
  --border: var(--at-divisa);
  --input: var(--at-campo-borda);
  --ring: var(--at-foco);
  --radius: 0.75rem;
  --chart-1: var(--at-serie-1);
  --chart-2: var(--at-serie-2);
  --chart-3: var(--at-serie-3);
  --chart-4: var(--at-serie-4);
  --chart-5: var(--at-serie-5);
  --sidebar: var(--at-vidro);
  --sidebar-foreground: var(--at-tinta-2);
  --sidebar-primary: var(--at-acao);
  --sidebar-primary-foreground: var(--at-acao-tinta);
  --sidebar-accent: var(--at-vidro-forte);
  --sidebar-accent-foreground: var(--at-tinta);
  --sidebar-border: var(--at-divisa);
  --sidebar-ring: var(--at-foco);
}
```

E nos componentes: `Card` e `Sidebar` ganham `vidro rounded-[18px]`; `Popover`, `DropdownMenu`, `Select`, `Dialog` e `Sheet` ganham `vidro-forte`; o `body`, `fundo-app`. O `Button` padrão já sai grafite; o `outline` vira `campo`.

### Tailwind 3 (Nuxt e projetos mais antigos)

```js
// tailwind.config.js
const defaultTheme = require('tailwindcss/defaultTheme')
const v = (nome) => `var(--at-${nome})`

module.exports = {
  darkMode: 'class',
  content: ['./app/**/*.{vue,js,ts}'], // ajuste ao projeto
  theme: {
    extend: {
      fontFamily: { sans: ['Inter', ...defaultTheme.fontFamily.sans] },
      colors: {
        tinta: { DEFAULT: v('tinta'), 2: v('tinta-2'), 3: v('tinta-3'), 4: v('tinta-4') },
        acao: { DEFAULT: v('acao'), hover: v('acao-hover'), tinta: v('acao-tinta') },
        marca: { DEFAULT: v('marca'), tinta: v('marca-tinta'), fundo: v('marca-fundo') },
        divisa: v('divisa'),
        realce: { DEFAULT: v('realce'), forte: v('realce-forte') },
        'campo-hover': v('campo-hover'),
        'campo-foco': v('campo-foco'),
        esqueleto: v('esqueleto'),
        trilho: v('trilho'),
        veu: v('veu'),
        foco: v('foco'),
        perigo: { DEFAULT: v('perigo'), fundo: v('perigo-fundo'), borda: v('perigo-borda'), solido: v('perigo-solido'), 'solido-hover': v('perigo-solido-hover') },
        atencao: { DEFAULT: v('atencao'), fundo: v('atencao-fundo'), borda: v('atencao-borda') },
        ok: { DEFAULT: v('ok'), fundo: v('ok-fundo'), borda: v('ok-borda') },
        marcado: { DEFAULT: v('marcado'), fundo: v('marcado-fundo'), borda: v('marcado-borda') },
      },
      keyframes: {
        surgir: { from: { opacity: '0' }, to: { opacity: '1' } },
        subir: { from: { transform: 'translateY(8px)', opacity: '0' }, to: { transform: 'translateY(0)', opacity: '1' } },
      },
      animation: { surgir: 'surgir 0.2s ease-out', subir: 'subir 0.25s ease-out' },
    },
  },
}
```

No `main.css`: `@tailwind base; @tailwind components; @tailwind utilities;` e depois o bloco da §2. No Tailwind 3, barra de opacidade em cor de variável (`bg-perigo/10`) não funciona: use os tokens `-fundo`.

### Protótipo num HTML só, sem build

Para testar a receita num arquivo solto (como o `exemplo.html`), use o Tailwind 4 do CDN:

```html
<style>html { background: #e9ebef } html.dark { background: #0d0f12 }</style><!-- cobre o instante antes do CDN compilar -->
<script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
<style type="text/tailwindcss">
  /* o bloco do Tailwind 4 acima, SEM a linha @import "tailwindcss" (o CDN já inclui;
     com ela o navegador tenta baixar um arquivo "tailwindcss" e dá erro) */
  /* depois, o bloco de tokens da §2 */
</style>
```

O CDN é só para protótipo; app de verdade usa o build.

### Sem Tailwind

O bloco da §2 já traz tudo o que é vidro, chão e campo. Para o resto, use as variáveis (`color: var(--at-tinta-3)`) com as medidas da §5 em px: Tailwind conta 4 px por unidade (`h-10` = 40 px, `px-3` = 12 px, `rounded-xl` = 12 px, `text-sm` = 14 px).

## 4. Moldura: chão e janelas

```html
<body class="fundo-app">
  <div class="flex h-dvh overflow-hidden">
    <!-- barra lateral: janela de vidro; no celular vira gaveta (§8) -->
    <aside class="vidro fixed inset-y-0 left-0 z-40 flex w-64 shrink-0 -translate-x-full flex-col overflow-y-auto rolagem-oculta transition-transform duration-200 lg:static lg:z-auto lg:my-3 lg:ml-3 lg:w-60 lg:translate-x-0 lg:rounded-[18px]">…</aside>

    <div class="flex min-w-0 flex-1 flex-col overflow-hidden">
      <!-- topo, só no celular: também é vidro -->
      <header class="vidro mx-2 mt-[calc(0.5rem+env(safe-area-inset-top))] flex items-center gap-3 rounded-2xl px-3 py-2.5 lg:hidden">…</header>

      <!-- só o main rola: o chão fica parado atrás do vidro -->
      <main class="min-h-0 flex-1 overflow-y-auto rolagem-fina p-2 pb-[calc(0.5rem+env(safe-area-inset-bottom))] lg:p-3">
        <div class="mx-auto max-w-[1360px] space-y-2 lg:space-y-3">
          <!-- cabeçalho da página (direto no chão) e depois as janelas -->
        </div>
      </main>
    </div>
  </div>
</body>
```

- **Respiro:** 12 px no computador (`p-3`, `gap-3`), 8 px no celular (`p-2`, `gap-2`). Grades de janelas: `grid gap-2 lg:gap-3`.
- **Janela:** `vidro rounded-[18px]`, com 16 a 20 px por dentro (`p-4 lg:p-5`, ou `px-4 lg:px-5` com cabeçalho próprio).
- **É janela:** barra lateral, cada painel ou cartão, colunas de lista e detalhe (a lista numa janela, o detalhe em outra, 12 px entre elas), topo do celular.
- **Fica no chão, sem vidro:** o cabeçalho da página (título, subtítulo e filtros) e as faixas de aviso entre janelas.
- **Nunca vidro dentro de vidro.** Dentro da janela vale `campo`, `folha`, `item-sel` e linhas `border-divisa`.
- **Cabeçalho da página:** título `text-xl font-semibold tracking-tight text-tinta`, subtítulo `text-[13px] text-tinta-3`; os filtros ficam numa linha só, à direita, acima de tudo o que eles mudam.

```html
<div class="flex flex-wrap items-end justify-between gap-3 px-1 pt-2">
  <div>
    <h1 class="text-xl font-semibold tracking-tight text-tinta">Visão geral</h1>
    <p class="mt-0.5 text-[13px] text-tinta-3">Últimos 30 dias</p>
  </div>
  <div class="flex flex-wrap items-center gap-2"><!-- pílulas de período, select, ação principal --></div>
</div>
```

## 5. Componentes

Classes testadas no `exemplo.html`. No React troque `class` por `className`; os ícones são do lucide.

### Marca

```html
<div class="marca-logo h-9 w-9 rounded-[11px] text-[13px]">DS</div>
<div class="leading-tight">
  <p class="text-[15px] font-semibold tracking-tight text-tinta">Drone Sense</p>
  <p class="text-xs text-tinta-3">Operações</p>
</div>
```

No topo do celular: `marca-logo h-7 w-7 rounded-lg text-[11px]`.

### Botões

| Tipo | Classes |
|---|---|
| Principal (um por tela) | `inline-flex h-10 items-center justify-center gap-2 rounded-xl bg-acao px-4 text-sm font-semibold text-acao-tinta transition-colors hover:bg-acao-hover disabled:opacity-50` |
| Secundário | `campo inline-flex h-10 items-center justify-center gap-2 rounded-xl px-4 text-sm font-semibold text-tinta transition-colors hover:bg-campo-hover disabled:opacity-50` |
| Compacto (barras de ação, cabeçalho de janela) | `campo inline-flex h-9 items-center gap-2 rounded-[10px] px-3 text-[13px] font-semibold text-tinta transition-colors hover:bg-campo-hover` |
| Mínimo (dentro de faixa ou cabeçalho de gráfico) | `campo inline-flex h-8 items-center gap-1.5 rounded-[10px] px-2.5 text-xs font-semibold text-tinta-2 transition-colors hover:bg-campo-hover` |
| Só ícone | `campo flex h-9 w-9 items-center justify-center rounded-xl text-tinta-2 transition-colors hover:bg-campo-hover` (ligado: `bg-acao text-acao-tinta` no lugar de `campo text-tinta-2`) |
| Discreto (rodapé, barra lateral) | `flex h-9 w-9 items-center justify-center rounded-xl text-tinta-3 transition-colors hover:bg-realce` |
| Perigo (só na confirmação de algo que não volta) | `h-10 rounded-xl bg-perigo-solido px-4 text-sm font-semibold text-white transition-colors hover:bg-perigo-solido-hover` |

Ícone de 16 px (`h-4 w-4`) nos botões; 20 px nos de 40 px só com ícone. Em andamento: troque o ícone por `Loader2` com `animate-spin` e desabilite. Botão de sair: `hover:bg-perigo-fundo hover:text-perigo`.

### Campos

```html
<label class="flex flex-col gap-1 text-xs font-semibold text-tinta-3">
  Nome do arquivo
  <input class="campo h-10 rounded-xl px-3 text-sm font-normal text-tinta outline-none placeholder:text-tinta-4 focus:border-campo-foco">
</label>
<p role="alert" class="mt-1.5 text-sm font-semibold text-perigo">Dê um nome para o arquivo.</p>

<!-- busca: o ícone mora dentro do campo -->
<label class="campo flex h-10 items-center gap-2 rounded-xl px-3 transition-colors focus-within:border-campo-foco">
  <Search class="h-4 w-4 shrink-0 text-tinta-4" />
  <input placeholder="Buscar por nome ou número" class="min-w-0 flex-1 bg-transparent text-sm text-tinta outline-none placeholder:text-tinta-4">
</label>
```

- Select: `campo h-10 rounded-xl px-3 text-sm text-tinta outline-none focus:border-campo-foco`; compacto, `h-9 rounded-lg px-2 text-[13px] font-medium`.
- Área de texto grande: o `campo rounded-2xl p-1.5 focus-within:border-campo-foco` envolve um `textarea` transparente.
- Com erro: `border-perigo` no campo e a mensagem embaixo com `role="alert"`.
- Rótulo em frase normal, sem dois-pontos e sem caixa alta.

### Pílulas, segmentado e abas

- **Pílula de filtro:** `h-9 rounded-full px-3.5 text-[13px] font-semibold transition-colors` mais, ligada, `bg-acao text-acao-tinta` e, desligada, `campo text-tinta-2 hover:bg-campo-hover`. Contagem dentro: `tabular-nums opacity-70`. Menor: `h-8 px-3 text-xs`.
- **Segmentado** (7, 30, 90 dias): uma fileira de pílulas com `aria-pressed`, num `role="group"`.
- **Fileira que desliza no celular:** `flex gap-1.5 overflow-x-auto rolagem-oculta`.
- **Abas sublinhadas** (dentro de um painel): contêiner `flex gap-1 border-b border-divisa px-4`; aba `-mb-px border-b-2 px-3 py-1.5 text-xs font-semibold transition-colors`, ativa `border-acao text-tinta`, inativa `border-transparent text-tinta-4 hover:text-tinta-2`.

### Barra lateral

```html
<p class="px-6 pb-1.5 text-xs font-semibold text-tinta-3">Painel</p>
<nav class="space-y-0.5 px-3">
  <!-- onde você está: o vidro levanta; o contador fica grafite -->
  <a aria-current="page" class="item-sel flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm font-semibold text-tinta">
    <LayoutDashboard class="h-[18px] w-[18px] shrink-0" />
    <span class="min-w-0 flex-1 truncate">Visão geral</span>
    <span class="min-w-[24px] rounded-full bg-acao px-2 py-0.5 text-center text-xs font-semibold tabular-nums text-acao-tinta">7</span>
  </a>
  <a class="flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm font-semibold text-tinta-2 transition-colors hover:bg-realce">
    <Send class="h-[18px] w-[18px] shrink-0" />
    <span class="min-w-0 flex-1 truncate">Voos</span>
    <span class="min-w-[24px] rounded-full px-2 py-0.5 text-center text-xs font-semibold tabular-nums text-tinta-3">318</span>
  </a>
</nav>

<!-- grupo secundário: menor e mais apagado -->
<p class="mt-5 px-6 pb-1.5 text-xs font-semibold text-tinta-3">Mais</p>
<a class="flex items-center gap-3 rounded-xl px-3 py-2 text-[13px] font-medium text-tinta-3 transition-colors hover:bg-realce">
  <FileText class="h-4 w-4 shrink-0" /> Relatórios
</a>

<!-- rodapé: pessoa, tema e sair -->
<div class="mx-3 mt-auto flex items-center gap-0.5 border-t border-divisa pt-3 pb-[calc(0.75rem+env(safe-area-inset-bottom))] lg:pb-3">…</div>
```

Contador de novidade (algo novo pede atenção) é o da marca, não o grafite: veja Selos.

### Linha de lista

Para listas de registros clicáveis (caixa de entrada, pedidos, chamados), dentro de um contêiner `space-y-0.5 px-2`:

```html
<button class="flex w-full items-start gap-3 rounded-[13px] px-2.5 py-2.5 text-left transition-colors hover:bg-realce">
  <!-- selecionada: item-sel no lugar de hover:bg-realce -->
  <span class="…avatar…">AR</span>
  <div class="min-w-0 flex-1">
    <div class="flex items-center gap-2">
      <p class="truncate text-sm font-semibold text-tinta">Ana Ribeiro</p><!-- com novidade: font-bold -->
      <span class="ml-auto shrink-0 text-xs tabular-nums text-tinta-4">há 4 min</span>
    </div>
    <div class="mt-0.5 flex items-center gap-2 text-xs text-tinta-4">
      <p class="min-w-0 flex-1 truncate">Perfeito! Qual o próximo passo?</p>
      <span class="flex h-[19px] min-w-[19px] items-center justify-center rounded-full bg-marca px-1.5 text-[11px] font-bold tabular-nums text-white">2</span>
    </div>
  </div>
</button>
```

Linha de apoio com tom, só quando pede ação: `mt-0.5 flex items-start gap-1.5 text-[13px] leading-snug`, ícone `h-3.5 w-3.5 text-atencao` e o texto `<span class="font-semibold text-atencao">Não responde desde 28/10:</span> chamar de novo`.

### Selos, etiquetas e pontos

- **Selo de situação** (padrão, discreto): `campo inline-flex items-center gap-1.5 rounded-full px-2.5 py-1 text-xs font-medium text-tinta-2`, com ícone `h-3.5 w-3.5` em `text-ok`, `text-atencao`, `text-perigo` ou `text-marcado`. Situação sem juízo (inativo, rascunho, arquivado): ícone em `text-tinta-4`.
- **Selo tingido** (quando precisa saltar aos olhos): `inline-flex items-center gap-1.5 rounded-full border border-atencao-borda bg-atencao-fundo px-2.5 py-1 text-xs font-semibold text-atencao`.
- **Etiqueta com cor escolhida pela pessoa:** `rounded-full px-2 py-1 text-[11px] font-semibold` com `style="background: {cor}1f; color: {cor}"` (12% de fundo).
- **Contador de novidade:** `flex h-[19px] min-w-[19px] items-center justify-center rounded-full bg-marca px-1.5 text-[11px] font-bold tabular-nums text-white`.
- **Ponto de novo:** `h-2.5 w-2.5 rounded-full bg-marca`. **Ao vivo / presença:** `h-2 w-2 animate-pulse rounded-full bg-ok`.

### Avatar

`inline-flex h-10 w-10 shrink-0 items-center justify-center overflow-hidden rounded-full bg-marca-fundo text-sm font-semibold text-marca-tinta`, com as iniciais da primeira e da última palavra. Tamanhos de 32 (`h-8 w-8 text-xs`), 40 e 48 px. Com foto, `<img class="h-full w-full object-cover">`; se a imagem falhar, volte às iniciais.

### Faixa de aviso

```html
<div role="status" class="flex flex-wrap items-center gap-x-3 gap-y-2 rounded-xl border border-atencao-borda bg-atencao-fundo px-3.5 py-2.5 text-[13px]">
  <TriangleAlert class="h-4 w-4 shrink-0 text-atencao" />
  <p class="min-w-[12rem] flex-1 text-tinta">2 voos estão sem relatório há mais de 3 dias.</p>
  <button class="campo h-7 rounded-lg px-2.5 text-xs font-semibold text-tinta transition-colors hover:bg-campo-hover">Ver voos</button>
</div>
```

Uma frase, o tom no ícone e a ação que resolve. Troque `atencao` por `perigo`, `ok` ou `marcado`; aviso neutro usa `campo` no lugar da borda e do fundo; erro leva `role="alert"`.

### Menu suspenso

```html
<!-- no <body> (portal): veja "Camadas que flutuam" -->
<div role="menu" class="vidro-forte fixed z-50 w-52 overflow-hidden rounded-xl py-1">
  <p class="px-3 pb-1 pt-2 text-[11px] font-semibold text-tinta-4">Passar para</p>
  <button role="menuitem" class="flex w-full items-center gap-2 px-3 py-2 text-left text-sm text-tinta transition-colors hover:bg-realce-forte">
    <Download class="h-4 w-4 text-tinta-3" /> Baixar planilha
    <Check class="ml-auto h-3.5 w-3.5 text-tinta" /><!-- só no item escolhido -->
  </button>
  <div class="my-1 border-t border-divisa"></div>
  <button role="menuitem" class="flex w-full items-center gap-2 px-3 py-2 text-left text-sm text-perigo transition-colors hover:bg-perigo-fundo">
    <Trash2 class="h-4 w-4" /> Apagar
  </button>
</div>
```

Abre colado no botão (4 px abaixo, alinhado pela borda). Fecha com Esc, clique fora e rolagem. O botão leva `aria-haspopup="menu"` e `aria-expanded`.

### Camadas que flutuam: sempre no `<body>`

Menu, dica de gráfico, popover, janela de diálogo e aviso rápido vão para o `<body>` (React `createPortal`, Vue `<Teleport to="body">`, Radix/shadcn já fazem). Dentro de uma `.vidro`, o `backdrop-filter` da janela vira a raiz do desfoque: o que está atrás do menu aparece nítido, o `position: fixed` passa a contar a partir da janela, e o `overflow-hidden` dela corta o menu.

### Janela de diálogo (no celular, folha que sobe)

```html
<div class="fixed inset-0 z-50 flex items-end justify-center bg-veu backdrop-blur-sm sm:items-center sm:p-4">
  <div role="dialog" aria-modal="true" aria-labelledby="titulo" class="vidro-forte flex max-h-[90dvh] w-full max-w-md animate-subir flex-col rounded-t-2xl outline-none sm:max-h-[85vh] sm:rounded-2xl">
    <div class="flex items-start justify-between gap-4 px-5 pb-3 pt-5 sm:px-6 sm:pt-6">
      <h3 id="titulo" class="text-lg font-semibold tracking-tight text-tinta">Exportar relatório</h3>
      <button aria-label="Fechar" class="-my-1.5 -mr-2 flex h-10 w-10 items-center justify-center rounded-lg text-tinta-4 transition-colors hover:bg-realce hover:text-tinta-2">
        <X class="h-5 w-5" />
      </button>
    </div>
    <div class="space-y-4 overflow-y-auto px-5 text-sm text-tinta-2 sm:px-6">…</div>
    <div class="flex justify-end gap-2 px-5 pb-[calc(1.25rem+env(safe-area-inset-bottom))] pt-5 sm:px-6 sm:pb-6">
      <button class="campo h-10 rounded-xl px-4 text-sm font-semibold text-tinta transition-colors hover:bg-campo-hover">Cancelar</button>
      <button class="h-10 rounded-xl bg-acao px-4 text-sm font-semibold text-acao-tinta transition-colors hover:bg-acao-hover">Exportar</button>
    </div>
  </div>
</div>
```

Esc fecha; o foco vai para o primeiro campo e volta ao botão de origem; o Tab fica preso dentro; o fundo fecha só se o toque começou nele; a página atrás não rola. Larguras: `max-w-sm`, `max-w-md` e `max-w-2xl`. Para apagar, o botão de perigo entra no lugar do grafite.

### Aviso rápido (toast)

```html
<div class="pointer-events-none fixed bottom-[calc(1rem+env(safe-area-inset-bottom))] left-4 right-4 z-[60] flex flex-col gap-2 sm:left-auto sm:right-4 sm:w-full sm:max-w-sm">
  <div role="status" class="vidro-forte pointer-events-auto flex items-start gap-3 rounded-2xl p-3.5">
    <CircleCheck class="mt-0.5 h-5 w-5 shrink-0 text-ok" />
    <p class="flex-1 text-sm text-tinta">Lista renomeada.</p>
    <button class="-my-1.5 shrink-0 rounded-lg px-2.5 py-1.5 text-sm font-semibold text-tinta underline decoration-tinta-4 underline-offset-4 transition-colors hover:bg-realce-forte">Desfazer</button>
    <button aria-label="Fechar aviso" class="-my-2 -mr-2 flex h-10 w-10 shrink-0 items-center justify-center rounded-lg text-tinta-4 transition-colors hover:bg-realce-forte hover:text-tinta-2">
      <X class="h-4 w-4" />
    </button>
  </div>
</div>
```

Entra pela direita (de `translate-x-4 opacity-0` para o lugar, em 200 ms) e sai sozinho em 6 s. Erro: `role="alert"` e ícone `text-perigo`; informação neutra, ícone `text-tinta-3`.

### Tabela

```html
<section class="vidro rounded-[18px]">
  <header class="flex flex-wrap items-center justify-between gap-3 px-4 pb-3 pt-4 lg:px-5">…título, busca, ⋯…</header>
  <div class="overflow-x-auto rolagem-fina pb-2">
    <table class="w-full min-w-[580px] text-sm">
      <thead>
        <tr class="border-y border-divisa">
          <th scope="col" class="px-4 py-2.5 text-left text-xs font-semibold text-tinta-3 lg:pl-5">Cliente</th>
          <th scope="col" class="px-4 py-2.5 text-right text-xs font-semibold text-tinta-3 lg:pr-5">Área (ha)</th>
        </tr>
      </thead>
      <tbody>
        <tr class="border-b border-divisa transition-colors last:border-0 hover:bg-realce">
          <td class="px-4 py-3 font-medium text-tinta lg:pl-5">Fazenda Boa Vista</td>
          <td class="px-4 py-3 text-right tabular-nums text-tinta lg:pr-5">186</td>
        </tr>
      </tbody>
    </table>
  </div>
</section>
```

Números à direita com `tabular-nums`; datas e colunas de apoio em `text-tinta-3`; situação com o selo discreto. Linha selecionada: `bg-realce-forte` no `<tr>` (a sombra do `item-sel` não funciona em linha de tabela). Em lista longa, cabeçalho fixo com `sticky top-0 fundo-secao`. No celular, a tabela rola de lado dentro da janela, e a página não.

### Indicador (KPI)

```html
<section class="vidro rounded-[18px] p-4 lg:p-5">
  <p class="text-[13px] font-medium text-tinta-3">Hectares aplicados</p>
  <p class="mt-1.5 text-2xl font-semibold leading-tight tracking-tight text-tinta lg:text-[28px]">12.480</p>
  <div class="mt-2 flex items-end justify-between gap-3">
    <p class="flex flex-wrap items-center gap-1 text-xs font-semibold text-ok">
      <TrendingUp class="h-3.5 w-3.5" />+8,2% <span class="font-medium text-tinta-3">vs. setembro</span>
    </p>
    <!-- mini tendência (80 × 32): linha de 1,5 px em --at-serie-contexto, ponto atual em --at-serie-destaque -->
  </div>
</section>
```

Variação sempre com sinal, seta e o período comparado: melhorou em `text-ok`, piorou em `text-perigo`, sem juízo em `text-tinta-3`. O valor grande não usa `tabular-nums`. Fileira de indicadores: `grid grid-cols-2 gap-2 lg:gap-3 xl:grid-cols-4`.

### Estado vazio

```html
<div class="flex flex-col items-center justify-center gap-3 px-6 py-10 text-center">
  <div class="campo flex h-14 w-14 items-center justify-center rounded-2xl text-tinta-3"><Bell class="h-7 w-7" /></div>
  <p class="text-lg font-semibold tracking-tight text-tinta">Nenhum alerta agora</p>
  <p class="max-w-xs text-sm text-tinta-3">Quando um voo precisar de você, ele aparece aqui.</p>
</div>
```

### Carregando

Esqueleto com a silhueta do conteúdo: `animate-pulse` e blocos `rounded bg-esqueleto` (linha principal `h-3`, secundária `h-2.5 opacity-60`, avatar `h-10 w-10 rounded-full`). Ao recarregar, mantenha a tela anterior em `opacity-60` em vez de piscar o esqueleto.

### Interruptor

```html
<button role="switch" aria-checked="true" class="relative inline-flex h-6 w-11 shrink-0 items-center rounded-full bg-acao transition-colors disabled:opacity-50">
  <span class="inline-block h-5 w-5 translate-x-[1.375rem] rounded-full bg-acao-tinta shadow transition-transform"></span>
</button>
<!-- desligado: trilha bg-trilho; bolinha bg-white translate-x-0.5 -->
```

### Outros

- **Cabeçalho de grupo fixo:** `fundo-secao sticky top-0 z-[1] px-4 pb-1.5 pt-3 text-xs font-semibold text-tinta-2`.
- **Separador de dia** (timeline): pílula `campo rounded-full px-3 py-1 text-[11px] font-semibold text-tinta-3`, centralizada.
- **Balões de conversa** (se houver): nosso `rounded-2xl rounded-tr-md bg-zinc-900 px-3.5 py-2 text-sm text-white dark:bg-zinc-700`; da outra pessoa, `folha rounded-2xl rounded-tl-md px-3.5 py-2 text-sm text-tinta`.

## 6. Gráficos e números

Antes da cor, escolha a forma. A paleta abaixo passou na checagem de daltonismo (protanopia e deuteranopia, diferença mínima entre vizinhos acima de 8) e de contraste sobre o vidro claro (`#f6f7f9`) e escuro (`#17191e`). No claro, laranja, água, amarelo e magenta ficam abaixo de 3:1; por isso todo gráfico tem legenda e o botão **Tabela**.

### A forma

| O dado | Use | Evite |
|---|---|---|
| Um número que importa agora | indicador (§5) com variação e mini tendência | gráfico de uma barra só |
| O número que abre o painel | número grande (40 a 48 px, semibold), um por tela | fonte de enfeite |
| Tendência no tempo | linha; com uma série, área com lavagem | barras para série longa |
| Comparar categorias | barras (horizontais se os nomes forem longos) | pizza |
| Parte de um todo | barra empilhada, até 4 partes e "Outras" | pizza 3D, rosca de valores parecidos |
| Uma série importa, o resto é contexto | destaque: a série em grafite, as outras em cinza | arco-íris |
| Antes e depois, meta | linha com a meta em traço fino; barras divergentes | dois eixos Y |
| Mais de 7 categorias com significado | tabela, ou tabela com gráfico | mais cores |

### A cor

- **Uma série:** grafite (`--at-serie-destaque`).
- **Destaque:** a série que importa em grafite, as outras em `--at-serie-contexto`.
- **Séries que são o assunto:** `--at-serie-1` a `-8`, sempre nessa ordem, e a cor segue a entidade (filtrar não repinta quem ficou). Até 4 é o confortável; de 5 a 8, com legenda; depois disso, junte o resto em "Outras" (cinza de contexto). Dispersão e mapa: no máximo 3 cores.
- **Intensidade** (mapa de calor, choropleth): `--at-seq-1` (pouco) a `--at-seq-7` (muito). No escuro a rampa já vem invertida.
- **Bom ou ruim:** os tons `ok`, `atencao` e `perigo`, sempre com ícone e texto. Nunca misture tom de situação e série no mesmo gráfico.
- **A cor da marca não entra em gráfico.**
- **Texto nunca na cor da série.** Valores, rótulos e legenda ficam em tinta; a cor vai na marquinha ao lado.

### O acabamento

- Linha de 2 px com cantos redondos. Ponto de 8 px com anel de 2 px na cor `--at-grafico-fundo`.
- Área: lavagem da cor da série, de 12% no alto até 0 na base (degradê vertical). Nunca um bloco cheio.
- Barra ou coluna de até 24 px, ponta com raio de 4 px e base reta. 2 px de vão entre partes empilhadas e entre barras encostadas; o vão é vazio, sem contorno.
- Grade: só linhas horizontais, finas e sólidas, em `--at-grade`; linha de base em `--at-eixo`. Sem grade vertical, sem tracejado.
- Eixos em 12 px e `--at-tinta-3`. O eixo Y mostra de 3 a 4 marcas redondas no padrão brasileiro (0; 3.000; 6.000; 9.000), a não ser que todas as barras tenham o valor escrito.
- Rótulo direto só onde conta (o último ponto, o total da última coluna), nunca em todos.
- Legenda sempre que houver 2 séries ou mais: quadradinho de 10 px `rounded-[3px]` (barras) ou traço (linhas) e o nome em `text-xs text-tinta-2`. Com uma série só, o título basta.
- Dica (tooltip): `vidro-forte` no `<body>`, valor primeiro (`text-sm font-semibold tabular-nums text-tinta`), nome depois (`text-tinta-3`), traço na cor da série. Na linha, uma mira vertical acha o ponto mais perto; nas barras, a coluna inteira é o alvo e ganha fundo `--at-realce`. Funciona também no teclado.
- Todo gráfico tem o botão **Tabela**, o gêmeo acessível com os mesmos números.
- Nunca dois eixos Y: números de escalas diferentes viram dois gráficos.

### A janela do gráfico

```html
<section class="vidro rounded-[18px]">
  <header class="flex items-start justify-between gap-3 px-4 pt-4 lg:px-5">
    <div>
      <h2 class="text-[15px] font-semibold tracking-tight text-tinta">Hectares aplicados por semana</h2>
      <p class="mt-0.5 text-xs text-tinta-3">Últimas 12 semanas</p>
    </div>
    <button aria-pressed="false" class="campo inline-flex h-8 shrink-0 items-center gap-1.5 rounded-[10px] px-2.5 text-xs font-semibold text-tinta-2 transition-colors hover:bg-campo-hover">
      <Table class="h-3.5 w-3.5" /> Tabela
    </button>
  </header>
  <ul class="flex flex-wrap gap-x-3.5 gap-y-1 px-4 pt-3 text-xs text-tinta-2 lg:px-5"><!-- legenda, com 2+ séries --></ul>
  <div class="relative px-2 pb-3 pt-2 lg:px-3"><!-- o gráfico --></div>
</section>
```

Altura fixa inclui a faixa do eixo X, para a janela não ganhar rolagem por dentro.

### Bibliotecas

**SVG à mão** (sem biblioteca): o `exemplo.html`, se vier junto, tem a linha e as colunas completas (`graficoLinha()` e `graficoColunas()`). O essencial:

```js
// desenhe na largura medida do contêiner e redesenhe quando ela mudar (com só viewBox, o texto estica)
new ResizeObserver(() => desenhar()).observe(conteiner)

// coluna com ponta de 4 px arredondada e base reta (rx arredondaria a base também)
const coluna = (x, y, w, h, r = Math.min(4, h / 2)) =>
  `M${x},${y + h}V${y + r}Q${x},${y} ${x + r},${y}H${x + w - r}Q${x + w},${y} ${x + w},${y + r}V${y + h}Z`
// <path d="${coluna(x, y, 24, h)}" style="fill: var(--at-serie-destaque)"/>

// alvo da dica: um <rect fill="transparent"> da altura do gráfico em cada faixa, por cima das barras;
// ao passar o mouse, mostre a dica (no <body>) e pinte a faixa com var(--at-realce)
```

Cores sempre por `style="fill: var(--at-…)"` ou `stroke`, nunca hex: assim o tema troca sem redesenhar.

**SVG por biblioteca** (Recharts, visx, Nivo): use `var(--at-…)` direto e o tema troca sem redesenhar.

```tsx
<ResponsiveContainer width="100%" height={250}>
  <AreaChart data={dados} margin={{ top: 14, right: 16, left: 0, bottom: 0 }}>
    <defs>
      <linearGradient id="lavagem" x1="0" y1="0" x2="0" y2="1">
        <stop offset="0" stopColor="var(--at-serie-destaque)" stopOpacity={0.12} />
        <stop offset="1" stopColor="var(--at-serie-destaque)" stopOpacity={0} />
      </linearGradient>
    </defs>
    <CartesianGrid vertical={false} stroke="var(--at-grade)" />
    <XAxis dataKey="semana" tickLine={false} axisLine={{ stroke: 'var(--at-eixo)' }} tick={{ fill: 'var(--at-tinta-3)', fontSize: 12 }} />
    <YAxis width={46} tickLine={false} axisLine={false} tick={{ fill: 'var(--at-tinta-3)', fontSize: 12 }} tickFormatter={(n) => n.toLocaleString('pt-BR')} />
    <Tooltip content={<DicaDeVidro />} cursor={{ stroke: 'var(--at-eixo)' }} />
    <Area type="monotone" dataKey="hectares" stroke="var(--at-serie-destaque)" strokeWidth={2} fill="url(#lavagem)"
      dot={false} activeDot={{ r: 4, fill: 'var(--at-serie-destaque)', stroke: 'var(--at-grafico-fundo)', strokeWidth: 2 }} />
  </AreaChart>
</ResponsiveContainer>
// Barras: <Bar dataKey="soja" stackId="a" fill="var(--at-serie-1)" maxBarSize={24} />;
// raio [4, 4, 0, 0] só na parte de cima da pilha.
```

**Canvas** (Chart.js, ECharts, uPlot): canvas não lê CSS. Leia os tokens e redesenhe quando o tema mudar:

```js
const token = (nome) => getComputedStyle(document.documentElement).getPropertyValue(nome).trim()
// monte as cores com token('--at-serie-1'), token('--at-grade'), token('--at-tinta-3')…
new MutationObserver(() => redesenhar()).observe(document.documentElement, { attributes: true, attributeFilter: ['class'] })
```

## 7. Tema escuro

- Classe `dark` no `<html>`; o bloco `.dark` dos tokens troca tudo.
- Sem escolha salva, segue o sistema. A escolha da pessoa vale por cima e fica salva.
- Aplique antes de pintar, senão a tela pisca branca:

```html
<script>
  (function () {
    try {
      var salvo = localStorage.getItem('tema') // 'claro' | 'escuro' | null
      var escuro = salvo ? salvo === 'escuro' : matchMedia('(prefers-color-scheme: dark)').matches
      document.documentElement.classList.toggle('dark', escuro)
    } catch (e) {}
  })()
</script>
```

- **Next:** `next-themes` com `<ThemeProvider attribute="class" defaultTheme="system" enableSystem disableTransitionOnChange>` e `<html suppressHydrationWarning>`.
- **Nuxt:** cookie lido no servidor e `useHead({ htmlAttrs: { class } })`, ou `@nuxtjs/color-mode` com `classSuffix: ''`.
- **Astro ou HTML:** o script acima no `<head>` (no Astro, com `is:inline`).
- O botão fica no rodapé da barra lateral: lua no claro, sol no escuro, com `aria-label` "Tema escuro" ou "Tema claro".
- Barra do navegador no celular, na cor do chão:

```html
<meta name="theme-color" media="(prefers-color-scheme: light)" content="#e9ebef">
<meta name="theme-color" media="(prefers-color-scheme: dark)" content="#0d0f12">
```

## 8. Celular

- `<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover, interactive-widget=resizes-content">`.
- A moldura usa `h-dvh`; topo, rodapé da barra, folhas e avisos respeitam `env(safe-area-inset-*)`.
- A barra lateral vira gaveta: `w-64`, fechada com `-translate-x-full` e `inert`; véu `fixed inset-0 z-30 bg-black/30 backdrop-blur-[2px]`; Esc e toque no véu fecham.
- Topo de vidro com o menu ☰ e a marca. Cabeçalhos compactos: nada de duas linhas de botões.
- A janela de diálogo vira folha que sobe de baixo (já está na receita do diálogo).
- Toque de 40 px (`h-10 w-10`); em barras densas, 32 px com `flex-1`.
- Campo com 16 px no iPhone, para não dar zoom (a regra já está nos tokens).
- Respiro de 8 px; indicadores em duas colunas; tabela rola de lado dentro da janela. Em 390 px de largura a página não pode rolar de lado.

## 9. Comportamento e textos

- **Ação que dá para voltar:** faça na hora e ofereça **Desfazer** no aviso rápido. Confirmação só para o que não volta (apagar), sempre numa janela de diálogo, nunca `window.confirm`.
- **Resposta sempre:** hover, foco visível (o contorno já vem nos tokens), carregando, deu certo, deu errado.
- **Erro** diz o que aconteceu e oferece "Tentar novamente".
- **Textos:** frase normal, curta e direta, sem jargão de sistema. Botão é verbo ("Exportar", "Salvar"); rótulo sem dois-pontos; números no padrão brasileiro (1.420; R$ 286 mil; 8,2%; 31/10).
- **Ícones:** só lucide, traço 2. 16 px em botões e menus, 18 px na barra lateral, 20 px em botões de 40 px, 14 px dentro de texto pequeno. O ícone herda a cor do texto; só ícone de tom leva cor.
- **Movimento:** cores em 150 ms (`transition-colors`); entradas de 200 a 250 ms com `ease-out` (`animate-surgir`, `animate-subir`); gaveta em 200 ms. Quem pede "reduzir movimento" fica sem animação (já nos tokens).

## 10. Não faça

| Não | Faça |
|---|---|
| Botão principal na cor da marca (verde, azul…) | grafite (`bg-acao`) |
| Fundo liso, branco ou cinza chapado, atrás do vidro | `fundo-app`, com a luz |
| Vidro dentro de vidro; desfoque em cada linha de lista | vidro só em janelas e no que flutua; dentro, `campo`, `folha`, `item-sel` |
| Menu ou dica dentro da janela | no `<body>` (portal) |
| Borda cinza forte, sombra preta curta | `border-divisa` e as sombras dos tokens |
| Preto puro ou azul-marinho no escuro | os tokens do `.dark` (grafite) |
| Rótulo em CAIXA ALTA com letras espaçadas | frase normal, 12 px semibold, `text-tinta-3` |
| Título em extrabold | `font-semibold tracking-tight` |
| Ícone colorido de enfeite, cartões de cores diferentes | ícone na cor do texto; cor só no estado |
| Cor fixa sem o par do escuro (`text-gray-900` sozinho) | papéis (`text-tinta`), que trocam sozinhos |
| Pizza, arco-íris, dois eixos, número em todo ponto | a §6 |
| A página inteira rolando, com o fundo junto | só o `main` rola; o chão fica parado |

## 11. Checklist

1. Alterne claro e escuro em todas as telas: nada some, nada fica preto chapado ou azul-marinho.
2. Entre as janelas aparece o chão (8 a 12 px), com a luz suave.
3. Fora dos gráficos, cor só na marca, na novidade e nos tons com significado.
4. Cada tela tem uma ação principal, grafite.
5. Nenhum hex fora do bloco de tokens.
6. Menu, dica e janela de diálogo desfocam o que está atrás (moram no `<body>`).
7. Celular em 390 px: sem rolagem de lado, toques de 40 px, folha no lugar da janela, campo de 16 px no iPhone.
8. Gráficos: legenda com 2 séries ou mais, botão Tabela, texto nunca na cor da série.
9. Lado a lado com as referências: a mesma calma, o mesmo vidro, o mesmo grafite.

---

Origem: Drone Sense Atende (out/2026). As variáveis usam o prefixo `--at-` para não brigar com os tokens de marca de outros apps. A paleta de gráficos foi checada para daltonismo e contraste sobre o vidro claro e o escuro.
