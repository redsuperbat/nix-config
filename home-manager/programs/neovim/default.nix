{
  pkgs,
  config,
  rustproof,
  configDir,
  pkgs-pinned,
  ...
}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    extraPackages = with pkgs; [
      imagemagick # For viewing images
      ghostscript # For rendering pdf:s
      mermaid-cli # For rendering mermaid diagrams
      actionlint # Github action linter
      alejandra # nix formatter
      checkmake # Makefile linter
      dockerfile-language-server
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
      copilot-language-server
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
      ruby-lsp
      tinymist # typst language server
      typstyle # typst formatter
      oxlint # linter for js/ts files
      fish-lsp

      # TODO: reconfigure lsp for vue
      # The package is pinned to version 0.2.8 since
      # 0.3.0 is causing all types of issues
      pkgs-pinned.vue-language-server
      yaml-language-server
    ];
  };

  # Set default manpage viewer to neovim
  home.sessionVariables.MANPAGER = "nvim +Man!";

  # source lua config
  xdg.configFile = {
    "nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${configDir}/nix-config/home-manager/programs/neovim/nvim";
      recursive = true;
    };
  };
}
