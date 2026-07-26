{
  description = "A collection of flake templates";

  outputs = { self }: {

    templates = {

      python = {
        path = ./python;
        description = "Python template, with packages managed by uv and support for auto-rebuilding with nix-direnv.";
        welcomeText = ''
          # Getting started
          - Run `git init`
          - Commit the flake, .gitignore, .envrc, and pyproject.toml.
          - Run `nix flake update` to make the flake lockfile and commit it.
          - Enable `nix-direnv` with `direnv allow`
          - Add packages with `uv add <package name>`
        '';
      };

    };

    defaultTemplate = self.templates.python;

  };
}
