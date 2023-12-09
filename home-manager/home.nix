{ config, pkgs, ... }:

{
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";

  home.stateVersion = "23.11";

  home.packages = [
    pkgs.bat        # better cat
    pkgs.fd         # better find
    pkgs.fzf        # fuzzy finder
    pkgs.git
    pkgs.k9s        # kubernetes cli
    pkgs.kubectl    # kubernetes cli
    pkgs.krew       # kubernetes plugin manager
    pkgs.lazygit    # git ui
    pkgs.neovim     # better vim
    pkgs.ripgrep    # better grep
    pkgs.tldr       # better man
    pkgs.tmux       # better screen
    pkgs.wezterm    # better terminal
    pkgs.wget       # better curl

    pkgs.rustup

    pkgs.nodePackages_latest.pnpm
    pkgs.nodejs

    pkgs.meslo-lgs-nf   # NERDfont 
  ];

  fonts.fontconfig.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    
    initExtraFirst = ''
      # p10k instant prompt
      P10K_INSTANT_PROMPT="$XDG_CACHE_HOME/p10k-instant-prompt-''${(%):-%n}.zsh"
      [[ ! -r "$P10K_INSTANT_PROMPT" ]] || source "$P10K_INSTANT_PROMPT"
    '';

    initExtra = ''
      # p10k configureation file
      source ~/.config/home-manager/config/p10k.zsh
      
      # custom zsh configuration (since home-manager controls the .zshrc file)
      source ~/.zshconf
    '';

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
