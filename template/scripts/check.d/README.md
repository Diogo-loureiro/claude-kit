# Project checks

`*.sh` files here belong to the project (the kit never overwrites them). `scripts/check` runs each
one in alphabetical order in `stop` and `ci` modes, passing the mode as `$1`. Silent on success,
non-zero exit on failure. Example: `10-architecture.sh` running import-linter or dependency-cruiser.
