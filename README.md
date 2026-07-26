# nix_dev_templates

Nix flake templates for development environments on systems with the nix package manager installed.

## Templates

Implemented:
- python

Planned:
- nodejs
- ?

## Usage

Recommended to use with `nix-direnv`.

1. Get template in your working directory: `nix flake init -t github:alikhamze/nix_dev_templates#python`
2. Create git repo: `git init`
3. Commit template files after making initial changes.
4. Create flake lock file: `nix flake update`
5. Enable nix-direnv: `direnv allow`

## License

[CNPLv8+](https://git.pixie.town/thufie/npl-builder)
