{ pkgs, ... }: with pkgs;

let
  unstable = import <nixos-unstable> {
    config = {
      allowUnfree = true;
    };
  };
  navicat = pkgs.callPackage ./../pkgs/navicat.nix { };
  python = python39.withPackages (ps: with ps; [ pynvim msgpack flake8 ]);
in

{
  nixpkgs.overlays = [ (import ./../overlays/insomnia.nix) ];
  # configuration
  programs.firefox = {
    enable = true;
    languagePacks = [ "fr" "en-US" ];
  };
  environment.systemPackages = [
    # essential
    chromium # web browser
    exa # replacement for ls
    fd # simple alternative to find
    file # determine type of file
    fzf # command line fuzzy finder
    gthumb # image viewer
    jq # command line json processor
    kitty # terminal
    rar # utility for rar archives
    ripgrep # (rg) recursive regex search utility
    starship # customizable shell prompt
    unzip # zip archive utility - exctractor
    wget # file retriever utility
    zip # zip archive utility - compressor

    # neovim
    unstable.neovim-unwrapped # ❤️
    black # python code formatter
    cargo # rust package manager
    stylua # lua code formatter
    sumneko-lua-language-server # LSP for lua
    tree-sitter # parser generator tool
    wl-clipboard # command line copy/paste utility for wayland
    nixpkgs-fmt
    nil # nix LSP

    # webdev
    navicat
    postman # API development environment
    # httpie # API development environment
    insomnia # API development environment
    wkhtmltopdf-bin

    # dev
    gcc # GNU compiler collection
    git # version control system
    gnumake # build from MakeFile
    lazygit # terminal UI for git

    # utils
    dig # domain name server
    # docker-compose # compose for docker
    kooha # screen recorder
    lm_sensors # read hardware sensors
    neofetch # system info script
    poppler_utils # pdf rendering library
    protonvpn-gui # GUI for proton VPN
    timewarrior # time tracking
    # virtualbox # virtualization

    # node
    nodejs
    nodePackages.prettier
    nodePackages.neovim
    nodePackages.intelephense
    nodePackages.eslint

    # python3
    python

    # latex - pdf
    masterpdfeditor # pdf editor
    tectonic
    tikzit

    # messaging
    signal-desktop # signal

    # office
    libreoffice-fresh # office suite
    onlyoffice-bin # office suite

  ];
}
