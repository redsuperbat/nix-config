{
  userConfig,
  config,
  ...
}: {
  # Install git via home-manager module
  programs.git = {
    enable = true;
    settings = {
      user = {
        email = userConfig.email;
        name = userConfig.fullName;
      };
      pull.rebase = "true";
      core.hooksPath = "${config.xdg.configHome}/git/hooks";
    };
    signing = {
      format = "ssh";
      signByDefault = true;
      key = "~/.ssh/id_ed25519.pub";
    };
  };

  # Global commit-msg hook: reject commits that include a Co-authored-by trailer.
  xdg.configFile."git/hooks/commit-msg" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # Disallow co-authored commits.
      if grep -qiE '^[[:space:]]*Co-authored-by:' "$1"; then
        echo "error: co-authored commits are not allowed (found a Co-authored-by trailer)." >&2
        exit 1
      fi
    '';
  };
}
