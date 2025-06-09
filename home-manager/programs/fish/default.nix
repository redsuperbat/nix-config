{pkgs, ...}: {
  programs.fish = {
    enable = true;
    shellInit = ''
      # Source theme
      source $HOME/.config/fish/kanagawa.fish
    '';

    plugins = [
      {
        name = "nvm.fish";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "nvm.fish";
          rev = "846f1f20b2d1d0a99e344f250493c41a450f9448";
          sha256 = "";
        };
      }
    ];

    functions = {
      # Clear all logs in all windows
      clw = ''
        for pane in (tmux list-panes -F "#{pane_id}")
            tmux send-keys -t $pane C-z clear Enter
            tmux clear-history -t $pane
        end
      '';
      cl = "clear; tmux clear-history";
      # Do not print fish greeting
      fish_greeting = "";
      kill_port = "kill -9 $(lsof -ti:$argv[1])";
      fish_prompt = ''
        set -l __last_command_exit_status $status

        if not set -q -g __fish_arrow_functions_defined
            set -g __fish_arrow_functions_defined
            function _git_branch_name
                set -l branch (git symbolic-ref --quiet HEAD 2>/dev/null)
                if set -q branch[1]
                    echo (string replace -r "^refs/heads/" "" $branch)
                else
                    echo (git rev-parse --short HEAD 2>/dev/null)
                end
            end

            function _is_git_dirty
                not command git diff-index --cached --quiet HEAD -- &>/dev/null
                or not command git diff --no-ext-diff --quiet --exit-code &>/dev/null
            end

            function _is_git_repo
                type -q git
                or return 1
                git rev-parse --git-dir >/dev/null 2>&1
            end

            function _hg_branch_name
                echo (hg branch 2>/dev/null)
            end

            function _is_hg_dirty
                set -l stat (hg status -mard 2>/dev/null)
                test -n "$stat"
            end

            function _is_hg_repo
                fish_print_hg_root >/dev/null
            end

            function _repo_branch_name
                _$argv[1]_branch_name
            end

            function _is_repo_dirty
                _is_$argv[1]_dirty
            end

            function _repo_type
                if _is_hg_repo
                    echo hg
                    return 0
                else if _is_git_repo
                    echo git
                    return 0
                end
                return 1
            end
        end

        set -l cyan (set_color -o cyan)
        set -l yellow (set_color -o yellow)
        set -l red (set_color -o red)
        set -l green (set_color -o green)
        set -l blue (set_color -o blue)
        set -l normal (set_color normal)

        set -l arrow_color "$green"
        if test $__last_command_exit_status != 0
            set arrow_color "$red"
        end

        set -l arrow "$arrow_color➜"
        if fish_is_root_user
            set arrow "$arrow_color# "
        end

        set -l cwd $cyan(prompt_pwd | path basename)

        set -l repo_info
        if set -l repo_type (_repo_type)
            set -l repo_branch $red(_repo_branch_name $repo_type)
            set repo_info "$blue $repo_type:($repo_branch$blue)"

            if _is_repo_dirty $repo_type
                set -l dirty "$yellow ✗"
                set repo_info "$repo_info$dirty"
            end
        end

        echo -n -s $arrow " "$cwd $repo_info $normal " "
      '';
    };

    binds = {
      "ctrl-y" = {
        mode = "insert";
        command = "accept-autosuggestion execute";
      };
    };

    shellAliases = {
      htop = "btm";

      # git
      gaa = "git add --all";
      gcam = "git commit --all --message";
      gcl = "git clone";
      gco = "git checkout";
      ggl = "git pull";
      ggp = "git push";
      gap = "git add :/ -Ap";

      kc = "kubectl";
      lg = "lazygit";
      ld = "lazydocker";

      repo = "cd $HOME/Documents/repositories";
      temp = "cd $HOME/Downloads/temp";

      v = "nvim";
      vi = "nvim";
      vim = "nvim";

      ls = "eza -1a --group-directories-first";
      ll = "eza -bhl --icons --group-directories-first"; # long list
      la = "eza -abhl --icons --group-directories-first"; # all list
      lt = "eza --tree --level=2 --icons"; # tree
    };
  };
}
