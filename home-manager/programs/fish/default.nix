{
  workspaceDir,
  pkgs,
  ...
}: {
  # Set shell to fish
  home.sessionVariables.SHELL = "${pkgs.fish}";

  programs.fish = {
    enable = true;
    shellInit =
      # fish
      ''
        fish_vi_key_bindings

        set -l foreground DCD7BA normal
        set -l selection 2D4F67 brcyan
        set -l comment 727169 brblack
        set -l red C34043 red
        set -l orange FF9E64 brred
        set -l yellow C0A36E yellow
        set -l green 76946A green
        set -l purple 957FB8 magenta
        set -l cyan 7AA89F cyan
        set -l pink D27E99 brmagenta

        # Syntax Highlighting Colors
        set -g fish_color_normal $foreground
        set -g fish_color_command $cyan
        set -g fish_color_keyword $pink
        set -g fish_color_quote $yellow
        set -g fish_color_redirection $foreground
        set -g fish_color_end $orange
        set -g fish_color_error $red
        set -g fish_color_param $purple
        set -g fish_color_comment $comment
        set -g fish_color_selection --background=$selection
        set -g fish_color_search_match --background=$selection
        set -g fish_color_operator $green
        set -g fish_color_escape $pink
        set -g fish_color_autosuggestion $comment

        # Completion Pager Colors
        set -g fish_pager_color_progress $comment
        set -g fish_pager_color_prefix $cyan
        set -g fish_pager_color_completion $foreground
        set -g fish_pager_color_description $comment
      '';

    functions = {
      # Clear all logs in all windows
      clw =
        # fish
        ''
          for pane in (tmux list-panes -F "#{pane_id}")
              tmux send-keys -t $pane C-z clear Enter
              tmux clear-history -t $pane
          end
        '';
      cl = "clear; tmux clear-history";
      fish_greeting = ""; # Do not print fish greeting
      kill_port = "kill -9 $(lsof -ti:$argv[1])";
      git_bootstrap = "_clone__tmux $argv[1] (basename $argv[1] .git)";
      new_project =
        # fish
        ''
          set project_name $argv[1]
          set project_path "${workspaceDir}/$project_name"

          if tmux has-session -t $project_name &>/dev/null
              tmux switch-client -t $project_name
              return
          end

          if test -d $project_path
              echo "Project exists, creating new session"
              tmux new-session -ds $project_name -c $project_path
              tmux switch-client -t $project_path
              return
          end

          echo "Bootstrapping $project_name"
          mkdir -p $project_path
          tmux new-session -ds $project_name -c $project_path
          tmux switch-client -t $project_path
        '';
      _clone__tmux =
        # fish
        ''
          set repository_url $argv[1]
          set repository_name $argv[2]
          set repository_path "${workspaceDir}/$repository_name"

          if tmux has-session -t $repository_name &>/dev/null
              echo "Session exists switching to it"
              tmux switch-client -t $repository_name
              return
          end

          if test -d $repository_path
              echo "Repository exists on machine creating new session"
              tmux new-session -ds $repository_name -c $repository_path
              tmux switch-client -t $repository_name
              return
          end

          echo "Bootstrapping $repository_name"
          git clone $repository_url $repository_path
          tmux new-session -ds $repository_name -c $repository_path
          tmux switch-client -t $repository_name
        '';
      fzf_file =
        # fish
        ''
          set file (fzf --walker-root "${workspaceDir}" --preview "bat {}")
          if not test -f "$file"
              return
          end
          # cat only if piped to another command
          if test -t 1
              bat "$file"
          else
              cat "$file"
          end
        '';
      github_tms =
        # fish
        ''
          if not gh auth status &>/dev/null
              echo "Not logged in, authenticate with github first"
              gh auth login
          end

          set org $argv[1]
          set repositories (gh repo list --json sshUrl,name -L 1000 $org)
          set selected_item (echo $repositories | jq -r ".[].name" | cat -n | fzf | string trim)
          if test -z "$selected_item"
              return
          end
          set selected_item_index (echo $selected_item | awk '{print $1}')
          set index (math "$selected_item_index - 1")
          set repository_url (echo $repositories | jq -r ".[$index].sshUrl")
          set repository_name (echo $repositories | jq -r ".[$index].name")
          _clone__tmux $repository_url $repository_name
        '';
      fish_prompt =
        # fish
        ''
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
        command = [
          "accept-autosuggestion"
          "execute"
        ];
        operate = "preset";
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

      nds = "nh darwin switch";

      kc = "kubectl";
      lg = "lazygit";
      ld = "lazydocker";

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
