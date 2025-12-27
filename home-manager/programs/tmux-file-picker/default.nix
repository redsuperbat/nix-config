{pkgs, ...}: let
  tmux-file-picker = pkgs.stdenv.mkDerivation {
    pname = "tmux-file-picker";
    version = "unstable-2025-01-28";
    src = pkgs.fetchFromGitHub {
      owner = "raine";
      repo = "tmux-file-picker";
      rev = "840bd302a281267e5fde2a8323682faa873cc718";
      sha256 = "sha256-gV65yhf4mFLoYg+Lf8RuLmhRwbF6ZawYqZLkRCSpXuQ=";
    };
    dontBuild = true;
    nativeBuildInputs = [pkgs.makeWrapper];
    installPhase = ''
      mkdir -p $out/bin
      cp tmux-file-picker $out/bin/tmux-file-picker
      chmod +x $out/bin/tmux-file-picker
      wrapProgram $out/bin/tmux-file-picker \
        --prefix PATH : ${
        pkgs.lib.makeBinPath [
          pkgs.tmux
          pkgs.fzf
          pkgs.fd
          pkgs.git
          pkgs.zoxide
          pkgs.bat
          pkgs.tree
          pkgs.coreutils-prefixed
          pkgs.gnugrep
        ]
      }
    '';
    meta = with pkgs.lib; {
      description = "Pop up fzf in tmux to quickly insert file paths";
      homepage = "https://github.com/raine/tmux-file-picker";
      license = licenses.mit;
      platforms = platforms.unix;
      maintainers = [];
    };
  };
in {
  home.packages = [tmux-file-picker];
}
