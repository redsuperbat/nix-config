{
  pkgs,
  config,
  self,
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
      ruby-lsp
      ruff # Python linter
      rustproof # Spell checker
      shellcheck
      shfmt # shell formatter
      sqlfluff
      stylua
      tailwindcss-language-server
      taplo # Toml toolkit
      terraform-ls
      tflint # Terraform linter
      typescript-language-server
      vscode-langservers-extracted
      vue-language-server
      yaml-language-server
      tree-sitter
      tex-fmt # Latex formatter
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
