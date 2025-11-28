{pkgs, ...}: let
  tmux-file-picker = pkgs.stdenv.mkDerivation {
    pname = "tmux-file-picker";
    version = "unstable-2025-01-28";

    src = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/raine/tmux-file-picker/main/tmux-file-picker";
      sha256 = "1g2jqappf543ibs75zxa6cxc7hlwfj71wcb2mzh2yxifij70qkif";
    };

    dontUnpack = true;
    dontBuild = true;

    nativeBuildInputs = [pkgs.makeWrapper];

    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/tmux-file-picker
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
