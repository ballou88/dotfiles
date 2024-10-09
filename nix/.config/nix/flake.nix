{
  description = "Mike's Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
    let
    configuration = { pkgs, ... }: {

      nixpkgs.config.allowUnfree = true;
# List packages installed in system profile. To search by name, run:
# $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.neovim
        pkgs.wezterm
          pkgs.tmux
          pkgs.obsidian
          pkgs.slack
          pkgs.zoom-us
        ];

      fonts.packages = [
        pkgs.nerdfonts
      ];

      homebrew = {
          enable = true;
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
          ];
          masApps = {
              "Ampethamine" = 937984704;
              "Tailscale" = 1475387142;
              "NextDNS" = 1464122853;
              "Stoic" = 1312926037;
              "Mela" = 1568924476;
          };
          # onActivation.cleanup = "zap";
        };

# Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
# nix.package = pkgs.nix;

# Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

# Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
# programs.fish.enable = true;

# Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

# Used for backwards compatibility, please read the changelog before changing.
# $ darwin-rebuild changelog
      system.stateVersion = 5;

# The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
# Build darwin flake using:
# $ darwin-rebuild build --flake .#Roberts-MacBook-Pro
    darwinConfigurations."Roberts-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [ configuration
      nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;

            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
            enableRosetta = true;

            # User owning the Homebrew prefix
            user = "robertballou";

            # Automatically migrate existing Homebrew installations
            autoMigrate = true;
          };
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."Roberts-MacBook-Pro".pkgs;
  };
}
