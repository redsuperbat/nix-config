{
  pkgs,
  config,
  configDir,
  ...
}: {
  home.file.".claude/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${configDir}/nix-config/home-manager/programs/claude-code/settings.json";

  home.file.".claude/statusline.sh" = {
    source = ./statusline.sh;
    executable = true;
  };

  # Set editorMode in ~/.claude.json (runtime state file) without clobbering other keys
  home.activation.claudeEditorMode = config.lib.dag.entryAfter ["writeBoundary"] ''
    FILE="$HOME/.claude.json"
    if [ -f "$FILE" ]; then
      ${pkgs.jq}/bin/jq '.editorMode = "vim"' "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
    else
      echo '{"editorMode": "vim"}' > "$FILE"
    fi
  '';
}
