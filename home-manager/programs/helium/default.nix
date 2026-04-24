{
  pkgs,
  helium,
  ...
}: {
  programs.helium = {
    enable = true;
    package = helium.packages.${pkgs.system}.helium.overrideAttrs (old: {
      src = pkgs.fetchurl {
        url = old.src.url;
        hash = "sha256-qLsd9TNAri8ytp2LyRiRQmCxrvC60r/JYQZCpdEP8es=";
      };
    });
    extensions = [
      {
        id = "nngceckbapebfimnlniiiahkandclblb";
        hash = "sha256-XOVs2Tvay8hQ13SHz+728BDu2mMyQ0JxUuUI6FZ1NaM=";
      } # Bitwarden
      {
        id = "gppongmhjkpfnbhagpmjfkannfbllamg";
        hash = "sha256-47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=";
      } # Wappalyzer
      {
        id = "fmkadmapgofadopljbjfkapdkoienihi";
        hash = "sha256-X3DIlm39NyFz8bGKVjubF8JGeS58EirqeETOBk8Hfgc=";
      } # React developer tools
      {
        id = "khncfooichmfjbepaaaebmommgaepoid";
        hash = "sha256-hiKyaY3/CLquJqjDY49STmbfwSVi5yhpSBn6HvLigCM=";
      } # Unhook youtube shorts
      {
        id = "dbepggeogbaibhgnhhndojpepiihcmeb";
        hash = "sha256-MZjCaqcZvkYt6lhQUPvtm4uAYo1X6oihE7q/UzTFUXw=";
      } # Vimium
    ];
  };
}
