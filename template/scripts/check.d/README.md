# Checks do projeto

Arquivos `*.sh` aqui são do projeto (o kit nunca os sobrescreve). O `scripts/check` roda cada um
em ordem alfabética nos modos `stop` e `ci`, passando o modo como `$1`. Silêncio no sucesso,
exit != 0 na falha. Exemplo: `10-architecture.sh` com import-linter ou dependency-cruiser.
