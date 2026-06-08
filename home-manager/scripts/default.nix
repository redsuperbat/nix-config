{pkgs, ...}: {
  home.packages = with pkgs; [
    (writeScriptBin "js" (builtins.readFile ./bin/js.ts))
    (writeScriptBin "vfile" (builtins.readFile ./bin/vfile.fish))
    (writeScriptBin "mkpr" (builtins.readFile ./bin/mkpr.fish))
    (writeScriptBin "linear" (builtins.readFile ./bin/linear.fish))
    (writeScriptBin "liag" (builtins.readFile ./bin/linear_agent.fish))
    (writeScriptBin "plan" (builtins.readFile ./bin/plan.fish))
    (writeScriptBin "dbconnect" (builtins.readFile ./bin/dbconnect.fish))
    (writeScriptBin "tmux-file-picker" (builtins.readFile ./bin/tmux-file-picker.bash))
  ];
}
