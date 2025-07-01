{pkgs, ...}: {
  home.packages = with pkgs; [
    (writeScriptBin "js" (builtins.readFile ./bin/js.ts))
    (writeScriptBin "mkpr" (builtins.readFile ./bin/mkpr.ts))
  ];
}
