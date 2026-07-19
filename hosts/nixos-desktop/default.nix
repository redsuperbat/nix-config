{
  config,
  pkgs,
  userConfig,
  homeDir,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # Nix settings
  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = "nix-command flakes";
      download-buffer-size = 524288000;
    };
    optimise.automatic = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  # Boot loader — adjust if the machine uses GRUB/BIOS instead of UEFI.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos-desktop";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Stockholm";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

  # User configuration
  users.users.${userConfig.name} = {
    isNormalUser = true;
    description = userConfig.fullName;
    home = homeDir;
    shell = pkgs.fish;
    extraGroups = ["wheel" "networkmanager" "docker" "video" "audio"];
  };

  # Fish must be enabled at the system level to be a valid login shell
  programs.fish.enable = true;

  # Hyprland - the per-user config lives in
  # home-manager/programs-linux/hyprland
  programs.hyprland.enable = true;

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
      user = "greeter";
    };
  };

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true; # 32-bit audio for Steam/Proton games
    pulse.enable = true;
  };

  services.printing.enable = true;

  virtualisation.docker.enable = true;

  hardware.graphics = {
    enable = true;
    # 32-bit support is required by Steam/Proton games
    enable32Bit = true;
  };

  # NVIDIA RTX 3060 (Ampere). Use the proprietary `nvidia` driver instead of
  # the default nouveau — required for usable gaming performance, CUDA, etc.
  # `steam` etc. is unfree (allowUnfree is set in the flake).
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    # NVIDIA's own open-source kernel module. Recommended (and as of the R560
    # driver, the default) for Turing-generation cards and newer — Ampere
    # qualifies. The userspace libraries are still proprietary, hence unfree.
    open = true;
    modesetting.enable = true; # required for Wayland; good practice on X11 too
    nvidiaSettings = true; # the `nvidia-settings` GUI + `nvidia-smi`
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Steam + Proton. `steam` is unfree (allowUnfree is set in the flake).
  # Patch bubblewrap to work around "Unexpected capabilities but not setuid"
  # error (nixpkgs#217119). The check is removed so Steam's FHS sandbox can
  # run even when the bwrap binary carries file capabilities without setuid.
  programs.steam = let
    patchedBwrap = pkgs.bubblewrap.overrideAttrs (o: {
      patches = (o.patches or []) ++ [./bwrap.patch];
    });
  in {
    enable = true;
    remotePlay.openFirewall = true; # Steam Remote Play
    dedicatedServer.openFirewall = true; # Source dedicated server ports
    # Proton ships with Steam; add Proton-GE as an extra compatibility tool.
    # Select it per-game via Steam > Properties > Compatibility.
    extraCompatPackages = [pkgs.proton-ge-bin];
    package = pkgs.steam.override {
      buildFHSEnv = args:
        (pkgs.buildFHSEnv.override {bubblewrap = patchedBwrap;})
        args;
    };
  };

  # Helium browser (ungoogled-chromium based). `pkgs.helium` is provided by
  # the helium-browser flake overlay applied in flake.nix (Linux only).
  environment.systemPackages = [pkgs.helium];

  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.symbols-only
  ];

  # Used for backwards compatibility, please read the changelog before changing.
  # https://nixos.org/manual/nixos/stable/options.html#opt-system.stateVersion
  system.stateVersion = "26.05";
}
