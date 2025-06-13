{
  pkgs,
  config,
  self,
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
      dockerfile-language-server-nodejs
      golangci-lint
      gopls
      gotools
      hadolint # Dockerfile linter
      isort
      lua-language-server
      nil # nix language server
      nodePackages.prettier
      pyright
      ruby-lsp
      ruff
      rust-analyzer
      shellcheck
      shfmt
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
    ];
  };

  # source lua config from this repo
  xdg.configFile = {
    "nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${self}/home-manager/programs/neovim/nvim";
      recursive = true;
    };
  };
}
