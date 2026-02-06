{pkgs, ...}: {
  home.packages = with pkgs; [
    (writeScriptBin "js" (builtins.readFile ./bin/js.ts))
    (writeScriptBin "mkpr" (builtins.readFile ./bin/mkpr.fish))
    (writeScriptBin "linear" (builtins.readFile ./bin/linear.fish))
  ];
}
