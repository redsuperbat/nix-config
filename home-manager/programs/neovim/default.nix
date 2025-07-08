{
  pkgs,
  config,
  rustproof,
  configDir,
  ...
}: {
  # Neovim text editor configuration
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    extraPackages = with pkgs; [
      actionlint # Github action linter
      alejandra # nix formatter
      checkmake # Makefile linter
      dockerfile-language-server-nodejs
      golangci-lint
      gopls
      gotools
      hadolint # Dockerfile linter
      intelephense # php language server
      lua-language-server
      nil # nix language server
      nodePackages.prettier
      postgres-lsp
      ruff # Python linter & formatter
      rustproof # Spell checker
      shellcheck
      shfmt # shell formatter
      sqlfluff
      stylua
      tailwindcss-language-server
      taplo # Toml toolkit
      tectonic # Latex compiler
      terraform-ls
      tex-fmt # Latex formatter
      texlab # Latex lsp
      tflint # Terraform linter
      tree-sitter
      ty # Python LSP
      typescript-language-server # Official ts version
      typescript-go # Go implementation of typescript
      vscode-langservers-extracted
      vue-language-server
      yaml-language-server
    ];
  };

  # Set default manpage viewer to neovim
  home.sessionVariables.MANPAGER = "nvim +Man!";

  # source lua config from this repo
  xdg.configFile = {
    "nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${configDir}/nix-config/home-manager/programs/neovim/nvim";
      recursive = true;
    };
  };
}
