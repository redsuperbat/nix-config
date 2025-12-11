{
  pkgs,
  userConfig,
  homeDir,
  ...
}: {
  # Nix settings
  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = "nix-command flakes";
      download-buffer-size = 524288000;
    };
    optimise.automatic = true;
  };

  # User configuration
  users.users.${userConfig.name} = {
    description = userConfig.fullName;
    name = userConfig.name;
    home = homeDir;
  };

  # Add ability to use TouchID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # System settings
  system = {
    primaryUser = userConfig.name;

    activationScripts.postActivation.text = ''
      # Following line should allow us to avoid a logout/login cycle when changing settings
      sudo -u ${userConfig.name} /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

    defaults = {
      CustomUserPreferences = {
        # Disable slack auto updates
        "com.tinyspeck.slackmacgap" = {
          SlackNoAutoUpdates = true;
        };
        "com.apple.symbolichotkeys" = {
          AppleSymbolicHotKeys = {
            # Disable '󰘳  + Space' for Spotlight Search
            "64".enabled = false;
            # Disable '󰘳  + Alt + Space' for Finder search window
            "65".enabled = false;
            # Disable 'Control + Space' for changing locale
            "60".enabled = false;
            # Disable '󰘳  + m' for minimizing windows
            "233".enabled = false;
            # Rebind "move focus to next window" to 󰘳  + §
            "27" = {
              enabled = true;
              value = {
                type = "standard";
                parameters = [
                  65535
                  10
                  1048576
                ];
              };
            };
          };
        };
      };
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        ApplePressAndHoldEnabled = false;
        AppleShowAllExtensions = true;
        KeyRepeat = 1; # Time ms between key-repeats when holding key down
        InitialKeyRepeat = 20; # Time ms before key repeat starts
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticWindowAnimationsEnabled = false;
        NSDocumentSaveNewDocumentsToCloud = false;
        NSNavPanelExpandedStateForSaveMode = true;
        PMPrintingExpandedStateForPrint = true;
      };
      LaunchServices.LSQuarantine = false; # Do not ask when opening downloaded apps
      trackpad = {
        TrackpadRightClick = true;
        Clicking = true;
      };
      finder = {
        AppleShowAllFiles = true;
        CreateDesktop = false;
        FXDefaultSearchScope = "SCcf"; # Search in current folder
        FXEnableExtensionChangeWarning = false; # Do not warn when changing file extensions
        FXPreferredViewStyle = "Nlsv"; # Show list mode always
        QuitMenuItem = true;
        ShowPathbar = true;
        ShowStatusBar = true;
        _FXShowPosixPathInTitle = true;
        _FXSortFoldersFirst = true;
      };
      dock = {
        autohide = true;
        expose-animation-duration = 0.15;
        show-recents = false;
        showhidden = true;
        persistent-apps = [];
        tilesize = 30;
        wvous-bl-corner = 5;
        wvous-br-corner = 1;
        wvous-tl-corner = 1;
        wvous-tr-corner = 1;
      };
      screencapture = {
        location = "${homeDir}/Downloads/tmp";
        type = "png";
        disable-shadow = true;
      };
      menuExtraClock = {
        ShowSeconds = true;
        Show24Hour = true;
      };
    };
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };

  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.symbols-only
  ];

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 6;
}
