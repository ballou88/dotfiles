{catppuccin, ...}: {
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      syntaxHighlighting.catppuccin.enable = true;
      syntaxHighlighting.catppuccin.flavor = "macchiato";
      initExtra = ''
        export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
        '';
    };
    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };

  home.shellAliases = {
    k = "kubectl";
    g="git";
    gst="git status -s";
    ga="git add";
    gc="git commit";
    gd="git diff";
    gco="git checkout";
    gp="git push";
    gl="git pull";
    glg="git log --graph --oneline --all";
    gcm="git commit -m";
    gaa="git add -A";

    urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
    urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
  };
}
