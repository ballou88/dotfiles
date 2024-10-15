{ ... }: {
  programs.starship = {
    enable = true;

    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    catppuccin.enable = true;
    catppuccin.flavor = "macchiato";

    settings = {
      character = {
        success_symbol = "[›](bold green)";
        error_symbol = "[›](bold red)";
      };
      aws = {
        symbol = "🅰 ";
      };
      python = {
        symbol = " ";
      };

      ruby = {
        symbol = " ";
      };

      direnv = {
        disabled = false;
      };
      gcloud = {
# do not show the account/project's info
# to avoid the leak of sensitive information when sharing the terminal
        format = "on [$symbol$active(\($region\))]($style) ";
        symbol = "🅶 ️";
      };
    };
  };
         }
