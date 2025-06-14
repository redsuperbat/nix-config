{...}: {
  programs.direnv = {
    enable = true;
    # Function which can be used in nix shell hooks
    # to export functions
    stdlib = ''
      export_function() {
        local name=$1
        local alias_dir=$PWD/.direnv/aliases
        mkdir -p "$alias_dir"
        PATH_add "$alias_dir"
        local target="$alias_dir/$name"
        if declare -f "$name" >/dev/null; then
          echo "#!/usr/bin/env bash" > "$target"
          declare -f "$name" >> "$target" 2>/dev/null
          echo "$name" >> "$target"
          chmod +x "$target"
        fi
      }
    '';
    nix-direnv.enable = true;
  };
}
