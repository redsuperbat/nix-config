{pkgs, ...}: {
  home.packages = with pkgs; [
    (writeScriptBin "js" (builtins.readFile ./bin/js.js))
  ];
}
