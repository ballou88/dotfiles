{ pkgs, ...}: {
  ##########################################################################
  #
  #  Install all apps and packages here.
  #
  #  NOTE: Your can find all available options in:
  #    https://daiderd.com/nix-darwin/manual/index.html
  #
  #
  ##########################################################################

  # Install packages from nix's official package repository.
  #
  # The packages installed here are available to all users, and are reproducible across machines, and are rollbackable.
  # But on macOS, it's less stable than homebrew.
  #
  # Related Discussion: https://discourse.nixos.org/t/darwin-again/29331
  environment.systemPackages = with pkgs; [
    git
    neovim
    wezterm
    tmux
    obsidian
    slack
    zoom-us
  ];

  # TODO To make this work, homebrew need to be installed manually, see https://brew.sh
  #
  # The apps installed by homebrew are not managed by nix, and not reproducible!
  # But on macOS, homebrew has a much larger selection of apps than nixpkgs, especially for GUI apps!
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      # 'zap': uninstalls all formulae(and related files) not listed here.
      # cleanup = "zap";
    };

    taps = [
      "homebrew/services"
    ];

    # `brew install`
    # TODO Feel free to add your favorite apps here.
    brews = [
      # "aria2"  # download tool
    ];

    # `brew install --cask`
    # TODO Feel free to add your favorite apps here.
    casks = [
        "1password"
        "1password-cli"
        "arc"
        "aerospace"
        "backblaze"
        "google-chrome"
        "halloy"
        "iina"
        "imageoptim"
        "itsycal"
        "karabiner-elements"
        "keymapp"
        "kindle"
        "raycast"
        "sabnzbd"
        "steam"
        "stats"
        "the-unarchiver"
        "visual-studio-code"
        masApps = {
            "Ampethamine" = 937984704;
            "Mela" = 1568924476;
            "NextDNS" = 1464122853;
            "Stoic" = 1312926037;
            "Tailscale" = 1475387142;
        };
    ];
  };
}
