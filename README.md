# nix_dev_templates

My nix flake templates for development environments on systems with the nix package manager installed.

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

## Cleaning up completed/legacy projects

`nix-direnv` dependencies are kept in the nix store and symlinked (I believe) into the `.direnv` directory.
As long as those symlinks exist, normal nix garbage collection will not delete those packages from the store.

Once you're done working on a project, to clean the store, you can do the following:
```sh
nix-store --gc --print-roots | grep direnv # finds which direnv environments are holding which packages in the store
rm -fr path/to/the/.direnv/folder          # remove the symlinks blocking the gc
nix-collect-garbage -d                     # garbage collect again now  that the blocker is removed
```

## License

[CNPLv8+](https://git.pixie.town/thufie/npl-builder)

(I originally wanted to keep this repo private, but I also don't want to login on every system I want to use these on.
For that reason, and because I have learned a lot from others' nix repos, I'm making it public.
Rather than reserving all rights, I'm putting an ethical license on it so others can learn from my templates and use them in positive ways.
