{
  description = "Python dev shell template with libraries for numpy and matplotlib. Packages managed by uv.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05"; # Adjust nixpkgs as desired, either to a different version or nixpkgs-unstable.
  };

  outputs =
    { self, nixpkgs }:
    let
      inherit (nixpkgs) lib;

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems = f: lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});

    in
    {
      devShells = forAllSystems (
        pkgs:
        let
          # The python interpreter uv will use. Pinned here so the flake determines
          # the Python version. Choose between the cachix generic build and 
          # the optimized build.
          #python = pkgs.python314;
          python = pkgs.python314.override {
            enableOptimizations = true;
            enableLTO = true;
          };

          # Shared libraries that PyPI wheels expect to find on a normal
          # FHS distro. Their bundled .so files are not patched by Nix, so
          # they resolve dependencies via LD_LIBRARY_PATH at import time.
          runtimeLibs = with pkgs; [
            stdenv.cc.cc.lib # libstdc++.so.6, libgcc_s.so.1, libgomp.so.1
            zlib # libz.so.1 - numpy
            zstd
            openssl
            glib libGL # opencv, matplotlib GUI backends

            # Add as your dependencies grow:
            # numactl              # some torch builds want libnuma.so.1
          ];
          # If an import fails with a missing .so, run
          # ldd .venv/lib/python3.14/site-packages/<pkg>/<file>.so | grep 'not found' 
          # to find which library to add to runtimeLibs.

          libPath = lib.makeLibraryPath runtimeLibs;
        in
        {
          default = pkgs.mkShell {
            packages = [
              python
              pkgs.uv
              pkgs.git
              pkgs.ruff
            ];

            env = {
              # Point uv at the Nix interpreter and forbid it from fetching
              # its own. (To let uv manage Python, delete these lines and
              # enable programs.nix-ld system-wide instead.)
              UV_PYTHON = "${python}/bin/python";
              UV_PYTHON_DOWNLOADS = "never";

              # Keep the venv inside the project directory.
              UV_PROJECT_ENVIRONMENT = ".venv";
            }
            // lib.optionalAttrs pkgs.stdenv.isLinux {
              LD_LIBRARY_PATH = libPath;
              # Disabled - Ignored unless programs.nix-ld is enabled; harmless otherwise.
              # NIX_LD_LIBRARY_PATH = libPath;
            };

            shellHook = ''
              if [ ! -f pyproject.toml ]; then
                echo "no pyproject.toml here — run 'uv init' to start a project"
              else
                uv sync --quiet
                source .venv/bin/activate
              fi
            '';
          };
        }
      );
    };
}
